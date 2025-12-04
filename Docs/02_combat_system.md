# 02. Combat System: Hitboxes, Damage, and Physics

## 1. Deterministic Physics
Combat outcomes are determined by geometry and time, not dice rolls.
*   **Hitbox**: The volume where an attack deals damage.
*   **Hurtbox**: The volume where a unit takes damage.
*   **Resolution**: If Hitbox intersects Hurtbox at time $t$, damage occurs.

### 1.1 Inertial Evasion
Evasion is the act of physically not being where the attack is.
*   **Tracking**: Projectiles may have turn rates. High speed units can out-turn projectiles (angular velocity check).
*   **Grazing**: If Hitbox overlaps Hurtbox by < 20%, it is a "Graze" (reduced damage).

## 2. Kinetic Interaction Model (Frame Data)
Every attack action is split into three phases, all scaled by Speed:

1.  **Startup (Wind-up)**:
    *   Time before Hitbox activates.
    *   Vulnerable to **Interruption**.
2.  **Active (Duration)**:
    *   Time Hitbox is active.
    *   Area denial phase.
3.  **Recovery (Back-swing)**:
    *   Time after Hitbox deactivates before unit can act again.
    *   Vulnerable to **Punish**.

## 3. Hit Feedback
*   **Hitstop**: When a hit occurs, both attacker and defender freeze for a micro-duration (e.g., 0.1s). This emphasizes impact and can alter timing in multi-unit scuffles.
*   **Stagger**: Heavy hits can force a unit into a recovery animation, cancelling their current action.

## 4. Animation Canceling
Advanced play allows canceling Recovery frames using special resources (e.g., "Focus"), allowing for combos.
