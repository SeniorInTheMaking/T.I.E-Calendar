//
//  T_I_E_CalendarApp.swift
//  T.I.E-Calendar
//
//  Created by Никита Щеглов on 18.08.2025.
//

import SwiftUI

@main
struct T_I_E_CalendarApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
