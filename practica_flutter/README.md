# Task Manager

A Flutter application with hierarchical navigation (Navigator), tabs (TabController), and navigation drawer (Drawer) following MVVM architecture.

## Features

- **MVVM Architecture**: Clean separation of UI (Views), business logic (ViewModels), and data (Models).
- **Multiple Navigation Types**:
  - Hierarchical Navigation (Navigator) between screens
  - Tab Navigation for different task categories
  - Drawer Navigation for app sections and categories
- **Task Management**:
  - Create, read, update, and delete tasks
  - Categorize tasks
  - Set priorities
  - Set due dates
  - Mark tasks as complete
- **Modern UI with Material Design**

## Project Structure

```
lib/
├── models/          # Data models
├── views/           # UI components
│   └── tabs/        # Tab views
├── viewmodels/      # Business logic
├── services/        # Data services
├── theme/           # App theme
└── main.dart        # Entry point
```

## Getting Started

1. Clone the repository
2. Install dependencies:
   ```
   flutter pub get
   ```
3. Run the app:
   ```
   flutter run
   ```

## Architecture

This app follows the MVVM (Model-View-ViewModel) architecture:

- **Models**: Define the data structures (Task, Category)
- **Views**: Handle UI and user interactions
- **ViewModels**: Manage business logic and state
- **Services**: Handle data operations

## Dependencies

- provider: ^6.1.1 - For state management
- uuid: ^4.3.3 - For generating unique identifiers

## Development Notes

This application demonstrates:
- Implementation of MVVM pattern in Flutter
- Multiple navigation patterns
- State management with Provider
- UI design with Material components
