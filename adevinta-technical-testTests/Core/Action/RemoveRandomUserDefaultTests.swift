import XCTest
import RxSwift
import SwiftyMocky
import RxBlocking

@testable import adevinta_technical_test

class RemoveRandomUserDefaultTests: XCTestCase {
    
    private var removeRandomUser: RemoveRandomUserDefault!
    private let randomUsersRepository = RandomUsersRespositoryMock()
    private let removedRandomUsersRepository = RemovedRandomUsersRepositoryMock()
    private let previousRandomUsers = FactoryTest.createPreviousRandomUsers()
    private let randomUser = FactoryTest.createRandomUser()
    private var result: MaterializedSequenceResult<RandomUsers>!
    
    func test_updateRandomUsers() {
        Given(randomUsersRepository, .find(willReturn: previousRandomUsers))
        Given(removedRandomUsersRepository, .find(willReturn: []))
        givenAnAction()
        
        whenExecute()
        
        thenUpdateRandomUsers()
    }
    
    func test_updateRemovedRandomUsers() {
        Given(randomUsersRepository, .find(willReturn: previousRandomUsers))
        Given(removedRandomUsersRepository, .find(willReturn: []))
        givenAnAction()
        
        whenExecute()
        
        thenUpdateRemovedRandomUsers()
    }
    
    func test_removeRandomUser() {
        Given(randomUsersRepository, .find(willReturn: previousRandomUsers))
        Given(removedRandomUsersRepository, .find(willReturn: []))
        givenAnAction()
        
        whenExecute()
        
        thenRemoveRandomUser()
    }

    fileprivate func givenAnAction() {
        removeRandomUser = RemoveRandomUserDefault(randomUsersRepository, removedRandomUsersRepository)
    }
    
    fileprivate func whenExecute() {
        result = removeRandomUser.execute(randomUser).toBlocking().materialize()
    }
    
    fileprivate func thenUpdateRandomUsers() {
        Verify(randomUsersRepository, .once, .find())
        Verify(randomUsersRepository, .once, .put(.any))
    }
    
    fileprivate func thenUpdateRemovedRandomUsers() {
        Verify(removedRandomUsersRepository, .once, .find())
        Verify(removedRandomUsersRepository, .once, .put(.any))
    }
    
    fileprivate func thenRemoveRandomUser() {
        switch result {
        case .completed(let randomUsers):
            XCTAssertEqual(randomUsers.count, 1)
            XCTAssertEqual(randomUsers.first?.users.count, 1)
        default:
            XCTFail()
        }
    }
}
