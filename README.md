#  Eco Defensores: A Queda do Consórcio

![Godot Engine](https://img.shields.io/badge/Godot_4.x-478CBF?style=for-the-badge&logo=godotengine&logoColor=white)
![GDScript](https://img.shields.io/badge/GDScript-355570?style=for-the-badge&logo=godotengine&logoColor=white)
![Status](https://img.shields.io/badge/Status-Vertical_Slice-success?style=for-the-badge)

**Eco Defensores** é um jogo de Estratégia em Tempo Real (RTS) e Tower Defense Tático desenvolvido em **Godot 4**. Com uma forte mensagem ecológica e estética em pixel art 16-bits, o jogador atua como a força restauradora da natureza contra o avanço predatório do maquinário industrial.

---

##  O Jogo (Core Loop)

Em vez de destruir o mapa para extrair recursos, a sua missão é **restaurar a vida**. 
Proteja o *Centro de Biodiversidade*, acumule Bio-Créditos e posicione estrategicamente sua fauna e flora para conter as ondas de poluição do Consórcio Corte-Profundo.

* **Expanda a Vida:** Plante árvores para aumentar a *Saúde do Bioma*.
* **Defenda o Território:** Construa barreiras táticas para atrasar os inimigos.
* **Contra-Ataque:** Recrute os ágeis *Eco Agentes* para destruir as máquinas de cerco e artilharia tóxica.

Se a Saúde do Bioma chegar a 0%, ou o seu Centro de Biodiversidade for destruído, a natureza perde.

---

## Características Técnicas e Mecânicas

* **Sistema de Grid Isométrico:** Construção modular perfeitamente alinhada via coordenadas matemáticas (`local_to_map`).
* **Inteligência Artificial (IA) de Combate:** Unidades aliadas e inimigas utilizam sistemas de radar baseados em grupos do Godot (`get_nodes_in_group`) e distâncias relativas para engajamento dinâmico.
* **Controle de Câmera RTS:** Implementação de *Edge Scrolling* com restrições dinâmicas de *Viewport*.
* **Sincronia de Animação/Estado:** Arquitetura de código utilizando corrotinas (`await animation_finished`) para prevenir a sobrescrita de estados durante o combate corpo-a-corpo e garantir o "Game Feel".
* **Gerenciamento Global:** Uso de Padrão Singleton (`GameManager`) para controle assíncrono da economia (Bio-Créditos) e da condição de vitória/derrota global.

---

##  Entidades e Balanceamento

###  Forças da Natureza (Jogador)
* **Centro de Biodiversidade:** O coração da base. Gera recursos através de *Timers*.
* **Eco Agente:** Unidade rápida (Velocidade: 35) e letal à curta distância.
* **Barreira Biológica:** Estrutura defensiva projetada para o "Taunt" (atrair dano).

###  Consórcio Corte-Profundo (Inimigos)
* **Agressor:** Máquina pesada (Velocidade: 20). Prioriza o desmatamento físico e ataques ao Centro.
* **Atirador Tóxico:** Unidade de artilharia (Velocidade: 30) que engaja à distância (Alcance: 150), forçando o jogador a agir ativamente em vez de apenas construir defesas estáticas.

---

## Como Executar o Projeto

1. Faça o clone do repositório:
   ```bash
   git clone [https://github.com/MarioHenriqueM/Game_RTS_ODS.git](https://github.com/MarioHenriqueM/Game_RTS_ODS.git)