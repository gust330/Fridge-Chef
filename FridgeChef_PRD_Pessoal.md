# FridgeChef — PRD Pessoal
*Versão 2.0 | Maio 2026 | Uso pessoal, sem paywall*

---

## Visão do produto

**FridgeChef** é uma app iOS pessoal para gerir o que existe em casa, recomendar receitas com base nesses ingredientes e criar automaticamente uma lista de compras quando algum item acaba.

Este produto **não é uma startup nem um SaaS**. É uma app feita para uso individual do utilizador, sem subscrições, sem paywall, sem contas obrigatórias, sem analytics de terceiros e sem funcionalidades bloqueadas.

A prioridade do produto é:

1. Ser muito rápida no dia a dia.
2. Funcionar bem offline.
3. Ter UX moderna e agradável.
4. Reduzir atrito ao adicionar ingredientes.
5. Ajudar a decidir “o que cozinhar hoje” em segundos.

---

## Objetivos

### Objetivo principal
Ajudar o utilizador a saber:
- o que tem em casa,
- o que está a acabar,
- o que pode cozinhar com isso,
- e o que precisa de comprar.

### Objetivos secundários
- Reduzir desperdício alimentar.
- Tornar a organização do frigorífico e despensa simples.
- Adaptar receitas a diferentes estilos de alimentação.
- Facilitar rotina de compras.
- Ser agradável ao ponto de o utilizador querer abrir a app todos os dias.

### Não objetivos
- Marketplace.
- Rede social.
- App multiutilizador complexa.
- Monetização.
- Sistema de delivery.
- Backend pesado para suportar milhares de utilizadores.

---

## Princípios do produto

### 1. Personal-first
A app é desenhada para **uma pessoa** e para os hábitos dessa pessoa.

### 2. Local-first
Os dados vivem localmente no iPhone, com opção de sync por iCloud para backup e continuidade entre dispositivos.

### 3. Zero paywall
Todas as features existem desde o primeiro dia, sem tiers.

### 4. Baixo atrito
Adicionar ingredientes, marcar esgotado e abrir receitas tem de demorar poucos segundos.

### 5. Visual e táctil
A app deve parecer viva: bom uso de animações, haptics, transições e feedback contextual.

---

## Utilizador-alvo

### Perfil principal
- Utilizador individual.
- Cozinha em casa com alguma frequência.
- Quer comer melhor sem complicar demasiado.
- Quer receitas por objetivo: saudável, cheat meal, intermédio, proteína alta, etc.
- Usa iPhone como dispositivo principal.

### Contexto de uso
- Em casa, a ver o frigorífico ou a despensa.
- No supermercado, a confirmar o que falta.
- Antes das refeições, para decidir o que cozinhar.
- Durante a cozinha, para seguir os passos da receita.

---

## Proposta de valor

A app junta quatro coisas num único fluxo:
- inventário de ingredientes,
- recomendação de receitas,
- controlo do que acabou,
- e lista de compras automática.

O valor real não está apenas em “guardar ingredientes”, mas em transformar stock doméstico em decisões úteis.

---

## Escopo do produto

### Core pillars
1. **Inventário doméstico** — o que existe em casa.
2. **Recomendações de receitas** — com base no stock real.
3. **Gestão de faltas** — marcar o que acabou ou está a acabar.
4. **Lista de compras inteligente** — gerar e organizar o que é preciso comprar.
5. **Preferências alimentares** — filtrar receitas por dieta, refeição e objetivo.

---

## Funcionalidades principais

## 1. Inventário de ingredientes

### 1.1 Adicionar ingredientes
Métodos de adição:
- Manual.
- Pesquisa com autocomplete.
- Quantidade + unidade.
- Categoria.
- Data de validade opcional.
- Nota opcional.
- Favorito / compra recorrente.

Campos por ingrediente:
- Nome.
- Quantidade.
- Unidade.
- Categoria.
- Localização: frigorífico, congelador, despensa.
- Data de validade.
- Estado: disponível, pouco, esgotado.
- Frequência de compra.

