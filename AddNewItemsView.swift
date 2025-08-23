import SwiftUI


struct AddCategoryView: View {
    let spaceWidth: CGFloat

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @FocusState private var isNameFocused: Bool
    
    @State private var categoryName: String = ""
    @State private var categoryColor: String = "noteBlue"
    
    let availableColors = ["noteBlue", "noteYellow", "noteRed", "noteGreen",
                          "noteOrange", "notePurple", "notePink", "noteGray"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Название категории")) {
                    TextField("Введите название", text: $categoryName)
                        .focused($isNameFocused)
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
                        hideKeyboard()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        hideKeyboard()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            addCategory()
                        }
                    }
                    .disabled(categoryName.isEmpty)
                }
            }
        }
        .onAppear {
            isNameFocused = true
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


struct AddNoteView: View {
    let category: CategoryEntity
    let spaceWidth: CGFloat
    let spaceHeight: CGFloat

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var noteTitle: String = ""
    @State private var noteContent: String = ""
    
    @FocusState private var isTitleFocused: Bool
    
    var body: some View {
        ZStack {
            Color("addNoteBackground")
            
            VStack(spacing: 0) {
                HStack {
                    
                    Button("Отмена") {
                        hideKeyboard()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            dismiss()
                        }
                    }
                    .frame(maxWidth: spaceWidth * 0.25, alignment: .leading)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    
                    Spacer()
                    
                    Text(category.name ?? "Новая запись")
                        .font(.system(size: 20))
                        .frame(maxWidth: spaceWidth * 0.32)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                    Spacer()
                    
                    Button("Готово") {
                        hideKeyboard()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            addNote()
                        }
                    }
                    .frame(maxWidth: spaceWidth * 0.25, alignment: .trailing)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .disabled(noteContent.isEmpty)
                }
                //            .padding(.horizontal, spaceWidth * 0.03)
                .padding(.bottom, 15)
                
                
                VStack(spacing: 0) {
                    ZStack(alignment: .leading) {
                        if noteTitle.isEmpty {
                            Text("Заголовок")
                                .font(.system(size: 19, weight: .semibold))
                                .foregroundStyle(.brown.opacity(0.7))
                        }
                        
                        TextField("", text: $noteTitle)
                            .font(.system(size: 19, weight: .semibold))
                            .foregroundColor(.primary)
                            .focused($isTitleFocused)
                    }
                    
                    
                    Divider()
                        .frame(width: .infinity, height: 1)
                        .padding(.vertical, 5)
                    
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $noteContent)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(.primary)
                            .scrollContentBackground(.hidden)
                            .padding(.top, -8)
                            .padding(.leading, -4)
                        
                        if noteContent.isEmpty {
                            Text("Начните писать...")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundStyle(.brown.opacity(0.7))
                        }
                    }
                }
                //            .padding(.horizontal, spaceWidth * 0.03)
            }
            .padding()
        }
        .onAppear {
            isTitleFocused = true
        }
    }
    private func addNote() {
        let newNote = NoteEntity(context: viewContext)
        newNote.id = UUID()
        newNote.title = noteTitle
        newNote.content = noteContent
        newNote.date = Date()
        newNote.category = category
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Ошибка сохранения NoteEntity: \(error.localizedDescription)")
        }
    }
}


extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}
