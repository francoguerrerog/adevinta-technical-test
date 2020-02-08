import XCTest
import SwiftyMocky
import RxSwift
import RxTest

@testable import adevinta_technical_test

class RandomUsersListViewModelTests: XCTestCase {
    
    private var viewModel: RandomUsersListViewModel!
    private let coordinator = CoordinatorMock()
    private let findRandomUsers = FindRandomUsersMock()
    private let randomUsers = FactoryTest.createPreviousRandomUsers()
    
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    
    private var randomUsersObserver: TestableObserver<[RandomUserListViewData]>!
    
    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        randomUsersObserver = scheduler.createObserver([RandomUserListViewData].self)
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
    
    func test_goToDetail() {
        Given(findRandomUsers, .execute(willReturn: .just(randomUsers)))
        givenAGoToDetailScenario()
        
        WhenSelectCell()
        
        thenGoToDetail()
    }
    
    func test_findRandomUsersWhenScrollToBottom() {
        Given(findRandomUsers, .execute(willReturn: .just(randomUsers)))
        givenAViewModel()
        
        whenScrollToBottom()
        
        thenFindUsers()
    }
    
    fileprivate func givenAViewModel() {
        viewModel = RandomUsersListViewModel(coordinator, findRandomUsers)
    }
    
    fileprivate func givenAGoToDetailScenario() {
        givenAViewModel()
        whenViewDidLoad()
    }
    
    fileprivate func whenViewDidLoad() {
        viewModel.viewDidLoad()
    }
    
    fileprivate func WhenSelectCell() {
        viewModel.selectCell(at: 0)
    }
    
    fileprivate func whenScrollToBottom() {
        viewModel.scrollToBottom()
    }
    
    fileprivate func thenFindUsers() {
        Verify(findRandomUsers, .once, .execute())
    }
    
    fileprivate func thenEmitRandomUsers() {
        let events = randomUsersObserver.events
        XCTAssertEqual(events.count, 2)
        XCTAssertEqual(events.last?.value.element?.count, 2)
    }
    
    fileprivate func thenGoToDetail() {
        Verify(coordinator, .once, .goToRandomUserDetail(.any))
    }
}

//sourcery: AutoMockable
extension Coordinator {}
