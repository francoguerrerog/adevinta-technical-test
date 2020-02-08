import Foundation

struct RandomUser {
    let gender: Gender
    let name: Name
    let location: Location
    let email: String
    let login: Login
    let dateOfBirth: UserDate
    let dateOfRegistration: UserDate
    let phone: String
    let cell: String
    let id: NameValue
    let picture: Pictures
    let nationality: String
    
    enum Gender: String {
        case male
        case female
    }
}
