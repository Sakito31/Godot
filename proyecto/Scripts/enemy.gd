extends CharacterBody2D


# Velocidad constante del enemigo
const VELOCIDAD = 50.0

# Usa la gravedad que tenga configurada el proyecto
var gravedad = ProjectSettings.get_setting("physics/2d/default_gravity")


# ¿Está atacando?
var atacando = false

# Dirección:
# 1 = derecha
# -1 = izquierda
var direccion = 1

# Referencias a los nodos
@onready var raycast = $RayCastPared
@onready var animacion = $EnemyAnimations


func _physics_process(delta):

	# -------------------------
	# GRAVEDAD
	# -------------------------
	if not is_on_floor():
		velocity.y += gravedad * delta


	# -------------------------
	# COMPROBAR RAYCAST
	# Comprueba si el raycast está colisionando
	# contra un objeto que esté en grupo Jugador (En este caso el Player)
	# se para de mover
	# -------------------------
	if raycast.is_colliding():

			# Si es una pared, girar
			direccion *= -1

			# Girar personaje
			animacion.flip_h = direccion < 0

			# Girar RayCast
			raycast.target_position.x *= -1

	else:

		# No detecta nada → caminar
		velocity.x = VELOCIDAD * direccion

		# Animación de caminar
		animacion.play("walking")


	# Aplicar movimiento
	move_and_slide()
