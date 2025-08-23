import SwiftUI

struct ContentView: View {
    
    var body: some View {
        ZStack {
            Color("appBackground")
                .ignoresSafeArea()
            
            CurrentDateScreen()
        }
    }
}


#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
