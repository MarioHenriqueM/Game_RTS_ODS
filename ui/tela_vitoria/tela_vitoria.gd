extends Control

func _ready() -> void:
	# Foca no botão para facilitar o uso
	$CenterContainer/VBoxContainer/BotaoMenu.grab_focus()

func _on_button_pressed() -> void:
		# Reinicia os valores do bioma antes de voltar
	GameManager.saude_bioma = 0.0
	GameManager.bio_creditos = 100 # Ou o valor inicial que definiu
	get_tree().change_scene_to_file("res://ui/main_menu/TelaInicio.tscn")
