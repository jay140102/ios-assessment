# Navigation Drawer iOS Assessment

A production-ready SwiftUI application demonstrating modern iOS development practices, including remote data fetching, complex JSON parsing, and dynamic UI rendering.

## Project Overview

This project implements a navigation drawer interface for an iOS application. It retrieves a structured navigation menu from a remote API and renders it using a custom-designed SwiftUI interface. The application handles profile information, quick actions, and a category-based application list with expansion capabilities.

## Architecture

The project follows the Model-View-ViewModel (MVVM) design pattern to ensure a clean separation of concerns and testability.

- **Models**: Defines the data structures (`NavigationResponse`, `MenuItem`) and conforms to `Codable` for seamless JSON mapping.
- **Views**: SwiftUI views (`ContentView`) responsible for layout and styling. They observe the ViewModel for state changes.
- **ViewModels**: `DrawerViewModel` manages the application state, business logic, and data transformation for the UI.
- **Networking**: `APIService` handles the data fetching layer using `URLSession` and async/await syntax.

## Technical Implementation

### API Handling

The network layer uses `URLSession` with the modern `async/await` concurrency model. Error handling is implemented via a custom `APIError` enum to manage scenarios such as invalid URLs, network connectivity issues, and decoding failures.

### JSON Parsing

Data is parsed from a complex, nested JSON structure using the `Codable` protocol. Custom `CodingKeys` are utilized to map snake_case API response keys to camelCase Swift properties, maintaining idiomatic Swift naming conventions throughout the codebase.

### Section Extraction Logic

The API returns a flat array of menu items where sections are denoted by specific item types and labels. The `DrawerViewModel` implements logic to:
- Identify section headers (e.g., "APPS", "HELP & MORE").
- Dynamically extract items belonging to each section based on their position in the array relative to headers.
- Filter specific utility items like "Messages", "Notifications", "Rate Us", and "Sign Out" for specialized placement in the UI.

## Folder Structure

- `NavigationDrawerApp/`
  - `NavigationDrawerAppApp.swift`: Application entry point.
  - `ContentView.swift`: Main UI implementation including layout components.
  - `DrawerViewModel.swift`: State management and business logic.
  - `NavigationResponse.swift`: Data models and Codable structures.
  - `APIService.swift`: Singleton network service for API communication.

## How to Run

1. Clone or download the source code.
2. Open `NavigationDrawerApp.xcodeproj` in Xcode 13 or later.
3. Ensure the active scheme is set to `NavigationDrawerApp`.
4. Select a simulator or physical device running iOS 15.0 or later.
5. Press `Cmd + R` to build and run the application.

## Technical Decisions

- **No Third-Party Libraries**: The project relies exclusively on Apple's first-party frameworks (SwiftUI, Foundation) to minimize binary size and dependency overhead.
- **Async/Await**: Utilized for clean, readable asynchronous code instead of tradition completion handlers.
- **LazyVGrid**: Used for the menu grid to optimize performance by only rendering items as they become visible on screen.
- **State Selection**: Used `@StateObject` for the ViewModel to ensure its lifecycle is tied correctly to the view hierarchy.
- **System Grouped Background**: Used standard system colors and shadows to provide a native iOS feel while matching the provided design requirements.
