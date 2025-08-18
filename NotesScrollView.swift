import SwiftUI


struct NotesScrollView: View {
    @Binding var currentDate: Date
    let spaceHeight: CGFloat
    let spaceWidth: CGFloat

    @Environment(\.managedObjectContext) private var ctx
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \NoteEntity.date, ascending: false)],
        animation: .default
    )
    private var notes: FetchedResults<NoteEntity>
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(notes) { note in
                    NoteView(note: note, spaceHeight: spaceHeight, spaceWidth: spaceWidth)
                        .padding(.horizontal, spaceWidth * 0.045)
                        .padding(.top, spaceHeight * 0.04)
                }
            }
        }
    }
}


struct NoteView: View {
    let note: NoteEntity
    let spaceHeight: CGFloat
    let spaceWidth: CGFloat
    
    @State private var isExpanded = false
    
    var body: some View {
        let maxNoteHeight = spaceHeight * 0.4
        
        let titleFontSize = maxNoteHeight * 0.105
        let contentFontSize = titleFontSize * 0.9
//        let typeFontSize = titleFontSize * 0.9
        
        VStack (alignment: .leading, spacing: maxNoteHeight * 0.02) {
            Text(note.title ?? "")
                .font(.system(size: titleFontSize, weight: .medium, design: .default))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, spaceWidth * 0.04)
                .lineLimit(1)
                .padding(.top, maxNoteHeight * 0.05)
            
            Text(note.content ?? "")
                .font(.system(size: contentFontSize, weight: .regular, design: .default))
                .padding(.horizontal, spaceWidth * 0.04)
                .truncationMode(.head)
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray.opacity(0.2))
                .padding(.vertical, maxNoteHeight * 0.01)
            
//            Text(note.category?.name ?? "Нет категории")
//                .font(.system(size: typeFontSize, weight: .semibold, design: .rounded))
//                .padding(.horizontal, spaceWidth * 0.04)
        }
        .foregroundColor(Color(red: 1/255, green: 17/255, blue: 4/255)).opacity(0.9)
        .padding(.bottom, maxNoteHeight * 0.03)
        .frame(maxWidth: .infinity, maxHeight: isExpanded ? nil : maxNoteHeight, alignment: .top)

        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white.opacity(0.9))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 2)
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 10)
           
        .onTapGesture {
            withAnimation(.spring(duration: 0.4)) {
                isExpanded.toggle()
            }
        }
    }
}




























//struct NotesScrollView: View {
//    @Binding var currentDate: Date
//    let spaceHeight: CGFloat
//
//    @StateObject private var manager = NotesManager()
//    @State private var newNoteText = ""
//
//    var body: some View {
//        VStack {
//            TextField("Новая заметка", text: $newNoteText)
//
//            Button("Добавить") {
//                guard !newNoteText.isEmpty else { return }
//                manager.addNote(category: Category(name: "Событие", color: "зеленый"), title: "Яндекс-музей", content: newNoteText)
//                newNoteText = ""
//            }
//
//            List {
//                ForEach(manager.notes) { note in
//                    VStack(alignment: .leading) {
//                        Text(note.type)
//                        Text(note.content)
//                        Text(note.date, style: .date)
//                    }
//                }
//                .onDelete { indexSet in
//                    indexSet.forEach { manager.deleteNote(note: manager.notes[$0]) }
//                }
//            }
//        }
//        .padding()
//    }
//}
