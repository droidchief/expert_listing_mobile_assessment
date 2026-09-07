# Expert Listing — Mobile

A Flutter client for Expert Listing: a property-listing social feed with stories, posts (text/image/video), likes, comments, filters, and a composer.

## Running the app

```bash
flutter pub get
flutter run
```

The API base URL and mock user ID are compile-time overridable, in case you need to point at a different backend:

```bash
flutter run --dart-define=API_BASE_URL=https://your-api.example.com/api/v1 \
            --dart-define=MOCK_USER_ID=00000000-0000-0000-0000-000000000001
```

By default it points at the shared dev backend, with a mocked-user header standing in for real auth.

## Design decisions

- **State management**: Cubit (`flutter_bloc`) throughout — no `freezed`, models use `json_serializable`/`equatable` instead.
- **Navigation**: `go_router` with a `StatefulShellRoute` for the bottom-nav tabs (each keeps its own scroll/nav stack), plus root-level routes for the story viewer and composer so they render full-screen over the shell.
- **Networking**: `dio` with a layered interceptor chain (auth header → logging → error mapping), converting failures into a typed `Failure` hierarchy so every screen handles errors the same way.
- **Theming**: every color, spacing value, and text style is a token in `core/theme/` — no hex literals or magic numbers in feature code.
- **Sheets**: comments, filters, and the location picker are all `DraggableScrollableSheet`s inside a modal bottom sheet, sharing the same drag-to-dismiss and layout conventions.
- **Optimistic UI**: likes and the double-tap-to-like heart update the UI immediately and roll back on API failure.
- **Media**: images are compressed (WebP, capped at 1600px) and stripped of EXIF before upload.
- **Mock data**: stories are mocked client-side (the real `/stories` endpoint doesn't yet return per-story detail); everything else hits the live API.

## Screens

<img width="330" height="717" alt="Simulator Screenshot - iPhone 16 Pro Max - 2026-09-07 at 16 13 20" src="https://github.com/user-attachments/assets/7e22522c-c965-4056-aca8-c37184d94b15" />

<img width="330" height="717" alt="Simulator Screenshot - iPhone 16 Pro Max - 2026-09-07 at 16 13 58" src="https://github.com/user-attachments/assets/55aba8df-977d-485e-956e-786ef65d0d87" />

<img width="330" height="717" alt="Simulator Screenshot - iPhone 16 Pro Max - 2026-09-07 at 16 14 31" src="https://github.com/user-attachments/assets/8a29c6f2-8c5e-46cb-82ff-fb45c837fe82" />

<img width="330" height="717" alt="Simulator Screenshot - iPhone 16 Pro Max - 2026-09-07 at 16 15 27" src="https://github.com/user-attachments/assets/bb581aa6-bb01-49ac-8184-d879b38f4a14" />

<img width="330" height="717" alt="Simulator Screenshot - iPhone 16 Pro Max - 2026-09-07 at 16 15 40" src="https://github.com/user-attachments/assets/307c2831-b833-4122-aa0f-440f01ed53bd" />





