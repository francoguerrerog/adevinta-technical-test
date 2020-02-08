import XCTest
import SwiftyMocky
import RxSwift
import RxTest

@testable import adevinta_technical_test

class RandomUsersListViewModelTests: XCTestCase {
    
    private var viewModel: RandomUsersListViewModel!
    private let findRandomUsers = FindRandomUsersMock()
    private let randomUsers = FactoryTest.createPreviousRandomUsers()
    
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    
    private var randomUsersObserver: TestableObserver<[RandomUser]>!
    
    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        randomUsersObserver = scheduler.createObserver([RandomUser].self)
    }
    
    func test_findRandomUsersWhenDidLoad() {
        Given(findRandomUsers, .execute(willReturn: .just(randomUsers)))
        givenAViewModel()
        
        whenViewDidLoad()
        
        thenFindUsers()
    }
    
    func test_emitRandomUsers() {
        Given(findRandomUsers, .execute(willReturn: .just(randomUsers)))
        givenAViewModel()
        
        viewModel.output.randomUsers.subscribe(randomUsersObserver).disposed(by: disposeBag)
        whenViewDidLoad()
        
        thenEmitRandomUsers()
    }
    
    fileprivate func givenAViewModel() {
        viewModel = RandomUsersListViewModel(findRandomUsers)
    }
    
    fileprivate func whenViewDidLoad() {
        viewModel.viewDidLoad()
    }
    
    fileprivate func thenFindUsers() {
        Verify(findRandomUsers, .once, .execute())
    }
    
    fileprivate func thenEmitRandomUsers() {
        let events = randomUsersObserver.events
        XCTAssertEqual(events.count, 2)
        XCTAssertEqual(events.last?.value.element?.count, 2)
    }
}
