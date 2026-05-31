import SwiftUI
import SwiftData

struct FridgeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Ingredient.name) private var ingredients: [Ingredient]
    
    @State private var searchText = ""
    @State private var selectedLocation = "Tudo"
    let locations = ["Tudo", "Frigorífico", "Congelador", "Despensa"]
    
    var filteredIngredients: [Ingredient] {
        ingredients.filter { item in
            let matchesLocation = selectedLocation == "Tudo" || item.storageLocation == selectedLocation
            let matchesSearch = searchText.isEmpty || item.name.localizedCaseInsensitiveContains(searchText)
            return matchesLocation && matchesSearch
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Segment Picker Personalizado
                Picker("Localização", selection: $selectedLocation) {
                    ForEach(locations, id: \.self) { location in
                        Text(location).tag(location)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color.appBackground)
                
                // Lista de Ingredientes
                List {
                    ForEach(filteredIngredients) { ingredient in
                        IngredientRowView(ingredient: ingredient)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    markAsOut(ingredient)
                                } label: {
                                    Label("Esgotado", systemImage: "cart.badge.plus")
                                }
                                .tint(.red)
                                
                                Button {
                                    markAsRunningLow(ingredient)
                                } label: {
                                    Label("A Acabar", systemImage: "exclamationmark.triangle")
                                }
                                .tint(.appOrange)
                            }
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Inventário")
            .searchable(text: $searchText, prompt: "Pesquisar ingrediente...")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addSampleItem) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.appGreen)
                    }
                }
            }
        }
    }
    
    // Funções de Gestão (PRD: Ações rápidas)
    private func markAsOut(_ ingredient: Ingredient) {
        ingredient.status = "Esgotado"
        // Em um app real, adicionaria à lista de compras aqui
    }
    
    private func markAsRunningLow(_ ingredient: Ingredient) {
        ingredient.status = "A acabar"
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(filteredIngredients[index])
            }
        }
    }
    
    private func addSampleItem() {
        withAnimation {
            let newItem = Ingredient(name: "Tomates", quantity: 6, unit: "un", category: "Vegetais", storageLocation: "Frigorífico", status: "Disponível")
            modelContext.insert(newItem)
        }
    }
}
