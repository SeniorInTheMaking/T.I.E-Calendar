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
                            .padding(.horizontal, spaceWidth * 0.05)
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
    
    var maskView: some View {
        if checkContentHeight(content: note.content ?? "", lines: 5, fontSize: 18, maxWidth: spaceWidth * 0.92) && !isExpanded {
            return AnyView(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .black, location: 0),
                        .init(color: .black, location: 0.4),
                        .init(color: .clear, location: 1)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        } else {
            return AnyView(Color.black)
        }
    }
    
    var body: some View {
        let cleanContent = cleanContent(note.content ?? "")
        let maxNoteHeight = spaceHeight * 0.4
        
        VStack (alignment: .leading, spacing: maxNoteHeight * 0.02) {
            Text(note.title ?? "No date")
                .font(.system(size: 20, weight: .medium, design: .default))
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)
                .padding(.horizontal, spaceWidth * 0.04)
                .padding(.top, maxNoteHeight * 0.05)
            
            ZStack(alignment: .bottom) {
                Text(isExpanded ? note.content ?? "" : cleanContent)
                    .font(.system(size: 18, weight: .regular, design: .default))
                    .padding(.horizontal, spaceWidth * 0.04)
                    .lineLimit(isExpanded ? nil : 5)
                    .mask(maskView)
                    .animation(.easeInOut(duration: 0.4), value: isExpanded)
            }
            
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
    
    private func cleanContent(_ content: String) -> String {
        content
            .components(separatedBy: .newlines)
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            .joined(separator: "\n")
    }
    
    private func checkContentHeight(content: String, lines: Int, fontSize: CGFloat, maxWidth: CGFloat) -> Bool {
        let font = UIFont.systemFont(ofSize: fontSize)
        let boundingBox = content.boundingRect(
            with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        return boundingBox.height > font.lineHeight * CGFloat(lines)
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

