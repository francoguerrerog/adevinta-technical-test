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
    
    private let coordinator: Coordinator
    private let findRandomUsers: FindRandomUsers
    
    private let disposeBag = DisposeBag()

    init(_ coordinator: Coordinator,
         _ findRandomUsers: FindRandomUsers) {
        self.coordinator = coordinator
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
    
    private func randomUserAtIndex(_ randomUsers: [RandomUser], _ index: Int) -> RandomUser? {
        if index >= 0 && index < randomUsers.count {
            return randomUsers[index]
        }
        return nil
    }
}

extension RandomUsersListViewModel {
    func viewDidLoad() {
        findNewRandomUsers()
    }
    
    func selectCell(at index: Int) {
        output.randomUsers
            .take(1)
            .subscribe(onNext: { (randomUsers) in
                guard let randomUser = self.randomUserAtIndex(randomUsers, index) else { return }
                self.coordinator.goToRandomUserDetail(randomUser)
            }).disposed(by: disposeBag)
    }
}
