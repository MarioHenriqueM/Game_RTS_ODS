extends Camera2D

# Velocidade que a câmera se move pelo mapa
@export var velocidade_camera: float = 600.0

# Quantos pixels de distância da borda o mouse precisa estar para a tela andar
@export var margem_borda: float = 30.0 

func _process(delta: float) -> void:
	var viewport = get_viewport()
	var mouse_pos = viewport.get_mouse_position()
	var tamanho_tela = viewport.get_visible_rect().size
	
	var direcao = Vector2.ZERO

	# --- VERIFICAÇÃO DO MOUSE NAS BORDAS ---
	
	# Borda Esquerda
	if mouse_pos.x < margem_borda:
		direcao.x -= 1
	# Borda Direita
	elif mouse_pos.x > tamanho_tela.x - margem_borda:
		direcao.x += 1
		
	# Borda Superior
	if mouse_pos.y < margem_borda:
		direcao.y -= 1
	# Borda Inferior
	elif mouse_pos.y > tamanho_tela.y - margem_borda:
		direcao.y += 1

	# --- SUPORTE A TECLADO (OPCIONAL MAS RECOMENDADO) ---
	# Permite usar as setas ou WASD também, caso o jogador prefira
	if Input.is_action_pressed("ui_right"): direcao.x += 1
	if Input.is_action_pressed("ui_left"): direcao.x -= 1
	if Input.is_action_pressed("ui_down"): direcao.y += 1
	if Input.is_action_pressed("ui_up"): direcao.y -= 1

	# --- APLICA O MOVIMENTO ---
	# Normalizamos a direção para a câmera não andar mais rápido na diagonal
	if direcao != Vector2.ZERO:
		position += direcao.normalized() * velocidade_camera * delta
