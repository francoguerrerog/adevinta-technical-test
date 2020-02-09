import Foundation
import RxSwift

class RandomUserDetailViewModel {
    
    struct Output {
        let randomUser: Observable<RandomUserDetailViewData>
    }
    public lazy var output = Output(randomUser: randomUserSubject.asObservable())
    
    private let randomUserSubject = PublishSubject<RandomUserDetailViewData>()
    
    private let randomUser: RandomUser
    
    init(_ randomUser: RandomUser) {
        self.randomUser = randomUser
    }
    
    private func emitRandomUser() {
        
        let randomUserDetailViewData = toRandomUserDetailViewData(randomUser)
        randomUserSubject.onNext(randomUserDetailViewData)
    }
    
    private func toRandomUserDetailViewData(_ randomUser: RandomUser) -> RandomUserDetailViewData {
        
        let name = "\(randomUser.name.title) \(randomUser.name.first) \(randomUser.name.last)"
        let location = "\(randomUser.location.street.number) \(randomUser.location.street.name) \(randomUser.location.city) \(randomUser.location.state)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy"
        let registrationDate = "\(dateFormatter.string(from: randomUser.dateOfRegistration.date))"
        
        return RandomUserDetailViewData(gender: randomUser.gender.rawValue,
                                        name: name,
                                        location: location,
                                        registrationDate: registrationDate,
                                        email: randomUser.email,
                                        picture: randomUser.picture.large)
    }
}

extension RandomUserDetailViewModel {
    func viewDidLoad() {
        emitRandomUser()
    }
}
