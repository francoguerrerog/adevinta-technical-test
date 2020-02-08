import Foundation

struct UserDateResponse: Codable {
    let date: Date
    let age: Int
    
    func toUserDate() -> UserDate {
        return UserDate(date: date,
                        age: age)
    }
}
