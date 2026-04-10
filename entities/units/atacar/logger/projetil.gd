extends Area2D

var direcao: Vector2 = Vector2.ZERO
var velocidade: float = 150.0

func _physics_process(delta: float) -> void:
	# Faz o tiro voar na direção escolhida
	position += direcao * velocidade * delta

# Vá na aba Node (Sinais) do Projetil, dê duplo clique no sinal "area_entered"
# e conecte a este script para criar a função abaixo:
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("arvores"):
		if area.has_method("receber_dano"):
			area.receber_dano()
		else:
			area.queue_free()
			if GameManager.has_method("alterar_saude_bioma"):
				GameManager.alterar_saude_bioma(-2.0)
				
		queue_free() # O tiro se destrói ao bater no alvo
