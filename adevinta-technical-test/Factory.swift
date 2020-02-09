import Foundation

struct Factory {
    private static let randomUsersService = ApiRandomUsersService()
    private static let randomUsersRepository = InMemoryRandomUsersRespository()
    private static let removedRandomUsersRepository = InMemoryRemovedRandomUsersRepository()
    private static let persistedRandomUsersRepository = UserDefaultsRandomUsersRespository()
    private static let persistedRemovedRandomUsersRepository = UserDefaultsRemovedRandomUsersRepository()
    
    public static func createRandomUsersListViewModel(_ coordinator: Coordinator) -> RandomUsersListViewModel {
        
        let findRandomUsers = FindRandomUsersDefault(randomUsersService, persistedRandomUsersRepository, persistedRemovedRandomUsersRepository)
        let removeRandomUser = RemoveRandomUserDefault(persistedRandomUsersRepository, persistedRemovedRandomUsersRepository)
        return RandomUsersListViewModel(coordinator, findRandomUsers, removeRandomUser)
    }
    
    public static func createRandomUserDetailViewModel(_ randomUser: RandomUser) -> RandomUserDetailViewModel {
        return RandomUserDetailViewModel(randomUser)
    }
}
