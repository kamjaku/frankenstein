extends StaticBody2D

# Grab the hurtbox/damage receiver node
@onready var damage_receiver = $damage_receiver 

func _ready() -> void:
	# Connect the signal from your hurtbox to this script
	# If you made a custom Hurtbox class, use its custom signal name here
	damage_receiver.area_entered.connect(_on_receive_damage)

func _on_receive_damage(area: hurtbox) -> void:
	# Simple check: verify if whatever hit it is a hitbox/damage emitter
	# You can read the damage value if your hitbox script passes it
	print("Barrel took damage!")
	
	# Destroy the barrel
	queue_free() 
