import Foundation

struct LoginResponse: Codable {
    let uuid: String
    let username: String
    let password: String
    let salt: String
    let md5: String
    let sha1: String
    let sha256: String
    
    func toLogin() -> Login {
        return Login(uuid: uuid,
                     username: username,
                     password: password,
                     salt: salt,
                     md5: md5,
                     sha1: sha1,
                     sha256: sha256)
    }
    
    init(login: Login) {
        self.uuid = login.uuid
        self.username = login.username
        self.password = login.password
        self.salt = login.salt
        self.md5 = login.md5
        self.sha1 = login.sha1
        self.sha256 = login.sha256
    }
}
