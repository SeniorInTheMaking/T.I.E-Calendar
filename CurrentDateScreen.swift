import SwiftUI
import Foundation


struct CurrentDateScreen: View {
    @State private var currentDate: Date = Date()
    
    @Environment(\.managedObjectContext) private var ctx
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack (spacing: 0) {
                    HStack {
                        MounthAndYearView(currentDate: $currentDate,
                                          spaceHeight: max(geometry.size.height, geometry.size.width) * 0.05,
                                          spaceWidth: geometry.size.width)
                        
                        Spacer()
                        
                        DatePickerView(currentDate: $currentDate,
                                       spaceHeight: max(geometry.size.height, geometry.size.width) * 0.05,
                                       spaceWidth: geometry.size.width)
                    }
                    .padding(.top, geometry.size.height * 0.02)
                    .padding(.horizontal, geometry.size.width * 0.05)
                    
                    
                    DateFlipView(currentDate: $currentDate,
                                 spaceHeight: max(geometry.size.height, geometry.size.width) * 0.15)
                    .padding(.horizontal, geometry.size.width * 0.15)
                    .padding(.top, geometry.size.height * 0.01)
                    
                    
                    WeekRow(currentDate: $currentDate,
                            spaceHeight: max(geometry.size.height, geometry.size.width) * 0.025,
                            spaceWidth: geometry.size.width)
                    
                    NotesScrollView(currentDate: $currentDate,
                                    spaceHeight: max(geometry.size.height, geometry.size.width) * 0.6,
                                    spaceWidth: geometry.size.width)
                    //                .padding(.horizontal, geometry.size.width * 0.04)
                    .padding(.top, geometry.size.height * 0.015)
                }
                
                VStack {
                    Spacer()
                    
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .clear, location: 0),
                            .init(color: .clear, location: 0.7),
                            .init(color: Color("appBackground"), location: 1)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .allowsHitTesting(false)
                }
                .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    ButtonPlusView(spaceWidth: min(geometry.size.height, geometry.size.width),
                                   spaceHeight: max(geometry.size.height, geometry.size.width))
                    //                .offset(y: -max(geometry.size.height, geometry.size.width) * 0.02)
                    
//                    Button("Очистить все данные") {
//                        PersistenceController.shared.resetAllData()
//                    }
                }
            }
        }
    }
}
