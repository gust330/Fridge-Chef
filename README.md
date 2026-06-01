# FridgeChef

App pessoal para iOS para gerir inventário doméstico, recomendar receitas e gerar listas de compras automaticamente.

Baseado no [PRD Pessoal v2.0](./FridgeChef_PRD_Pessoal.md).

## Stack

- **SwiftUI** + **SwiftData** (iOS 17+)
- **Haptics** (UIImpactFeedbackGenerator)
- **Notificações locais** (UNUserNotificationCenter)
- **Motor local** de matching de receitas (sem dependências externas)
- **IA opcional** (OpenAI) para geração de receitas alternativas

## Como abrir no Mac

### 1. Requisitos
- macOS 14 (Sonoma) ou superior
- Xcode 15+ (recomendado 15.3 ou superior para SwiftData estável)
- iOS 17+ no dispositivo/simulador de destino

### 2. Criar o projeto Xcode
1. Abre o Xcode.
2. **File → New → Project…**
3. Escolhe **iOS → App**.
4. Configura:
   - **Product Name:** FridgeChef
   - **Interface:** SwiftUI
   - **Language:** Swift
   - **Storage:** SwiftData
   - **Bundle Identifier:** com.teuuser.FridgeChef (ou o teu)
5. **Desmarca** "Include Tests" (opcional).
6. Escolhe a pasta onde queres o projeto.

### 3. Importar os ficheiros do repositório
1. No Finder, abre a pasta clonada (`FridgeChef/`).
2. No Xcode, apaga os ficheiros `ContentView.swift` e `<Nome>App.swift` que foram criados automaticamente pelo template.
3. Arrasta para o Xcode as seguintes pastas do repositório:
   - `Models/`
   - `Services/`
   - `Utils/`
   - `Views/`
4. Na janela "Choose options for adding these files":
   - ✅ **Copy items if needed** (para que os ficheiros fiquem dentro do projeto)
   - ✅ **Create groups**
   - ✅ Adiciona ao target **FridgeChef**
5. Clica em **Finish**.

### 4. Configurar o target
1. Seleciona o projeto no navegador esquerdo.
2. Em **TARGETS → FridgeChef**, separa a tab **General**.
3. Em **Minimum Deployments**, define **iOS 17.0** ou superior.
4. Seleciona o teu **Development Team** em **Signing & Capabilities**.

### 5. Build & Run
- Seleciona o scheme **FridgeChef** → um simulador (ex: iPhone 15) ou dispositivo físico.
- `Cmd+R` para compilar e correr.
- A app abre com 8 receitas curadas de exemplo (SampleData).

## Estrutura do projeto

```
FridgeChef/
├── FridgeChefApp.swift          # Entry point + ModelContainer
├── FridgeChef_PRD_Pessoal.md    # PRD
├── Models/                       # SwiftData @Model
│   ├── Ingredient.swift
│   ├── Recipe.swift
│   ├── RecipeMatch.swift
│   ├── ShoppingItem.swift
│   └── UserPreference.swift
├── Services/
│   ├── AIService.swift          # OpenAI (opcional)
│   ├── HapticsService.swift
│   ├── NotificationService.swift
│   └── RecipeMatcher.swift      # Motor local de scoring
├── Utils/
│   ├── Constants.swift
│   ├── SampleData.swift
│   └── Theme.swift
└── Views/
    ├── MainTabView.swift
    ├── HomeView.swift
    ├── FridgeView.swift
    ├── AddIngredientView.swift
    ├── RecipeDetailView.swift
    ├── AIRecipeGeneratorView.swift
    ├── OtherViews.swift          # Receitas, Compras, Perfil
    └── Components/
        ├── EmptyStateView.swift
        ├── IngredientRowView.swift
        └── RecipeCardView.swift
```

## Próximos passos (Fase 2 do PRD)

- Widget (WidgetKit) com ingredientes a expirar
- Siri Shortcuts via App Intents
- Quick Add com parsing inteligente
- Planeador semanal simples
