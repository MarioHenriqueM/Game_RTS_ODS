extends StaticBody2D

@export var taxa_geracao: int = 15 
var vida: int = 3 # A base aguenta 3 ataques antes de ser destruída

@onready var timer_gerador: Timer = $TimerGerador

func _ready() -> void:
	# DICA DE OURO: Adicionamos o Centro ao grupo "arvores" via código.
	# Assim, a IA do Agressor vai caçá-lo automaticamente como se fosse uma "árvore gigante"!
	add_to_group("arvores") 
	add_to_group("centros")
	
	var tamanho_original = scale
	scale = Vector2.ZERO
	var tween = create_tween()
	# Faz ele crescer até o tamanho original, seja ele qual for!
	tween.tween_property(self, "scale", tamanho_original, 0.3).set_trans(Tween.TRANS_BOUNCE)
	
	timer_gerador.wait_time = 2.5 
	timer_gerador.autostart = true
	timer_gerador.timeout.connect(_on_timer_timeout)
	timer_gerador.start()

func _on_timer_timeout() -> void:
	GameManager.adicionar_bio_creditos(taxa_geracao)
	var tween = create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2(1.1, 1.1), 0.1)
	tween.tween_property($Sprite2D, "scale", Vector2(1.0, 1.0), 0.1)

# NOVA FUNÇÃO: O que acontece quando o Consórcio ataca a base
func receber_dano() -> void:
	vida -= 1
	print("ALERTA: Centro de Biodiversidade sob ataque! Vida restante: ", vida)
	
	# Efeito visual de dano (pisca em vermelho)
	$Sprite2D.modulate = Color(1, 0, 0) # Fica vermelho
	var tween = create_tween()
	tween.tween_property($Sprite2D, "modulate", Color(1, 1, 1), 0.3) # Volta ao normal
	
	if vida <= 0:
		# 1. Tira ESTA base do grupo antes de contar, pois ela está prestes a ser destruída
		remove_from_group("centros")
		
		# 2. Conta quantos Centros ainda sobraram no mapa
		var centros_restantes = get_tree().get_nodes_in_group("centros").size()
		
		# 3. Se não sobrou nenhum, é Game Over
		if centros_restantes <= 0:
			GameManager.game_over_centro_destruido()
		else:
			# Se ainda tem outros, apenas avisa o jogador
			print("Uma base caiu! Mas a luta continua. Centros restantes: ", centros_restantes)
			
		# 4. Finalmente, destrói o prédio
		queue_free()
