import SwiftUI
import CoreData


struct ButtonPlusView: View {
    let spaceWidth: CGFloat
    let spaceHeight: CGFloat
    @State private var showList = false
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \NoteEntity.date, ascending: true)],
        animation: .default)
    private var notes: FetchedResults<NoteEntity>

    var body: some View {
        let buttonSize = 85.0
        
        if showList {
            categoriesListView(showList: $showList,
                               spaceWidth: spaceWidth,
                               spaceHeight: spaceHeight)
        }
        
        Button {
            withAnimation(.spring(duration: 0.5)) {
                showList.toggle()
            }
        } label: {
            Image("buttonPlus")
                .resizable()
                .frame(width: buttonSize, height: buttonSize)
                .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 2)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 10)
                .rotationEffect(.degrees(showList ? 45 : 0))
                .animation(.spring(response: 0.9, dampingFraction: 0.7), value: showList)
        }
    }
}


struct categoriesListView: View {
    @Binding var showList: Bool
    let spaceWidth: CGFloat
    let spaceHeight: CGFloat
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CategoryEntity.id, ascending: true)],
        animation: .default)
    private var categories: FetchedResults<CategoryEntity>
    
    var body: some View {
        let rowHeight = 65.0
        
        ScrollView {
            LazyVStack (spacing: 0) {
                ForEach(categories, id: \.id) { category in
                    CategoryRow(category: category,
                                rowWidth: spaceWidth * 0.6,
                                rowHeight: rowHeight,
                                showList: $showList)
                }
                AddNewCategoryRow(spaceWidth: spaceWidth,
                                  rowHeight: rowHeight,
                                  showList: $showList)
            }
        }
        .frame(maxWidth: spaceWidth * 0.7,
               maxHeight: rowHeight * min(5.2, CGFloat(categories.count) + 0.2))
        .background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 5)
                )
        )
        .offset(y: showList ? 0 : spaceHeight * 0.05)
        .opacity(showList ? 1 : 0)
    }
}


struct CategoryRow: View {
    let category: CategoryEntity
    let rowWidth: CGFloat
    let rowHeight: CGFloat
    @Binding var showList: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            
            Button(action: {
                withAnimation(.spring(duration: 0.5)) {
                    showList = false
                }
            }) {
                HStack (spacing: rowWidth * 0.05) {
                    Circle()
                        .fill(Color(category.color ?? "blue"))
                        .frame(width: 18)
                        .overlay(
                            Circle()
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                    
                    Text(category.name ?? "No name")
                        .font(.system(size: 22, weight: .medium, design: .rounded))
                        .foregroundColor(Color("systemTitle1"))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray.opacity(0.6))
                }
                .padding()
                .frame(height: rowHeight)
                .contentShape(Rectangle())
            }
            Divider()
                .background(Color.gray.opacity(0.3))
                .frame(width: rowWidth * 0.9)
        }
        .frame(height: rowHeight)
    }
}





struct AddNewCategoryRow: View {
    let spaceWidth: CGFloat
    let rowHeight: CGFloat
    @Binding var showList: Bool
    
    @State private var isPressed = false
    
    var body: some View {
        let rowWidth = spaceWidth * 0.6
            
        Button(action: {
            isPressed = true
//            withAnimation(.spring(duration: 0.5)) {
//                showList = false
//            }
        }) {
            HStack (spacing: rowWidth * 0.05) {
                Image(systemName: "plus")
                    .foregroundColor(.gray)
                    .frame(width: 18)
                
                Text("Новая категория")
                    .font(.system(size: 24, weight: .medium, design: .rounded))
                    .foregroundColor(Color("systemTitle1"))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray.opacity(0.6))
            }
            .padding()
            .frame(height: rowHeight)
            .contentShape(Rectangle())
            }
        .sheet(isPresented: $isPressed) {
            AddCategoryView(spaceWidth: spaceWidth)
        }
    }
}
