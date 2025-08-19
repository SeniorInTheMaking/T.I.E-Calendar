import SwiftUI
import CoreData


struct buttonPlusView: View {
    let spaceWidth: CGFloat
    @State private var showWindow = false
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \NoteEntity.date, ascending: true)],
        animation: .default)
    private var notes: FetchedResults<NoteEntity>

    var body: some View {
        let buttonSize = spaceWidth * 0.2
        
        Button {
            showWindow = true
        } label: {
            Image("buttonPlus")
                .resizable()
                .frame(width: buttonSize, height: buttonSize)
                .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 2)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 10)
                .sheet(isPresented: $showWindow) {
                    AddCategoryView(spaceWidth: spaceWidth)
                }
        }
    }
}


struct AddCategoryView: View {
    let spaceWidth: CGFloat

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var categoryName: String = ""
    @State private var categoryColor: String = "noteBlue"
    
    let availableColors = ["noteBlue", "noteYellow", "noteRed", "noteGreen",
                          "noteOrange", "notePurple", "notePink", "noteGray"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Название категории")) {
                    TextField("Введите название", text: $categoryName)
                }
                
                Section(header: Text("Цвет категории")) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4)) {
                        ForEach(availableColors, id: \.self) { color in
                            ColorCircleView(colorName: color, isSelected: categoryColor == color, spaceWidth: spaceWidth)
                                .onTapGesture {
                                    categoryColor = color
                                }
                        }
                    }
                }
            }
            .navigationTitle("Новая категория")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        addCategory()
                    }
                    .disabled(categoryName.isEmpty)
                }
            }
        }
    }
    private func addCategory() {
        let newCategory = CategoryEntity(context: viewContext)
        newCategory.id = UUID()
        newCategory.name = categoryName
        newCategory.color = categoryColor
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Ошибка сохранения категории: \(error.localizedDescription)")
        }
    }
}


struct ColorCircleView: View {
    let colorName: String
    let isSelected: Bool
    let spaceWidth: CGFloat
    
    var body: some View {
        let circleSize = spaceWidth * 0.1
        let frameSize = circleSize * 1.1
        let markSize = circleSize * 0.4
        
        ZStack {
            Circle()
                .fill(Color(colorName))
                .frame(width: circleSize)
            
            if isSelected {
                Circle()
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    .frame(width: frameSize, height: frameSize)
                
                Image(systemName: "checkmark")
                    .foregroundColor(.primary)
                    .font(.system(size: markSize, weight: .bold))
            }
        }
        .frame(width: frameSize, height: frameSize)
    }
}