### 1.2 Estados do ingrediente
Cada ingrediente pode estar em três estados:
- **Disponível** — existe quantidade suficiente.
- **A acabar** — ainda existe, mas convém repor.
- **Esgotado** — já não existe; entra na lista de compras.

### 1.3 Ações rápidas
- Swipe para marcar “a acabar”.
- Swipe para marcar “esgotado”.
- Tap para editar quantidade.
- Long press para abrir ações rápidas.
- Botão “usar na receita” para descontar quantidade após cozinhar.

### 1.4 Organização
Filtros:
- Por localização.
- Por categoria.
- Por validade.
- Por estado.
- Por favoritos.

Ordenações:
- A expirar primeiro.
- Mais recentemente adicionados.
- Mais usados.
- Ordem alfabética.

---

## 2. Recomendação de receitas

### 2.1 Objetivo
A partir dos ingredientes existentes, a app recomenda receitas úteis e realistas.

### 2.2 Tipos de refeição
- Pequeno-almoço
- Almoço
- Jantar
- Snack
- Pós-treino
- Brunch
- Sobremesa

### 2.3 Modos alimentares
- Saudável
- Cheat meal
- Intermédio
- Alta proteína
- Vegetariano
- Vegan
- Sem glúten
- Baixo carboidrato
- Rápido e simples

### 2.4 Lógica de recomendação
Cada receita recebe uma pontuação baseada em:
- percentagem de ingredientes já disponíveis,
- ingredientes que estão a expirar em breve,
- tempo de preparação,
- adequação ao modo alimentar escolhido,
- histórico do que foi feito recentemente,
- preferência pessoal do utilizador.

### 2.5 Resultado da recomendação
Cada receita deve mostrar:
- nome,
- foto,
- tempo estimado,
- dificuldade,
- calorias aproximadas,
- badge do estilo alimentar,
- percentagem de ingredientes disponíveis,
- ingredientes em falta,
- opção para adicionar os que faltam à lista de compras.

### 2.6 Estratégia recomendada de implementação
Para uso pessoal, a melhor estratégia é híbrida:

**Fase inicial**
- Base local de receitas curated.
- Motor de matching local e rápido.
- Sem dependência total de IA.

**Camada opcional de IA**
- Geração de receitas alternativas.
- Ajuste de receitas ao stock disponível.
- Sugestões como “versão mais saudável”, “mais proteica” ou “mais rápida”.

Isto evita que a app dependa sempre de chamadas externas para funcionar.

---

## 3. Lista de compras inteligente

### 3.1 Geração automática
Itens entram na lista de compras quando:
- o utilizador marca um ingrediente como esgotado,
- uma receita precisa de ingredientes em falta,
- um ingrediente está “a acabar” e o utilizador confirma reposição,
- um item recorrente já não existe em casa.

### 3.2 Estrutura da lista
A lista é agrupada por:
- Frutas e legumes
- Carnes e peixe
- Lacticínios
- Congelados
- Despensa
- Bebidas
- Condimentos
- Outros

### 3.3 Ações
- Marcar item como comprado.
- Editar quantidade.
- Juntar itens duplicados.
- Reordenar manualmente.
- Limpar itens comprados.
- Converter itens comprados em stock do frigorífico/despensa.

### 3.4 Modo compras
Modo visual simplificado para supermercado:
- tipografia maior,
- contraste forte,
- grupos por categoria,
- check rápido com haptics,
- barra de progresso da lista.

---

## 4. Gestão de validade e desperdício

### 4.1 Alertas de validade
- Ingredientes a expirar em breve.
- Ingredientes expirados.
- Sugestões de receitas para aproveitar esses ingredientes.

### 4.2 Waste prevention
A app deve ter uma secção “Usar primeiro” com:
- ingredientes mais urgentes,
- receitas que os aproveitam,
- ação rápida “cozinhar hoje”.

### 4.3 Histórico simples
- Quantos ingredientes foram usados antes de expirar.
- Quantos expiraram.
- Categorias com maior desperdício.

