import UIKit
import RxSwift
import RxCocoa

class RandomUsersListViewController: UIViewController {
    
    private let viewModel: RandomUsersListViewModel
    private lazy var mainView = RandomUsersListView.initFromNib()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var isLoading = false
    
    private let filterTypingSubject = PublishSubject<String>()
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: RandomUsersListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: .none, bundle: .none)
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }
            
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTitle()
        setupTableView()
        setupSearchController()
        bindFilterTyping()
        bindViewModel()
        viewModel.viewDidLoad()
    }
    
    private func setTitle() {
        
        self.title = "Random Users"
    }
    
    private func setupTableView() {
        
        mainView.tableView.delegate = self
        mainView.tableView.register(UINib(nibName: ItemCellView.cellIdentifier, bundle: Bundle(for: type(of: self))), forCellReuseIdentifier: ItemCellView.cellIdentifier)
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Filter..."
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }

    private func bindViewModel() {
        
        bindLoading()
        bindTableView()
    }
    
    private func bindLoading() {
        
        viewModel.output.loading
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (loading) in
                self?.isLoading = loading
                self?.mainView.loadingView.isHidden = !loading
            }).disposed(by: disposeBag)
    }
    
    private func bindTableView() {
        
        viewModel.output.randomUsers
            .observeOn(MainScheduler.instance)
            .bind(to: mainView.tableView.rx.items(cellIdentifier: ItemCellView.cellIdentifier, cellType: ItemCellView.self)) { [weak self] row, element, cell in
                cell.tag = row
                self?.configureCell(cell, with: element)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureCell(_ cell: ItemCellView, with item: RandomUserListViewData) {
        
        cell.titleLabel.text = item.name
        cell.subtitleLabel.text = "\(item.email)\n\(item.phone)"
        if let url = URL(string: item.picture) {
            cell.itemImage.load(url: url)
        }
        
        bindRemoveAction(cell)
        bindOpenAction(cell)
        
    }
    
    private func bindRemoveAction(_ cell: ItemCellView) {
        cell.removeButton.rx.tap
            .bind { [weak self] _ in
                self?.viewModel.selectRemoveCell(at: cell.tag)
        }.disposed(by: cell.disposeBag)
    }
    
    private func bindOpenAction(_ cell: ItemCellView) {
        cell.openButton.rx.tap
            .bind { [weak self] _ in
                self?.viewModel.selectOpenCell(at: cell.tag)
        }.disposed(by: cell.disposeBag)
    }
    
    private func bindFilterTyping() {
        filterTypingSubject
            .asObservable()
            .debounce(.milliseconds(800), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] filter in
                self?.viewModel.selectFilter(filter)
            }).disposed(by: disposeBag)
    }
}

extension RandomUsersListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100.0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height && !isLoading {
            viewModel.scrollToBottom()
        }
    }
}

extension RandomUsersListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filterTypingSubject.onNext(searchController.searchBar.text!)
    }
}

extension RandomUsersListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
}
