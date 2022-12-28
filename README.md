# Todo
Todo usando swiftUi e Core Data

## Feature
- Para realizar requisicoes no core date usamos FetchedResultss
- Como em UIKIT podemos criar nossos srotDescriptor
- Para cabputar o contexto usamos o conceito do decorator Environment
- Toda vez que usar essa propreidade precisamos com anotacao de ponto, chamaro environment no preview
- Core data seu core continua igual em swift ui,precisamos chamar o contexto e salvar
- Caso nao salvar no contexto nao ficara salvo de faot no core data apenas em seu sand box



```swift
@Environment(\.managedObjectContext) private var viewContext

//para adicionar
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


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}



```
##
- Aprendi o uso do decordor [@Binding](https://jaredsinclair.com/2020/05/07/swiftui-cheat-sheet.html)
- Esse decorator e util para fazer uma relacao de notificadao da screen antecessora com a sucessora
- Quando a task for salva na screen AddNewTaskView vou alterar a proreidade na tela ContentView
- Reapare qeu a screen AddNewTaskView e dinamica quando o state showButtonAddTask for verdadeiro ira mostrar a screen
- Assim que a task for salava na screen AddNewTask farei atravez do bind alterar a proreidade do showButtonAddTask assim fechando novametne a screen que etava aberta
- Sem essa relacao precisaria criar uma funcao ou outra altertiva para fazer essa comunicacao indireta entre filho e pai

```swift

//strcut anterior

struct AddNewTaskView: View {

@Binding var closeButtonAddTask: Bool;

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


}


//ContentView

struct ContentView: View {
	@State private var showButtonAddTask = false

//proreidade showButtonAddTask ira mudar automatico na outra screen
	
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
				
}



```

## 
- Outro decorator util e o [FocusState](https://www.hackingwithswift.com/quick-start/swiftui/how-to-dismiss-the-keyboard-for-a-textfield) com ele consigo fechar o teclado de um text field



```swift
@FocusState private var textFieldFocused: Bool

//fechar teclado
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
	


//text field
	TextField("",text: $task)
				.modifier(PlaceHolderStyle(showPlaceHolder: task.isEmpty, alignment: nil, text: "New task", color: .gray.opacity(0.5)))
				.padding(.vertical,10)
				.foregroundColor(isDarkMode ? .pink : .black)
				.background(Color(UIColor.systemGray6))
				.cornerRadius(7)
				.focused($textFieldFocused)
				.font(.system(size: 24,weight: .bold,design: .rounded))



```

##
- Por fim aprendi aplicar um efeito bacana para ofuscar a tela de fundo 
- Usamos a propreidade blendMode e blur

```swift

//quando modal abrir sera essa tela de background
VStack {
			
			Spacer()
			
		}// VStack
		.frame(minWidth: 0,maxWidth: .infinity, minHeight: 0,maxHeight: .infinity,alignment: .center)
		.edgesIgnoringSafeArea(.all)
		.background(color)
		.opacity(opacity)
		.blendMode(.overlay) // aplicar efeito melhor atras
		
	}



//na imagem de fundo que ocupa a tela toda
.background(
					BackgroundImageView()
						.ignoresSafeArea(.all)
						.blur(radius: showButtonAddTask ? 8.0 : 0,opaque: false) //importante para efeito ficar bom
				)
				
//ZStack
.background(
					BackgroundImageView()
						.ignoresSafeArea(.all)
						.blur(radius: showButtonAddTask ? 8.0 : 0,opaque: false) //importante para efeito ficar bom
				)


```

##
- Para construir um navigation bar de forma customizada e so remover o toolbar usando hidden
- Existe um EditButton nativo do switUI para integarir com as lsitas
- Nesse projeto ele estava acionando o metodo onDelete 






```swift
//button nativo
EditButton() //esse editButton e nativo do struct apos selecionar ira ativaro onDelete da list
							.foregroundColor(.white)
							.padding(.vertical,2)
							.padding(.horizontal,20)
							.background(
								RoundedRectangle(cornerRadius: 12)
									.stroke(Color.white,lineWidth: 2)
								
							)



	List {
						
						ForEach(items) { item in
							
							VStack(alignment: .leading,spacing: 10){
								
								ListRowItemView(item: item)
								
							}
							
						}
						.onDelete(perform: deleteItems)
						
	}
	
	
	//delete
	
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
	




```
## 
- Por fim aprendi construi meus proprios esticulos costumizados para os componetnes nativos que swift disponibiliza
- Para aplicar um estilo customizado e usar a proprieda Style, nesse caso toggleStyle, dentro do sue consturto passo a funcao que criamos
- Abaixo tambem tem um exmeplo de modificador para placeholder 


```swift
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


//modificador
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





```

