import Foundation
import RxSwift

class RandomUsersListViewModel {
    
    struct Output {
        let randomUsers: Observable<[RandomUser]>
        let loading: Observable<Bool>
    }
    public lazy var output = Output(randomUsers: randomUsersSubject.asObservable(),
                                    loading: loadingSubject.asObservable())
    
    private let randomUsersSubject = BehaviorSubject<[RandomUser]>(value: [])
    private let loadingSubject = PublishSubject<Bool>()
    
    private let findRandomUsers: FindRandomUsers
    
    private let disposeBag = DisposeBag()

    init(_ findRandomUsers: FindRandomUsers) {
        self.findRandomUsers = findRandomUsers
    }
    
    private func findNewRandomUsers() {
        loadingSubject.onNext(true)
        findRandomUsers.execute()
            .subscribe(onSuccess: { [weak self] (randomUsers) in
                self?.loadingSubject.onNext(false)
                self?.randomUsersSubject.onNext(randomUsers.users)
            }, onError: { [weak self] _ in
                self?.loadingSubject.onNext(false)
            }).disposed(by: disposeBag)
    }
    
}

extension RandomUsersListViewModel {
    func viewDidLoad() {
        findNewRandomUsers()
    }
}
