extends Area2D

# Llama al AnimationPlayer y al AnimatedSprite para animaciones etc...
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	
# =================================
# ANIMACIONES MEGABOLADEFUEGO
# =================================
	# 1. Reproducir la animación visual del sprite en bucle
	animated_sprite.play("fireball")
	
	# 2. Reproducir la animación de movimiento del AnimationPlayer
	animation_player.play("fly")
	
