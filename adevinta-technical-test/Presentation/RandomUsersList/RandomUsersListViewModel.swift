import Foundation
import RxSwift

class RandomUsersListViewModel {
    
    struct Output {
        let randomUsers: Observable<[RandomUserListViewData]>
        let loading: Observable<Bool>
    }
    public lazy var output = Output(randomUsers: randomUsersSubject.asObservable(),
                                    loading: loadingSubject.asObservable())
    
    private let randomUsersSubject = BehaviorSubject<[RandomUserListViewData]>(value: [])
    private let loadingSubject = PublishSubject<Bool>()
    
    private let coordinator: Coordinator
    private let findRandomUsers: FindRandomUsers
    
    private var randomUsers: [RandomUser] = []
    
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
                self?.saveCurrentRandomUsers(randomUsers.users)
                self?.emitRandomUsers(randomUsers.users)
            }, onError: { [weak self] _ in
                self?.loadingSubject.onNext(false)
            }).disposed(by: disposeBag)
    }
    
    private func saveCurrentRandomUsers(_ randomUsers: [RandomUser]) {
        
        self.randomUsers = randomUsers
    }
    
    private func emitRandomUsers(_ randomUsers: [RandomUser]) {
        
        let randomUserListViewData = randomUsers.map{ toRandomUserListViewData($0) }
        randomUsersSubject.onNext(randomUserListViewData)
    }
    
    private func toRandomUserListViewData(_ randomUser: RandomUser) -> RandomUserListViewData {
        
        let name = "\(randomUser.name.title) \(randomUser.name.first) \(randomUser.name.last)"
        return RandomUserListViewData(name: name, email: randomUser.email, picture: randomUser.picture.thumbnail, phone: randomUser.phone)
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
        
        guard let randomUser = self.randomUserAtIndex(randomUsers, index) else { return }
        coordinator.goToRandomUserDetail(randomUser)
    }
    
    func scrollToBottom() {
        
        findNewRandomUsers()
    }
}
