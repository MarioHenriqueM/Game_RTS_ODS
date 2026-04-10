extends Node

# Recursos do RTS Sustentável
var bio_creditos: int = 100
var sementes_nativas: int = 50
var taxa_desmatamento: float = 0.0 # Porcentagem de 0 a 100
var saude_bioma: float = 10
var saude_maxima: float = 100.0
var construcao_selecionada: String = "arvore"

# Sinais para atualizar a Interface (HUD)
signal recursos_atualizados
signal bioma_alterado
signal bioma_atualizado(nova_saude)

func adicionar_bio_creditos(valor: int) -> void:
	bio_creditos += valor
	recursos_atualizados.emit()

func gastar_sementes(valor: int) -> bool:
	if sementes_nativas >= valor:
		sementes_nativas -= valor
		recursos_atualizados.emit()
		return true
	return false
	
func calcular_impacto_ambiental(area_reflorestada: int, area_degradada: int) -> void:
	# Lógica simples para definir se o jogador está ganhando ou perdendo para o desmatamento
	var total_area = area_reflorestada + area_degradada
	if total_area > 0:
		taxa_desmatamento = float(area_degradada) / float(total_area) * 100.0
		bioma_alterado.emit()
# Adicione esta função no seu GameManager.gd
func gastar_bio_creditos(valor: int) -> bool:
	if bio_creditos >= valor:
		bio_creditos -= valor
		recursos_atualizados.emit()
		print("Créditos gastos. Saldo atual: ", bio_creditos)
		return true
	else:
		print("Aviso: Bio-Créditos insuficientes!")
		return false
func alterar_saude_bioma(valor: float) -> void:
	saude_bioma += valor
	
	# Trava matemática para a barra não passar de 100 nem cair abaixo de 0
	saude_bioma = clamp(saude_bioma, 0.0, saude_maxima)
	
	# Toca o megafone avisando a nova saúde
	bioma_atualizado.emit(saude_bioma)
	
	# Condição de Vitória!
	if saude_bioma >= saude_maxima:
		chamar_vitoria()
		# Aqui no futuro você pode chamar uma tela de vitória
	elif saude_bioma <= 0.0:
		chamar_derrota()
		

func chamar_derrota() -> void:
	print("DERROTA: O bioma foi totalmente devastado.")
	# Pausa o jogo no fundo (opcional, mas recomendado)
	get_tree().paused = true 
	get_tree().change_scene_to_file("res://ui/tela_derrota/TelaDerrota.tscn")
		
func chamar_vitoria() -> void:
	print("Objetivo ODS 15 alcançado! O bioma foi restaurado.")
	# Muda para o ecrã de vitória que vamos criar a seguir
	# Certifique-se de que o caminho do ficheiro está correto
	get_tree().change_scene_to_file("res://ui/tela_vitoria/TelaVitoria.tscn")
		
func game_over_centro_destruido() -> void:
	print("DERROTA CRÍTICA: O Centro de Biodiversidade foi destruído pelos ataques industriais!")
	# Pausa o jogo inteiro para simular a tela de Game Over
	chamar_derrota()
