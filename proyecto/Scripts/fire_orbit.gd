extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# =================================
# ANIMACIONES FIREORBIT
# =================================
	# 1. Reproducir la animación visual del sprite en bucle
	animated_sprite.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
