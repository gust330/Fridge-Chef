# FridgeChef

App pessoal para gerir inventário doméstico, recomendar receitas e gerar listas de compras automaticamente.

Baseado no [PRD Pessoal v2.0](./FridgeChef_PRD_Pessoal.md).

## Stack

- **SwiftUI** + **SwiftData** (iOS 17+ / macOS 14+)
- **Haptics** com fallback em macOS
- **Notificações locais** (UNUserNotificationCenter)
- **Motor local** de matching de receitas (sem dependências externas)
- **IA opcional** (OpenAI) para geração de receitas alternativas

## Como abrir no Mac

### 1. Requisitos
- macOS 14 (Sonoma) ou superior
- Xcode 15+ (recomendado 15.3 ou superior para SwiftData estável)

### 2. Criar o projeto Xcode
1. Abre o Xcode.
2. **File → New → Project…**
3. Escolhe **macOS → App** (não iOS).
4. Configura:
   - **Product Name:** FridgeChef
   - **Interface:** SwiftUI
   - **Language:** Swift
   - **Storage:** SwiftData
   - **Bundle Identifier:** com.teuuser.FridgeChef (ou o teu)
5. **Desmarca** "Include Tests" (opcional).
6. Escolhe a pasta onde queres o projeto (recomendo: junto a esta pasta clonada).

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

### 4. Configurar o target para SwiftData
1. Seleciona o projeto no navegador esquerdo.
2. Em **TARGETS → FridgeChef**, separa a tab **General**.
3. Em **Minimum Deployments**, define **macOS 14.0** ou superior.
4. Em **Frameworks, Libraries, and Embedded Content**, garante que não falta nenhuma framework (SwiftData vem do sistema).

### 5. Adicionar capabilities (opcional)
- **App Sandbox:** já vem ativado por defeito.
- **Notifications:** se quiseres que a app agende lembretes, precisas adicionar a capability. No entanto, o `UNUserNotificationCenter` funciona no Mac sem entitlement extra, só precisas do consentimento do utilizador no primeiro launch.

### 6. Build & Run
- Seleciona o scheme **FridgeChef** → **My Mac**.
- `Cmd+R` para compilar e correr.
- A app abre com dados de exemplo (SampleData carrega 8 receitas curadas).

## Estrutura do projeto

```
FridgeChef/
├── FridgeChefApp.swift          # Entry point + ModelContainer
├── FridgeChef_PRD_Pessoal.md    # PRD (este repositório)
├── Models/                       # SwiftData @Model
│   ├── Ingredient.swift
│   ├── Recipe.swift
│   ├── RecipeMatch.swift
│   ├── ShoppingItem.swift
│   └── UserPreference.swift
├── Services/
│   ├── AIService.swift          # OpenAI (opcional)
│   ├── HapticsService.swift     # Compatível iOS/macOS
│   ├── NotificationService.swift
│   └── RecipeMatcher.swift      # Motor local de scoring
├── Utils/
│   ├── Compat.swift             # Extensões de compatibilidade
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

## Compatibilidade

A app foi desenhada para correr em **iOS, iPadOS e macOS** com o mesmo código-fonte. As APIs específicas de iOS estão protegidas com `#if os(iOS)` ou centralizadas no `Utils/Compat.swift`.

## Próximos passos (Fase 2 do PRD)

- Widget (WidgetKit) com ingredientes a expirar
- Siri Shortcuts via App Intents
- Quick Add com parsing inteligente
- Planeador semanal simples
