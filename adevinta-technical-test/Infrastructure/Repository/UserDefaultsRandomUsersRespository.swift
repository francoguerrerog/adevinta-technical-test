import Foundation

class UserDefaultsRandomUsersRespository: RandomUsersRespository {
    
    private let randomUsersKey = "KEY_RANDOM_USERS"
    private let defaults = UserDefaults.standard
    
    func put(_ randomUsers: RandomUsers) {
        let randomUsersResponse = RandomUsersResponse(randomUsers: randomUsers)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(randomUsersResponse) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: randomUsersKey)
        }
    }
    
    func find() -> RandomUsers? {
        if let savedRandomUsers = defaults.object(forKey: randomUsersKey) as? Data {
            let decoder = JSONDecoder()
            if let randomUsers = try? decoder.decode(RandomUsersResponse.self, from: savedRandomUsers) {
                return randomUsers.toRandomUsers()
            }
        }
        
        return nil
    }
}
