class_name AttackAction
extends CombatAction

@export var damage: int = 10
@export var attack_range: float = 50.0
@export var hitbox_radius: float = 20.0

# Frame Data (in seconds)
@export var startup_time: float = 0.5
@export var active_time: float = 0.2
@export var recovery_time: float = 0.5

func _init():
	action_type = Type.ATTACK
	duration = startup_time + active_time + recovery_time
