import Foundation

struct UILSong: Identifiable, Decodable, Hashable {
    let uilCode: String
    let instrumentSlug: String?
    let instrumentName: String?
    let eventName: String
    let title: String
    let composer: String
    let arranger: String?
    let publishers: [String]
    let publisherText: String
    let classLevel: Int
    let specification: String
    let noMemoryRequired: Bool
    let publicDomainPdfURL: URL?
    let publicDomainSource: String?
    let sheetMusicAffiliateURL: URL?
    let sheetMusicAffiliateLabel: String?
    let sheetMusicAffiliateSource: String?

    var id: String { uilCode }

    enum CodingKeys: String, CodingKey {
        case uilCode
        case instrumentSlug
        case instrumentName
        case eventName
        case title
        case composer
        case arranger
        case publishers
        case publisherText
        case classLevel
        case specification
        case noMemoryRequired
        case publicDomainPdfURL = "publicDomainPdfUrl"
        case publicDomainSource
        case sheetMusicAffiliateURL = "sheetMusicAffiliateUrl"
        case sheetMusicAffiliateLabel
        case sheetMusicAffiliateSource
    }
}
