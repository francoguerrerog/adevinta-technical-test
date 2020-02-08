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
}
