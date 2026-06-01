import SwiftUI
import SwiftData

// MARK: - Receitas
struct RecipesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var recipes: [Recipe]
    @Query private var ingredients: [Ingredient]

    @State private var selectedMealType: String = "Todas"
    @State private var selectedDiet: String = "Todas"
    @State private var showOnlyFavorites = false

    private let mealTypes = ["Todas"] + AppConstants.MealType.all
    private let diets = ["Todas"] + AppConstants.Diet.all

    private var matches: [RecipeMatch] {
        let allRecipes = recipes.isEmpty ? SampleData.recipes : recipes
        return RecipeMatcher.rank(
            recipes: allRecipes,
            ingredients: ingredients,
            preferredDiets: [],
            limit: 50
        )
        .filter { m in
            (selectedMealType == "Todas" || m.recipe.mealType == selectedMealType) &&
            (selectedDiet == "Todas" || m.recipe.dietType == selectedDiet) &&
            (!showOnlyFavorites || m.recipe.isFavorite)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Filtros horizontais: refeição
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(mealTypes, id: \.self) { type in
                                FilterChip(text: type, selected: selectedMealType == type) {
                                    selectedMealType = type
                                    HapticsService.light()
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Filtros horizontais: dieta
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(diets, id: \.self) { diet in
                                FilterChip(text: diet, selected: selectedDiet == diet) {
                                    selectedDiet = diet
                                    HapticsService.light()
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    Toggle("Só favoritas", isOn: $showOnlyFavorites)
                        .padding(.horizontal)

                    if matches.isEmpty {
                        EmptyStateView(
                            icon: "book.closed",
                            title: "Sem receitas",
                            message: "Ajusta os filtros ou adiciona ingredientes para ver sugestões."
                        )
                        .frame(height: 280)
                    } else {
                        VStack(spacing: 16) {
                            ForEach(matches, id: \.recipe.id) { match in
                                NavigationLink(destination: RecipeDetailView(recipe: match.recipe)) {
                                    RecipeCardView(recipe: match.recipe, match: match)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 24)
                    }
                }
                .padding(.top, 8)
            }
            .background(Color.appBackground.ignoresSafeArea())
            .navigationTitle("Receitas")
        }
    }
}

struct FilterChip: View {
    let text: String
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(selected ? Color.appGreen : Color.appGreen.opacity(0.1))
                .foregroundColor(selected ? .white : .appGreen)
                .clipShape(Capsule())
        }
    }
}

// MARK: - Lista de Compras
struct ShoppingListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ShoppingItem.createdAt) private var items: [ShoppingItem]
    @Query private var ingredients: [Ingredient]

    @State private var showAddSheet = false
    @State private var shoppingMode = false
    @State private var newName = ""
    @State private var newQty: Double = 1
    @State private var newUnit = AppConstants.Unit.all.first ?? "un"
    @State private var newCategory = AppConstants.Category.all.first ?? "Outros"

    private var grouped: [(String, [ShoppingItem])] {
        Dictionary(grouping: items) { $0.category }
            .sorted { $0.key < $1.key }
            .map { ($0.key, $0.value.sorted { $0.isChecked && !$1.isChecked }) }
    }

    private var checked: Int { items.filter { $0.isChecked }.count }
    private var total: Int { items.count }
    private var progress: Double { total == 0 ? 0 : Double(checked) / Double(total) }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header com progresso
                if !items.isEmpty {
                    VStack(spacing: 6) {
                        HStack {
                            Text("\(checked) de \(total) comprados")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("\(Int(progress * 100))%")
                                .font(.subheadline).bold()
                                .foregroundColor(.appGreen)
                        }
                        ProgressView(value: progress)
                            .tint(.appGreen)
                    }
                    .padding()
                    .background(Color.cardBackground)
                }

                if items.isEmpty {
                    EmptyStateView(
                        icon: "cart",
                        title: "Lista vazia",
                        message: "Quando marcares ingredientes como esgotado, eles aparecem aqui.",
                        action: { showAddSheet = true },
                        actionLabel: "Adicionar manualmente"
                    )
                } else {
                    List {
                        ForEach(grouped, id: \.0) { (category, list) in
                            Section(header: Text(category)) {
                                ForEach(list) { item in
                                    shoppingRow(item)
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .background(Color.appBackground.ignoresSafeArea())
            .navigationTitle("Compras")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        shoppingMode.toggle()
                        HapticsService.medium()
                    } label: {
                        Image(systemName: shoppingMode ? "cart.circle.fill" : "cart.circle")
                            .foregroundColor(shoppingMode ? .appGreen : .secondary)
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
                addItemSheet
            }
        }
        .environment(\.dynamicTypeSize, shoppingMode ? .xxLarge : .large)
    }

    @ViewBuilder
    private func shoppingRow(_ item: ShoppingItem) -> some View {
        HStack(spacing: 14) {
            Button {
                item.isChecked.toggle()
                if item.isChecked { HapticsService.success() } else { HapticsService.light() }
            } label: {
                Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                    .font(shoppingMode ? .largeTitle : .title2)
                    .foregroundColor(item.isChecked ? .appGreen : .gray)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(shoppingMode ? .title3 : .body)
                    .strikethrough(item.isChecked, color: .gray)
                    .foregroundColor(item.isChecked ? .gray : .primary)
                Text("\(item.quantity, specifier: "%.1f") \(item.unit)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                modelContext.delete(item)
            } label: { Label("Apagar", systemImage: "trash") }
        }
        .swipeActions(edge: .leading) {
            Button {
                convertToStock(item)
            } label: { Label("Stock", systemImage: "arrow.down.to.line") }
            .tint(.appGreen)
        }
    }

    @ViewBuilder
    private var addItemSheet: some View {
        NavigationStack {
            Form {
                Section("Item") {
                    TextField("Nome (ex: Leite)", text: $newName)
                    HStack {
                        TextField("Qtd", value: $newQty, format: .number)
                            .keyboardType(.decimalPad)
                        Picker("", selection: $newUnit) {
                            ForEach(AppConstants.Unit.all, id: \.self) { Text($0).tag($0) }
                        }
                        .pickerStyle(.menu).labelsHidden()
                    }
                    Picker("Categoria", selection: $newCategory) {
                        ForEach(AppConstants.Category.all, id: \.self) { Text($0).tag($0) }
                    }
                }
            }
            .navigationTitle("Adicionar à lista")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { showAddSheet = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Adicionar", action: addItem)
                        .disabled(newName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func addItem() {
        let item = ShoppingItem(
            name: newName.trimmingCharacters(in: .whitespaces),
            quantity: newQty,
            unit: newUnit,
            category: newCategory
        )
        withAnimation {
            modelContext.insert(item)
            HapticsService.success()
        }
        newName = ""
        newQty = 1
        showAddSheet = false
    }

    private func convertToStock(_ item: ShoppingItem) {
        let ingredient = Ingredient(
            name: item.name,
            quantity: item.quantity,
            unit: item.unit,
            category: item.category,
            storageLocation: AppConstants.Storage.locations.first ?? "Frigorífico",
            status: AppConstants.Status.available
        )
        withAnimation {
            modelContext.insert(ingredient)
            modelContext.delete(item)
            HapticsService.success()
        }
    }
}

// MARK: - Perfil
struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var recipes: [Recipe]
    @Query private var ingredients: [Ingredient]

    @AppStorage("preferredDiets") private var preferredDietsData: Data = Data()
    @AppStorage("hapticsEnabled") private var hapticsEnabled: Bool = true
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true
    @AppStorage("themePreference") private var themePreference: String = "system"

    @State private var preferredDiets: [String] = []

    var body: some View {
        NavigationStack {
            Form {
                Section("Preferências Alimentares") {
                    NavigationLink {
                        DietPickerView(selected: $preferredDiets)
                            .onChange(of: preferredDiets) { _, newValue in
                                if let data = try? JSONEncoder().encode(newValue) {
                                    preferredDietsData = data
                                }
                            }
                    } label: {
                        HStack {
                            Label("Dietas favoritas", systemImage: "leaf")
                            Spacer()
                            Text("\(preferredDiets.count)")
                                .foregroundColor(.secondary)
                        }
                    }
                }

                Section("Inventário") {
                    statRow(icon: "refrigerator", title: "Ingredientes", value: "\(ingredients.count)")
                    statRow(icon: "fork.knife", title: "Receitas", value: "\(recipes.count)")
                    statRow(icon: "xmark.octagon", title: "Esgotados", value: "\(ingredients.filter { $0.status == AppConstants.Status.outOfStock }.count)")
                }

                Section("UX") {
                    Picker("Tema", selection: $themePreference) {
                        Text("Sistema").tag("system")
                        Text("Claro").tag("light")
                        Text("Escuro").tag("dark")
                    }
                    Toggle("Haptics", isOn: $hapticsEnabled)
                    Toggle("Notificações de validade", isOn: $notificationsEnabled)
                }

                Section("Acerca") {
                    HStack {
                        Text("FridgeChef")
                        Spacer()
                        Text("v2.0")
                            .foregroundColor(.secondary)
                    }
                    Text("App pessoal. Sem paywalls. Sem contas.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Perfil")
            .onAppear {
                if let arr = try? JSONDecoder().decode([String].self, from: preferredDietsData) {
                    preferredDiets = arr
                }
            }
        }
    }

    @ViewBuilder
    private func statRow(icon: String, title: String, value: String) -> some View {
        HStack {
            Label(title, systemImage: icon)
            Spacer()
            Text(value)
                .font(.headline)
                .foregroundColor(.appGreen)
        }
    }
}

struct DietPickerView: View {
    @Binding var selected: [String]
    private let diets = AppConstants.Diet.all

    var body: some View {
        List {
            ForEach(diets, id: \.self) { diet in
                Button {
                    if selected.contains(diet) {
                        selected.removeAll { $0 == diet }
                    } else {
                        selected.append(diet)
                    }
                    HapticsService.light()
                } label: {
                    HStack {
                        Text(diet)
                        Spacer()
                        if selected.contains(diet) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.appGreen)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle("Dietas favoritas")
    }
}
