# Tap Speed: Pattern Race Backend Handoff

Last updated: 2026-04-02

## Purpose

This document explains the current frontend application flow, what each screen needs from the backend, which parts are already mocked, and the recommended API / WebSocket contract for backend implementation.

It is intended for the backend team so they can build a backend that fits the current Flutter app without guessing frontend intent.

## Product Summary

Tap Speed: Pattern Race is a mobile real-time multiplayer reflex game built in Flutter with a clean feature-based architecture.

Current implemented user flow:

1. Splash screen
2. Auth entry screen
3. Home shell with 4 tabs:
   - Lobby
   - Leaderboard
   - Shop
   - Profile
4. Lobby -> Matchmaking
5. Matchmaking -> Gameplay

Important current status:

- Splash, auth, lobby, leaderboard, shop, and profile are fully implemented UI screens.
- Matchmaking and gameplay are currently demo-driven at the UI layer.
- A real integration-oriented gameplay data path already exists in the codebase using WebSocket abstractions, even though the visible gameplay screen is temporarily mocked for UI development.

## Frontend Architecture Notes

Relevant frontend integration points:

- App shell: `lib/app.dart`
- Auth state: `lib/features/auth/presentation/controllers/auth_controller.dart`
- Auth session model: `lib/features/auth/domain/entities/auth_session.dart`
- Mock API client: `lib/core/network/api_client.dart`
- WebSocket abstraction: `lib/core/network/websocket_client.dart`
- Socket event parsing: `lib/shared/models/socket_event_model.dart`
- Gameplay remote data source: `lib/features/gameplay/data/datasources/gameplay_remote_data_source.dart`
- Gameplay repository: `lib/features/gameplay/data/repositories/gameplay_repository_impl.dart`
- Gameplay controller: `lib/features/gameplay/presentation/controllers/game_session_controller.dart`

Practical implication:

- For auth, profile, shop, lobby, and leaderboard, the backend team can design REST endpoints first.
- For matchmaking and live gameplay, the backend should prioritize WebSocket support.

## Screen-by-Screen Backend Analysis

### 1. Splash Screen

Frontend behavior:

- Purely visual.
- No network dependency today.

Backend requirement:

- None.

Optional future support:

- Remote config
- Force upgrade flag
- Maintenance mode
- Startup content version check

Recommended future endpoint:

- `GET /app/bootstrap`

Example response:

```json
{
  "maintenance": false,
  "minimumSupportedVersion": "1.0.0",
  "latestVersion": "1.0.0",
  "motd": null
}
```

### 2. Auth Entry Screen

Frontend behavior:

- Supports:
  - Guest login
  - Google sign-in
- Current auth repository is mocked.
- Auth controller expects a session with:
  - `displayName`
  - `providerType`

Required backend capabilities:

- Create guest session
- Exchange Google identity token for app session
- Return persistent app token
- Return current user identity
- Support logout / token invalidation if needed

Recommended endpoints:

- `POST /auth/guest`
- `POST /auth/google`
- `GET /auth/me`
- `POST /auth/logout`

Recommended request / response shapes:

`POST /auth/guest`

```json
{
  "deviceId": "optional-stable-device-id",
  "platform": "android"
}
```

Response:

```json
{
  "accessToken": "jwt-or-session-token",
  "refreshToken": "optional-refresh-token",
  "user": {
    "id": "user_123",
    "displayName": "Player_X1",
    "provider": "guest"
  }
}
```

`POST /auth/google`

```json
{
  "idToken": "google-id-token"
}
```

Response:

```json
{
  "accessToken": "jwt-or-session-token",
  "refreshToken": "optional-refresh-token",
  "user": {
    "id": "user_456",
    "displayName": "Player_X1",
    "provider": "google"
  }
}
```

`GET /auth/me`

```json
{
  "user": {
    "id": "user_123",
    "displayName": "Player_X1",
    "provider": "guest"
  }
}
```

Notes:

- The app should eventually persist session locally using the storage service.
- Backend should support issuing a stable `userId` even for guest accounts.

### 3. Home / Lobby Screen

Frontend UI currently shows:

- Player name
- Level
- Coin balance
- Play button
- Create room
- Join room
- Daily reward card
- Top players preview

