//
//  PlaySound.swift
//  Devote
//
//  Created by kenjimaeda on 27/12/22.
//

import Foundation
import AVFoundation

var  player: AVAudioPlayer?

struct PlaySound  {
	static func  play(resource: String, type: String)  {
		let url = Bundle.main.path(forResource: resource, ofType: type)
		
		guard let url = url else {return}
		
		do {
			player = try  AVAudioPlayer(contentsOf: URL(filePath: url))
			player?.play()
		}catch {
			print(error)
		}
	
	}
	
}
