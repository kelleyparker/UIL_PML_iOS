import SwiftUI

struct DatasetBrowserView: View {
    @State private var viewModel: DatasetBrowserViewModel

    init(viewModel: DatasetBrowserViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                ProgressView("Loading \(viewModel.dataset.label)")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

            case .failed(let message):
                ContentUnavailableView(
                    "Couldn’t Load Dataset",
                    systemImage: "wifi.exclamationmark",
                    description: Text(message)
                )

            case .loaded:
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        if let stats = viewModel.stats {
                            DatasetStatsHeader(dataset: viewModel.dataset, stats: stats)
                        }

                        classFilters

                        LazyVStack(spacing: 14) {
                            ForEach(viewModel.visibleSongs) { song in
                                SongCardView(song: song)
                            }
                        }
                    }
                    .padding()
                }
                .background(Color(.systemGroupedBackground))
            }
        }
        .navigationTitle(viewModel.dataset.label)
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $viewModel.query, prompt: "Search title, composer, publisher, or UIL code")
        .task {
            await viewModel.loadIfNeeded()
        }
        .onChange(of: viewModel.query) { _, _ in
            viewModel.applyFilters()
        }
    }

    private var classFilters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(viewModel.availableClassFilters, id: \.self) { filter in
                    Button {
                        viewModel.selectedClassFilter = filter
                        viewModel.applyFilters()
                    } label: {
                        Text(filterTitle(filter))
                            .font(.subheadline.weight(.semibold))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(viewModel.selectedClassFilter == filter ? Color.accentColor : Color(.secondarySystemFill))
                            .foregroundStyle(viewModel.selectedClassFilter == filter ? .white : .primary)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func filterTitle(_ filter: String) -> String {
        switch filter {
        case "all":
            "All Classes"
        case "nmr":
            "No Memory Required"
        default:
            "Class \(filter)"
        }
    }
}

private struct DatasetStatsHeader: View {
    let dataset: UILDataset
    let stats: UILDatasetStats

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(stats.schoolYear)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            Text(dataset.label)
                .font(.title2.weight(.bold))

            HStack(spacing: 12) {
                statChip("\(stats.songCount)", "Titles")
                statChip("\(stats.databaseRecordCount)", "Records")
                statChip("\(stats.publicDomainPdfCount)", "PDFs")
                statChip("\(stats.noMemoryRequiredCount)", "NMR")
            }

            if let audit = stats.notes["dataset_audit"] {
                Text(audit)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [Color(red: 0.11, green: 0.19, blue: 0.35), Color(red: 0.37, green: 0.11, blue: 0.22)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private func statChip(_ value: String, _ label: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value)
                .font(.headline.weight(.bold))
            Text(label)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.8))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.white.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

private struct SongCardView: View {
    let song: UILSong

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        badge("Class \(song.classLevel)", color: Color(red: 0.13, green: 0.31, blue: 0.62))
                        badge(song.eventName, color: Color(.secondarySystemFill), textColor: .primary)
                    }

                    Text(song.title)
                        .font(.title3.weight(.bold))
                    Text(song.composer)
                        .font(.headline)
                        .foregroundStyle(Color(red: 0.81, green: 0.18, blue: 0.28))
                }

                Spacer(minLength: 12)

                Text(song.uilCode)
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Publisher(s)")
                    .font(.headline)
                ForEach(song.publishers, id: \.self) { publisher in
                    Text("• \(publisher)")
                        .foregroundStyle(.secondary)
                }
            }

            Text(song.specification.isEmpty ? "No additional UIL specification listed." : song.specification)
                .foregroundStyle(.secondary)

            if song.noMemoryRequired {
                Text("No Memory Required")
                    .font(.footnote.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(Color.red.opacity(0.12))
                    .foregroundStyle(.red)
                    .clipShape(Capsule())
            }

            HStack {
                Spacer()
                VStack(alignment: .trailing, spacing: 10) {
                    if let url = song.publicDomainPdfURL {
                        Link(destination: url) {
                            actionButtonLabel("Open Public Domain PDF")
                        }
                    }

                    if let url = song.sheetMusicAffiliateURL {
                        Link(destination: url) {
                            actionButtonLabel(song.sheetMusicAffiliateLabel ?? "Buy Sheet Music")
                        }
                    }
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color(red: 0.18, green: 0.24, blue: 0.35), lineWidth: 1)
        )
    }

    private func badge(_ title: String, color: Color, textColor: Color = .white) -> some View {
        Text(title)
            .font(.subheadline.weight(.bold))
            .foregroundStyle(textColor)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(color)
            .clipShape(Capsule())
    }

    private func actionButtonLabel(_ title: String) -> some View {
        Text(title)
            .font(.headline.weight(.bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(Color(red: 0.78, green: 0.10, blue: 0.18))
            .clipShape(Capsule())
    }
}
