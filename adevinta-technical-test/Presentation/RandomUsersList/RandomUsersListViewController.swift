import UIKit
import RxSwift
import RxCocoa

class RandomUsersListViewController: UIViewController {
    
    private let viewModel: RandomUsersListViewModel
    private lazy var mainView = RandomUsersListView.initFromNib()
    
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

    private func bindViewModel() {
        bindLoading()
        bindTableView()
    }
    
    private func bindLoading() {
        viewModel.output.loading
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (loading) in
                self?.mainView.loadingView.isHidden = !loading
            }).disposed(by: disposeBag)
    }
    
    private func bindTableView() {
        viewModel.output.randomUsers
            .observeOn(MainScheduler.instance)
            .bind(to: mainView.tableView.rx.items(cellIdentifier: ItemCellView.cellIdentifier, cellType: ItemCellView.self)) { [weak self] row, element, cell in
                self?.configureCell(cell, with: element)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureCell(_ cell: ItemCellView, with item: RandomUser) {
        cell.titleLabel.text = "\(item.name.title) \(item.name.first) \(item.name.last)"
        cell.subtitleLabel.text = "\(item.location.street.number) \(item.location.street.name) \(item.location.city)"
        if let url = URL(string: item.picture.thumbnail) {
            cell.itemImage.load(url: url)
        }
    }
}

extension RandomUsersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectCell(at: indexPath.row)
    }
}
