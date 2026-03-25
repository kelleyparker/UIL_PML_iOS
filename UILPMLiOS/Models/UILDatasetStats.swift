import Foundation

struct UILDatasetStats: Decodable, Hashable {
    let schoolYear: String
    let instrumentSlug: String?
    let instrumentName: String?
    let songCount: Int
    let publisherCount: Int
    let noteCount: Int
    let databaseRecordCount: Int
    let classBreakdown: [String: Int]
    let noMemoryRequiredCount: Int
    let publicDomainPdfCount: Int
    let eventBreakdown: [String: Int]?
    let notes: [String: String]
}
