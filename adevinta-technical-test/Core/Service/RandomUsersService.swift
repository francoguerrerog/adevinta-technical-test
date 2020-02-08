import Foundation
import RxSwift

protocol RandomUsersService {
    func find() -> Single<RandomUsers>
}
