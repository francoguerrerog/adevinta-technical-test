import Foundation

class UserDefaultsRemovedRandomUsersRepository: RemovedRandomUsersRepository {
    
    private let randomUsersKey = "KEY_DELETED_RANDOM_USERS"
    private let defaults = UserDefaults.standard
    
    func put(_ randomUsers: [RandomUser]) {
        let randomUsersResponse = RandomUsersResponse(randomUsers: RandomUsers(users: randomUsers))
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(randomUsersResponse) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: randomUsersKey)
        }
    }
    
    func find() -> [RandomUser] {
        if let savedRandomUsers = defaults.object(forKey: randomUsersKey) as? Data {
            let decoder = JSONDecoder()
            if let randomUsers = try? decoder.decode(RandomUsersResponse.self, from: savedRandomUsers) {
                return randomUsers.toRandomUsers().users
            }
        }
        return []
    }
}
