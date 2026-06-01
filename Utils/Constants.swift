import Foundation

enum AppConstants {
    enum Storage {
        static let locations = ["Frigorífico", "Congelador", "Despensa"]
    }

    enum Status {
        static let available = "Disponível"
        static let runningLow = "A acabar"
        static let outOfStock = "Esgotado"
        static let all = [available, runningLow, outOfStock]
    }

    enum Category {
        static let frutas = "Frutas e Legumes"
        static let carnes = "Carnes e Peixe"
        static let lacticinios = "Lacticínios"
        static let congelados = "Congelados"
        static let despensa = "Despensa"
        static let bebidas = "Bebidas"
        static let condimentos = "Condimentos"
        static let outros = "Outros"
        static let all = [frutas, carnes, lacticinios, congelados, despensa, bebidas, condimentos, outros]
    }

    enum Unit {
        static let all = ["un", "g", "kg", "ml", "L", "colher", "xícara", "dente", "pitada"]
    }

    enum MealType {
        static let all = ["Pequeno-almoço", "Almoço", "Jantar", "Snack", "Pós-treino", "Brunch", "Sobremesa"]
    }

    enum Diet {
        static let all = ["Saudável", "Cheat meal", "Intermédio", "Alta proteína", "Vegetariano", "Vegan", "Sem glúten", "Baixo carboidrato", "Rápido e simples"]
    }
}
