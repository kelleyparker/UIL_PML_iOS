import Foundation

struct UILDataset: Identifiable, Hashable {
    enum Section: String, CaseIterable, Identifiable {
        case solo = "Solos"
        case ensemble = "Ensembles"
        case largeGroup = "Large Groups"

        var id: String { rawValue }

        var subtitle: String {
            switch self {
            case .solo:
                "Individual literature lists"
            case .ensemble:
                "Small ensemble and chamber literature"
            case .largeGroup:
                "Band, orchestra, choir, and large ensemble lists"
            }
        }
    }

    let slug: String
    let label: String
    let shortLabel: String
    let songsPath: String
    let statsPath: String
    let section: Section

    var id: String { slug }
}
