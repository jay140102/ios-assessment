import Foundation

@MainActor
final class DrawerViewModel: ObservableObject {
    @Published var navigationResult: NavigationResult?
    @Published var appItems: [MenuItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showAllApps: Bool = false

    var displayedAppItems: [MenuItem] {
        showAllApps ? appItems : Array(appItems.prefix(4))
    }

    func fetchNavigation() async {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await APIService.shared.fetchNavigation()
            navigationResult = response.result
            appItems = extractAppsSection(from: response.result.menus)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    private func extractAppsSection(from menus: [MenuItem]) -> [MenuItem] {
        var collecting = false
        var result: [MenuItem] = []

        for item in menus {
            if item.type == 0 && item.label == "APPS" {
                collecting = true
                continue
            }
            if collecting {
                if item.type == 0 {
                    break
                }
                if item.type == 1 {
                    result.append(item)
                }
            }
        }

        return result
    }
}
