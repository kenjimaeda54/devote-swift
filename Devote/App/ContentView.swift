//
//  ContentView.swift
//  Devote
//
//  Created by kenjimaeda on 26/12/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
	//MARK: - Properties
	@Environment(\.managedObjectContext) private var viewContext
	@State private var showButtonAddTask = false
	@AppStorage("isDarkMode") var isDarkMode = false
	
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
		animation: .default)
	private var items: FetchedResults<Item>
	
	//MARK: - Properties
	func toggleAddTaskView() {
		showButtonAddTask = true
	}
	
	func handleDarkMode(){
		isDarkMode.toggle()
		PlaySound.play(resource: "sound-tap", type: "mp3")
		feedback.notificationOccurred(.success)
	}
	
	//MARK: - Body
	var body: some View {
		NavigationStack {
			//esconder teclado
			//https://www.hackingwithswift.com/quick-start/swiftui/how-to-dismiss-the-keyboard-for-a-textfield
			ZStack(alignment: .bottom) {
				VStack{
					
					HStack {
						
						Text("Devote")
							.font(.largeTitle)
							.foregroundColor(.white)
							.fontWeight(.black)
						
						Spacer()
						
						EditButton() //esse editButton e nativo do struct apos selecionar ira ativaro onDelete da list
							.foregroundColor(.white)
							.padding(.vertical,2)
							.padding(.horizontal,20)
							.background(
								RoundedRectangle(cornerRadius: 12)
									.stroke(Color.white,lineWidth: 2)
								
							)
						
						Button (action: handleDarkMode ) {
							Image(systemName: isDarkMode ? "moon.circle.fill" : "moon.circle")
								.font(.system(size: 23))
								.foregroundColor(.white)
						}
						
					} //HStack
					
					Spacer(minLength: 80)
					Button(action:  toggleAddTaskView) {
						Label {
							Text("New Task")
								.font(.system(size: 24,weight: .bold,design: .rounded))
								.foregroundColor(.white)
						} icon: {
							Image(systemName: "plus.circle")
								.font(.largeTitle)
								.foregroundColor(.white)
						}
						
					}
					.padding(.vertical,20)
					.padding(.horizontal,20)
					.background(
						LinearGradient(gradient: Gradient(colors: [Color.pink,Color.blue]), startPoint: .leading, endPoint: .trailing)
					)
					.clipShape(Capsule())
					
					List {
						
						ForEach(items) { item in
							
							VStack(alignment: .leading,spacing: 10){
								
								ListRowItemView(item: item)
								
							}
							
						}
						.onDelete(perform: deleteItems)
						
					}// List
					.listStyle(InsetGroupedListStyle())
					//esconder o background da flista
					.scrollContentBackground(.hidden)
					//esconder scroll em list
					//https://www.hackingwithswift.com/quick-start/swiftui/how-to-hide-the-scroll-indicators-in-scrollview-list-and-more
					.scrollIndicators(.hidden)
					
					
				}// Vstack
				.padding()
				.toolbar {
					ToolbarItem(placement: .navigationBarTrailing) {
						EditButton()
					}
				}
				.navigationTitle("Daily Tasks")
				.background(
					BackgroundImageView()
						.ignoresSafeArea(.all)
						.blur(radius: showButtonAddTask ? 8.0 : 0,opaque: false) //importante para efeito ficar bom
				)
				.background(colorBackground)
				.toolbar(.hidden, for: .navigationBar)
				.blur(radius: showButtonAddTask ? 8.0 : 0,opaque: false)//importante para efeito ficar bom
				
				if showButtonAddTask {
					BlanckView(color: isDarkMode ?  .black : .gray, opacity: isDarkMode ? 0.3 : 0.5)
						.onTapGesture {
							withAnimation {
								showButtonAddTask = false
							}
						}
					AddNewTaskView(closeButtonAddTask:  $showButtonAddTask)
						.padding(.horizontal,20)
				}
				
				
			}// ZStack
		}//Navigation Stack
		
		
	}
	
	private func deleteItems(offsets: IndexSet) {
		withAnimation {
			offsets.map { items[$0] }.forEach(viewContext.delete)
			
			do {
				try viewContext.save()
			} catch {
				let nsError = error as NSError
				fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
			}
		}
	}
}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
