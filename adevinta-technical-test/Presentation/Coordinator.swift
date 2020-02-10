import Foundation
import UIKit

protocol Coordinator {
    func goToRandomUserDetail(_ randomUser: RandomUser)
}

class CoordinatorDefault {
    
    private let window: UIWindow
    private var viewNavigation: UINavigationController?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        
        let viewController = createRandomUsersViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        viewNavigation = navigationController
    }
    
    private func createRandomUsersViewController() -> RandomUsersListViewController {
        
        let viewModel = Factory.createRandomUsersListViewModel(self)
        return RandomUsersListViewController(viewModel: viewModel)
    }
    
    private func createRandomUserDetailViewController(_ randomUser: RandomUser) -> RandomUserDetailViewController {
        
        let viewModel = Factory.createRandomUserDetailViewModel(randomUser)
        return RandomUserDetailViewController(viewModel: viewModel)
    }
    
    private func pushViewController(viewController: UIViewController) {
        
        guard let navigation = viewNavigation else { return }
        navigation.pushViewController(viewController, animated: true)
    }
}

extension CoordinatorDefault: Coordinator {
    
    func goToRandomUserDetail(_ randomUser: RandomUser) {
        
        let viewController = createRandomUserDetailViewController(randomUser)
        pushViewController(viewController: viewController)
    }
}
