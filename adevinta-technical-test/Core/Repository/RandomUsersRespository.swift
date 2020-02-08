import Foundation

protocol RandomUsersRespository {
    func put(_ randomUsers: RandomUsers)
    func find() -> RandomUsers?
}
