# Clean Water and Sanitation: Water Leakage Reporting App (AquaReport)

An academic, beginner-friendly Flutter Web application developed to support **United Nations Sustainable Development Goal 6 (SDG 6): Clean Water and Sanitation**.

The application empowers citizens to promptly report water leakages, pipeline breaches, broken public taps, and overflowing tanks in their locality, while providing transparent tracking and live community impact metrics.

---

## 1. Project Overview
- **Project Title:** Clean Water and Sanitation: Water Leakage Reporting App
- **Academic Domain:** Web & Mobile Application Development / Civic Technology
- **Theme:** UN Sustainable Development Goal 6 (Clean Water and Sanitation)
- **Target Platform:** Web (Desktop, Tablet, Mobile Browsers)
- **Architecture:** Flutter Material 3 with In-Memory Session State Management (`StatefulWidget` and `ChangeNotifier`)

---

## 2. Problem Statement
Municipal water distribution utilities report that up to **30% to 45% of treated drinking water** is lost due to undetected underground pipe fractures, public standpost damages, and storage tank overflow before it reaches consumer taps. Conventional reporting mechanisms rely on manual utility patrols or bureaucratic complaint books, leading to significant delays and millions of liters of clean water wastage.

---

## 3. Project Objectives
1. **Rapid Reporting:** Allow any citizen to log a water leakage complaint in under 60 seconds with location, incident type, and description.
2. **Instant Tracking:** Provide real-time status tracking using auto-generated unique complaint reference IDs (e.g., `WLR-1001`).
3. **Dynamic Demonstration:** Permit simulated workflow transitions between **Pending**, **In Progress**, and **Resolved** to verify real-time metric synchronization across the application.
4. **Civic Awareness:** Promote water conservation by linking local leakage resolution directly to UN SDG Target 6.1 and 6.4.

---

## 4. Key Features
- **Dashboard / Home:**
  - Dynamic KPI summary cards: Total Reported, Pending Action, In Progress, and Resolved Issues.
  - One-click navigation to report or track issues.
  - Recent community complaints feed with status badges.
  - SDG 6 Impact & water conservation information section.
- **Report Leakage Page:**
  - Citizen name, location, problem description, and reporting date.
  - Leakage category selector (*Pipe Leakage*, *Broken Public Tap*, *Overflowing Water Tank*, *Other*).
  - Simulated photo attachment selector.
  - Form validation with clear error feedback.
  - Unique sequential Complaint ID generation upon successful submission (`WLR-XXXX`).
- **View Complaints Page:**
  - Pre-populated with 8 realistic sample complaints across different municipal zones.
  - Full search capability by Complaint ID, location, citizen name, or incident type.
  - Filter chips for *All*, *Pending*, *In Progress*, and *Resolved*.
  - Individual complaint cards with responsive layouts.
- **Complaint Details & Tracking:**
  - Visual status progress stepper (Reported &rarr; In Progress &rarr; Resolved).
  - Detailed breakdown of incident location, reporter name, and description.
  - **Academic Demonstration Panel:** Interactive status updater allowing examiners to change status and observe dashboard counts update instantaneously.
- **Track Complaint Page:**
  - Quick ID lookup input with instant search.
  - Demo test chips for single-click examination testing.
- **About Project Page:**
  - Comprehensive explanation of problem statement, objectives, system workflow, and UN SDG 6 alignment.
  - Ready-to-fill Academic Project metadata section.

---

## 5. Technologies Used
- **Frontend Framework:** Flutter 3.x (Web)
- **Programming Language:** Dart 3.x
- **UI Design System:** Material Design 3 (Water-themed palette: Deep Sky Blue, Teal, Eco-Green, White)
- **State Management:** Flutter built-in `ChangeNotifier` and `StatefulWidget` (zero external paid/complex packages)
- **Storage:** Shared in-memory session registry (resets upon page reload)

---

## 6. Project Structure

```text
lib/
├── main.dart                          # Application entry point & Material 3 theme configuration
├── models/
│   └── complaint.dart                 # Complaint model, status enum, and 8 sample records
├── services/
│   └── complaint_service.dart         # In-memory shared state service with ChangeNotifier
├── screens/
│   ├── main_shell.dart                # Responsive top navigation & mobile drawer shell
│   ├── home_screen.dart               # Dashboard with KPI cards, quick actions & SDG facts
│   ├── report_leakage_screen.dart     # Reporting form with validation & ID generation
│   ├── complaints_screen.dart         # Complaints catalog with search and status filtering
│   ├── complaint_details_screen.dart  # Full details, progress stepper & viva demo controls
│   ├── track_complaint_screen.dart    # ID tracking interface with quick test chips
│   └── about_screen.dart              # SDG 6 mission, problem statement & project info
└── widgets/
    ├── summary_card.dart              # Reusable metric summary card
    ├── complaint_card.dart            # Reusable complaint listing card
    └── status_badge.dart              # Status chip with color and icon indicators

test/
├── widget_test.dart                   # Smoke test for core UI layout
└── app_test.dart                      # Comprehensive unit and integration test suite
```

---

## 7. Setup and Running Locally

### Prerequisites
- Flutter SDK (version 3.19 or later)
- Google Chrome browser installed

### Run Commands
1. Clone or extract the project folder:
   ```bash
   cd Water-Leakage-Reporting-App
   ```
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Run the code analyzer:
   ```bash
   flutter analyze
   ```
4. Run the automated test suite:
   ```bash
   flutter test
   ```
5. Launch the application in Google Chrome:
   ```bash
   flutter run -d chrome
   ```
   *(Alternatively, run with web-server mode: `flutter run -d web-server --web-port 8080`)*

---

## 8. Building the Web Version
To generate an optimized, production-ready static web bundle:
```bash
flutter build web --release
```
The compiled static website files will be generated in `build/web/`. These files can be hosted directly on GitHub Pages, Firebase Hosting, Netlify, Vercel, or any standard HTTP web server (e.g. Apache, Nginx, or Python `http.server`).

---

## 9. Limitations of the Basic Version
- **Session-Based Storage:** As required for this beginner academic prototype, complaints are stored in in-memory Dart lists during the browser session. Data resets when the page is refreshed.
- **No External Database / Backend:** Does not use Firebase, SQL databases, or external APIs to ensure zero-cost, self-contained demonstration without requiring paid credentials or API keys.
- **Simulated Municipal Actions:** Status update buttons are provided directly on the complaint details screen for academic viva demonstration rather than an authenticated municipal administration portal.
- **Simulated Photo Upload:** Photo attachments use curated visual problem tags rather than external cloud storage buckets.
