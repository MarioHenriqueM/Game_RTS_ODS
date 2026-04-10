extends CharacterBody2D

var max_agressores: int = 3
var agressores_gerados: int = 0
var velocidade: float = 20.0
var arvore_alvo: Node2D = null
var alcance_de_corte: float = 50.0 

# NOVA VARIÁVEL DE ESTADO:
var atacando: bool = false 

func _ready() -> void:
	# Etiqueta o inimigo para o Eco Agente conseguir caçá-lo
	add_to_group("agressores")

func _physics_process(delta: float) -> void:
	# Se estiver no meio de um ataque, pausa a movimentação e não muda de alvo
	if atacando:
		return

	# 1. Busca alvo se não tiver nenhum
	if not is_instance_valid(arvore_alvo):
		buscar_arvore_mais_proxima()
		if has_node("Animacao"): # Previne erros se a animação não existir
			$Animacao.play("idle")
	
	# 2. Se tem alvo, persegue!
	elif is_instance_valid(arvore_alvo):
		var direcao = global_position.direction_to(arvore_alvo.global_position)
		velocity = direcao * velocidade
		move_and_slide()
		
		if has_node("Animacao"):
			$Animacao.play("walk")
			# Vira o rosto para o lado certo
			$Animacao.flip_h = (velocity.x < 0)
		
		# 3. Se chegou no alcance de corte, destrói/ataca!
		if global_position.distance_to(arvore_alvo.global_position) <= alcance_de_corte:
			cortar_arvore()
	else:
		velocity = Vector2.ZERO

func buscar_arvore_mais_proxima() -> void:
	# Pega as listas corretamente
	var alvos_arvores = get_tree().get_nodes_in_group("arvores")
	var alvos_barreiras = get_tree().get_nodes_in_group("barreiras")
	var alvos_agentes = get_tree().get_nodes_in_group("agentes")
	
	# Junta as listas
	var todos_alvos = alvos_arvores + alvos_barreiras + alvos_agentes
	
	# Se não tem nada no mapa, aborta a busca
	if todos_alvos.size() == 0:
		arvore_alvo = null
		return
	
	var alvo_temp = null
	var menor_distancia = INF
	
	# Procura o mais perto (seja árvore, barreira ou agente)
	for alvo in todos_alvos:
		if is_instance_valid(alvo):
			var dist = global_position.distance_to(alvo.global_position)
			if dist < menor_distancia:
				menor_distancia = dist
				alvo_temp = alvo
				
	# Define o alvo final
	arvore_alvo = alvo_temp

func cortar_arvore() -> void:
	# TRAVA DE SEGURANÇA: Só tenta cortar se o alvo existir
	if arvore_alvo != null and is_instance_valid(arvore_alvo):
		
		# LIGA A TRAVA! O inimigo para de andar
		atacando = true
		velocity = Vector2.ZERO
		
		if has_node("Animacao"):
			$Animacao.play("attack")
			
			# MÁGICA: Espera a animação de bater terminar
			await $Animacao.animation_finished
		
		# Verifica se o alvo AINDA existe depois da animação 
		# (O Eco Agente pode ter matado o inimigo ou destruído a barreira nesse meio tempo)
		if is_instance_valid(arvore_alvo):
			
			# Verifica se o alvo (Barreira, Agente ou Centro) tem a função receber_dano
			if arvore_alvo.has_method("receber_dano"):
				arvore_alvo.receber_dano()
			else:
				# É uma árvore normal
				arvore_alvo.queue_free()
				
				if GameManager.has_method("alterar_saude_bioma"):
					GameManager.alterar_saude_bioma(-2.0)
			
			print("Agressor: Alvo atacado com sucesso!")
	
	# Limpa o alvo e DESLIGA A TRAVA para voltar a andar
	arvore_alvo = null
	atacando = false