Não é preciso transformar isto numa app de métricas pesada; deve ser útil, não obsessiva.

---

## 5. Perfil e preferências

### 5.1 Preferências pessoais
- Dietas favoritas.
- Ingredientes a evitar.
- Alergias / intolerâncias.
- Número de porções habitual.
- Objetivo atual: comer melhor, receitas rápidas, alta proteína, conforto, etc.

### 5.2 Preferências de UX
- Light / dark mode.
- Haptics on/off.
- Notificações on/off.
- Unidades preferidas.
- Ordem padrão das tabs.

### 5.3 Histórico pessoal
- Receitas feitas recentemente.
- Ingredientes mais comprados.
- Refeições favoritas.
- Últimos ingredientes adicionados.

---

## Funcionalidades extra recomendadas

Estas features fazem sentido para uso pessoal e aumentam muito a utilidade sem exigir monetização.

### 1. Quick Add inteligente
Campo único onde o utilizador escreve algo como:
- “frango 500g”
- “6 ovos”
- “arroz 1kg”

A app interpreta automaticamente nome, quantidade e unidade.

### 2. Receitas favoritas
Guardar receitas preferidas e piná-las no topo.

### 3. Repetir compra
Botão para voltar a adicionar rapidamente à lista itens recorrentes.

### 4. Meal suggestions do dia
Na home, mostrar:
- uma sugestão saudável,
- uma rápida,
- uma indulgente,
- uma com ingredientes urgentes.

### 5. Modo “Tenho só isto”
O utilizador selecciona 2-5 ingredientes e a app responde com receitas possíveis ou quase possíveis.

### 6. Planeador simples
Não precisa de ser uma funcionalidade enterprise. Basta permitir:
- guardar receita para amanhã,
- guardar para esta semana,
- ver mini plano semanal.

### 7. Widget iOS
- ingredientes a expirar,
- sugestão de refeição,
- itens em falta.

### 8. Siri Shortcuts
- “O que posso cozinhar hoje?”
- “Adicionar ovos à lista de compras”
- “Marcar leite como esgotado”

---

## Decisões de produto

### O que muda por ser uma app pessoal

#### Remover completamente
- Paywall.
- Subscrições.
- Free tier / premium tier.
- Analytics de growth.
- Onboarding comercial.
- Referrals.
- Multiutilizador complexo.
- Backend centrado em contas.

#### Simplificar fortemente
- Autenticação: não é obrigatória.
- Sync: opcional via iCloud.
- Estrutura de dados: feita para um utilizador, não para equipas.
- Roadmap: focado em utilidade real, não em monetização.

#### Melhorar por ser pessoal
- Mais personalização local.
- Mais automações centradas nos teus hábitos.
- Menos fricção.
- Mais velocidade e privacidade.

---

## Arquitetura técnica recomendada

## Opção recomendada
**SwiftUI + SwiftData + iCloud opcional + motor local de regras + camada opcional de IA**

### Stack
| Camada | Tecnologia | Motivo |
|---|---|---|
| UI | SwiftUI | Melhor para iOS moderno e animações fluidas |
| Persistência local | SwiftData | Simples, nativo, ideal para app pessoal |
| Sync opcional | CloudKit / iCloud | Backup e continuidade sem criar backend próprio |
| Notificações | UserNotifications | Alertas de validade e lembretes |
| Widgets | WidgetKit | Sugestões e lembretes no ecrã principal |
| Siri | App Intents / Shortcuts | Ações rápidas por voz |
| IA opcional | API externa modular | Apenas para enriquecer recomendações |

### Porque esta arquitetura é melhor para este caso
- Menos custo e complexidade.
- Mais privacidade.
- Mais rapidez para desenvolver.
- Menos pontos de falha.
- Funciona mesmo sem internet nas features principais.

### Quando usar IA
Usar IA apenas para:
- gerar variações de receitas,
- adaptar receitas aos ingredientes existentes,
- resumir passos,
- sugerir substituições.

