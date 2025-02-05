extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.GameWon.connect(_fire_confetti)

func _fire_confetti():
	$CPUParticles2D.emitting = true
