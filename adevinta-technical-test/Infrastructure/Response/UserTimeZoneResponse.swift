import Foundation

struct UserTimeZoneResponse: Codable {
    let offset: String
    let description: String
    
    func toUserTimeZone() -> UserTimeZone {
        return UserTimeZone(offset: offset,
                            description: description)
    }
    
    init(timeZone: UserTimeZone) {
        self.offset = timeZone.offset
        self.description = timeZone.description
    }
}
