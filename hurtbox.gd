class_name hurtbox
extends Area2D

# Signal to alert the parent entity (Player/Enemy) that they took damage
signal damage_received(amount: int)

@export var is_invincible: bool = false # Useful for temporary post-hit invincibility

func take_damage(amount: int) -> void:
	if is_invincible:
		return
		
	# Emit the signal so the main character script can reduce its health
	damage_received.emit(amount)
