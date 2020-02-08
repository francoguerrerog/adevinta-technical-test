import XCTest
import RxSwift
import RxTest

@testable import adevinta_technical_test

class RandomUserDetailViewModelTests: XCTestCase {
    
    private var viewModel: RandomUserDetailViewModel!
    private let randomUser = FactoryTest.createRandomUser()
    
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    
    private var randomUserObserver: TestableObserver<RandomUser>!
    
    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        randomUserObserver = scheduler.createObserver(RandomUser.self)
    }
    
    func test_emitRandomUserWhenDidLoad() {
        givenAViewModel()
        
        viewModel.output.randomUser.subscribe(randomUserObserver).disposed(by: disposeBag)
        whenViewDidLoad()
        
        thenEmitRandomUser()
    }
    
    fileprivate func givenAViewModel() {
        viewModel = RandomUserDetailViewModel(randomUser)
    }
    
    fileprivate func whenViewDidLoad() {
        viewModel.viewDidLoad()
    }
    
    fileprivate func thenEmitRandomUser() {
        let events = randomUserObserver.events
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events.first?.value.element?.name.first, randomUser.name.first)
        XCTAssertEqual(events.first?.value.element?.name.last, randomUser.name.last)
    }
}
