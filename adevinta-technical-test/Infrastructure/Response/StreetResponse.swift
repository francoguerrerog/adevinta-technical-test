import Foundation

struct StreetResponse: Codable {
    let number: Int
    let name: String
    
    func toStreet() -> Street {
        return Street(number: number,
                      name: name)
    }
}
