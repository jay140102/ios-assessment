import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = DrawerViewModel()

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                mainContent
            }
        }
        .task {
            await viewModel.fetchNavigation()
        }
    }

    private var mainContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                profileSection
                Divider()
                    .padding(.vertical, 12)
                appsSection
            }
            .padding()
        }
    }

    private var profileSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(viewModel.navigationResult?.title ?? "")
                .font(.headline)
            Text(viewModel.navigationResult?.walletAmount ?? "")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }

    private var appsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("APPS")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.displayedAppItems) { item in
                    appCell(for: item)
                }
            }

            if viewModel.appItems.count > 4 {
                Button {
                    viewModel.showAllApps.toggle()
                } label: {
                    Text(viewModel.showAllApps ? "See Less" : "See More")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .padding(.top, 4)
            }
        }
    }

    private func appCell(for item: MenuItem) -> some View {
        VStack(spacing: 8) {
            AsyncImage(url: URL(string: item.icon)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Color.secondary.opacity(0.2)
            }
            .frame(width: 44, height: 44)
            .cornerRadius(8)

            Text(item.label)
                .font(.caption)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}
