//
//  ToggleStyle.swift
//  Devote
//
//  Created by kenjimaeda on 27/12/22.
//

import SwiftUI

//customizei um compontente nativo que Swiftui disponibiliza
struct ToggleCustomStyle: ToggleStyle {
	
	
	
	func makeBody(configuration: Configuration) -> some View {
		HStack(spacing: 7) {
			Image(systemName: configuration.isOn ?  "checkmark.circle.fill" : "circle")
				.foregroundColor(configuration.isOn ? .pink : Color.primary)
				.font(.title2)
			//precisa colcoar onTap ele ira assumir todo comportamento
			//colocado aqui
				.onTapGesture {
					configuration.isOn.toggle()
					
					if configuration.isOn {
						PlaySound.play(resource: "sound-rise", type: "mp3")
						feedback.notificationOccurred(.success)
					}else {
						PlaySound.play(resource: "sound-tap", type: "mp3")
						feedback.notificationOccurred(.success)
					}
					
				}
			//aqui sera o label
			configuration.label
				.font(.system(size: 23,weight: .bold,design: .rounded))
				.foregroundColor(configuration.isOn ? .pink : .black)
			
		}// HStack
		
	}
}

struct ToggleStyle_Previews: PreviewProvider {
	static var previews: some View {
		Toggle("Is label", isOn: .constant(true))
			.previewLayout(.sizeThatFits)
			.toggleStyle(ToggleCustomStyle())
	}
}
