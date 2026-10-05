extends CharacterBody2D


# Constantes de velocidad y salto
const VELOCIDAD = 100.0
const SALTO = -200.0

# Usa la gravedad que tenga configurada el proyecto
var gravedad = ProjectSettings.get_setting("physics/2d/default_gravity")

# ¿Está vivo?
var esta_vivo = true

# ¿Está recibiendo daño?
var recibiendo_dano = false

# Referencia a las animaciones
@onready var animacion = $PlayerAnimations

#_ready() se ejecuta cuando el personaje ya está cargado y preparado en la escena
func _ready():

	# Añadir al grupo del jugador
	add_to_group("Jugador")


func _physics_process(delta):

	# -------------------------
	# MUERTO
	# Para que el PJ no se mueva al morirse
	# -------------------------

	if not esta_vivo:
		velocity = Vector2.ZERO
		return


	# -------------------------
	# RECIBIENDO DAÑO
	# -------------------------

	if recibiendo_dano:

		# Detener completamente al jugador al recibir daño
		velocity.x = 0

		# Mantener la gravedad para que el PJ caiga si recibe daño en el aire
		if not is_on_floor():
			velocity.y += gravedad * delta

		move_and_slide()
		return


	# -------------------------
	# GRAVEDAD
	# Si el jugador no está muerto y tampoco está recibiendo daño, llegamos aquí:
	# Gravedad normal
	# -------------------------

	if not is_on_floor():
		velocity.y += gravedad * delta


	# -------------------------
	# SALTO
	# Si pulsas "Barra Espaciadora" incrementa velocidad.y 
	# (vertical) * SALTO =(-200), el Sprite actual no tiene animación de salto
	# -------------------------

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = SALTO


	# -------------------------
	# MOVIMIENTO
	# Igual que el salto, pero velocidad.x (horizontal)
	# -------------------------

	var direccion = Input.get_axis("izquierda", "derecha")

	if direccion != 0:
		velocity.x = direccion * VELOCIDAD
	else:
		velocity.x = 0


	# -------------------------
	# GIRAR PERSONAJE
	# Para que el Sprite se voltee si se cambia de dirección.
	# -------------------------

	if direccion > 0:
		animacion.flip_h = false

	elif direccion < 0:
		animacion.flip_h = true


	# -------------------------
	# ANIMACIONES NORMALES
	# Reproduce las animaciones de caminar e idle 
	# y el move and slide() aplica el movimiento
	# -------------------------

	if direccion != 0:
		animacion.play("walking")
	else:
		animacion.play("idle")


	move_and_slide()


# =================================
# RECIBIR DAÑO / MORIR
# Esta función es la encargada de gestionar la muerte.
# Puede ser llamada desde otro objeto: body.morir() por ejemplo
# =================================

func morir():
 
	# Evitar que muera varias veces
	if recibiendo_dano or not esta_vivo:
		return

	# Detener inmediatamente cualquier movimiento
	velocity = Vector2.ZERO

	# Activa el estado de daño
	# Ahora el personaje entra en estado de daño.
	# Y cuando _physics_process() vuelva a ejecutarse, encontrará:
	recibiendo_dano = true

	# Reproduce la animación de daño
	animacion.play("hurt")

	# Esperar el golpe 2 segundos para darle un rollito a la muerte
	await get_tree().create_timer(2.0).timeout

	# Cambiar variables para morir
	recibiendo_dano = false
	esta_vivo = false

	# Asegurarnos de que no queda ningún movimiento
	velocity = Vector2.ZERO

	# Reproduce la animación de muerte
	animacion.play("death")

	# Esperar 3 segundos
	await get_tree().create_timer(3.0).timeout

	# Reiniciar escena. Esto vuelve a cargar la escena actual.
	get_tree().reload_current_scene()


# FUNCIONES DE MUERTE _body_entered
# MEGABOLADEFUEGO, ORBITA Y PINCHOS

# Si el jugador es tocado por la MEGABOLADEFUEGO
# de Area2D/Fireball
func _on_fireball_body_entered(body: Node2D) -> void:

# Si Player está en el grupo Jugador
# siempre está en este caso.
	if body.is_in_group("Jugador"):
# Si Player tiene el método morir
# se muere e imprime mensaje personalizado.
		if body.has_method("morir"):
			body.morir()
			print("¡Te han calcinado!")
			return;


# Si el jugador entra en la órbita de fuego
# de Area2D/Enemy3/FireOrbit
func _on_fire_orbit_body_entered(body: Node2D) -> void:

# Si Player está en el grupo Jugador
# siempre está en este caso.
	if body.is_in_group("Jugador"):
# Si Player tiene el método morir
# se muere e imprime mensaje personalizado.
		if body.has_method("morir"):
			body.morir()
			print("¡Te ha tocado el fantasma!")
			return;

# Si el jugador cae en los pinchos
# de Area2D/Pinchos
func _on_pinchos_body_entered(body: Node2D) -> void:
# Si Player está en el grupo Jugador
# siempre está en este caso.
	if body.is_in_group("Jugador"):
# Si Player tiene el método morir
# se muere e imprime mensaje personalizado.
		if body.has_method("morir"):
			body.morir()
			print("¡Pinchos")
			return;


# Si el jugador toca al Goblino 1
# de CharacterBody2D/Enemy/EnemyArea(Area2D)
func _on_enemy_area_body_entered(body: Node2D) -> void:
	# Si Player está en el grupo Jugador
# siempre está en este caso.
	if body.is_in_group("Jugador"):
# Si Player tiene el método morir
# se muere e imprime mensaje personalizado.
		if body.has_method("morir"):
			body.morir()
			print("Te ha eliminado un Goblino!")
			return;
