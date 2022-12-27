//
//  DevoteApp.swift
//  Devote
//
//  Created by kenjimaeda on 26/12/22.
//

import SwiftUI

@main
struct DevoteApp: App {
	//MARK: - Properties
	let persistenceController = PersistenceController.shared
	@AppStorage("isDarkMode")  var isDarkMode = false
	var body: some Scene {
		WindowGroup {
			ContentView()
				.environment(\.managedObjectContext, persistenceController.container.viewContext)
				.preferredColorScheme(isDarkMode ? ColorScheme.dark : ColorScheme.light)
		}
	}
}
