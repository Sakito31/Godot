
extends CharacterBody2D



# Llamamos a los nodos necesarios para el Script
@onready var animations: AnimatedSprite2D = $EnemyAnimations
@onready var ray_derecha: RayCast2D = $RayCastDerecha
@onready var ray_izquierda: RayCast2D = $RayCastIzquierda

# Usa la gravedad que tenga configurada el proyecto
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# ¿Está atacando? -> En este caso se usa para 
# que no reinicie la animación de ataque siempre
var attacking := false

# Frames del ataque que hacen daño, solo el 4 en este caso
var attack_frames := [4]

# Aquí conectamos dos señales de AnimatedSprite2D.

func _ready():
	# Cada vez que cambia el frame, Godot ejecuta,
	# Esto nos permite detectar exactamente cuándo debe hacer daño ->
	animations.frame_changed.connect(_on_animation_frame_changed)
	# Lo utilizamos para saber cuándo termina el ataque. ->
	animations.animation_finished.connect(_on_animation_finished)

	# -------------------------
	# FÍSICAS
	#  - Gravedad
	#  - Detección del jugador
	#  - Movimiento
	# -------------------------
func _physics_process(delta):
	# GRAVEDAD
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	# DETECTAR JUGADOR
	if not attacking:

		# DERECHA
		if ray_derecha.is_colliding():
			var objeto = ray_derecha.get_collider()

			if objeto.is_in_group("Jugador"):
				animations.flip_h = false
				start_attack()

		# IZQUIERDA
		elif ray_izquierda.is_colliding():
			var objeto = ray_izquierda.get_collider()

			if objeto.is_in_group("Jugador"):
				animations.flip_h = true
				start_attack()

	move_and_slide()


	# -------------------------
	# ATAQUE
	# -------------------------
func start_attack():
	if attacking:
		return

	attacking = true
	velocity.x = 0

	animations.play("attack")

	# -------------------------
	# Cambio de frame
	# -------------------------
func _on_animation_frame_changed():
	if animations.animation != "attack":
		return

	# Solo hace daño durante estos frames, en este caso [4]
	if animations.frame in attack_frames:

		# Comprobar derecha
		if ray_derecha.is_colliding():
			var objeto = ray_derecha.get_collider()

			if objeto.is_in_group("Jugador"):
				objeto.morir()

		# Comprobar izquierda
		if ray_izquierda.is_colliding():
			var objeto = ray_izquierda.get_collider()

			if objeto.is_in_group("Jugador"):
				objeto.morir()

	# -------------------------
	# ANIMACION IDLE
	# -------------------------
func _on_animation_finished():
	if animations.animation == "attack":
		attacking = false
		animations.play("idle")
