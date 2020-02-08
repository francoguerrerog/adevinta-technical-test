import Foundation

struct Factory {
    private static let randomUsersService = ApiRandomUsersService()
    private static let randomUsersRepository = InMemoryRandomUsersRespository()
    
    public static func createRandomUsersListViewModel() -> RandomUsersListViewModel {
        
        let findRandomUsers = FindRandomUsersDefault(randomUsersService, randomUsersRepository)
        return RandomUsersListViewModel(findRandomUsers)
    }
}
