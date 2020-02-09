import Foundation

struct RandomUsersResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case randomUsers = "results"
    }
    
    let randomUsers: [RandomUserResponse]
    
    func toRandomUsers() -> RandomUsers {
        return RandomUsers(users: randomUsers.compactMap{ $0.toRandomUser() })
    }
    
    init(randomUsers: RandomUsers) {
        self.randomUsers = randomUsers.users.map{ RandomUserResponse(randomUser: $0) }
    }
}

struct RandomUserResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case gender = "gender"
        case name = "name"
        case location = "location"
        case email = "email"
        case login = "login"
        case dateOfBirth = "dob"
        case dateOfRegistration = "registered"
        case phone = "phone"
        case cell = "cell"
        case id = "id"
        case picture = "picture"
        case nationality = "nat"
    }
    
    let gender: String
    let name: NameResponse
    let location: LocationResponse
    let email: String
    let login: LoginResponse
    let dateOfBirth: UserDateResponse
    let dateOfRegistration: UserDateResponse
    let phone: String
    let cell: String
    let id: NameValueResponse
    let picture: PicturesResponse
    let nationality: String
    
    func toRandomUser() -> RandomUser? {
        guard let gender = RandomUser.Gender(rawValue: gender) else { return nil }
        return RandomUser(gender: gender,
                          name: name.toName(),
                          location: location.toLocation(),
                          email: email,
                          login: login.toLogin(),
                          dateOfBirth: dateOfBirth.toUserDate(),
                          dateOfRegistration: dateOfRegistration.toUserDate(),
                          phone: phone,
                          cell: cell,
                          id: id.toNameValue(),
                          picture: picture.toPictures(),
                          nationality: nationality)
    }
    
    init(randomUser: RandomUser) {
        self.gender = randomUser.gender.rawValue
        self.name = NameResponse(name: randomUser.name)
        self.location = LocationResponse(location: randomUser.location)
        self.email = randomUser.email
        self.login = LoginResponse(login: randomUser.login)
        self.dateOfBirth = UserDateResponse(userDate: randomUser.dateOfBirth)
        self.dateOfRegistration = UserDateResponse(userDate: randomUser.dateOfRegistration)
        self.phone = randomUser.phone
        self.cell = randomUser.cell
        self.id = NameValueResponse(nameValue: randomUser.id)
        self.picture = PicturesResponse(pictures: randomUser.picture)
        self.nationality = randomUser.nationality
    }
}
