import SwiftUI
import SwiftData

struct RecipeDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let recipe: Recipe
    @State private var showCookedConfirmation = false

    private var steps: [String] {
        recipe.stepsText
            .split(whereSeparator: { $0 == "\n" })
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }

    private var ingredientsList: [String] {
        RecipeMatcher.parseIngredients(recipe.ingredientsText)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Hero
                ZStack(alignment: .bottomLeading) {
                    LinearGradient(
                        colors: [.appGreen.opacity(0.7), .appOrange.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 180)

                    HStack {
                        Text(recipe.mealType.uppercased())
                            .font(.caption).bold()
                            .padding(.horizontal, 10).padding(.vertical, 5)
                            .background(.white.opacity(0.9))
                            .clipShape(Capsule())
                            .foregroundColor(.appGreen)
                        Spacer()
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                            Text("\(recipe.prepTime + recipe.cookTime) min").bold()
                        }
                        .padding(.horizontal, 10).padding(.vertical, 5)
                        .background(.white.opacity(0.9))
                        .clipShape(Capsule())
                        .foregroundColor(.appOrange)
                    }
                    .padding()
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(recipe.title)
                        .font(.largeTitle).bold()
                    HStack(spacing: 8) {
                        BadgeView(text: recipe.dietType, color: .appGreen)
                        BadgeView(text: recipe.difficulty, color: .gray)
                        if let c = recipe.calories {
                            BadgeView(text: "\(c) kcal", color: .appOrange)
                        }
                    }
                }
                .padding(.horizontal)

                // Ações
                HStack(spacing: 12) {
                    Button(action: toggleFavorite) {
                        Label(recipe.isFavorite ? "Favorita" : "Favoritar",
                              systemImage: recipe.isFavorite ? "heart.fill" : "heart")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(recipe.isFavorite ? Color.red.opacity(0.15) : Color.appGreen.opacity(0.15))
                            .foregroundColor(recipe.isFavorite ? .red : .appGreen)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    Button(action: { showCookedConfirmation = true }) {
                        Label("Marcar como feita", systemImage: "checkmark.seal.fill")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(AppTheme.primaryGradient)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.horizontal)

                // Ingredientes
                sectionTitle("Ingredientes")
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(ingredientsList, id: \.self) { ing in
                        HStack(alignment: .top) {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 6))
                                .foregroundColor(.appGreen)
                                .padding(.top, 8)
                            Text(ing)
                                .font(.body)
                        }
                    }
                }
                .padding(.horizontal)

                // Passos
                sectionTitle("Preparação")
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(Array(steps.enumerated()), id: \.offset) { idx, step in
                        HStack(alignment: .top, spacing: 12) {
                            Text("\(idx + 1)")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 28, height: 28)
                                .background(Circle().fill(Color.appGreen))
                            Text(step)
                                .font(.body)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding(.horizontal)

                Spacer(minLength: 40)
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .alert("Receita concluída!", isPresented: $showCookedConfirmation) {
            Button("OK", role: .cancel) { dismiss() }
        } message: {
            Text("Os ingredientes foram descontados do inventário.")
        }
    }

    @ViewBuilder
    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.title2).bold()
            .padding(.horizontal)
            .padding(.top, 8)
    }

    private func toggleFavorite() {
        recipe.isFavorite.toggle()
        HapticsService.medium()
    }
}
