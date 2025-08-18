import SwiftUI
import CoreData
import UIKit


struct buttonPlusView: View {
    @Environment(\.managedObjectContext) private var context

    var body: some View {
        Button(action: {
            let newNote = NoteEntity(context: context)
            newNote.id = UUID()
            newNote.title = "New Not"
            newNote.content = "Add your content here..."
            newNote.date = Date()
//            newNote.category = nil
            
//            let workCategory = CategoryEntity(context: context)
//            workCategory.id = UUID()
//            workCategory.name = "Работа"
//            workCategory.color = "Зеленый"
//            newNote.category = workCategory
            
            do {
                try context.save()
                print("✅ Сохранение прошло успешно")
            } catch {
                print("❌ Ошибка сохранения: \(error), \((error as NSError).userInfo)")
            }
        }) {
            Text("Add New Note")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.black)
                .cornerRadius(10)
        }
    }
}


#Preview {
    buttonPlusView()
}
