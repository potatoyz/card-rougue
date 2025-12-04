class_name CombatAction
extends Resource

enum Type {
	MOVE,
	ATTACK,
	SKILL,
	WAIT
}

@export var unit_id: int
@export var action_type: Type
@export var start_time: float
@export var duration: float
@export var target_position: Vector2
@export var target_unit_id: int = -1

# For movement actions, we might want a curve or path
@export var movement_path: Curve2D

# Evaluate the state of this action at a specific time
# Returns a Dictionary with relevant state data (e.g., {"position": Vector2})
func evaluate_state(time: float) -> Dictionary:
	if time < start_time:
		return {}
	
	var effective_time = time - start_time
	var progress = clamp(effective_time / duration, 0.0, 1.0)
	
	var result = {}
	
	match action_type:
		Type.MOVE:
			if movement_path:
				# Sample the curve based on progress
				# Curve2D sampling is usually by offset length, not 0-1 t unless baked
				var total_length = movement_path.get_baked_length()
				var current_offset = total_length * progress
				result["position"] = movement_path.sample_baked(current_offset)
			else:
				# Fallback linear interpolation if no curve
				# This assumes we know start position, which might be tricky if actions are chained.
				# For MVP, let's assume we store start_position in the action when created
				pass
				
	return result
