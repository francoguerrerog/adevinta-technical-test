import Foundation

struct Factory {
    private static let randomUsersService = ApiRandomUsersService()
    private static let randomUsersRepository = InMemoryRandomUsersRespository()
    
    public static func createRandomUsersListViewModel(_ coordinator: Coordinator) -> RandomUsersListViewModel {
        
        let findRandomUsers = FindRandomUsersDefault(randomUsersService, randomUsersRepository)
        return RandomUsersListViewModel(coordinator, findRandomUsers)
    }
    
    public static func createRandomUserDetailViewModel() -> RandomUserDetailViewModel {
        return RandomUserDetailViewModel()
    }
}
