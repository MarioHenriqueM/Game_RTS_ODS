extends CanvasLayer

@onready var texto_creditos: Label = $TextoCreditos
@onready var barra_bio: ProgressBar = $BarraReflorestamento

func _ready() -> void:
	# Conecta os sinais do GameManager para atualizar a UI em tempo real [cite: 44]
	GameManager.recursos_atualizados.connect(atualizar_tela)
	GameManager.bioma_alterado.connect(atualizar_barra)
	GameManager.bioma_atualizado.connect(_on_bioma_atualizado)
	$BarraReflorestamento.value = GameManager.saude_bioma
	
	atualizar_tela()
	atualizar_barra()
	
	
func _on_bioma_atualizado(nova_saude: float) -> void:
	$BarraReflorestamento.value = nova_saude
	
	
func atualizar_tela() -> void:
	texto_creditos.text = "Bio-Créditos: " + str(GameManager.bio_creditos)

func atualizar_barra() -> void:
	# A barra reflete a saúde do bioma (ODS 15) [cite: 24]
	barra_bio.value = GameManager.saude_bioma 
	
	# Verifica condições de vitória/derrota da Sprint 2 [cite: 65, 66]
	if barra_bio.value <= 0:
		exibir_mensagem_derrota()
	elif barra_bio.value >= 100:
		exibir_mensagem_vitoria()

func exibir_mensagem_derrota():
	# Aqui você pode chamar o Antagonista para uma fala provocativa [cite: 58]
	print("O desmatamento venceu. O bioma foi perdido.")

func exibir_mensagem_vitoria():
	print("Parabéns! Você restaurou a biodiversidade terrestre!")


func _on_botao_arvore_pressed() -> void:
	GameManager.construcao_selecionada = "arvore"
	print("Modo Selecionado: Plantar Árvore")

func _on_botao_centro_pressed() -> void:
	GameManager.construcao_selecionada = "centro"
	print("Modo Selecionado: Construir Centro de Biodiversidade")


func _on_botao_agente_pressed() -> void:
	GameManager.construcao_selecionada = "agente"
	print("Modo Selecionado: Recrutar Eco Agente") # Replace with function body.


func _on_botao_barreira_pressed() -> void:
	GameManager.construcao_selecionada = "barreira"
	print("Modo Selecionado: Construir Barreira")
