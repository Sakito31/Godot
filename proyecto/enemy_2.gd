extends CharacterBody2D

const GRAVEDAD = 980.0

@onready var raycast_der = $RayCastDerecha
@onready var raycast_izq = $RayCastIzquierda
@onready var animacion = $EnemyAnimations
@onready var area_ataque = $AreaAtaque
@onready var area_muerte_colision = $AreaAtaque/CollisionShape2D

var atacando = false
var ya_ataco = false

# Guardamos la posición original del AreaAtaque
var posicion_inicial_area: Vector2


func _ready() -> void:
	# Guardamos la posición original del AreaAtaque
	if area_ataque:
		posicion_inicial_area = area_ataque.position

	# El área de daño empieza desactivada
	if area_muerte_colision:
		area_muerte_colision.disabled = true


func _physics_process(delta: float) -> void:
	# =========================
	# GRAVEDAD
	# =========================
	if not is_on_floor():
		velocity.y += GRAVEDAD * delta
	else:
		velocity.y = 0


	# El enemigo no se mueve horizontalmente
	velocity.x = 0


	# =========================
	# DETECTAR AL JUGADOR
	# =========================
	var detectando_derecha = (
		raycast_der.is_colliding()
		and raycast_der.get_collider().is_in_group("Jugador")
	)

	var detectando_izquierda = (
		raycast_izq.is_colliding()
		and raycast_izq.get_collider().is_in_group("Jugador")
	)

	var detectando_jugador = detectando_derecha or detectando_izquierda


	# Si el jugador deja de estar detectado,
	# permitimos atacar otra vez
	if not detectando_jugador:
		ya_ataco = false


	# =========================
	# ATAQUE
	# =========================
	if not atacando:

		if detectando_jugador and not ya_ataco:

			var direccion = 1

			if detectando_derecha:
				direccion = 1
			elif detectando_izquierda:
				direccion = -1

			iniciar_ataque(direccion)

		else:

			if animacion.animation != "idle":
				animacion.play("idle")


	# Aplicar movimiento y gravedad
	move_and_slide()


# =====================================================
# INICIAR ATAQUE
# =====================================================
func iniciar_ataque(direccion: int) -> void:

	atacando = true
	ya_ataco = true


	# =========================
	# GIRAR SPRITE
	# =========================

	if direccion == -1:
		animacion.flip_h = true
	else:
		animacion.flip_h = false


	# =========================
	# COLOCAR AREA DE ATAQUE
	# =========================

	if area_ataque:

		# Primero restauramos la posición original
		area_ataque.position = posicion_inicial_area

		# Colocamos el área delante del enemigo
		if direccion == 1:

			# ATAQUE HACIA LA DERECHA
			area_ataque.position.x = abs(posicion_inicial_area.x)

		else:

			# ATAQUE HACIA LA IZQUIERDA
			area_ataque.position.x = -abs(posicion_inicial_area.x)


	# =========================
	# DESACTIVAR DAÑO AL COMENZAR
	# =========================

	if area_muerte_colision:
		area_muerte_colision.disabled = true


	# Reproducir animación
	animacion.play("attack")


# =====================================================
# ACTIVAR EL DAÑO EN LOS FRAMES DEL ATAQUE
# =====================================================
func _on_enemy_animations_frame_changed() -> void:

	if animacion.animation == "attack" and area_muerte_colision:

		# FRAMES QUE HACEN DAÑO
		if animacion.frame == 2 or animacion.frame == 3:

			area_muerte_colision.disabled = false

		else:

			area_muerte_colision.disabled = true


# =====================================================
# CUANDO TERMINA EL ATAQUE
# =====================================================
func _on_enemy_animations_animation_finished() -> void:

	if animacion.animation == "attack":

		# Desactivar el área de daño
		if area_muerte_colision:
			area_muerte_colision.disabled = true

		# El enemigo ya puede volver a atacar
		atacando = false


# =====================================================
# CUANDO EL JUGADOR ENTRA EN EL AREA DE ATAQUE
# =====================================================
func _on_area_ataque_body_entered(body: Node2D) -> void:

	if body.is_in_group("Jugador"):

		if body.has_method("morir"):
			body.morir()
