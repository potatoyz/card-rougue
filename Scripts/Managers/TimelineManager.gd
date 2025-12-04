extends Node

# Singleton: TimelineManager

var actions: Array[CombatAction] = []
var current_time: float = 0.0
var is_planning: bool = true
var turn_duration: float = 5.0 # Standard turn length in seconds

# Signals
signal time_changed(new_time)
signal action_added(action)

func _ready():
	pass

func add_action(action: CombatAction):
	actions.append(action)
	emit_signal("action_added", action)

func clear_actions():
	actions.clear()

# Get the state of a specific unit at a specific time
func get_unit_state_at_time(unit_id: int, time: float) -> Dictionary:
	# Find the action relevant to this unit at this time
	# For MVP, assuming sequential actions for simplicity or finding the active one
	# In a full system, we'd need to sort actions by time and find the one covering 'time'
	var relevant_action: CombatAction = null
	var last_action: CombatAction = null
	
	for action in actions:
		if action.unit_id == unit_id:
			if time >= action.start_time and time <= (action.start_time + action.duration):
				relevant_action = action
				break
			if action.start_time < time:
				last_action = action
	
	if relevant_action:
		return relevant_action.evaluate_state(time)
	elif last_action:
		# If we are past the last action, stay at the end state of that action
		return last_action.evaluate_state(last_action.start_time + last_action.duration)
	
	return {}

# Play the turn (Execution Phase)
func play_turn():
	is_planning = false
	current_time = 0.0
	set_process(true)

func _process(delta):
	if not is_planning:
		current_time += delta
		emit_signal("time_changed", current_time)
		
		# Execute actions that start now? 
		# Or just let the Units update themselves based on time?
		# For MVP, let's just stop at turn_duration
		if current_time >= turn_duration:
			is_planning = true
			set_process(false)
			current_time = 0.0
			emit_signal("time_changed", 0.0)
