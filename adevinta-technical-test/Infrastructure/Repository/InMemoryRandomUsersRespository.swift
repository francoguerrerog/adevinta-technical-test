import Foundation

class InMemoryRandomUsersRespository: RandomUsersRespository {
    
    private var randomUsers: RandomUsers?
    
    func put(_ randomUsers: RandomUsers) {
        self.randomUsers = randomUsers
    }
    
    func find() -> RandomUsers? {
        return randomUsers
    }
}
