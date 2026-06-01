import Foundation
import SwiftData

/// Receitas curadas (PRD - Fase 1: Base local de receitas)
enum SampleData {
    static let recipes: [Recipe] = [
        Recipe(
            title: "Omelete de Espinafres",
            mealType: "Pequeno-almoço",
            dietType: "Saudável",
            prepTime: 5, cookTime: 5, difficulty: "Fácil",
            ingredientsText: "3 ovos\n1 mão-cheia de espinafres\nQueijo ralado a gosto\nSal e pimenta",
            stepsText: "Bate os ovos com sal e pimenta.\nRefoga os espinafres brevemente.\nJunta os ovos e o queijo.\nCozinha até dourar de ambos os lados.",
            calories: 280, isFavorite: false
        ),
        Recipe(
            title: "Salada de Quinoa",
            mealType: "Almoço",
            dietType: "Vegetariano",
            prepTime: 15, cookTime: 0, difficulty: "Fácil",
            ingredientsText: "1 chávena de quinoa\nTomates cherry\nPepino\nQueijo feta\nAzeite e limão",
            stepsText: "Coze a quinoa e deixa arrefecer.\nCorta os vegetais.\nMistura tudo e tempera com azeite e limão.",
            calories: 350, isFavorite: false
        ),
        Recipe(
            title: "Frango com Batata Doce",
            mealType: "Jantar",
            dietType: "Alta Proteína",
            prepTime: 10, cookTime: 30, difficulty: "Média",
            ingredientsText: "2 peitos de frango\n2 batatas doces\nBrócolos\nAzeite, paprika, sal",
            stepsText: "Corta a batata doce em cubos e assa a 200ºC por 20 min.\nTempera o frango e grelha.\nCoze os brócolos a vapor.\nServe tudo no prato.",
            calories: 520, isFavorite: false
        ),
        Recipe(
            title: "Salmão Grelhado com Legumes",
            mealType: "Jantar",
            dietType: "Saudável",
            prepTime: 10, cookTime: 15, difficulty: "Fácil",
            ingredientsText: "2 postas de salmão\nCourgette\nPimento\nLimão\nAzeite",
            stepsText: "Corta os legumes em tiras.\nGrelha o salmão 4 min de cada lado.\nGrelha os legumes.\nRega com limão e azeite.",
            calories: 450, isFavorite: false
        ),
        Recipe(
            title: "Pasta Carbonara",
            mealType: "Jantar",
            dietType: "Cheat meal",
            prepTime: 5, cookTime: 15, difficulty: "Média",
            ingredientsText: "200g de esparguete\n100g de bacon\n2 gemas de ovo\nQueijo parmesão\nPimenta",
            stepsText: "Coze a pasta.\nFrita o bacon.\nMistura gemas, queijo e pimenta.\nJunta tudo fora do lume (sem cozer o ovo).",
            calories: 700, isFavorite: false
        ),
        Recipe(
            title: "Iogurte com Granola",
            mealType: "Pequeno-almoço",
            dietType: "Rápido e simples",
            prepTime: 3, cookTime: 0, difficulty: "Fácil",
            ingredientsText: "1 iogurte natural\n50g de granola\nFrutos vermelhos\nMel",
            stepsText: "Coloca o iogurte numa taça.\nAdiciona a granola e os frutos.\nRega com mel a gosto.",
            calories: 320, isFavorite: false
        ),
        Recipe(
            title: "Bowl de Atum",
            mealType: "Almoço",
            dietType: "Alta Proteína",
            prepTime: 10, cookTime: 0, difficulty: "Fácil",
            ingredientsText: "1 lata de atum\nArroz cozido\nEdamame\nCenoura ralada\nMolho de soja",
            stepsText: "Coze o arroz e deixa arrefecer.\nOrganiza todos os ingredientes numa taça.\nRega com molho de soja.",
            calories: 480, isFavorite: false
        ),
        Recipe(
            title: "Smoothie Verde",
            mealType: "Snack",
            dietType: "Vegan",
            prepTime: 5, cookTime: 0, difficulty: "Fácil",
            ingredientsText: "1 banana\n1 mão-cheia de espinafres\n1 copo de leite de aveia\n1 colher de manteiga de amêndoa",
            stepsText: "Coloca tudo na liquidificadora.\nTritura até ficar homogéneo.\nServe frio.",
            calories: 250, isFavorite: false
        )
    ]
}
