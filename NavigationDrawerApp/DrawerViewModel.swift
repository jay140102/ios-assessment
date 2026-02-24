import Foundation

@MainActor
final class DrawerViewModel: ObservableObject {
    @Published var navigationResult: NavigationResult?
    @Published var appItems: [MenuItem] = []
    @Published var helpItems: [MenuItem] = []
    @Published var quickActions: [MenuItem] = []
    @Published var rateUsItem: MenuItem?
    @Published var signOutItem: MenuItem?
    
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
            parseMenus(response.result.menus)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    private func parseMenus(_ menus: [MenuItem]) {
        var currentSection: String = ""
        var tempApps: [MenuItem] = []
        var tempHelp: [MenuItem] = []
        var tempQuick: [MenuItem] = []
        
        for item in menus {
            if item.type == 0 {
                currentSection = item.label
                continue
            }
            
            if item.label == "Messages" || item.label == "Notifications" {
                tempQuick.append(item)
                continue
            }
            
            if item.label == "Rate Us" {
                rateUsItem = item
                continue
            }
            
            if item.label == "Sign Out" {
                signOutItem = item
                continue
            }

            if currentSection == "APPS" {
                tempApps.append(item)
            } else if currentSection == "HELP & MORE" {
                tempHelp.append(item)
            }
        }
        
        self.appItems = tempApps
        self.helpItems = tempHelp
        self.quickActions = tempQuick
    }
}
