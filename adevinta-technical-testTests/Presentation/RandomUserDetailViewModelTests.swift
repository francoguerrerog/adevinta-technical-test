import XCTest
import RxSwift
import RxTest

@testable import adevinta_technical_test

class RandomUserDetailViewModelTests: XCTestCase {
    
    private var viewModel: RandomUserDetailViewModel!
    private let randomUser = FactoryTest.createRandomUser()
    
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    
    private var randomUserObserver: TestableObserver<RandomUserDetailViewData>!
    
    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        randomUserObserver = scheduler.createObserver(RandomUserDetailViewData.self)
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
        XCTAssert((events.first?.value.element?.name.contains(randomUser.name.first))!)
        XCTAssert((events.first?.value.element?.name.contains(randomUser.name.last))!)
    }
}
