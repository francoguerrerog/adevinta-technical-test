import Foundation

@testable import adevinta_technical_test

struct FactoryTest {
    private static let pedro = RandomUser(gender: .male, name: Name(title: "Mr.", first: "Pedro", last: "Perez"), location: Location(street: Street(number: 123, name: "street of pedro"), city: "city of pedro", state: "state of pedro", country: "country of pedro", postcode: "1234", coordinates: Coordinate(latitude: "1235", longitude: "1234"), timezone: UserTimeZone(offset: "123", description: "IDK")), email: "pedro@mail.com", login: Login(uuid: "uuid", username: "username", password: "password", salt: "salt", md5: "md5", sha1: "sha1", sha256: "sha256"), dateOfBirth: UserDate(date: Date(), age: 20), dateOfRegistration: UserDate(date: Date(), age: 20), phone: "0123456", cell: "01235", id: NameValue(name: "DNI", value: "12345"), picture: Pictures(large: "", medium: "", thumbnail: ""), nationality: "AR")
    
    private static let pablo = RandomUser(gender: .male, name: Name(title: "Mr.", first: "Pablo", last: "Hernandez"), location: Location(street: Street(number: 1234, name: "street of pablo"), city: "city of pablo", state: "state of pablo", country: "country of pablo", postcode: "12345", coordinates: Coordinate(latitude: "1235", longitude: "1234"), timezone: UserTimeZone(offset: "123", description: "IDK")), email: "pablo@mail.com", login: Login(uuid: "uuid", username: "username", password: "password", salt: "salt", md5: "md5", sha1: "sha1", sha256: "sha256"), dateOfBirth: UserDate(date: Date(), age: 20), dateOfRegistration: UserDate(date: Date(), age: 20), phone: "0123456", cell: "01235", id: NameValue(name: "DNI", value: "123456"), picture: Pictures(large: "", medium: "", thumbnail: ""), nationality: "AR")
    
    private static let luis = RandomUser(gender: .male, name: Name(title: "Mr.", first: "Luis", last: "Gonzalez"), location: Location(street: Street(number: 1234, name: "street of luis"), city: "city of luis", state: "state of luis", country: "country of luis", postcode: "12345", coordinates: Coordinate(latitude: "1235", longitude: "1234"), timezone: UserTimeZone(offset: "123", description: "IDK")), email: "luis@mail.com", login: Login(uuid: "uuid", username: "username", password: "password", salt: "salt", md5: "md5", sha1: "sha1", sha256: "sha256"), dateOfBirth: UserDate(date: Date(), age: 20), dateOfRegistration: UserDate(date: Date(), age: 20), phone: "0123456", cell: "01235", id: NameValue(name: "DNI", value: "12345656"), picture: Pictures(large: "", medium: "", thumbnail: ""), nationality: "AR")
    
    
    static func createPreviousRandomUsers() -> RandomUsers {
        return RandomUsers(users: [pedro, pablo])
    }
    
    static func createNewRandomUsersWithDuplicated() -> RandomUsers {
        return RandomUsers(users: [pedro, luis, pablo])
    }
}
