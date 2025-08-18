import SwiftUI
import CoreData
import UIKit


struct buttonPlusView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \NoteEntity.id, ascending: true)],
        animation: .default)
    private var notes: FetchedResults<NoteEntity>

    var body: some View {
        Button(action: addItem
        ) {
            Text("Add New Note")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.black)
                .cornerRadius(10)
        }
    }
    private func addItem() {
        let newNote = NoteEntity(context: viewContext)
        newNote.id = UUID()
        newNote.title = "New Note"
        newNote.content = "Add your content here..."
        newNote.date = Date()
//        let newItem = Item(context: viewContext)
//        newItem.timestamp = Date()
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}


#Preview {
    buttonPlusView()
}
