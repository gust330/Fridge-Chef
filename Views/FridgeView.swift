import SwiftUI
import SwiftData

struct FridgeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Ingredient.name) private var ingredients: [Ingredient]

    @State private var searchText = ""
    @State private var selectedLocation = "Tudo"
    @State private var selectedStatus = "Todos"
    @State private var showAddSheet = false
    @State private var sortMode: SortMode = .expiryFirst

    let locations = ["Tudo"] + AppConstants.Storage.locations
    let statusOptions = ["Todos"] + AppConstants.Status.all

    enum SortMode: String, CaseIterable, Identifiable {
        case expiryFirst = "A expirar"
        case recentlyAdded = "Recentes"
        case mostUsed = "Mais usados"
        case alphabetical = "Alfabética"
        var id: String { rawValue }
    }

    var filteredIngredients: [Ingredient] {
        let base = ingredients.filter { item in
            let matchesLocation = selectedLocation == "Tudo" || item.storageLocation == selectedLocation
            let matchesStatus = selectedStatus == "Todos" || item.status == selectedStatus
            let matchesSearch = searchText.isEmpty || item.name.localizedCaseInsensitiveContains(searchText)
            return matchesLocation && matchesStatus && matchesSearch
        }
        switch sortMode {
        case .expiryFirst:
            return base.sorted {
                ($0.expiryDate ?? .distantFuture) < ($1.expiryDate ?? .distantFuture)
            }
        case .recentlyAdded:
            return base.sorted { $0.createdAt > $1.createdAt }
        case .mostUsed:
            return base.sorted { $0.isFavorite && !$1.isFavorite }
        case .alphabetical:
            return base.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Localização", selection: $selectedLocation) {
                    ForEach(locations, id: \.self) { Text($0).tag($0) }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.top, 8)

                Picker("Estado", selection: $selectedStatus) {
                    ForEach(statusOptions, id: \.self) { Text($0).tag($0) }
                }
                .pickerStyle(.menu)
                .padding(.horizontal)
                .padding(.vertical, 4)

                if filteredIngredients.isEmpty {
                    EmptyStateView(
                        icon: "refrigerator",
                        title: "Frigorífico vazio",
                        message: "Adiciona ingredientes para começares a gerir o teu stock.",
                        action: { showAddSheet = true },
                        actionLabel: "Adicionar ingrediente"
                    )
                } else {
                    List {
                        ForEach(filteredIngredients) { ingredient in
                            NavigationLink(destination: IngredientDetailView(ingredient: ingredient)) {
                                IngredientRowView(ingredient: ingredient)
                            }
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
                            .swipeActions(edge: .leading) {
                                Button {
                                    addToShoppingList(ingredient)
                                } label: {
                                    Label("Lista", systemImage: "cart.fill.badge.plus")
                                }
                                .tint(.blue)
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Inventário")
            .searchable(text: $searchText, prompt: "Pesquisar ingrediente...")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Section("Ordenar por") {
                            ForEach(SortMode.allCases) { mode in
                                Button(mode.rawValue) { sortMode = mode }
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down.circle")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showAddSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.appGreen)
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddIngredientView()
            }
        }
    }

    // MARK: - Ações (PRD: Ações rápidas)
    private func markAsOut(_ ingredient: Ingredient) {
        ingredient.status = AppConstants.Status.outOfStock
        addToShoppingList(ingredient)
        HapticsService.warning()
    }

    private func markAsRunningLow(_ ingredient: Ingredient) {
        ingredient.status = AppConstants.Status.runningLow
        HapticsService.medium()
    }

    private func addToShoppingList(_ ingredient: Ingredient) {
        let item = ShoppingItem(
            name: ingredient.name,
            quantity: 1,
            unit: ingredient.unit,
            category: ingredient.category,
            linkedIngredientId: ingredient.id
        )
        modelContext.insert(item)
        HapticsService.success()
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(filteredIngredients[index])
            }
        }
    }
}

// Vista simples de detalhe/edição
struct IngredientDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var ingredient: Ingredient
    @State private var hasExpiry: Bool

    init(ingredient: Ingredient) {
        self.ingredient = ingredient
        _hasExpiry = State(initialValue: ingredient.expiryDate != nil)
    }

    var body: some View {
        Form {
            Section("Identificação") {
                TextField("Nome", text: $ingredient.name)
                HStack {
                    Text("Qtd")
                    Spacer()
                    TextField("0", value: $ingredient.quantity, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                    TextField("un", text: $ingredient.unit)
                        .frame(width: 60)
                }
            }
            Section("Estado") {
                Picker("Estado", selection: $ingredient.status) {
                    ForEach(AppConstants.Status.all, id: \.self) { Text($0).tag($0) }
                }
                Picker("Localização", selection: $ingredient.storageLocation) {
                    ForEach(AppConstants.Storage.locations, id: \.self) { Text($0).tag($0) }
                }
            }
            Section("Validade") {
                Toggle("Tem data de validade", isOn: $hasExpiry)
                if hasExpiry {
                    DatePicker("Expira em", selection: Binding(
                        get: { ingredient.expiryDate ?? Date() },
                        set: { ingredient.expiryDate = $0 }
                    ), displayedComponents: .date)
                }
            }
            Section("Extras") {
                Toggle("Favorito", isOn: $ingredient.isFavorite)
                Toggle("Compra recorrente", isOn: $ingredient.isRecurring)
            }
        }
        .navigationTitle(ingredient.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
