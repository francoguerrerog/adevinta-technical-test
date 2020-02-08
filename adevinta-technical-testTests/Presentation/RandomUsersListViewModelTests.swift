import XCTest
import SwiftyMocky
import RxSwift
import RxTest

@testable import adevinta_technical_test

class RandomUsersListViewModelTests: XCTestCase {
    
    private var viewModel: RandomUsersListViewModel!
    private let coordinator = CoordinatorMock()
    private let findRandomUsers = FindRandomUsersMock()
    private let removeRandomUser = RemoveRandomUserMock()
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
        
        WhenSelectOpenCell()
        
        thenGoToDetail()
    }
    
    func test_findRandomUsersWhenScrollToBottom() {
        Given(findRandomUsers, .execute(willReturn: .just(randomUsers)))
        givenAViewModel()
        
        whenScrollToBottom()
        
        thenFindUsers()
    }
    
    func test_removeRandomUser() {
        Given(findRandomUsers, .execute(willReturn: .just(randomUsers)))
        Given(removeRandomUser, .execute(.any, willReturn: .just(randomUsers)))
        givenARemoveRandomUserScenario()
        
        whenSelectRemoveCell()
        
        thenRemoveRandomUser()
    }
    
    func test_filterRandomUsers() {
        Given(findRandomUsers, .execute(willReturn: .just(randomUsers)))
        givenAFilterScenario()
        
        viewModel.output.randomUsers.subscribe(randomUsersObserver).disposed(by: disposeBag)
        whenFilter()
        
        thenEmitFilteredRandomUsers()
    }
    
    fileprivate func givenAViewModel() {
        viewModel = RandomUsersListViewModel(coordinator, findRandomUsers, removeRandomUser)
    }
    
    fileprivate func givenAGoToDetailScenario() {
        givenAViewModel()
        whenViewDidLoad()
    }
    
    fileprivate func givenARemoveRandomUserScenario() {
        givenAViewModel()
        whenViewDidLoad()
    }
    
    fileprivate func givenAFilterScenario() {
        givenAViewModel()
        whenViewDidLoad()
    }
    
    fileprivate func whenViewDidLoad() {
        viewModel.viewDidLoad()
    }
    
    fileprivate func WhenSelectOpenCell() {
        viewModel.selectOpenCell(at: 0)
    }
    
    fileprivate func whenScrollToBottom() {
        viewModel.scrollToBottom()
    }
    
    fileprivate func whenSelectRemoveCell() {
        viewModel.selectRemoveCell(at: 0)
    }
    
    fileprivate func whenFilter() {
        viewModel.selectFilter("pedro")
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
    
    fileprivate func thenRemoveRandomUser() {
        Verify(removeRandomUser, .once, .execute(.any))
    }
    
    fileprivate func thenEmitFilteredRandomUsers() {
        let events = randomUsersObserver.events
        XCTAssertEqual(events.count, 2)
        XCTAssertEqual(events.first?.value.element?.count, 2)
        XCTAssertEqual(events.last?.value.element?.count, 1)
    }
}
