//
//  ListRowItemView.swift
//  Devote
//
//  Created by kenjimaeda on 27/12/22.
//

import SwiftUI

struct ListRowItemView: View {
	//MARK: - Properties
	@Environment(\.managedObjectContext) var viewContext
	@ObservedObject var item: Item
	
	var body: some View {
		Toggle(isOn: $item.completion) {
			Text(item.task ?? "")
				.font(.system(.title2,design: .rounded))
				.fontWeight(.bold)
				.foregroundColor(item.completion ? .pink : Color.primary)
				.padding(.vertical,12)
		}
		.toggleStyle(ToggleCustomStyle())
		//https://developer.apple.com/documentation/swiftui/view/onreceive(_:perform:)
		.onReceive(item.objectWillChange) { _ in
			if self.viewContext.hasChanges {
			  try?	self.viewContext.save()
			}
		}
	
	}//Toggle
}


