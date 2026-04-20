# Live Session App – Flutter Assignment (Senior Level)

## Overview

Build a Flutter application that simulates a platform where users can discover, book, and join live sessions (e.g., fitness, meditation, etc.).

---

## Core Features

* View sessions categorized as:

  * Upcoming
  * Live
  * Completed

* View session details

* Book/register for sessions

* Join live session (simulated UI)

---

## Key Requirements

### 1. Architecture

* Use a scalable architecture (Clean Architecture / MVVM preferred)
* Ensure clear separation of concerns

---

### 2. State Management

* Use a structured state management approach (Bloc / Riverpod / Provider)

---

### 3. Pagination

* Implement pagination for session listing
* Simulate large datasets

---

### 4. Offline Support

* Cache data locally
* Show last available data when offline

---

### 5. Booking & Persistence

* Persist user bookings locally

---

### 6. Session State Handling

* Handle transitions:

  * upcoming → live → completed

---

### 7. Live Session Simulation

* Display:

  * Live indicator
  * Session timer (countdown or running)
  * Placeholder UI for video

---

### 8. Rejoin Session

* Allow user to rejoin session if they leave

---

### 9. Basic Chat (Mocked or Polling-Based)

* Implement simple chat UI
* Real-time not required

---

## Data Source

Use a local JSON file or mock data.

Your implementation should:

* Simulate API behavior (delay, pagination)
* Be easily replaceable with a real API

---

## Sample Data

```json
[
  {
    "id": "1",
    "title": "Morning Fitness",
    "instructor": "Amit Sharma",
    "startTime": "2026-04-20T08:00:00Z",
    "endTime": "2026-04-20T09:00:00Z",
    "status": "upcoming"
  }
]
```

---

## Constraints

* Do NOT put business logic in UI
* Do NOT hardcode everything in one file
* Use proper layering (data/domain/presentation)

---

## Deliverables

* Updated GitHub repository
* APK file
* README with:
  * Architecture explanation
  * State Management
  * Data Layer Design
  * Trade-offs
  * Improvements
  * Assumptions
* Loom video (5–10 min walkthrough)

---

## Timeline

48 hours

---

## Evaluation Focus

* Architecture quality
* Code structure
* State management
* Problem-solving approach
* Scalability thinking

---

## Optional Bonus

* Integrate video streaming SDK
* Improve chat system
