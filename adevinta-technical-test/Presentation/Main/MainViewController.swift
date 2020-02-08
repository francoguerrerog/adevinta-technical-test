import UIKit
import RxSwift

class MainViewController: UIViewController {
    
    private let viewModel: MainViewModel
    private lazy var mainView = MainView.initFromNib()

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: .none, bundle: .none)
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }
            
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }

    private func bindViewModel() {
        let service = ApiRandomUsersService()
        
        service.find()
            .subscribeOn(MainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { (randomUsers) in
                print(randomUsers)
            }, onError: { (error) in
                print(error)
            }).disposed(by: DisposeBag())
    }
}
