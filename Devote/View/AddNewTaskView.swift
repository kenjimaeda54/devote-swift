//
//  AddNewTaskView.swift
//  Devote
//
//  Created by kenjimaeda on 26/12/22.
//

import SwiftUI

struct AddNewTaskView: View {
	//MARK: - Properties
	@AppStorage("isDarkMode") var isDarkMode = false
	@State private var task = ""
	@FocusState private var textFieldFocused: Bool
	@Environment(\.managedObjectContext) private var viewContext
	//https://jaredsinclair.com/2020/05/07/swiftui-cheat-sheet.html
	//vou notificar a outra tela desse estado
	@Binding var closeButtonAddTask: Bool;
	//com binding eu vou notificar uma tela antecessor da sua propriedade
	//parecido com propos em React
	//na outra tela possui uma propriedade chamada showButtonAddTask
	//ela ira alterar o valor a partir dela
	
	
	//MARK: - Func
	func handleSubmit() {
		withAnimation {
			let newItem = Item(context: viewContext)
			newItem.task = task
			newItem.completion = false
			newItem.timestamp = Date()
			newItem.id = UUID()
			textFieldFocused = false
			task = ""
			closeButtonAddTask = false
			
			do {
				try viewContext.save()
				PlaySound.play(resource: "sound-ding", type: "mp3")
			}catch {
				print(error)
			}
	
		}
	}
	
	var body: some View {
		VStack(spacing: 16) {
			TextField("",text: $task)
				.modifier(PlaceHolderStyle(showPlaceHolder: task.isEmpty, alignment: nil, text: "New task", color: .gray.opacity(0.5)))
				.padding(.vertical,10)
				.foregroundColor(isDarkMode ? .pink : .black)
				.background(Color(UIColor.systemGray6))
				.cornerRadius(7)
				.focused($textFieldFocused)
				.font(.system(size: 24,weight: .bold,design: .rounded))
			
			
			Button(action: handleSubmit) {
				Spacer()
				Text("Save")
				Spacer()
			}
			.padding(13)
			.disabled(task.isEmpty)
			.foregroundColor(.white)
			.background(task.isEmpty ? .blue :  .pink)
			.cornerRadius(7)
			.font(.system(size: 24,weight: .bold,design: .rounded))
		}
		.padding(.horizontal,20)
		.padding(.vertical,20)
		.background(isDarkMode ? .black  : .white)
		.cornerRadius(15)
		.shadow(color: Color(red: 0, green: 0, blue: 0,opacity: 0.65), radius: 24)
	}//VStack
}

struct AddNewTaskView_Previews: PreviewProvider {
	static var previews: some View {
		AddNewTaskView(closeButtonAddTask: .constant(true))
			.previewLayout(.sizeThatFits)
			.padding()
			.background(.gray)
	}
}
