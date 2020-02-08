import Foundation
import RxSwift

protocol RemoveRandomUser {
    func execute(_ randomUser: RandomUser) -> Single<RandomUsers>
}

class RemoveRandomUserDefault: RemoveRandomUser {
    private let randomUsersRespository: RandomUsersRespository
    private let removedRandomUsersRepository: RemovedRandomUsersRepository
    
    init(_ randomUsersRespository: RandomUsersRespository,
         _ removedRandomUsersRepository: RemovedRandomUsersRepository) {
        self.randomUsersRespository = randomUsersRespository
        self.removedRandomUsersRepository = removedRandomUsersRepository
    }
    
    func execute(_ randomUser: RandomUser) -> Single<RandomUsers> {
        
        return findRandomUsers()
            .flatMap{ self.removeRandomUserIfNeeded(randomUser, $0) }
            .flatMap{ self.updateRandomUsers($0) }
    }
}

extension RemoveRandomUserDefault {
    
    private func findRandomUsers() -> Single<RandomUsers> {
        
        return Single.create { observer in
            
            let randomUsers = self.randomUsersRespository.find() ?? RandomUsers(users: [])
            observer(.success(randomUsers))
            
            return Disposables.create { }
        }
    }
    
    private func removeRandomUserIfNeeded(_ user: RandomUser, _ randomUsers: RandomUsers) -> Single<RandomUsers> {
        
        return Single.create { observer in
            
            self.updateRemovedRandomUser(user)
            let filteredUsers = self.filterRandomUsers(user, randomUsers.users)
            observer(.success(RandomUsers(users: filteredUsers)))
            
            return Disposables.create { }
        }
    }
    
    private func updateRemovedRandomUser(_ randomUser: RandomUser) {
        
        var removedRandomUsers = removedRandomUsersRepository.find()
        removedRandomUsers.append(randomUser)
        removedRandomUsersRepository.put(removedRandomUsers)
    }
    
    private func filterRandomUsers(_ user: RandomUser, _ randomUsers: [RandomUser]) -> [RandomUser] {
        
        return randomUsers.filter{ !($0.id.name == user.id.name &&
            $0.id.value == user.id.value &&
            $0.name.title == user.name.title &&
            $0.name.first == user.name.first &&
            $0.name.last == user.name.last) }
    }
    
    private func updateRandomUsers(_ randomUsers: RandomUsers) -> Single<RandomUsers> {
        
        return Single<RandomUsers>.create { observer in
            
            self.randomUsersRespository.put(randomUsers)
            observer(.success(randomUsers))
            
            return Disposables.create { }
        }
    }
}
