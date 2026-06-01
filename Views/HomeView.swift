import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var recipes: [Recipe]
    @Query private var allIngredients: [Ingredient]
    @Query(filter: #Predicate<Ingredient> { $0.status == "A acabar" || $0.status == "Esgotado" })
    private var urgentIngredients: [Ingredient]
    @Query(sort: \ShoppingItem.createdAt) private var shoppingItems: [ShoppingItem]

    @State private var showAIGenerator = false
    @State private var showAddIngredient = false

    private var topMatches: [RecipeMatch] {
        let preferredDiets: [String] = UserDefaults.standard.stringArray(forKey: "preferredDiets") ?? []
        return RecipeMatcher.rank(
            recipes: recipes.isEmpty ? SampleData.recipes : recipes,
            ingredients: allIngredients,
            preferredDiets: preferredDiets,
            limit: 3
        )
    }

    private var shoppingChecked: Int { shoppingItems.filter { $0.isChecked }.count }
    private var shoppingTotal: Int { shoppingItems.count }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Cabeçalho
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(greeting)
                                .font(.title2).bold()
                            Text("O que vamos cozinhar hoje?")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(AppTheme.primaryGradient)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)

                    // Ações Rápidas
                    HStack(spacing: 12) {
                        QuickActionButton(icon: "plus", title: "Adicionar", color: .appGreen) {
                            showAddIngredient = true
                        }
                        QuickActionButton(icon: "sparkles", title: "Magia IA", color: .appOrange) {
                            showAIGenerator = true
                        }
                        QuickActionButton(icon: "cart", title: "Compras", color: .blue) {
                            // O utilizador navega pela tab bar
                        }
                    }
                    .padding(.horizontal)

                    // Usar Primeiro
                    VStack(alignment: .leading, spacing: 12) {
                        sectionHeader("Usar Primeiro", systemImage: "clock.badge.exclamationmark")
                        if urgentIngredients.isEmpty {
                            Text("Nada urgente. Boa gestão!")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 14) {
                                    ForEach(urgentIngredients) { ingredient in
                                        UrgentIngredientCard(ingredient: ingredient)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }

                    // Sugestão do Dia (motor local)
                    VStack(alignment: .leading, spacing: 12) {
                        sectionHeader("Sugestões para ti", systemImage: "fork.knife.circle")
                        if topMatches.isEmpty {
                            EmptyStateView(
                                icon: "frying.pan",
                                title: "Sem sugestões",
                                message: "Adiciona ingredientes ou receitas para começarmos."
                            )
                            .frame(height: 220)
                        } else {
                            VStack(spacing: 16) {
                                ForEach(topMatches, id: \.recipe.id) { match in
                                    NavigationLink(destination: RecipeDetailView(recipe: match.recipe)) {
                                        RecipeCardView(recipe: match.recipe, match: match)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    // Mini resumo de Compras
                    if !shoppingItems.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            sectionHeader("Compras", systemImage: "cart.circle")
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(shoppingChecked) / \(shoppingTotal)")
                                        .font(.title).bold()
                                        .foregroundColor(.appGreen)
                                    Text("itens comprados")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                ProgressView(value: shoppingTotal == 0 ? 0 : Double(shoppingChecked) / Double(shoppingTotal))
                                    .progressViewStyle(.linear)
                                    .tint(.appGreen)
                                    .frame(width: 140)
                            }
                            .padding()
                            .background(Color.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.horizontal)
                        }
                    }

                    Spacer(minLength: 40)
                }
            }
            .background(Color.appBackground.ignoresSafeArea())
            .navigationBarHidden(true)
            .sheet(isPresented: $showAIGenerator) { AIRecipeGeneratorView() }
            .sheet(isPresented: $showAddIngredient) { AddIngredientView() }
        }
    }

    @ViewBuilder
    private func sectionHeader(_ title: String, systemImage: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .foregroundColor(.appGreen)
            Text(title)
                .font(.title3).bold()
        }
        .padding(.horizontal)
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Bom dia, Chef!"
        case 12..<18: return "Boa tarde, Chef!"
        default: return "Boa noite, Chef!"
        }
    }
}

// Subcomponentes
struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    var action: () -> Void

    var body: some View {
        Button(action: {
            HapticsService.light()
            action()
        }) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 52, height: 52)
                    .background(color.gradient)
                    .clipShape(Circle())
                    .shadow(color: color.opacity(0.3), radius: 6, y: 3)
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct UrgentIngredientCard: View {
    let ingredient: Ingredient

    private var icon: String {
        if ingredient.status == AppConstants.Status.outOfStock { return "xmark.octagon.fill" }
        if let date = ingredient.expiryDate, date <= Date() { return "exclamationmark.triangle.fill" }
        return "clock.fill"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.red)
                .font(.title2)
            Text(ingredient.name)
                .font(.headline)
                .lineLimit(1)
            Text(ingredient.status)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(16)
        .frame(width: 150, alignment: .leading)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.05), radius: 6, y: 3)
    }
}
