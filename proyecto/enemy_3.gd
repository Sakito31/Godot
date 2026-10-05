extends Area2D

@export var radio_llama: float = 55.0
@export var velocidad_llama: float = 2.5

@onready var fire_orbit: Node2D = $FireOrbit

var angulo: float = -PI / 2


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
	angulo += velocidad_llama * delta

	if angulo >= TAU:
		angulo -= TAU

	var x = cos(angulo) * radio_llama
	var y = sin(angulo) * radio_llama

	fire_orbit.position = Vector2(x, y)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Jugador"):
		queue_free()