What is mocked today:

- Level
- Coin balance
- Daily reward timer
- Top players preview
- Create room / join room actions

Backend data needed for this screen:

- Player summary
- Wallet balances
- Daily reward state
- Short leaderboard preview
- Room system support

Recommended endpoint:

- `GET /home/summary`

Recommended response:

```json
{
  "player": {
    "id": "user_123",
    "displayName": "Player_X1",
    "level": 12,
    "xp": 12450,
    "xpNext": 15000
  },
  "wallet": {
    "coins": 2450,
    "gems": 15
  },
  "dailyReward": {
    "claimable": false,
    "nextClaimAt": "2026-04-03T18:30:00Z",
    "currentStreak": 3
  },
  "leaderboardPreview": [
    { "rank": 1, "playerId": "u1", "displayName": "User_92", "score": 9550 },
    { "rank": 2, "playerId": "u2", "displayName": "User_85", "score": 9100 },
    { "rank": 3, "playerId": "u3", "displayName": "User_78", "score": 8650 }
  ]
}
```

Daily reward backend requirements:

- `POST /rewards/daily/claim`
- Enforce one claim per reward window
- Return reward granted and next claim time

Room support for lobby buttons:

- `POST /rooms`
- `POST /rooms/join`
- `GET /rooms/{roomId}`

Suggested room payloads:

`POST /rooms`

```json
{
  "mode": "pattern_race",
  "visibility": "private"
}
```

Response:

```json
{
  "roomId": "room_abc",
  "joinCode": "7T4X2Q",
  "hostPlayerId": "user_123",
  "status": "waiting"
}
```

`POST /rooms/join`

```json
{
  "joinCode": "7T4X2Q"
}
```

### 4. Matchmaking Screen

Frontend UI currently shows:

- Searching state
- Estimated wait timer
- Player card
- Cancel button

Important current frontend behavior:

- The current screen uses a temporary 5-second local timer to move to gameplay.
- This must be replaced by real backend-driven matchmaking.

Backend responsibilities:

- Queue player into matchmaking
- Match players by mode / skill / region
- Notify when match is found
- Support queue cancellation

Recommended transport:

- WebSocket preferred
- REST can be used to request queue join/cancel, but real-time updates should still flow over WebSocket

Recommended queue lifecycle:

1. Player enters queue
2. Backend acknowledges queue entry
3. Backend emits queue updates if needed
4. Backend emits `match_found`
5. Client transitions to gameplay

Recommended options:

- Option A: REST + WebSocket
  - `POST /matchmaking/queue`
  - `DELETE /matchmaking/queue/{ticketId}`
  - WebSocket emits `match_found`
- Option B: WebSocket-only
  - Client sends `queue_join`
  - Client sends `queue_cancel`
  - Server emits queue and match events

### 5. Gameplay Screen

Important note:

- The visible gameplay screen is currently a demo presentation layer.
- However, the frontend already contains a real backend-oriented gameplay stack using:
  - `WebSocketClient`
  - `GameplayRemoteDataSource`
  - `GameplayRepository`
  - `GameSessionController`

Backend should target that real contract, not the temporary demo sequence.

#### Current frontend WebSocket contract already defined in code

Client sends:

```json
{
  "type": "tile_tapped",
  "tileId": 2
}
```

Server events currently parsed by the client:

##### `match_found`

```json
{
  "type": "match_found",
  "matchId": "match-neon-2048",
  "opponentName": "Neon Lynx",
  "queueMs": 450
}
```

##### `pattern_received`

```json
{
  "type": "pattern_received",
  "pattern": [0, 2, 1, 3, 0, 1, 3, 2],
  "round": 1
}
```

##### `progress_update`

```json
{
  "type": "progress_update",
  "playerId": "local",
  "matchedTiles": 3,
  "totalTiles": 8,
  "lastTapValid": true
}
```

##### `game_result`

```json
{
  "type": "game_result",
  "winnerId": "local",
  "winnerName": "Guest Racer",
  "localScore": 8,
  "opponentScore": 6,
  "summary": "You locked the pattern before your rival could finish."
}
```

#### Gameplay backend responsibilities

