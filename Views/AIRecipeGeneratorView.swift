import SwiftUI
import SwiftData

struct AIRecipeGeneratorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var availableIngredients: [Ingredient]
    
    @State private var isGenerating = false
    @State private var generatedRecipe: Recipe? = nil
    @State private var errorMessage: String? = nil
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                if isGenerating {
                    ProgressView("O Chef de IA está a criar a receita...")
                        .padding()
                } else if let recipe = generatedRecipe {
                    // Mostrar a receita gerada
                    ScrollView {
                        RecipeCardView(recipe: recipe)
                            .padding()
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Ingredientes")
                                .font(.headline)
                            Text(recipe.ingredientsText)
                                .font(.body)
                            
                            Text("Passos")
                                .font(.headline)
                                .padding(.top, 8)
                            Text(recipe.stepsText)
                                .font(.body)
                        }
                        .padding(.horizontal)
                    }
                    
                    Button("Guardar no Livro de Receitas") {
                        saveRecipe(recipe)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.appGreen)
                    .padding()
                    
                } else {
                    Text("Crie uma refeição mágica usando apenas os ingredientes do seu frigorífico.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding()
                    
                    Button(action: generateMagicRecipe) {
                        HStack {
                            Image(systemName: "wand.and.stars")
                            Text("Gerar Receita com IA")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppTheme.primaryGradient)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.horizontal)
                    }
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding()
                    }
                }
            }
            .navigationTitle("Chef de IA")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Fechar") { dismiss() }
                }
            }
        }
    }
    
    private func generateMagicRecipe() {
        isGenerating = true
        errorMessage = nil
        
        let ingredientNames = availableIngredients
            .filter { $0.status != "Esgotado" }
            .map { "\($0.name) (\($0.quantity)\($0.unit))" }
        
        Task {
            do {
                // Em produção, os parâmetros de dieta viriam do Perfil do Utilizador
                let recipe = try await AIRecipeService.shared.generateRecipe(
                    availableIngredients: ingredientNames,
                    dietPreference: "Saudável",
                    mealType: "Jantar"
                )
                
                DispatchQueue.main.async {
                    self.generatedRecipe = recipe
                    self.isGenerating = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Erro ao gerar: \(error.localizedDescription)"
                    self.isGenerating = false
                }
            }
        }
    }
    
    private func saveRecipe(_ recipe: Recipe) {
        modelContext.insert(recipe)
        dismiss()
    }
}
