import Foundation

struct UILRemoteDataService {
    let session: URLSession
    let decoder: JSONDecoder
    let baseDataURL = URL(string: "https://kelleyparker.github.io/UIL_PrescribedMusicList/data/")!

    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
    }

    func loadStats(for dataset: UILDataset) async throws -> UILDatasetStats {
        let (data, response) = try await session.data(from: baseDataURL.appendingPathComponent(dataset.statsPath))
        try validate(response: response)
        return try decoder.decode(UILDatasetStats.self, from: data)
    }

    func loadSongs(for dataset: UILDataset) async throws -> [UILSong] {
        let (data, response) = try await session.data(from: baseDataURL.appendingPathComponent(dataset.songsPath))
        try validate(response: response)
        return try decoder.decode([UILSong].self, from: data)
    }

    private func validate(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
    }
}
