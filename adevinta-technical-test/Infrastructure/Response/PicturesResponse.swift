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
    
    init(pictures: Pictures) {
        self.large = pictures.large
        self.medium = pictures.medium
        self.thumbnail = pictures.thumbnail
    }
}
