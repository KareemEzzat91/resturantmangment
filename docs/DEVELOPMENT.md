# Development Guide

## Local Workflow

```bash
flutter pub get
flutter analyze
flutter run
```

## Before Committing

- Verify the application builds locally.
- Run static analysis.
- Test the affected customer or admin flow manually.
- Check loading, success, and error states.
- Confirm no credentials or private configuration were added.
- Add or update documentation when a feature changes the user flow.

## UI Changes

When modifying screens, test different screen sizes where possible and attach screenshots to the pull request. Keep animations purposeful and avoid blocking primary user actions.

## API Changes

When adding an endpoint:

1. Add the API operation through `ApiHelper`.
2. Add or update the relevant model.
3. Add the Cubit method that coordinates the request.
4. Emit appropriate loading, success, and error states.
5. Update API documentation when the endpoint affects the public application flow.

## Future Refactoring Direction

The current codebase can gradually evolve toward feature-first Clean Architecture without requiring a full rewrite. New features can introduce their own presentation, domain, data, repository, and service boundaries while existing screens continue to work.
