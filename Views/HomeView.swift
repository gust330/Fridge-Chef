import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var recipes: [Recipe]
    @Query(filter: #Predicate<Ingredient> { $0.status == "A acabar" || $0.status == "Esgotado" }) 
    private var urgentIngredients: [Ingredient]
    
    @State private var showAIGenerator = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Cabeçalho
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Bom dia, Chef!")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("O que vamos cozinhar hoje?")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.appGreen)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Ações Rápidas
                    HStack(spacing: 12) {
                        QuickActionButton(icon: "plus", title: "Adicionar", color: .appGreen) { }
                        QuickActionButton(icon: "sparkles", title: "Magia IA", color: .appOrange) {
                            showAIGenerator = true
                        }
                        QuickActionButton(icon: "cart", title: "Compras", color: .blue) { }
                    }
                    .padding(.horizontal)
                    
                    // Secção Usar Primeiro
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Usar Primeiro")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        if urgentIngredients.isEmpty {
                            Text("Não há ingredientes a expirar ou em falta.")
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(urgentIngredients) { ingredient in
                                        UrgentIngredientCard(ingredient: ingredient)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 8)
                            }
                        }
                    }
                    
                    // Secção Sugestão de Receita
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Sugestão do Dia")
                                .font(.title3)
                                .fontWeight(.bold)
                            Spacer()
                            Button("Ver Todas") { }
                                .font(.subheadline)
                                .foregroundColor(.appGreen)
                        }
                        .padding(.horizontal)
                        
                        // Placeholder Recipe (em ambiente real viria do backend/local database)
                        let mockRecipe = Recipe(title: "Salmão Grelhado com Legumes", mealType: "Jantar", dietType: "Saudável", prepTime: 10, cookTime: 15, difficulty: "Fácil", ingredientsText: "Salmão, Brócolos", stepsText: "Grelhar o salmão...")
                        
                        RecipeCardView(recipe: mockRecipe)
                            .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 40)
                }
            }
            .background(Color.appBackground.ignoresSafeArea())
            .navigationBarHidden(true)
            .sheet(isPresented: $showAIGenerator) {
                AIRecipeGeneratorView()
            }
        }
    }
}

// Subcomponente de Ação Rápida
struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(color)
                    .clipShape(Circle())
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// Subcomponente Ingrediente Urgente
struct UrgentIngredientCard: View {
    let ingredient: Ingredient
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.appOrange)
                .font(.title2)
            
            Text(ingredient.name)
                .font(.headline)
                .lineLimit(1)
            
            Text(ingredient.status)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(16)
        .frame(width: 140, alignment: .leading)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
