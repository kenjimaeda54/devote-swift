//
//  File.swift
//  Devote
//
//  Created by kenjimaeda on 26/12/22.
//

import Foundation
import SwiftUI

//crei meu proprio modificador de placeholder
public struct PlaceholderStyle: ViewModifier {
		var showPlaceHolder: Bool
		var placeholder: String

		public func body(content: Content) -> some View {
				ZStack(alignment: .leading) {
						if showPlaceHolder {
								Text(placeholder)
								.padding(.horizontal, 15)
								.foregroundColor(Color.white.opacity(0.5))
						}
						content
						.padding(5.0)
				}
		}
}
