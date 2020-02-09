import Foundation

struct UserDateResponse: Codable {
    let date: Date
    let age: Int
    
    func toUserDate() -> UserDate {
        return UserDate(date: date,
                        age: age)
    }
    
    init(userDate: UserDate) {
        self.date = userDate.date
        self.age = userDate.age
    }
}
