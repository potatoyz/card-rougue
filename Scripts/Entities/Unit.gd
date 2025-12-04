class_name Unit
extends Node2D

@export var unit_id: int
@export var speed: float = 100.0
@export var team: int = 0 # 0: Player, 1: Enemy

# Visuals
@onready var sprite = $Sprite2D # Assuming a simple sprite for MVP

func _ready():
	add_to_group("units")

# Execute an action in real-time
func execute_action(action: CombatAction):
	# This will be called by the TimelineManager during playback
	# For MVP, we might just tween the position for movement
	if action.action_type == CombatAction.Type.MOVE:
		var tween = create_tween()
		# Calculate duration based on speed? 
		# In CKT, duration is already calculated when the action is created based on speed.
		# So we just use action.duration.
		
		# We need to know where to move to. 
		# If it's a path, we might need to follow it.
		if action.movement_path:
			# For simple tweening, we might just move to end point, but for curve we need more.
			# Let's keep it simple: Move to target_position
			tween.tween_property(self, "global_position", action.target_position, action.duration)
		else:
			tween.tween_property(self, "global_position", action.target_position, action.duration)

# Set the unit's state for preview (Ghost Mode)
func set_preview_state(state: Dictionary):
	if state.has("position"):
		global_position = state["position"]

# Combat Stats
@export var max_health: int = 100
@onready var health: int = max_health

signal died(unit)

func take_damage(amount: int):
	health -= amount
	print("Unit %d took %d damage. Health: %d/%d" % [unit_id, amount, health, max_health])
	if health <= 0:
		die()

func die():
	print("Unit %d died!" % unit_id)
	emit_signal("died", self)
	queue_free()