- Create authoritative match session
- Generate round pattern
- Validate tile tap order server-side
- Track local and opponent progress
- Resolve winner server-side
- Prevent cheating by not trusting client-computed success
- Support reconnect and state replay

#### Recommended additional gameplay events

The current client only parses 4 event types, but backend should be prepared for a richer protocol soon:

- `countdown_started`
- `round_started`
- `round_completed`
- `player_disconnected`
- `player_reconnected`
- `powerup_used`
- `match_cancelled`
- `server_error`
- `state_snapshot`

Recommended richer gameplay event example:

```json
{
  "type": "state_snapshot",
  "matchId": "match_123",
  "phase": "input",
  "round": 2,
  "patternLength": 8,
  "you": {
    "playerId": "user_123",
    "matchedTiles": 4,
    "totalTiles": 8,
    "lastTapValid": true
  },
  "opponent": {
    "playerId": "user_987",
    "matchedTiles": 3,
    "totalTiles": 8,
    "lastTapValid": true
  },
  "remainingMs": 19000
}
```

#### Suggested gameplay rules to enforce server-side

- Match has authoritative round pattern
- Each player input is validated against expected next tile
- Invalid taps should not advance progress
- Progress percentage = `matchedTiles / totalTiles`
- Match winner logic must be server-owned
- Backend should emit final result only once

### 6. Leaderboard Screen

Frontend UI currently supports:

- Global tab
- Friends tab
- Podium top 3
- Ranked list below podium

What is mocked today:

- All leaderboard data
- Friends relationship data
- All-time filter

Recommended endpoints:

- `GET /leaderboards/global?period=all_time&limit=20`
- `GET /leaderboards/friends?period=all_time&limit=20`

Recommended response:

```json
{
  "period": "all_time",
  "scope": "global",
  "podium": [
    { "rank": 1, "playerId": "u1", "displayName": "GodMode", "score": 18500 },
    { "rank": 2, "playerId": "u2", "displayName": "SniperPro", "score": 14200 },
    { "rank": 3, "playerId": "u3", "displayName": "FastFingers", "score": 12100 }
  ],
  "entries": [
    { "rank": 4, "playerId": "u4", "displayName": "User_004", "score": 8000 },
    { "rank": 5, "playerId": "u5", "displayName": "User_005", "score": 7500 },
    { "rank": 6, "playerId": "user_123", "displayName": "Player_X1", "score": 7000, "isSelf": true }
  ]
}
```

Backend notes:

- Friends leaderboard implies a social graph or friend list service.
- If friends are not available in MVP, backend can return an empty list or a fallback list, but should keep the endpoint shape stable.

### 7. Shop Screen

Frontend UI currently supports:

- Coins tab
- Power-ups tab
- Coin packs
- Buy power-up actions
- Remove ads card
- Wallet badges for coins and gems/energy

What is mocked today:

- Catalog items
- Prices
- Ownership counts
- Purchase flow
- Wallet balances

Recommended endpoints:

- `GET /store/catalog`
- `GET /wallet`
- `GET /inventory/powerups`
- `POST /store/purchase`

Recommended `GET /store/catalog` response:

```json
{
  "wallet": {
    "coins": 2450,
    "gems": 15
  },
  "coinPacks": [
    {
      "sku": "coins_free_starter",
      "coins": 100,
      "label": "FREE",
      "isFree": true,
      "isFeatured": false
    },
    {
      "sku": "coins_500",
      "coins": 500,
      "label": "$0.99",
      "isFree": false,
      "isFeatured": true,
      "badge": "POPULAR"
    },
    {
      "sku": "coins_2000",
      "coins": 2000,
      "label": "$2.99",
      "isFree": false,
      "isFeatured": false
    }
  ],
  "powerUps": [
    {
      "sku": "hint",
      "name": "HINT",
      "description": "Reveal one tile",
      "coinCost": 50,
      "owned": 3
    },
    {
      "sku": "freeze_opponent",
      "name": "FREEZE OPPONENT",
      "description": "Freeze opponent for 3s",
      "coinCost": 100,
      "owned": 1
    }
  ],
  "specialOffers": [
    {
      "sku": "remove_ads",
      "name": "REMOVE ADS",
      "priceLabel": "$4.99",
      "type": "one_time_purchase"
    }
  ]
}
```

