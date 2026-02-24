import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = DrawerViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.errorMessage {
                    VStack {
                        Text("Error")
                            .font(.headline)
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task { await viewModel.fetchNavigation() }
                        }
                        .padding(.top)
                    }
                    .padding()
                } else {
                    mainContent
                }
            }
            .navigationBarHidden(true)
        }
        .task {
            await viewModel.fetchNavigation()
        }
    }

    private var mainContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerView
                
                profileCard
                
                quickActionsGrid
                
                sectionHeader(title: "Apps")
                appsGrid
                
                if !viewModel.showAllApps && viewModel.appItems.count > 4 {
                    seeMoreButton
                }
                
                sectionHeader(title: "Help More")
                helpMoreGrid
                
                rateUsButton
                
                signOutButton
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
    }

    // MARK: - Components

    private var headerView: some View {
        HStack {
            Text("Menu")
                .font(.system(size: 34, weight: .bold))
            
            Spacer()
            
            HStack(spacing: 4) {
                Image(systemName: "globe")
                Text("IND-INR-EN")
                    .font(.system(size: 14, weight: .medium))
                Image(systemName: "chevron.down")
                    .font(.system(size: 10))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(UIColor.secondarySystemFill))
            .cornerRadius(20)
            
            Button {
                // Search action
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.black)
                    .padding(10)
                    .background(Color(UIColor.secondarySystemFill))
                    .clipShape(Circle())
            }
        }
        .padding(.top, 10)
    }

    private var profileCard: some View {
        HStack(spacing: 12) {
            ZStack {
                if let photoUrl = viewModel.navigationResult?.userPhoto, let url = URL(string: photoUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                }
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.navigationResult?.title ?? "User Name")
                    .font(.system(size: 18, weight: .semibold))
                
                // Use wallet amount as secondary text if available, otherwise mock
                Text(viewModel.navigationResult?.walletAmount ?? "$0.00")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button("Edit Profile") {
                // Edit action
            }
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.blue)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }

    private var quickActionsGrid: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(viewModel.quickActions) { item in
                menuCell(for: item)
            }
        }
    }

    private func sectionHeader(title: String) -> some View {
        Text(title)
            .font(.system(size: 18, weight: .medium))
            .foregroundColor(.secondary)
            .padding(.top, 8)
    }

    private var appsGrid: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(viewModel.displayedAppItems) { item in
                menuCell(for: item)
            }
        }
    }

    private var helpMoreGrid: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(viewModel.helpItems) { item in
                menuCell(for: item)
            }
        }
    }

    private var seeMoreButton: some View {
        Button {
            withAnimation {
                viewModel.showAllApps.toggle()
            }
        } label: {
            Text("See More")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color(UIColor.secondarySystemFill))
                .cornerRadius(10)
        }
    }

    private var rateUsButton: some View {
        Group {
            if let item = viewModel.rateUsItem {
                HStack {
                    AsyncImage(url: URL(string: item.icon)) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        Image(systemName: "star.bubble")
                            .foregroundColor(.orange)
                    }
                    .frame(width: 24, height: 24)
                    
                    Spacer()
                    
                    Text(item.label)
                        .font(.system(size: 16, weight: .semibold))
                    
                    Spacer()
                    
                    // Empty space to balance the icon on the left
                    Color.clear.frame(width: 24, height: 24)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            }
        }
    }

    private var signOutButton: some View {
        Group {
            if let item = viewModel.signOutItem {
                Button {
                    // Sign out action
                } label: {
                    Text(item.label)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.red, lineWidth: 1)
                                .background(Color.white)
                        )
                }
            }
        }
    }

    private func menuCell(for item: MenuItem) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            AsyncImage(url: URL(string: item.icon)) { image in
                image.resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
            } placeholder: {
                placeholderIcon(for: item.label)
                    .frame(width: 28, height: 28)
            }
            
            Text(item.label)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }

    @ViewBuilder
    private func placeholderIcon(for label: String) -> some View {
        let iconName: String
        let color: Color
        
        switch label.lowercased() {
        case let l where l.contains("message"):
            iconName = "bubble.left.fill"; color = .purple
        case let l where l.contains("notification"):
            iconName = "bell.fill"; color = .red
        case let l where l.contains("album"):
            iconName = "photo.fill"; color = .yellow
        case let l where l.contains("job"):
            iconName = "briefcase.fill"; color = .pink
        case let l where l.contains("crowdfund"):
            iconName = "sun.max.fill"; color = .orange
        case let l where l.contains("group"):
            iconName = "person.2.fill"; color = .blue
        case let l where l.contains("setting"):
            iconName = "gearshape.fill"; color = .purple
        case let l where l.contains("privacy"):
            iconName = "lock.shield.fill"; color = .green
        case let l where l.contains("contact"):
            iconName = "person.crop.circle.badge.questionmark"; color = .red
        case let l where l.contains("term"):
            iconName = "doc.text.fill"; color = .pink
        default:
            iconName = "square.grid.2x2.fill"; color = .gray
        }
        
        Image(systemName: iconName)
            .resizable()
            .scaledToFit()
            .foregroundColor(color)
    }
}
