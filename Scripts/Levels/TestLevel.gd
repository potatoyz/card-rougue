extends Node2D

@onready var player_unit = $PlayerUnit
@onready var timeline_ui = $CanvasLayer/TimelineUI

func _ready():
	# Initialize units
	player_unit.unit_id = 1
	player_unit.speed = 200.0 # High speed
	
	# Add a dummy enemy
	var enemy = Unit.new()
	enemy.unit_id = 2
	enemy.position = Vector2(800, 300)
	enemy.modulate = Color.RED
	add_child(enemy)

func _unhandled_input(event):
	if not TimelineManager.is_planning:
		return

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Create a move action for the player
		var target_pos = get_global_mouse_position()
		
		# Calculate duration based on speed
		var dist = player_unit.position.distance_to(target_pos)
		var duration = dist / player_unit.speed
		
		# Create action
		var action = CombatAction.new()
		action.unit_id = player_unit.unit_id
		action.action_type = CombatAction.Type.MOVE
		action.start_time = 0.0 # For MVP, all actions start at 0
		action.duration = duration
		action.target_position = target_pos
		
		# Create a simple linear path for the action
		var curve = Curve2D.new()
		curve.add_point(player_unit.position)
		curve.add_point(target_pos)
		action.movement_path = curve
		
		# Add to manager
		TimelineManager.clear_actions() # Clear previous for simple 1-action MVP
		TimelineManager.add_action(action)
		
		print("Added Move Action: Duration %.2f s" % duration)

	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		print("Playing Turn...")
		TimelineManager.play_turn()