Recommended purchase request:

```json
{
  "sku": "hint",
  "currency": "coins",
  "quantity": 1
}
```

Recommended purchase response:

```json
{
  "success": true,
  "wallet": {
    "coins": 2400,
    "gems": 15
  },
  "inventoryDelta": {
    "powerUp": "hint",
    "added": 1,
    "newOwnedCount": 4
  }
}
```

Backend notes:

- Real-money purchase validation should be server-side and platform-aware.
- Coin purchases and remove-ads purchases should be idempotent.
- Inventory mutation must be authoritative server-side.

### 8. Profile Screen

Frontend UI currently shows:

- Player hero block
- Level badge
- XP progress
- Quick stats
- Best performance
- Achievements grid
- Recent matches
- Settings / account actions bottom sheet
- Sign out

What is real today:

- `displayName`
- `providerLabel`

What is mocked today:

- XP
- Level progress
- Stats
- Achievements
- Match history

Recommended endpoints:

- `GET /me/profile`
- `GET /me/achievements`
- `GET /me/matches?limit=20`
- `POST /auth/logout`

Recommended `GET /me/profile` response:

```json
{
  "player": {
    "id": "user_123",
    "displayName": "Player_X1",
    "provider": "guest",
    "level": 12,
    "title": "SPEED DEMON",
    "matchesPlayed": 330,
    "joinedAt": "2024-03-15T00:00:00Z",
    "currentXp": 12450,
    "nextLevelXp": 15000
  },
  "quickStats": {
    "wins": 247,
    "losses": 83,
    "winRate": 74.8
  },
  "bestPerformance": {
    "bestStreak": 12,
    "fastestPatternSeconds": 0.4,
    "highestLevelReached": 8
  }
}
```

Recommended `GET /me/achievements` response:

```json
{
  "items": [
    {
      "key": "speed_demon",
      "title": "SPEED DEMON",
      "subtitle": "< 0.5s tap",
      "unlocked": true
    },
    {
      "key": "flawless",
      "title": "FLAWLESS",
      "subtitle": "Perfect round",
      "unlocked": false
    }
  ]
}
```

Recommended `GET /me/matches?limit=20` response:

```json
{
  "items": [
    {
      "matchId": "match_1",
      "didWin": true,
      "opponentName": "GodMode",
      "level": 6,
      "coinDelta": 120,
      "completedAt": "2026-04-02T12:00:00Z"
    }
  ]
}
```

## Recommended Backend Domain Model

These are the core entities the frontend already implies:

- User
- AuthSession
- Wallet
- Inventory
- Achievement
- Match
- MatchRound
- QueueTicket
- Room
- LeaderboardEntry
- DailyRewardState
- PurchaseTransaction

Suggested minimal fields:

### User

- `id`
- `displayName`
- `provider`
- `createdAt`
- `lastSeenAt`

### Wallet

- `userId`
- `coins`
- `gems`

### Inventory

- `userId`
- `powerUps[]`
- `removeAdsPurchased`

### Match

- `id`
- `mode`
- `status`
- `createdAt`
- `startedAt`
- `endedAt`
- `winnerUserId`
- `players[]`

### MatchRound

- `matchId`
- `round`
- `pattern`
- `startedAt`
- `endedAt`

### LeaderboardEntry

- `playerId`
- `displayName`
- `score`
- `rank`
- `period`
- `scope`

## Current Client Event Contracts

These are the contracts that already exist in frontend parsing logic and should be treated as the first integration target.

### Auth session shape expected by frontend

```json
{
  "user": {
    "displayName": "Player_X1",
    "provider": "guest"
  }
}
```

### WebSocket client actions already implemented

Only one gameplay action is currently sent:

```json
{
  "type": "tile_tapped",
  "tileId": 1
}
```

### WebSocket server event types already implemented

- `match_found`
- `pattern_received`
- `progress_update`
- `game_result`

## Recommended API Summary

### Auth

- `POST /auth/guest`
- `POST /auth/google`
- `GET /auth/me`
- `POST /auth/logout`

### Home / Lobby

- `GET /home/summary`
- `POST /rewards/daily/claim`
- `POST /rooms`
- `POST /rooms/join`
- `GET /rooms/{roomId}`

