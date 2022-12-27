//
//  BlackView.swift
//  Devote
//
//  Created by kenjimaeda on 27/12/22.
//

import SwiftUI

struct BlanckView: View {
	//MARK: - Properties
	@State  var color: Color
	@State  var opacity: Double
	
	var body: some View {
		VStack {
			
			Spacer()
			
		}// VStack
		.frame(minWidth: 0,maxWidth: .infinity, minHeight: 0,maxHeight: .infinity,alignment: .center)
		.edgesIgnoringSafeArea(.all)
		.background(color)
		.opacity(opacity)
		.blendMode(.overlay) // aplicar efeito melhor atras
		
	}
}

struct BlackView_Previews: PreviewProvider {
	static var previews: some View {
		BlanckView(color: .black, opacity: 0.5)
			.background(BackgroundImageView())
		
		
	}
}
