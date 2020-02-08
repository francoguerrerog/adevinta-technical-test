import Foundation

struct Factory {
    private static let randomUsersService = ApiRandomUsersService()
    private static let randomUsersRepository = InMemoryRandomUsersRespository()
    private static let removedRandomUsersRepository = InMemoryRemovedRandomUsersRepository()
    
    public static func createRandomUsersListViewModel(_ coordinator: Coordinator) -> RandomUsersListViewModel {
        
        let findRandomUsers = FindRandomUsersDefault(randomUsersService, randomUsersRepository, removedRandomUsersRepository)
        let removeRandomUser = RemoveRandomUserDefault(randomUsersRepository, removedRandomUsersRepository)
        return RandomUsersListViewModel(coordinator, findRandomUsers, removeRandomUser)
    }
    
    public static func createRandomUserDetailViewModel(_ randomUser: RandomUser) -> RandomUserDetailViewModel {
        return RandomUserDetailViewModel(randomUser)
    }
}
