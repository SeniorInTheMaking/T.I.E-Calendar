import CoreData


struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let testItem = NoteEntity(context: viewContext)
        
        let eventCategory = CategoryEntity(context: viewContext)
        eventCategory.id = UUID()
        eventCategory.name = "Cобытие"
        eventCategory.color = "noteOrange"
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "T_I_E_Calendar")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true

        seedCategoriesIfNeeded()
    }
    
//    @MainActor
    private func seedCategoriesIfNeeded() {
        let ctx = container.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoryEntity")
        fetch.fetchLimit = 1

        let isEmpty = ((try? ctx.count(for: fetch)) ?? 0) == 0
        guard isEmpty else { return }

        let eventCategory = CategoryEntity(context: ctx)
        eventCategory.id = UUID()
        eventCategory.name = "Событие"
        eventCategory.color = "noteOrange"

        let taskCategory = CategoryEntity(context: ctx)
        taskCategory.id = UUID()
        taskCategory.name = "Задача"
        taskCategory.color = "noteBlue"
        
        let ideaCategory = CategoryEntity(context: ctx)
        ideaCategory.id = UUID()
        ideaCategory.name = "Идея"
        ideaCategory.color = "noteYellow"
        
        let noteCategory = CategoryEntity(context: ctx)
        noteCategory.id = UUID()
        noteCategory.name = "Заметка"
        noteCategory.color = "noteRed"
        
        let otherCategory = CategoryEntity(context: ctx)
        otherCategory.id = UUID()
        otherCategory.name = "Другое"
        otherCategory.color = "noteGray"

        try? ctx.save()
    }
    
    func resetAllData() {
        let ctx = container.viewContext
        
        let entityNames = ["NoteEntity", "CategoryEntity"]
        
        do {
            for name in entityNames {
                let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: name)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
                try ctx.execute(deleteRequest)
            }
            try ctx.save()
            print("✅ Все данные удалены")
        } catch {
            print("Ошибка при сбросе данных: \(error.localizedDescription)")
        }
    }
}
