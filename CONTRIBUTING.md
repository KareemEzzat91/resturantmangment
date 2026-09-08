# Contributing

Thanks for your interest in improving Restaurant Management.

## Development Setup

1. Install Flutter and a compatible Dart SDK.
2. Clone the repository.
3. Run `flutter pub get`.
4. Run `flutter analyze` before submitting changes.
5. Run the application with `flutter run`.

## Code Guidelines

- Keep screens focused on presentation and user interaction.
- Reuse the centralized API helper for HTTP requests.
- Keep API response mapping inside model classes.
- Prefer clear, descriptive names for methods and variables.
- Avoid committing secrets, API keys, generated build artifacts, or local configuration files.
- Keep user-facing strings readable and consistent.

## Commit Messages

Use short, descriptive commit messages such as:

```text
feat: add reservation validation
fix: handle failed payment response
refactor: simplify branch loading state
docs: update setup instructions
chore: update dependencies
```

## Pull Requests

A useful pull request should explain:

- What changed
- Why the change was needed
- How it was tested
- Any screenshots or recordings for UI changes

For UI work, include before/after screenshots when practical.
