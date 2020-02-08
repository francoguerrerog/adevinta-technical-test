import Foundation
import RxSwift

protocol FindRandomUsers {
    func execute() -> Single<RandomUsers>
}

class FindRandomUsersDefault: FindRandomUsers {
    private let randomUsersService: RandomUsersService
    private let randomUsersRespository: RandomUsersRespository
    private let removedRandomUsersRepository: RemovedRandomUsersRepository
    
    init(_ randomUsersService: RandomUsersService,
         _ randomUsersRespository: RandomUsersRespository,
         _ removedRandomUsersRepository: RemovedRandomUsersRepository) {
        self.randomUsersService = randomUsersService
        self.randomUsersRespository = randomUsersRespository
        self.removedRandomUsersRepository = removedRandomUsersRepository
    }
    
    func execute() -> Single<RandomUsers> {
        
        return findNewRandomUsers()
            .flatMap{ self.filterDuplicatedUsers($0) }
            .flatMap{ self.filterRemovedRandomUsers($0) }
            .flatMap{ self.updateRandomUsers($0) }
    }
}

extension FindRandomUsersDefault {
    
    private func findNewRandomUsers() -> Single<RandomUsers> {
        
        return randomUsersService.find()
    }
    
    private func filterDuplicatedUsers(_ randomUsers: RandomUsers) -> Single<RandomUsers> {
        
        return Single<RandomUsers>.create { observer in
            
            var existingUsers: [RandomUser] = self.findPreviousRandomUsersIfExist()
            randomUsers.users.forEach { (user) in
                if !self.isUserContained(randomUser: user, users: existingUsers) {
                    existingUsers.append(user)
                }
            }
            
            observer(.success(RandomUsers(users: existingUsers)))
            return Disposables.create { }
        }
    }
    
    private func findPreviousRandomUsersIfExist() -> [RandomUser] {
        
        guard let randomUsers = randomUsersRespository.find() else { return [] }
        return randomUsers.users
    }
    
    private func isUserContained(randomUser: RandomUser, users: [RandomUser]) -> Bool {
        
        return users.contains { (user) -> Bool in
            user.id.name == randomUser.id.name &&
                user.id.value == randomUser.id.value &&
                user.name.first == randomUser.name.first &&
                user.name.last == randomUser.name.last
        }
    }
    
    private func filterRemovedRandomUsers(_ randomUsers: RandomUsers) -> Single<RandomUsers> {
        
        return Single<RandomUsers>.create { observer in
            
            let removedUsers: [RandomUser] = self.findRemovedRandomUsers()
            
            let filteredUsers = randomUsers.users.compactMap { (randomUser) -> RandomUser? in
                if self.isUserContained(randomUser: randomUser, users: removedUsers) {
                    return nil
                }
                return randomUser
            }
            
            observer(.success(RandomUsers(users: filteredUsers)))
            return Disposables.create { }
        }
    }
    
    private func findRemovedRandomUsers() -> [RandomUser] {
        
        return removedRandomUsersRepository.find()
    }
    
    private func updateRandomUsers(_ randomUsers: RandomUsers) -> Single<RandomUsers> {
        
        return Single<RandomUsers>.create { observer in
            
            self.randomUsersRespository.put(randomUsers)
            observer(.success(randomUsers))
            
            return Disposables.create { }
        }
    }
}
