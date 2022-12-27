//
//  File.swift
//  Devote
//
//  Created by kenjimaeda on 26/12/22.
//

import Foundation
import SwiftUI

//crei meu proprio modificador de placeholder
struct PlaceHolderStyle: ViewModifier {
	let showPlaceHolder: Bool
	let alignment: Alignment?
	let text: String
	let color: Color
	
	
	func  body(content: Content) -> some View {
		ZStack(alignment: alignment ?? .leading) {
			if showPlaceHolder {
				Text(text)
					.foregroundColor(color)
					.padding(10)
			}
			content
				.padding(10)
		}
	}
	
}
