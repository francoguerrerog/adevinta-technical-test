import Foundation

struct NameResponse: Codable {
    let title: String
    let first: String
    let last: String
    
    func toName() -> Name {
        return Name(title: title, first: first, last: last)
    }
    
    init(name: Name) {
        self.title = name.title
        self.first = name.first
        self.last = name.last
    }
}
