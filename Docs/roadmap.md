# Implementation Roadmap

## Phase 1: Core Loop MVP (Current Focus)
**Goal**: A playable "Plan -> Execute" loop with basic combat.
*   [x] **Timeline UI**: Basic scrubbing and Ghost Unit visualization.
*   [ ] **Combat Actions**: Implement `AttackAction` with Hitbox logic.
*   [ ] **Health System**: Units have HP and take damage.
*   [ ] **Win Condition**: Enemy death triggers victory.
*   [ ] **Determinism Check**: Ensure Ghost preview matches Execution reality.

## Phase 2: Physics & Evasion
**Goal**: Implement the "Speed as Defense" mechanic.
*   [ ] **Projectile System**: Missiles with turn rates.
*   [ ] **Inertial Dodge**: High speed units out-turning missiles.
*   [ ] **Grazing**: Reduced damage for edge hits.
*   [ ] **Collision Warning UI**: Visual lines connecting attacker and victim in timeline.

## Phase 3: AI & Content
**Goal**: Smart enemies and more cards.
*   [ ] **Telegraphing**: AI shows aim lines during planning.
*   [ ] **Basic AI**: Enemy moves towards player and attacks.
*   [ ] **Card Expansion**: Implement `Dash`, `Time Slow`, `Area Denial`.

## Phase 4: Polish & Juice
**Goal**: Game feel.
*   [ ] **Hitstop**: Freeze frames on impact.
*   [ ] **Visuals**: Trail renderers, impact effects.
*   [ ] **Audio**: Dynamic pitch shifting based on speed.