### Quando não usar IA
Não usar IA para:
- CRUD de ingredientes,
- lista de compras,
- filtros simples,
- matching básico,
- lógica de validade.

Isso deve ser local e instantâneo.

---

## Modelo de dados

### Ingredient
- id
- name
- normalizedName
- quantity
- unit
- category
- storageLocation
- expiryDate
- status
- isFavorite
- isRecurring
- notes
- createdAt
- updatedAt

### Recipe
- id
- title
- mealType
- dietType
- prepTime
- cookTime
- difficulty
- calories
- protein
- carbs
- fat
- ingredients
- steps
- image
- tags
- lastCookedAt
- isFavorite

### ShoppingItem
- id
- name
- quantity
- unit
- category
- sourceType
- isChecked
- linkedIngredientId
- createdAt

### UserPreference
- id
- preferredDiets
- excludedIngredients
- allergens
- servingDefault
- notificationsEnabled
- hapticsEnabled
- themePreference

---

## Navegação da app

### Estrutura recomendada de tabs
1. **Home**
2. **Frigorífico**
3. **Receitas**
4. **Compras**
5. **Perfil**

### Razão desta estrutura
Para uso pessoal, faz mais sentido ter uma **Home inteligente** do que um botão central dedicado só a adicionar.

A Home deve concentrar:
- ingredientes urgentes,
- sugestões de receitas,
- atalhos rápidos,
- lista resumida,
- estado geral da casa.

---

## Estrutura dos ecrãs

## 1. Home
Conteúdo:
- saudação contextual,
- secção “Usar primeiro”,
- sugestão do dia,
- acessos rápidos,
- mini resumo da lista de compras,
- receitas para hoje.

### Ações rápidas da Home
- Adicionar ingrediente.
- Ver receitas com ingredientes urgentes.
- Marcar ingrediente como esgotado.
- Abrir modo compras.

## 2. Frigorífico
Conteúdo:
- segment control: frigorífico / congelador / despensa,
- pesquisa,
- filtros,
- grid ou lista,
- quick actions por ingrediente.

## 3. Receitas
Conteúdo:
- filtros por refeição e dieta,
- sugestões principais,
- receitas quase possíveis,
- favoritas,
- histórico recente.

## 4. Compras
Conteúdo:
- lista agrupada,
- barra de progresso,
- ações em lote,
- modo compras.

## 5. Perfil
Conteúdo:
- preferências,
- modos alimentares,
- histórico,
- definições de UI,
- integrações opcionais.

---

## UX e design

## Direção visual
A app deve combinar:
- estética limpa de app de saúde premium,
- calor visual de produto ligado a comida,
- microinterações modernas.

### Paleta sugerida
- Verde principal para frescura e controlo.
- Laranja secundário para energia e apetite.
- Neutros quentes para superfícies.
- Vermelho reservado apenas para urgência/erro.

### Estilo de componentes
- Cards suaves com profundidade subtil.
- Ícones simples e elegantes.
- Botões grandes e muito tocáveis.
- Bottom sheets para ações rápidas.
- Feedback visual forte em swipes e checks.

### Microinterações importantes
- Swipe com resistência física.
- Ingrediente marcado como esgotado “sai” visualmente do stock.
- Ingrediente adicionado à lista “salta” para a tab Compras.
- Check de compra com haptic + strike-through suave.
- Receita concluída com animação satisfatória.

### Haptics
- Light: filtros e seleções.
- Medium: adicionar item.
- Heavy: completar receita ou concluir compras.

---

## Fluxos principais

## Fluxo 1 — Adicionar stock
Abrir app → Home ou Frigorífico → adicionar ingrediente → preencher rapidamente → guardar → ingrediente aparece imediatamente na secção correta.

## Fluxo 2 — Decidir refeição
Abrir Receitas → escolher tipo de refeição e modo alimentar → ver sugestões → abrir receita → cozinhar → marcar como feita → stock atualizado.

