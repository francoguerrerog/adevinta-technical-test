import Foundation
import RxSwift

class RandomUserDetailViewModel {
    
    struct Output {
        let randomUser: Observable<RandomUser>
    }
    public lazy var output = Output(randomUser: randomUserSubject.asObservable())
    
    private let randomUserSubject = PublishSubject<RandomUser>()
    
    private let randomUser: RandomUser
    
    init(_ randomUser: RandomUser) {
        self.randomUser = randomUser
    }
    
    private func emitRandomUser() {
        randomUserSubject.onNext(randomUser)
    }
}

extension RandomUserDetailViewModel {
    func viewDidLoad() {
        emitRandomUser()
    }
}
