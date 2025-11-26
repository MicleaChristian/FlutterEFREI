# 🧪 Testing Guide for Todo App

This document explains how to run tests and what tests are available in the project.

## 📋 Test Coverage

### **Unit Tests** ✅
- **`Todo` Model**: Tests for data conversion, priority handling, and edge cases
- **`TodoProvider`**: Tests for state management, filtering, and data operations

### **Widget Tests** ✅
- **`TodoItem`**: Tests for individual todo item display and interactions
- **`HomeScreen`**: Tests for main screen layout and functionality
- **`AuthScreen`**: Tests for authentication screen components

### **Integration Tests** 🚧 (Coming Soon)
- **Full App Flow**: End-to-end testing of authentication and todo management
- **User Switching**: Testing account switching and data isolation

## 🚀 Running Tests

### **Install Dependencies**
```bash
flutter pub get
```

### **Run All Tests**
```bash
# Run all tests
flutter test

# Run with verbose output
flutter test --verbose

# Run specific test file
flutter test test/unit/todo_model_test.dart

# Run tests with coverage report
flutter test --coverage
```

### **Run Tests by Category**
```bash
# Run only unit tests
flutter test test/unit/

# Run only widget tests
flutter test test/widgets/

# Run specific test group
flutter test --name "Todo Model Tests"
```

### **Generate Mock Files** (if using Mockito)
```bash
# Generate mock classes for testing
flutter packages pub run build_runner build

# Watch for changes and auto-generate
flutter packages pub run build_runner watch
```

## 🧩 Test Structure

```
test/
├── all_tests.dart              # Test suite runner
├── test_config.dart            # Common test configuration
├── unit/                       # Unit tests
│   ├── todo_model_test.dart    # Todo model tests
│   └── todo_provider_test.dart # TodoProvider tests
└── widgets/                    # Widget tests
    ├── todo_item_test.dart     # TodoItem widget tests
    ├── home_screen_test.dart   # HomeScreen tests
    └── auth_screen_test.dart   # AuthScreen tests
```

## 📝 Writing New Tests

### **Unit Test Template**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_web_app/your_file.dart';

void main() {
  group('YourClass Tests', () {
    late YourClass instance;

    setUp(() {
      instance = YourClass();
    });

    test('should do something correctly', () {
      // Arrange
      final input = 'test';
      
      // Act
      final result = instance.doSomething(input);
      
      // Assert
      expect(result, equals('expected'));
    });
  });
}
```

### **Widget Test Template**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_web_app/widgets/your_widget.dart';

void main() {
  group('YourWidget Tests', () {
    testWidgets('should display correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: YourWidget(),
        ),
      );

      expect(find.text('Expected Text'), findsOneWidget);
    });
  });
}
```

## 🔧 Test Configuration

### **Test Helpers**
The `TestConfig` class provides common test utilities:
- `createTestApp()`: Creates test app with providers
- `waitForWidgetToSettle()`: Handles async operations
- `createMockTodoData()`: Creates test data

### **Mocking Services**
For testing with Firebase services, use Mockito:
```dart
@GenerateMocks([TodoService, AuthService])
void main() {
  late MockTodoService mockTodoService;
  
  setUp(() {
    mockTodoService = MockTodoService();
  });
}
```

## 📊 Test Results

### **Expected Test Output**
```
Running "flutter pub get" in my_flutter_web_app...
Running tests...
00:00 +0: Todo Model Tests
00:00 +1: Todo Model Tests
00:00 +2: Todo Model Tests
...
00:01 +15: All tests passed!
```

### **Coverage Report**
After running with `--coverage`, view the report:
```bash
# Install lcov if not available
brew install lcov

# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html

# Open in browser
open coverage/html/index.html
```

## 🚨 Common Test Issues

### **Provider Errors**
If you see provider-related errors:
```dart
// Wrap your widget with necessary providers
await tester.pumpWidget(
  MultiProvider(
    providers: [
      ChangeNotifierProvider<TodoProvider>.value(value: todoProvider),
      ChangeNotifierProvider<AuthService>.value(value: authService),
    ],
    child: YourWidget(),
  ),
);
```

### **Async Operations**
For async operations, use:
```dart
await tester.pumpAndSettle();
await TestConfig.waitForWidgetToSettle(tester);
```

### **Firebase Mocking**
For Firebase operations in tests:
```dart
// Use Mockito to mock Firebase services
when(mockTodoService.getTodosStream()).thenAnswer(
  (_) => Stream.value([])
);
```

## 🎯 Best Practices

1. **Test Naming**: Use descriptive test names that explain the expected behavior
2. **Arrange-Act-Assert**: Structure tests with clear sections
3. **Isolation**: Each test should be independent and not rely on other tests
4. **Mocking**: Mock external dependencies (Firebase, network calls)
5. **Coverage**: Aim for at least 80% code coverage
6. **Edge Cases**: Test error conditions and boundary cases

## 🔄 Continuous Integration

### **GitHub Actions** (Coming Soon)
```yaml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter test
```

## 📚 Additional Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Widget Testing Guide](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Mockito Package](https://pub.dev/packages/mockito)
- [Provider Testing](https://pub.dev/packages/provider#testing)

## 🆘 Troubleshooting

### **Tests Not Running**
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter test
```

### **Mock Generation Issues**
```bash
# Clean generated files
flutter packages pub run build_runner clean
flutter packages pub run build_runner build
```

### **Provider Context Errors**
Ensure your test widgets are wrapped with necessary providers and use `TestConfig.createTestApp()` helper.

---

**Happy Testing! 🎉**
