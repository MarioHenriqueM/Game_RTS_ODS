extends Control

# Caminho para a cena do mapa principal
# Verifique se este caminho está correto no seu projeto!
var caminho_mapa_principal = "res://levels/main_map/main_map.tscn"

func _ready():
	# Garante que o jogo NÃO esteja pausado ao entrar no menu
	# (Caso tenha vindo de uma tela de Game Over que pausou o jogo)
	get_tree().paused = false
	
	# Foca automaticamente no botão jogar para permitir uso de teclado/controle
	$ContainerCentral/ColunaMenu/Inciar_jogo.grab_focus()

func _on_inciar_jogo_pressed() -> void:
	# Muda a cena para o mapa principal do jogo
	print("Iniciando jogo...")
	get_tree().change_scene_to_file(caminho_mapa_principal)

func _on_sair_do_jogo_pressed() -> void:
	# Fecha o jogo
	print("Saindo do jogo...")
	get_tree().quit()
