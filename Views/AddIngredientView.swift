import SwiftUI
import SwiftData

struct AddIngredientView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var quantity: Double = 1
    @State private var unit: String = AppConstants.Unit.all.first ?? "un"
    @State private var category: String = AppConstants.Category.all.first ?? "Outros"
    @State private var storage: String = AppConstants.Storage.locations.first ?? "Frigorífico"
    @State private var hasExpiry: Bool = false
    @State private var expiryDate: Date = Date().addingTimeInterval(60 * 60 * 24 * 7)
    @State private var isFavorite: Bool = false
    @State private var isRecurring: Bool = false
    @State private var notes: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Identificação") {
                    TextField("Nome (ex: Tomates)", text: $name)
                        .textInputAutocapitalization(.words)
                    HStack {
                        Text("Qtd")
                        Spacer()
                        TextField("0", value: $quantity, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        Picker("", selection: $unit) {
                            ForEach(AppConstants.Unit.all, id: \.self) { u in
                                Text(u).tag(u)
                            }
                        }
                        .pickerStyle(.menu)
                        .labelsHidden()
                    }
                }

                Section("Organização") {
                    Picker("Categoria", selection: $category) {
                        ForEach(AppConstants.Category.all, id: \.self) { c in
                            Text(c).tag(c)
                        }
                    }
                    Picker("Localização", selection: $storage) {
                        ForEach(AppConstants.Storage.locations, id: \.self) { s in
                            Text(s).tag(s)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Validade") {
                    Toggle("Tem data de validade", isOn: $hasExpiry.animation())
                    if hasExpiry {
                        DatePicker("Expira em", selection: $expiryDate, displayedComponents: .date)
                    }
                }

                Section("Extras") {
                    Toggle("Favorito", isOn: $isFavorite)
                    Toggle("Compra recorrente", isOn: $isRecurring)
                    TextField("Notas", text: $notes, axis: .vertical)
                        .lineLimit(2...4)
                }
            }
            .navigationTitle("Novo Ingrediente")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar", action: save)
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                        .bold()
                }
            }
        }
    }

    private func save() {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        let item = Ingredient(
            name: trimmed,
            quantity: quantity,
            unit: unit,
            category: category,
            storageLocation: storage,
            expiryDate: hasExpiry ? expiryDate : nil,
            status: AppConstants.Status.available,
            isFavorite: isFavorite,
            isRecurring: isRecurring,
            notes: notes.isEmpty ? nil : notes
        )
        withAnimation {
            modelContext.insert(item)
            HapticsService.success()
        }
        dismiss()
    }
}
