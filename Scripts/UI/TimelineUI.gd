extends Control

@onready var slider = $HSlider
@onready var time_label = $Label

func _ready():
	# Connect to TimelineManager signals
	TimelineManager.time_changed.connect(_on_time_changed)
	
	# Configure slider
	slider.min_value = 0.0
	slider.max_value = TimelineManager.turn_duration
	slider.step = 0.1
	slider.value_changed.connect(_on_slider_value_changed)

func _process(delta):
	# Redraw ghost trails every frame or when needed
	queue_redraw()

func _on_slider_value_changed(value):
	if TimelineManager.is_planning:
		# Update the preview time in TimelineManager (or just use the slider value locally for preview)
		# Actually, TimelineManager should probably hold the "preview_time" state if we want global preview
		# For MVP, let's just use the slider value to ask TimelineManager for state
		_update_preview(value)

func _on_time_changed(new_time):
	# Update slider position during playback
	slider.value = new_time
	time_label.text = "Time: %.2f" % new_time

func _update_preview(time):
	# Ask TimelineManager for state of all units at 'time'
	# And update their "Ghost" representation.
	# For MVP, we might just update the actual units to their preview position if we are in planning mode.
	# This is a "WYSIWYG" approach for the MVP.
	var units = get_tree().get_nodes_in_group("units")
	for unit in units:
		var state = TimelineManager.get_unit_state_at_time(unit.unit_id, time)
		if state.has("position"):
			unit.set_preview_state(state)

func _draw():
	# Draw trails for all actions
	# This requires accessing TimelineManager.actions
	for action in TimelineManager.actions:
		if action.action_type == CombatAction.Type.MOVE:
			if action.movement_path:
				draw_polyline(action.movement_path.get_baked_points(), Color.BLUE, 2.0)
			elif action.target_position:
				# Draw simple line from start to end?
				# We need start position. 
				# For MVP, let's assume we can get it or just draw a line from unit current pos? 
				# No, unit might be at preview pos.
				# Let's skip complex trail drawing for this exact step and focus on the slider working.
				pass
