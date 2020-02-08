import XCTest
import RxSwift
import RxBlocking
import SwiftyMocky

@testable import adevinta_technical_test

class FindRandomUsersDefaultTests: XCTestCase {
    
    private var action: FindRandomUsersDefault!
    private let randomUsersRespository = RandomUsersRespositoryMock()
    private let randomUsersService = RandomUsersServiceMock()
    private let removedRandomUsersRepository = RemovedRandomUsersRepositoryMock()
    private var result: MaterializedSequenceResult<RandomUsers>!
    private let previousUsers = FactoryTest.createPreviousRandomUsers()
    private let newUsers = FactoryTest.createNewRandomUsersWithDuplicated()
    private let removedUser = FactoryTest.createRandomUser()
    
    func test_FindAttempts() {
        Given(randomUsersService, .find(willReturn: .just(previousUsers)))
        Given(removedRandomUsersRepository, .find(willReturn: []))
        givenAnAction()
        
        whenExecute()
        
        thenFindAttempts()
    }
    
    func test_filterNewUsers() {
        Given(randomUsersService, .find(willReturn: .just(newUsers)))
        Given(removedRandomUsersRepository, .find(willReturn: []))
        Given(randomUsersRespository, .find(willReturn: previousUsers))
        givenAnAction()
        
        whenExecute()
        
        thenRetreiveFilteredUsers()
    }
    
    func test_updateUsers() {
        Given(randomUsersService, .find(willReturn: .just(newUsers)))
        Given(removedRandomUsersRepository, .find(willReturn: []))
        Given(randomUsersRespository, .find(willReturn: previousUsers))
        givenAnAction()
        
        whenExecute()
        
        thenUpdateUsers()
    }
    
    func test_filterRemovedUsers() {
        Given(randomUsersService, .find(willReturn: .just(newUsers)))
        Given(removedRandomUsersRepository, .find(willReturn: [removedUser]))
        Given(randomUsersRespository, .find(willReturn: previousUsers))
        givenAnAction()
        
        whenExecute()
        
        thenFilterRemovedUsers()
    }
    
    fileprivate func givenAnAction() {
        action = FindRandomUsersDefault(randomUsersService, randomUsersRespository, removedRandomUsersRepository)
    }
    
    fileprivate func whenExecute() {
        result = action.execute().toBlocking().materialize()
    }
    
    fileprivate func thenFindAttempts() {
        Verify(randomUsersService, .once, .find())
        switch result {
        case .completed(let users):
            XCTAssertEqual(users.count, 1)
            XCTAssertEqual(users.first?.users.count, 2)
        default:
            XCTFail()
        }
    }
    
    fileprivate func thenRetreiveFilteredUsers() {
        switch result {
        case .completed(let users):
            XCTAssertEqual(users.count, 1)
            XCTAssertEqual(users.first?.users.count, 3)
        default:
            XCTFail()
        }
    }
    
    fileprivate func thenUpdateUsers() {
        Verify(randomUsersRespository, .once, .put(.any))
    }
    
    fileprivate func thenFilterRemovedUsers() {
        Verify(removedRandomUsersRepository, .once, .find())
        switch result {
        case .completed(let users):
            XCTAssertEqual(users.count, 1)
            XCTAssertEqual(users.first?.users.count, 2)
        default:
            XCTFail()
        }
    }
}
