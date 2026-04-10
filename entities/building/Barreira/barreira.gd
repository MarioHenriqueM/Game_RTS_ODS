extends StaticBody2D

var vida: float = 30.0 # Pode ajustar: quanto maior, mais tempo ela aguenta
var vida_maxima: float = 30.0

func _ready() -> void:
	# Efeito visual de nascer no mapa (opcional, mas fica legal)
	scale = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.3).set_trans(Tween.TRANS_BOUNCE)

func receber_dano() -> void:
	vida -= 10.0 # Cada ataque tira 10 de vida
	
	# Pisca a barreira em vermelho para mostrar que tomou dano
	modulate = Color(1, 0.5, 0.5) 
	await get_tree().create_timer(0.1).timeout
	modulate = Color(1, 1, 1)
	
	if vida <= 0:
		print("Barreira destruída!")
		queue_free() # Destrói a barreira
