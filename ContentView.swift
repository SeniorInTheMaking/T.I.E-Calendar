import SwiftUI

struct ContentView: View {
    
    var body: some View {
        ZStack {
            Color(red: 253/255, green: 252/255, blue: 250/255)
                .ignoresSafeArea()
            
            CurrentDateScreen()
        }
    }
}


#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
