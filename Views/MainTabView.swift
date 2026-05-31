import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            FridgeView()
                .tabItem {
                    Label("Frigorífico", systemImage: "refrigerator")
                }
            
            RecipesView()
                .tabItem {
                    Label("Receitas", systemImage: "fork.knife")
                }
            
            ShoppingListView()
                .tabItem {
                    Label("Compras", systemImage: "cart.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Perfil", systemImage: "person.fill")
                }
        }
        .tint(.green) // Cor principal sugerida no PRD
    }
}

#Preview {
    MainTabView()
}
