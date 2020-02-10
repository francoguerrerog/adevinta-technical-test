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
            .subscribe(onNext: { [weak self] randomUser in
                self?.setupRandomUser(randomUser)
            }).disposed(by: disposeBag)
    }
    
    private func setupRandomUser(_ randomUser: RandomUserDetailViewData) {
        
        if let url = URL(string: randomUser.picture) {
            mainView.pictureImage.load(url: url)
        }
        mainView.genderLabel.text = randomUser.gender.lowercased()
        mainView.nameLabel.text = randomUser.name
        mainView.locationLabel.text = randomUser.location
        mainView.regitrationDateLabel.text = randomUser.registrationDate
        mainView.emailLabel.text = randomUser.email
        
    }
}
