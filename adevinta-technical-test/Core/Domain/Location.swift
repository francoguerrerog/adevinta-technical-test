import Foundation

struct Location {
    let street: Street
    let city: String
    let state: String
    let country: String
    let postcode: String
    let coordinates: Coordinate
    let timezone: UserTimeZone
}
