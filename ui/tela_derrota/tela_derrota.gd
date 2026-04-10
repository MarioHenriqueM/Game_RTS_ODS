extends Control

func _ready() -> void:
	# Foca no botão de tentar de novo automaticamente
	%BotaoTentarNovamente.grab_focus()
	
	# Garante que o menu funcione mesmo se o jogo tiver sido pausado pelo GameManager
	process_mode = Node.PROCESS_MODE_ALWAYS 

func _on_botao_tentar_novamente_pressed() -> void:
	reiniciar_dados()
	# Tira o jogo do pause antes de recarregar
	get_tree().paused = false 
	# Troque "main_map.tscn" pelo nome real da sua cena do mapa!
	get_tree().change_scene_to_file("res://levels/main_map/main_map.tscn") 

func _on_botao_menu_pressed() -> void:
	reiniciar_dados()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/main_menu/TelaInicio.tscn")

# Função super importante para o jogador não renascer já morto!
func reiniciar_dados() -> void:
	# Coloque aqui os valores com os quais o jogador DEVE começar o jogo
	GameManager.saude_bioma = 10.0 # Exemplo: Começa com 30% de saúde
	GameManager.bio_creditos = 100 # Exemplo: Começa com 100 dinheiros
	GameManager.construcao_selecionada = ""
