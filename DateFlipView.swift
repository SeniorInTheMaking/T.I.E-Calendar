import SwiftUI


struct MounthAndYearView: View {
    @Binding var currentDate: Date
    let spaceHeight: CGFloat
    let spaceWidth: CGFloat
    
    // форматтер для отображения месяца и года
    private let formatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ru_RU")
        f.dateFormat = "LLLL yyyy"
        return f
    }()
    
    var body: some View {
        let textSize = spaceHeight
        
        let st = formatter.string(from: currentDate)
        Text(capitalizeFirstLetter(st))
            .font(.system(size: textSize, weight: .medium, design: .default))
            .foregroundColor(Color(red: 1/255, green: 17/255, blue: 4/255)).opacity(0.9)
            .frame(maxWidth: spaceWidth * 0.5, maxHeight: spaceHeight, alignment: .leading)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .animation(.bouncy(duration: 0.2), value: currentDate)
    }
    
    private func capitalizeFirstLetter(_ st: String) -> String {
        guard let first = st.first else { return st }
        return first.uppercased() + st.dropFirst()
    }
}


struct DatePickerView: View {
    @Binding var currentDate: Date
    let spaceHeight: CGFloat
    let spaceWidth: CGFloat

    @State private var showPicker = false
    
    var body: some View {
        let fontSize = spaceHeight * 0.45
            
        Button("Выбрать дату") {
            showPicker.toggle()
        }
        .font(.system(size: fontSize, weight: .medium, design: .default))
        .lineLimit(1)
        .minimumScaleFactor(0.5)
        .frame(maxWidth: spaceWidth * 0.4, maxHeight: spaceHeight, alignment: .trailing)
        .offset(y: spaceHeight * 0.05)
        .foregroundColor(Color(red: 93/255, green: 92/255, blue: 92/255)).opacity(0.8)

        
        .sheet(isPresented: $showPicker) {
            VStack {
                DatePicker(
                    "Выберите дату",
                    selection: $currentDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .padding(.top, 0)
                                
                Button("Готово") {
                    showPicker = false
                }
                
            }
            .presentationDetents([.height(UIScreen.main.bounds.size.height * 0.5)])
        }
    }
}


struct DateFlipView: View {
    @Binding var currentDate: Date
    let spaceHeight: CGFloat
    
    // форматтер для отображения только числа даты
    private let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d"
        return f
    }()
    
    var body: some View {
        let dateFontSize = spaceHeight
        let buttonSize = dateFontSize * 0.2
        let buttonWidth = dateFontSize * 0.3
        
        HStack {
            Button {
                changeDate(by: -1)
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: buttonSize, weight: .semibold, design: .rounded))
                    .opacity(0.8)
                    .foregroundStyle(.gray)
                    .frame(width: buttonWidth)
            }
            
            Spacer()
            
            Text(formatter.string(from: currentDate))
                .font(.system(size: dateFontSize, weight: .regular, design: .rounded))
                .animation(.bouncy(duration: 0.3), value: currentDate)
                .foregroundColor(Color(red: 0/255, green: 17/255, blue: 3/255)).opacity(0.9)
            
            Spacer()
            
            Button {
                changeDate(by: 1)
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: buttonSize, weight: .semibold, design: .rounded))
                    .opacity(0.8)
                    .foregroundStyle(.gray)
                    .frame(width: buttonWidth)
            }
        }
    }
    
    private func changeDate(by days: Int) {
        if let newDate = Calendar.current.date(byAdding: .day, value: days, to: currentDate) {
            currentDate = newDate
        }
    }
}


struct WeekRow: View {
    @Binding var currentDate: Date
    let spaceHeight: CGFloat
    let spaceWidth: CGFloat
    
    @State private var weekStart: Date = Date()
    @State private var newWeekStart: Date = Date()
    
    @State private var visibleIndeces: [Bool] = Array(repeating: false, count: 7)
    @State private var weekRowOpacity: Double = 1
    @State private var forward = true
    @State private var showCircle = false
    
    var calendar = Calendar.current
    
    // Получить список дат текущей недели
    private var weekDates: [Date] {
        (0..<7).map { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: weekStart) ?? currentDate
        }
    }
    
    // форматтер для отображения только числа даты
    private let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d"
        return f
    }()
    
    var body: some View {
        let numberSize = spaceHeight
        let numberWidth = spaceWidth * 0.08
        let numberSpacing = spaceWidth * 0.02
        
        HStack (spacing: numberSpacing) {
            ForEach(Array(weekDates.enumerated()), id: \.element) { i, date in
                let isSelected = calendar.isDate(date, inSameDayAs: currentDate)
                let isWeekend = calendar.isDateInWeekend(date)
                
                Text(formatter.string(from: date))
                    .font(.system(size: numberSize, weight: .medium, design: .rounded))
                    .frame(width: numberWidth)
                    .foregroundColor(isWeekend ? Color.pink : Color(red: 93/255, green: 92/255, blue: 92/255)).opacity(0.9)
                
                    .offset(y: visibleIndeces[i] ? 0 : spaceHeight * 0.3)
                    .opacity(visibleIndeces[i] ? 1 : 0)
                    .opacity(weekRowOpacity)
                
                    .background(
                        Circle()
                            .fill(Color.secondary.opacity(0.5))
                            .scaleEffect(showCircle ? isSelected ? 1.25 : 0.1 : 0)
                            .opacity(isSelected ? 1 : 0)
                            .opacity(weekRowOpacity)
                            .animation(.easeInOut(duration: 0.25), value: isSelected)
                    )
                    .onTapGesture {
                        currentDate = date
                }
            }
        }
        .onAppear {
            weekStart = calendar.dateInterval(of: .weekOfYear, for: currentDate)?.start ?? currentDate
            switchWeek()
        }
        .onChange(of: currentDate) {
            newWeekStart = calendar.dateInterval(of: .weekOfYear, for: currentDate)?.start ?? currentDate
            if newWeekStart != weekStart {
                forward = newWeekStart > weekStart
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    weekStart = newWeekStart
                }
                switchWeek()
            }
        }
    }
    
    private func switchWeek() {
        withAnimation(.easeInOut(duration: 0.3)) {
            weekRowOpacity = 0
            showCircle = false
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            visibleIndeces = Array(repeating: false, count: 7)
            weekRowOpacity = 1
            
            for i in 0..<7 {
                let index = forward ? i : 6 - i
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.03) {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        visibleIndeces[i] = true
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeInOut(duration: 0.35)) {
                    showCircle = true
                }
            }
        }
    }
}
