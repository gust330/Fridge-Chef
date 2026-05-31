import SwiftUI
import SwiftData

struct RecipesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var recipes: [Recipe]
    
    @State private var selectedFilter = "Todas"
    let filters = ["Todas", "Saudável", "Rápido", "Alta Proteína", "Vegetariano"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Categorias horizontais
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(filters, id: \.self) { filter in
                                Button(action: {
                                    withAnimation { selectedFilter = filter }
                                }) {
                                    Text(filter)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(selectedFilter == filter ? Color.appGreen : Color.appGreen.opacity(0.1))
                                        .foregroundColor(selectedFilter == filter ? .white : .appGreen)
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                    
                    // Lista de Receitas (Mock Data for preview)
                    let mock1 = Recipe(title: "Salada de Quinoa", mealType: "Almoço", dietType: "Vegetariano", prepTime: 15, cookTime: 0, difficulty: "Fácil", ingredientsText: "", stepsText: "", calories: 350)
                    let mock2 = Recipe(title: "Frango com Batata Doce", mealType: "Jantar", dietType: "Alta Proteína", prepTime: 10, cookTime: 30, difficulty: "Média", ingredientsText: "", stepsText: "", calories: 500)
                    
                    VStack(spacing: 20) {
                        RecipeCardView(recipe: mock1)
                        RecipeCardView(recipe: mock2)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                }
            }
            .background(Color.appBackground.ignoresSafeArea())
            .navigationTitle("Receitas")
        }
    }
}

struct ShoppingListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ShoppingItem.createdAt) private var items: [ShoppingItem]
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Para Comprar")) {
                    // Mocking some items if empty
                    if items.isEmpty {
                        Text("Lista vazia! Bom trabalho.")
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        ForEach(items) { item in
                            HStack(spacing: 16) {
                                Button(action: { item.isChecked.toggle() }) {
                                    Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                        .font(.title2)
                                        .foregroundColor(item.isChecked ? .appGreen : .gray)
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.name)
                                        .strikethrough(item.isChecked, color: .gray)
                                        .foregroundColor(item.isChecked ? .gray : .primary)
                                    Text("\(item.quantity, specifier: "%.1f") \(item.unit)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Compras")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addSampleShoppingItem) {
                        Image(systemName: "cart.badge.plus")
                            .font(.title3)
                            .foregroundColor(.appGreen)
                    }
                }
            }
        }
    }
    
    private func addSampleShoppingItem() {
        withAnimation {
            let newItem = ShoppingItem(name: "Leite de Aveia", quantity: 2, unit: "L", category: "Lacticínios")
            modelContext.insert(newItem)
        }
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Preferências Pessoais")) {
                    NavigationLink(destination: Text("Dietas")) {
                        Label("Dietas Favoritas", systemImage: "leaf")
                    }
                    NavigationLink(destination: Text("Alergias")) {
                        Label("Alergias / Restrições", systemImage: "exclamationmark.octagon")
                    }
                }
                
                Section(header: Text("Aparência e UX")) {
                    Toggle("Dark Mode", isOn: .constant(true))
                    Toggle("Haptics", isOn: .constant(true))
                }
                
                Section(header: Text("Acerca")) {
                    Text("FridgeChef v2.0 - Sem paywalls")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Perfil")
        }
    }
}
