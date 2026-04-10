extends Node2D

# Referências aos nós
@onready var chao_isometrico: TileMapLayer = $TileMapLayer 
@onready var cursor_fantasma = $CursorFantasma
# Certifique-se de que o nome do nó Timer no Inspetor é exatamente "TimerDesmatamento"
@onready var timer_desmatamento = $TimerDesmatamento 

# Carregamento de cenas
var cena_arvore: PackedScene = preload("res://entities/nature/tree/tree.tscn")
var cena_agressor: PackedScene = preload("res://entities/units/atacar/logger/agressor.tscn")
var cena_centro: PackedScene = preload("res://entities/building/town_center/CentroBiodiversidade.tscn")
var cena_agente: PackedScene = preload("res://entities/units/defender/eco_agent/EcoAgente.tscn")
var cena_atirador: PackedScene = preload("res://entities/units/atacar/logger/atirador.tscn")
var cena_barreira: PackedScene = preload("res://entities/building/Barreira/Barreira.tscn")

# --- FUNÇÃO DE INICIALIZAÇÃO (MODO DEMO) ---
func _ready() -> void:
	# 1. Configura a velocidade do spawn para a demonstração (1.5 segundos)
	timer_desmatamento.wait_time = 4.0
	timer_desmatamento.start()
	
	# 2. (Opcional) Bio-créditos iniciais altos para você mostrar as construções
	GameManager.bio_creditos = 500
	
	print("Modo Demo Ativado: Inimigos vindo do Leste a cada 4.0s.")

func _process(_delta: float) -> void:
	var posicao_mouse = get_global_mouse_position()
	var coordenada_grade = chao_isometrico.local_to_map(posicao_mouse)
	var posicao_centro_tile = chao_isometrico.map_to_local(coordenada_grade)
	
	cursor_fantasma.global_position = posicao_centro_tile
	
	if GameManager.construcao_selecionada != "":
		cursor_fantasma.show()
	else:
		cursor_fantasma.hide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		construir()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		GameManager.construcao_selecionada = ""
		print("Modo de construção cancelado.")

func construir() -> void:
	var posicao_mouse = get_global_mouse_position()
	var coordenada_grade = chao_isometrico.local_to_map(posicao_mouse)
	var posicao_centro_tile = chao_isometrico.map_to_local(coordenada_grade)
	
	if GameManager.construcao_selecionada == "arvore":
		if GameManager.gastar_bio_creditos(20):
			var nova_arvore = cena_arvore.instantiate()
			nova_arvore.position = posicao_centro_tile
			nova_arvore.add_to_group("arvores")
			add_child(nova_arvore)
			GameManager.alterar_saude_bioma(5.0)
			
	elif GameManager.construcao_selecionada == "centro":
		if GameManager.gastar_bio_creditos(100):
			var novo_centro = cena_centro.instantiate()
			novo_centro.position = posicao_centro_tile
			novo_centro.add_to_group("arvores") 
			add_child(novo_centro)
			
	elif GameManager.construcao_selecionada == "agente":
		if GameManager.gastar_bio_creditos(50):
			var novo_agente = cena_agente.instantiate()
			novo_agente.position = posicao_centro_tile
			add_child(novo_agente)
			
	elif GameManager.construcao_selecionada == "barreira":
		if GameManager.gastar_bio_creditos(15):
			var nova_barreira = cena_barreira.instantiate()
			nova_barreira.global_position = posicao_centro_tile
			add_child(nova_barreira)

func _on_timer_desmatamento_timeout() -> void:
	var novo_inimigo = null
	var sorteio = randf()
	
	if sorteio <= 0.7: 
		novo_inimigo = cena_agressor.instantiate()
	else:
		novo_inimigo = cena_atirador.instantiate()
	
	# Posição fixa no Leste (fora da tela) com variação de altura
	var y_aleatorio = randi_range(300, 600) 
	novo_inimigo.global_position = Vector2(1300, y_aleatorio) 
	
	# Adicionamos ao mapa apenas UMA VEZ para evitar erros
	if novo_inimigo != null:
		add_child(novo_inimigo)
		print("Demo Spawn: Inimigo surge do Leste.")
