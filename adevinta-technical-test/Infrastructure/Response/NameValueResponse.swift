import Foundation

struct NameValueResponse: Codable {
    let name: String?
    let value: String?
    
    func toNameValue() -> NameValue {
        return NameValue(name: name,
                         value: value)
    }
    
    init(nameValue: NameValue) {
        self.name = nameValue.name
        self.value = nameValue.value
    }
}
