extends Node2D

@onready var player_unit = $PlayerUnit
@onready var enemy_unit = $EnemyUnit
@onready var timeline_ui = $CanvasLayer/TimelineUI

func _ready():
	# Initialize units
	player_unit.unit_id = 1
	player_unit.speed = 200.0 # High speed
	
	enemy_unit.unit_id = 2
	enemy_unit.speed = 50.0
	
	# Create a preset action for enemy to move left
	_create_enemy_action()

func _create_enemy_action():
	var enemy_action = CombatAction.new()
	enemy_action.unit_id = enemy_unit.unit_id
	enemy_action.action_type = CombatAction.Type.MOVE
	enemy_action.start_time = 0.0
	var dist = enemy_unit.position.distance_to(Vector2(800, 500))
	enemy_action.duration = dist / enemy_unit.speed
	enemy_action.target_position = Vector2(800, 500)
	
	var curve = Curve2D.new()
	curve.add_point(enemy_unit.position)
	curve.add_point(Vector2(800, 500))
	enemy_action.movement_path = curve
	
	TimelineManager.add_action(enemy_action)


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
		
		# Remove only player's previous action, keep enemy's
		for i in range(TimelineManager.actions.size() - 1, -1, -1):
			if TimelineManager.actions[i].unit_id == player_unit.unit_id:
				TimelineManager.actions.remove_at(i)
		
		TimelineManager.add_action(action)
		
		print("Added Move Action: Duration %.2f s" % duration)

	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		print("Playing Turn...")
		TimelineManager.play_turn()