## Fluxo 3 — Reposição
Marcar ingrediente como esgotado → confirmar adição à lista de compras → item aparece agrupado por categoria → comprar → marcar como comprado → converter novamente em stock.

## Fluxo 4 — Aproveitar urgentes
Receber alerta de validade → abrir secção “Usar primeiro” → escolher receita sugerida → cozinhar antes do ingrediente expirar.

---

## Requisitos funcionais

### RF1
O utilizador consegue adicionar, editar e remover ingredientes.

### RF2
O utilizador consegue atribuir quantidades, unidades, categoria e validade.

### RF3
O utilizador consegue marcar ingredientes como “a acabar” ou “esgotado”.

### RF4
Ingredientes esgotados podem ser adicionados automaticamente à lista de compras.

### RF5
A app recomenda receitas com base nos ingredientes disponíveis e nas preferências do utilizador.

### RF6
A app mostra claramente os ingredientes que faltam para cada receita.

### RF7
O utilizador pode adicionar ingredientes em falta à lista de compras com um toque.

### RF8
O utilizador pode marcar receitas como favoritas e como concluídas.

### RF9
Ao concluir uma receita, a app pode descontar ingredientes do inventário.

### RF10
A app alerta para ingredientes perto da validade.

### RF11
A app funciona offline nas funcionalidades principais.

### RF12
A app suporta widgets e shortcuts opcionais.

---

## Requisitos não funcionais

### Performance
- Abrir em menos de 2 segundos.
- Ações principais devem parecer instantâneas.
- Scroll sempre fluido.

### Privacidade
- Dados locais por defeito.
- Sem partilha desnecessária com terceiros.
- Sem criação obrigatória de conta.

### Fiabilidade
- Não perder dados ao fechar a app.
- Recuperar estado com consistência.

### Acessibilidade
- Dynamic Type.
- VoiceOver.
- Contraste forte.
- Suporte para redução de movimento.

### Qualidade visual
- Dark mode completo.
- Haptics consistentes.
- Estados vazios desenhados com cuidado.

---

## Roadmap recomendado

## Fase 1 — MVP pessoal
- Home básica
- CRUD completo de ingredientes
- Estados: disponível / a acabar / esgotado
- Lista de compras automática
- Base local de receitas
- Filtros por refeição e dieta
- Receita detalhada com passos
- Alertas de validade

## Fase 2 — Polimento
- Melhor matching de receitas
- Histórico de receitas
- Favoritos
- Widget iOS
- Siri shortcuts
- Haptics e animações avançadas
- Planeador simples de semana

## Fase 3 — Inteligência extra
- Quick Add com parsing inteligente
- Sugestões com IA opcional
- Substituições de ingredientes
- Sugestões automáticas baseadas em hábitos
- Resumo de desperdício e uso

---

## Prioridades reais de desenvolvimento

Se o objetivo é construir bem e sem desperdício de tempo, a ordem ideal é:

1. **Data model sólido**
2. **Frigorífico / inventário impecável**
3. **Lista de compras automática**
4. **Matching local de receitas**
5. **UI polish e microinterações**
6. **IA opcional por cima do que já funciona**

A app tem de ser útil mesmo sem IA. Se já for boa nessa fase, a IA só a torna melhor.

---

## Decisão final de produto

Esta app deve ser tratada como uma **ferramenta pessoal premium sem monetização**, não como um produto comercial.

Por isso, o PRD final assume:
- todas as features livres,
- nenhuma feature bloqueada,
- nenhuma subscrição,
- nenhuma lógica de growth,
- foco total em utilidade, fluidez, design e privacidade.

---

## Resumo de direção

**O melhor caminho** para esta app é construir uma base iOS nativa, local-first, muito rápida, visualmente moderna e com automações reais no inventário e nas compras.

A recomendação de receitas deve assentar primeiro num motor local bem pensado. Depois disso, a IA entra apenas para elevar a experiência, não para suportar o produto inteiro.

---

*FridgeChef PRD Pessoal v2.0 — sem paywall, sem contas obrigatórias, desenhado para uso individual em iPhone*
