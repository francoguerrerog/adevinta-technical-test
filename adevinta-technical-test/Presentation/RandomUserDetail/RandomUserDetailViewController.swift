import UIKit
import RxSwift

class RandomUserDetailViewController: UIViewController {
    
    private let viewModel: RandomUserDetailViewModel
    private lazy var mainView = RandomUserDetailView.initFromNib()
    
    private let disposeBag = DisposeBag()

    init(viewModel: RandomUserDetailViewModel) {
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
        viewModel.viewDidLoad()
    }

    private func bindViewModel() {
        bindRandomUser()
    }
    
    private func bindRandomUser() {
        viewModel.output.randomUser
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { randomUser in
                print(randomUser)
            }).disposed(by: disposeBag)
    }
}
