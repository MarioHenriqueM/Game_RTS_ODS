extends CharacterBody2D

var velocidade: float = 35.0 # Ele é mais rápido que o Agressor
var alvo_atual: Node2D = null
var alcance_de_ataque: float = 50.0

var vida: float = 30.0
var vida_maxima: float = 30.0

var atacando: bool = false

func _ready() -> void:
	# Etiqueta o Agente para que as máquinas saibam quem ele é
	add_to_group("agentes")

func _physics_process(_delta: float) -> void:
	# Se estiver no meio de um ataque, não faz mais nada (ignora perseguição/movimento)
	if atacando:
		return
	
	# 1. Busca um agressor se estiver sem alvo
	if not is_instance_valid(alvo_atual):
		buscar_agressor()
		
		# Toca animação de parado enquanto vigia
		if has_node("Animacao"):
			$Animacao.play("idle")
	
	# 2. Se achou, corre para cima dele!
	elif is_instance_valid(alvo_atual):
		var direcao = global_position.direction_to(alvo_atual.global_position)
		velocity = direcao * velocidade
		move_and_slide()
		
		# Toca animação de corrida e vira o rosto
		if has_node("Animacao"):
			$Animacao.play("walk")
			$Animacao.flip_h = (velocity.x < 0) # Vira para a esquerda se estiver andando para trás
		
		# 3. Se chegou perto o suficiente, ataca
		if global_position.distance_to(alvo_atual.global_position) <= alcance_de_ataque:
			atacar()
	else:
		velocity = Vector2.ZERO # Fica parado vigiando se não tiver inimigos

func buscar_agressor() -> void:
	var inimigos = get_tree().get_nodes_in_group("agressores")
	
	if inimigos.size() == 0:
		alvo_atual = null
		return
		
	var alvo_temp = null
	var menor_distancia = INF
	
	for inimigo in inimigos:
		if is_instance_valid(inimigo):
			var dist = global_position.distance_to(inimigo.global_position)
			if dist < menor_distancia:
				menor_distancia = dist
				alvo_temp = inimigo
				
	alvo_atual = alvo_temp

func atacar() -> void:
	if alvo_atual != null and is_instance_valid(alvo_atual):
		
		print("1. Entrou no atacar. Ligando trava.")
		atacando = true 
		velocity = Vector2.ZERO 
		
		if has_node("Animacao"):
			$Animacao.stop()
			print("2. Mandou tocar a animação de attack.")
			$Animacao.play("attack")
			
			print("3. Esperando animação terminar...")
			await $Animacao.animation_finished 
			print("4. Animação terminou com sucesso!")
		
		if is_instance_valid(alvo_atual):
			print("5. Destruindo o inimigo!")
			alvo_atual.queue_free()
		
	alvo_atual = null
	atacando = false 
	print("6. Trava desligada. Voltando a patrulhar.")

func receber_dano() -> void:
	vida -= 10.0 # Cada golpe ou tiro do inimigo tira 10 de vida
	
	# Efeito visual: Pisca vermelho rápido para mostrar que tomou dano
	if has_node("Animacao"):
		$Animacao.modulate = Color(1, 0.5, 0.5) # Fica avermelhado
		await get_tree().create_timer(0.1).timeout
		$Animacao.modulate = Color(1, 1, 1) # Volta ao normal
		
	if vida <= 0:
		morrer()

func morrer() -> void:
	print("ALERTA: Um Eco Agente caiu em batalha!")
	queue_free()
