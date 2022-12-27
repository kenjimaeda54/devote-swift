//
//  BackgroundImageView.swift
//  Devote
//
//  Created by kenjimaeda on 26/12/22.
//

import SwiftUI

struct BackgroundImageView: View {
	var body: some View {
		Image("rocket")
			.resizable()
			.scaledToFill()
	}
}

struct BackgroundImageView_Previews: PreviewProvider {
	static var previews: some View {
		BackgroundImageView()
		
	}
}
