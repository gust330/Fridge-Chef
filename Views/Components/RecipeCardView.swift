import SwiftUI

struct RecipeCardView: View {
    let recipe: Recipe
    var match: RecipeMatch? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Imagem Placeholder Premium
            ZStack(alignment: .topTrailing) {
                LinearGradient(
                    colors: [Color.appGreen.opacity(0.5), Color.appOrange.opacity(0.5)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 150)
                .overlay(
                    Image(systemName: "fork.knife.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white.opacity(0.5))
                )

                HStack(alignment: .top) {
                    if let match {
                        Text("\(Int(match.availablePercent))% disponível")
                            .font(.caption2).bold()
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(.white.opacity(0.9))
                            .foregroundColor(.appGreen)
                            .clipShape(Capsule())
                    }
                    Spacer()
                    Button(action: {
                        recipe.isFavorite.toggle()
                        HapticsService.light()
                    }) {
                        Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(recipe.isFavorite ? .red : .white)
                            .padding(10)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                }
                .padding(12)
            }

            // Info
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(recipe.mealType.uppercased())
                        .font(.caption).bold()
                        .foregroundColor(.appOrange)
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption)
                        Text("\(recipe.prepTime + recipe.cookTime) min")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.secondary)
                }

                Text(recipe.title)
                    .font(.title3).bold()
                    .foregroundColor(.primary)
                    .lineLimit(2)

                HStack {
                    BadgeView(text: recipe.dietType, color: .appGreen)
                    if let cals = recipe.calories {
                        BadgeView(text: "\(cals) kcal", color: .gray)
                    }
                }
            }
            .padding(16)
            .background(Color.cardBackground)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
    }
}

struct BadgeView: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .clipShape(Capsule())
    }
}
