//
//  Constants.swift
//  Devote
//
//  Created by kenjimaeda on 26/12/22.
//

import Foundation
import SwiftUI

let itemFormatter: DateFormatter = {
	let formatter = DateFormatter()
	formatter.dateStyle = .short
	formatter.timeStyle = .medium
	return formatter
}()

var colorBackground: LinearGradient {
	return LinearGradient(gradient: Gradient(colors: [Color.pink,Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
}

 
let feedback = UINotificationFeedbackGenerator()

