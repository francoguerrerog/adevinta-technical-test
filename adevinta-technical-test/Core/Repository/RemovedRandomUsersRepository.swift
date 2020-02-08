import Foundation

protocol RemovedRandomUsersRepository {
    func put(_ randomUsers: [RandomUser])
    func find() -> [RandomUser]
}
