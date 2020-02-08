import Foundation

class InMemoryRemovedRandomUsersRepository: RemovedRandomUsersRepository {
    
    private var randomUsers: [RandomUser] = []
    
    func put(_ randomUsers: [RandomUser]) {
        self.randomUsers = randomUsers
    }
    
    func find() -> [RandomUser] {
        return randomUsers
    }
}
