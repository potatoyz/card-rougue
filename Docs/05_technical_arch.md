# 05. Technical Architecture (Godot)

## 1. Command Pattern
All actions must be encapsulated as `CombatAction` Resources to support serialization, undo/redo, and timeline scrubbing.

```gdscript
class_name CombatAction extends Resource

var unit_id: int
var action_type: int
var start_time: float
var duration: float
var curve: Curve2D

# Returns state at time t for preview
func evaluate_state(t: float) -> Dictionary:
    # ... implementation ...
```

## 2. TimelineManager
A singleton or main node that manages:
*   `commands`: Array of all planned actions.
*   `battle_time`: Current time in the turn.
*   `phase`: PLANNING vs EXECUTION.

## 3. Deterministic Physics (Shadow World)
Do not rely on `_physics_process` for gameplay logic if it introduces non-determinism.
*   **Shadow World**: A logic-only simulation (using `PhysicsServer2D` or pure math) that runs ahead of the visual render.
*   **Fast-Forward**: When planning, the system simulates the entire turn in the background to detect collisions and generate "Collision Warnings".

## 4. Animation Sync
Animations must be manually driven by `battle_time` during execution.
*   `AnimationPlayer.seek(time, true)`
*   `AnimationPlayer.playback_speed` scaled by Unit Speed.
