import Foundation

struct PicturesResponse: Codable {
    let large: String
    let medium: String
    let thumbnail: String
    
    func toPictures() -> Pictures {
        return Pictures(large: large,
                        medium: medium,
                        thumbnail: thumbnail)
    }
}
