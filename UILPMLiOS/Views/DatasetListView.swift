import SwiftUI

struct DatasetListView: View {
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Texas UIL Prescribed Music List")
                        .font(.title2.weight(.bold))
                    Text("Browse the same datasets used by the web app, with fast mobile search, class filters, public-domain links, and affiliate sheet-music links when available.")
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
            }

            ForEach(UILDatasetCatalog.grouped, id: \.section) { group in
                Section(group.section.rawValue) {
                    ForEach(group.datasets) { dataset in
                        NavigationLink(value: dataset) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(dataset.label)
                                    .font(.headline)
                                Text(group.section.subtitle)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 2)
                        }
                    }
                }
            }
        }
        .navigationDestination(for: UILDataset.self) { dataset in
            DatasetBrowserView(viewModel: DatasetBrowserViewModel(dataset: dataset))
        }
        .listStyle(.insetGrouped)
    }
}
