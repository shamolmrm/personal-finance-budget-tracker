# Personal Finance & Budget Tracker

Flutter app to track income and expenses, set budgets and savings goals, and see where money goes — with charts, receipt scanning and reminders.

The app lives in [`finance_app/`](finance_app/).

## Features (modules in `lib/features/`)
| Module | What it does |
|---|---|
| `auth` | Sign up / log in (Supabase) |
| `dashboard` | Balance overview and recent activity |
| `transactions` | Add, edit and list income & expenses |
| `budget` | Budgets per category |
| `goals` | Savings goals with progress |
| `analytics` | Spending charts (fl_chart) |
| `ai` | Receipt text recognition (Google ML Kit) and insights |
| `profile` | Settings and account |

## Stack
Flutter · Riverpod · Supabase · Hive (offline cache) · fl_chart · Lottie · Google ML Kit · Firebase Messaging · local notifications · Stripe · flutter_secure_storage

## Setup
```bash
cd finance_app
flutter pub get
```
1. Create a Supabase project and run `supabase_schema.sql` in its SQL editor.
2. Add your Supabase URL / anon key to the app config (do not commit real keys).
3. `flutter run`
