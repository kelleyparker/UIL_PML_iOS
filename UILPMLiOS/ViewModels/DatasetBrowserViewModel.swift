import Foundation
import Observation

@MainActor
@Observable
final class DatasetBrowserViewModel {
    enum LoadState: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    let dataset: UILDataset

    var stats: UILDatasetStats?
    var allSongs: [UILSong] = []
    var visibleSongs: [UILSong] = []
    var selectedClassFilter = "all"
    var query = ""
    var state: LoadState = .idle

    private let service: UILRemoteDataService

    init(dataset: UILDataset, service: UILRemoteDataService = UILRemoteDataService()) {
        self.dataset = dataset
        self.service = service
    }

    var availableClassFilters: [String] {
        guard let stats else { return ["all"] }
        let levels = stats.classBreakdown.keys
            .compactMap(Int.init)
            .sorted(by: >)
            .map(String.init)
        return ["all"] + levels + (stats.noMemoryRequiredCount > 0 ? ["nmr"] : [])
    }

    func loadIfNeeded() async {
        guard state == .idle else { return }
        await reload()
    }

    func reload() async {
        state = .loading
        do {
            async let statsRequest = service.loadStats(for: dataset)
            async let songsRequest = service.loadSongs(for: dataset)
            stats = try await statsRequest
            allSongs = try await songsRequest
            applyFilters()
            state = .loaded
        } catch {
            state = .failed(error.localizedDescription)
        }
    }

    func applyFilters() {
        let loweredQuery = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        visibleSongs = allSongs.filter { song in
            let classMatches: Bool = {
                switch selectedClassFilter {
                case "all":
                    true
                case "nmr":
                    song.noMemoryRequired
                default:
                    String(song.classLevel) == selectedClassFilter
                }
            }()

            guard classMatches else { return false }

            guard loweredQuery.isEmpty == false else { return true }

            return song.title.lowercased().contains(loweredQuery)
                || song.composer.lowercased().contains(loweredQuery)
                || song.publisherText.lowercased().contains(loweredQuery)
                || song.uilCode.lowercased().contains(loweredQuery)
                || song.eventName.lowercased().contains(loweredQuery)
        }
    }
}
