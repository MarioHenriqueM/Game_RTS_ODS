extends CharacterBody2D

var velocidade: float = 30.0 # Ele é mais lento que o Agressor comum
var alcance_de_tiro: float = 150.0 # Distância que ele para para atirar
var arvore_alvo: Node2D = null
var pode_atirar: bool = true

# Carrega a cena do tiro que criamos no Passo 1!
# ATENÇÃO: Verifique se este caminho está certinho no seu projeto
var cena_projetil: PackedScene = preload("res://entities/units/atacar/logger/Projetil.tscn")

func _ready() -> void:
	add_to_group("agressores") # Para o Eco Agente conseguir caçá-lo!
	
	# Configura o tempo de recarga do tiro (ex: atira a cada 2 segundos)
	$TimerAtaque.wait_time = 2.0
	$TimerAtaque.timeout.connect(_on_timer_ataque_timeout)

func _physics_process(_delta: float) -> void:
	if not is_instance_valid(arvore_alvo):
		buscar_arvore_mais_proxima()
		$Animacao.play("idle")
	
	if is_instance_valid(arvore_alvo):
		var distancia = global_position.distance_to(arvore_alvo.global_position)
		var direcao = global_position.direction_to(arvore_alvo.global_position)
		
		# Vira o rosto para o lado certo
		$Animacao.flip_h = (direcao.x < 0)
		
		# Só anda se estiver LONGE do alvo
		if distancia > alcance_de_tiro:
			velocity = direcao * velocidade
			move_and_slide()
			$Animacao.play("walk")
		else:
			# Está no alcance! Para de andar e atira
			velocity = Vector2.ZERO
			if pode_atirar:
				atirar(direcao)

func buscar_arvore_mais_proxima() -> void:
	var arvores = get_tree().get_nodes_in_group("arvores")
	if arvores.size() == 0:
		arvore_alvo = null
		return
		
	var alvo_temp = null
	var menor_distancia = INF
	
	for arvore in arvores:
		if is_instance_valid(arvore):
			var dist = global_position.distance_to(arvore.global_position)
			if dist < menor_distancia:
				menor_distancia = dist
				alvo_temp = arvore
				
	arvore_alvo = alvo_temp

func atirar(direcao_tiro: Vector2) -> void:
	pode_atirar = false
	$Animacao.play("attack")
	
	# Cria o tiro
	var novo_projetil = cena_projetil.instantiate()
	novo_projetil.global_position = global_position # Nasce na posição do atirador
	novo_projetil.direcao = direcao_tiro
	
	# Adiciona o tiro ao mapa (usamos get_parent() para o tiro não ficar preso ao inimigo)
	get_parent().add_child(novo_projetil)
	
	$TimerAtaque.start() # Começa a recarregar a arma

func _on_timer_ataque_timeout() -> void:
	pode_atirar = true # Arma recarregada!
