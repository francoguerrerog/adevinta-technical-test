
import UIKit

class RandomUserDetailViewController: UIViewController {
    
    private let viewModel: RandomUserDetailViewModel
    private lazy var mainView = RandomUserDetailView.initFromNib()

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
    }

    private func bindViewModel() {

    }
}