### Leaderboard

- `GET /leaderboards/global`
- `GET /leaderboards/friends`

### Store

- `GET /store/catalog`
- `GET /wallet`
- `GET /inventory/powerups`
- `POST /store/purchase`

### Profile

- `GET /me/profile`
- `GET /me/achievements`
- `GET /me/matches`

### Matchmaking / Live Match

- `POST /matchmaking/queue`
- `DELETE /matchmaking/queue/{ticketId}`
- `GET /matches/{matchId}`
- WebSocket `/ws/match`

## Real-Time Recommendations

Backend should support:

- Low-latency event delivery
- Server-authoritative gameplay validation
- Reconnection and state restoration
- Heartbeats / connection liveness
- Match cancellation / abandonment handling
- Opponent disconnect behavior

Recommended WebSocket authentication:

- Bearer token during handshake
- Or short-lived signed socket token from REST auth

Recommended WebSocket envelope:

```json
{
  "type": "progress_update",
  "timestamp": "2026-04-02T12:00:00Z",
  "payload": {}
}
```

Current frontend does not yet use an envelope wrapper, so if adopted, frontend parsing must be updated together with backend rollout.

## Non-Functional Requirements

### Security

- Do not trust client tap validation
- Validate Google auth token server-side
- Protect purchases against replay
- Protect daily rewards against duplicate claim

### Reliability

- Idempotent purchase and reward endpoints
- Retry-safe queue join / cancel behavior
- Proper disconnect cleanup

### Scalability

- Matchmaking service should be horizontally scalable
- WebSocket sessions should support sticky or state-restorable routing
- Leaderboards should be cached

### Observability

Recommended server logs / telemetry:

- auth success / failure
- queue join / queue leave
- match found latency
- gameplay validation failures
- disconnect / reconnect counts
- purchase success / failure
- reward claims

## Frontend-to-Backend Integration Priority

Recommended implementation order:

1. Auth
2. `GET /home/summary`
3. Leaderboards
4. Profile endpoints
5. Store catalog and wallet
6. Matchmaking WebSocket
7. Gameplay authoritative validation
8. Daily reward claiming
9. Rooms / private matches
10. Power-up usage inside live matches

## Key Gaps / Mock Areas To Replace

These frontend areas are currently mocked and should be replaced with backend integration next:

- Guest and Google auth repository responses
- Lobby player summary
- Daily reward timer and claim logic
- Leaderboards
- Shop catalog and purchases
- Profile stats and history
- Matchmaking success transition
- Gameplay sequence and result resolution

## Important Frontend Caveat

The current visible gameplay page is a temporary cinematic/demo UI and is not yet consuming live backend events directly.

However, the frontend already contains a reusable integration path for real gameplay sessions through:

- `lib/shared/models/socket_event_model.dart`
- `lib/features/gameplay/data/datasources/gameplay_remote_data_source.dart`
- `lib/features/gameplay/data/repositories/gameplay_repository_impl.dart`
- `lib/features/gameplay/presentation/controllers/game_session_controller.dart`

Recommendation:

- Backend should implement the WebSocket contract described above.
- Frontend can then switch the gameplay screen from demo sequence mode to controller-driven live data with minimal architecture changes.

## Questions For Backend / Product Alignment

These should be confirmed before final backend implementation:

1. Is guest account progression permanent per device or temporary until upgrade?
2. Should Google sign-in merge with an existing guest account?
3. Is the primary score metric leaderboard score, highest level, or win rating?
4. Are private rooms required for MVP or post-MVP?
5. Are power-ups usable in ranked multiplayer, or only in custom modes?
6. Is friends leaderboard backed by a real friends system, contacts import, or invite codes?
7. Are purchases platform billing-based only, or can there also be server-side virtual economy purchases?
8. Should gameplay support reconnect mid-match?

## Deliverable Expectation For Backend Team

To support the current frontend properly, the backend team should deliver:

- Auth service
- User profile service
- Wallet / reward / inventory service
- Store catalog and purchase validation service
- Leaderboard service
- Matchmaking service
- WebSocket gameplay session service

If backend wants a fast MVP:

- Start with auth + home summary + leaderboard + profile + store catalog
- Then implement WebSocket matchmaking and live gameplay

