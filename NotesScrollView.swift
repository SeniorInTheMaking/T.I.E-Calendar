import SwiftUI


struct NotesScrollView: View {
    @Binding var currentDate: Date
    let spaceHeight: CGFloat
    let spaceWidth: CGFloat

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \NoteEntity.date, ascending: true)],
        animation: .default)
    private var notes: FetchedResults<NoteEntity>
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if notes.isEmpty {
                    Text("No notes yet")
                } else {
                    ForEach(notes) { note in
                        NoteView(note: note, spaceHeight: spaceHeight, spaceWidth: spaceWidth)
                            .padding(.horizontal, spaceWidth * 0.045)
                            .padding(.top, spaceHeight * 0.04)
                    }
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
        
        VStack (alignment: .leading, spacing: maxNoteHeight * 0.02) {
            Text(note.title ?? "No date")
                .font(.system(size: 20, weight: .medium, design: .default))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, spaceWidth * 0.04)
                .lineLimit(1)
                .padding(.top, maxNoteHeight * 0.05)
            
            Text(note.content ?? "No content")
                .font(.system(size: 18, weight: .regular, design: .default))
                .padding(.horizontal, spaceWidth * 0.04)
                .lineLimit(isExpanded ? nil : 4)
                .truncationMode(.head)
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color(note.category?.color ?? "noteBlue").opacity(0.5))
                .padding(.vertical, maxNoteHeight * 0.015)
            
            HStack {
                Text(note.category?.name ?? "No category")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .padding(.horizontal, spaceWidth * 0.04)
                
                Spacer()
                
                NoteMenuButton(note: note, menuButtonSize: spaceWidth * 0.05)
                    .padding(.trailing, spaceWidth * 0.01)
            }
        }
        .foregroundColor(Color(red: 1/255, green: 17/255, blue: 4/255)).opacity(0.9)
        .padding(.bottom, maxNoteHeight * 0.03)

        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white.opacity(0.9))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(note.category?.color ?? "noteBlue").opacity(0.5), lineWidth: 1)
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


struct NoteMenuButton: View {
    let note: NoteEntity
    let menuButtonSize: CGFloat
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showMenu = false
    
    var body: some View {
        Menu {
            Button(role: .destructive) {
                deleteNote()
            } label: {
                Label("Удалить", systemImage: "trash")
            }
            
            // Можно добавить другие опции позже
            // Button("Редактировать") { ... }
            // Button("Поделиться") { ... }
            
        } label: {
            Image(systemName: "ellipsis")
                .font(.system(size: menuButtonSize, weight: .medium))
                .foregroundColor(.gray)
                .padding(8)
                .contentShape(Rectangle())
        }
        .onTapGesture {
            withAnimation(.spring()) {
                showMenu.toggle()
            }
        }
    }
    
    private func deleteNote() {
        withAnimation {
            viewContext.delete(note)
            
            do {
                try viewContext.save()
            } catch {
                print("Ошибка при удалении: \(error.localizedDescription)")
            }
        }
    }
}

