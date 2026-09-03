# CLAUDE.md — Project Instructions

## Workflow Rules (Follow Every Time)

### Before Planning
- If anything is unclear or missing context or if you want to ask any questions, **ask questions first** before writing a plan.
- Only ask what you actually need answered — do not ask for the sake of it.

### Planning
- Before implementing anything, **present a plan** — even if it's one line.
- The plan must describe what you intend to do and why.
- Wait after presenting the plan. Do **not** start implementing.

### Plan Approval
- Only implement when I explicitly say so (e.g. "go ahead", "implement", "do it").
- If I ask a question about the plan, **answer it and continue waiting**.
- Questions about the plan are not approval. Do not treat them as such.
- If I ask follow-up questions multiple times, keep answering and keep waiting until I give explicit approval.

### Implementation
- Once approved, implement fully and cleanly — do not cut corners.

---

## Memory System

### How It Works
- Project context is stored in topic-specific memory files referenced in `memory.md`.
- Examples: quest progression memory, quest accrual memory, etc.
- At the start of a session, I can tell you which memory files to check.

### Important Rules
- **Never treat memory files as ground truth.** They may be incomplete or outdated.
- Always cross-reference memory with actual code when there is any doubt.
- If you notice a memory file is missing information or is outdated, **proactively suggest updating it**.
- Do not assume a memory file doesn't exist just because I haven't mentioned it — ask if unsure.
- Some memory files are **always relevant regardless of session topic** — check these automatically without being told:
    - `memory.md` — index of all memory files; read this first if you haven't been told which files to check
    - Firebase deploy and project reference files (linked in memory.md) — check these before running any Firebase CLI command
- Update memory files when I ask directly, or when you judge an update is clearly needed.

---

## Commands

```bash
# Run app
flutter run

# Build
flutter build apk
flutter build ios

# Analyze
flutter analyze

# Format
dart format .

# Clean and reinstall dependencies
flutter clean && flutter pub get

# Code generation (run after modifying any freezed or json_serializable files)
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Tech Stack

| Layer | Tool |
|---|---|
| Framework | Flutter / Dart |
| State management | Riverpod (this is also our DI — do not suggest get_it) |
| Navigation | Navigator 1.0 (default Flutter navigator) |
| HTTP | Flutter's built-in `http` package |
| Data classes | freezed + json_serializable |
| Logging | debugPrint() |
| Local storage | None yet |
| Testing | None yet |

---

## Architecture

This project follows **Clean Architecture** with a **feature-based** structure — each feature owns its own `data/`, `domain/`, and `presentation/` layers.

### Top-Level Structure
```
lib/
├── main.dart
├── app.dart          # App root, theme, router wiring
├── core/             # Shared across ALL features — no feature-specific code here
├── features/         # One self-contained folder per feature
└── shared/           # Cross-feature but domain-specific (not generic like core/)
```

### core/
```
core/
  config/       # env, app config
  constants/    # design tokens — colors, typography, spacing, radius
  theme/        # ThemeData assembly from the tokens above
  router/       # router configuration, route names
  network/      # HTTP client, interceptors, connectivity check
  error/        # Failures, exceptions, error mapper (exceptions -> Failures)
  usecase/      # Base UseCase<Type, Params> abstract class
  utils/        # formatters, validators, logger
  widgets/      # Generic, cross-feature UI (buttons, cards, chips, nav bar)
```

### features/
Each feature follows the same three-layer shape:
```
features/<feature>/
├── data/
│   ├── datasources/     # remote (API) + local (cache) data sources
│   ├── models/          # DTOs — fromJson/toJson (+ local storage mapping if cached)
│   └── repositories/    # Repository impl — decides remote vs local, maps exceptions to Failures
├── domain/
│   ├── entities/        # Plain Dart classes, no JSON/storage annotations
│   ├── repositories/    # Abstract repository interface only
│   └── usecases/        # One class per use case, extends core UseCase
└── presentation/
    ├── providers/       # Riverpod providers/controllers, repository wiring
    ├── screens/         # Full pages
    └── widgets/         # Feature-scoped reusable widgets
```

### shared/
Models or providers reused by more than one feature (e.g. a trimmed-down entity used across multiple features) live here instead of being owned by a single feature, to avoid cross-feature imports.

### Rules
- Business logic belongs in `domain/` (entities + usecases) — never in `presentation/`.
- Data sources and repository implementations go in `data/` — never called directly from `presentation/`.
- `presentation/providers/` is the only place that talks to use cases; screens/widgets talk to providers, never to repositories or datasources directly.
- A feature's `domain/` layer must have zero Flutter imports and zero imports from its own `data/` layer.
- A model needed by more than one feature goes in `shared/models/` — not duplicated per feature.
- Theme values come from `core/constants/` and `core/theme/` — never hardcode values in widgets.
- Generic, feature-agnostic widgets go in `core/widgets/`; feature-specific widgets stay inside that feature's `presentation/widgets/`.
- Do not introduce a new top-level layer folder inside a feature beyond `data/domain/presentation` — split within those instead.

### Glass effect ("Liquid Glass")
- Any UI element that floats over photographic or map content (chips, pills, floating bars) must use `GlassSurface` from `core/widgets/glass_surface.dart` instead of a flat translucent color.
- This is a Flutter-drawn effect (`BackdropFilter` + blur, done by Flutter's own renderer) — not a native platform API — so it renders identically on Android and iOS with no per-platform branching.
- Do not apply it to solid UI chrome that isn't floating over dynamic content (primary buttons, flat cards) — those stay flat per the design system.

---

## Code Quality Rules

### General
- Always write **clean code** — every file, every function, every change.
- Write code that is **DRY** — no copy-pasted logic.
- Write code that is **readable** — clear names, obvious intent.
- Write code that is **maintainable** — easy to change without breaking things.
- Follow **single responsibility** — one class/function does one thing.
- Keep files focused — split when a file is doing too much.
-skip the testing i will do that by myself your task is to analyze the code if there is any sort of error in that or not just tell me what to test i will do it myself

### Flutter / Dart Specifics
- Use `const` constructors wherever possible.
- Prefer `StatelessWidget` unless local UI state is genuinely needed.
- Never put business logic inside widgets — keep it in providers or domain layer.
- Never call APIs directly from widgets or providers — go through the repository layer.
- Avoid deeply nested widget trees — extract into named widgets.
- Use meaningful, descriptive names — no abbreviations unless they are universally understood.
- Keep files under **500 lines**. If a file genuinely needs more, 700 lines is the hard cap — never exceed it. If a file is approaching the limit, split it by extracting widgets, helpers, or logic into separate files before it gets there.

---

## Hard Constraints

- **Never use `print()`** — always use `debugPrint()`.
- **Never use `BuildContext` across async gaps** — always check `mounted` before using context after an `await`.
- **Always run build_runner after modifying freezed/json files** — remind me if I forget.
- **Do not introduce new packages** without flagging it and explaining why first.
- **Do not suggest get_it** — Riverpod handles dependency injection.
