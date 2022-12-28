# Todo
Todo usando swiftUi e Core Data

## Feature
- Para realizar requisições no core date usamos FetchedResultss
- Como em UIKIT podemos criar nossos sortDescriptor
- Para capturar o contexto usamos o conceito do decorator Environment
- Quando usa essa propriedade precisa no preview instancia com anotação de ponto
- Core data seu core continua igual em UIkit em alguns requisitos, exemplo precisamos chamar o contexto e salvar
- Caso não salvar no contexto não salvara no core data, apenas em seu sand box


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
- Esse decorator e útil para fazer uma relação de notificação da screen antecessora com a sucessora
- Quando a task for salva na screen AddNewTaskView vou alterar a propriedade na tela ContentView
- Reapare que a screen AddNewTaskView e dinâmica quando o state showButtonAddTask for verdadeiro ira mostrar a screen
- Apos  a task for salva na screen AddNewTask,  irei alterar a propriedade do showButtonAddTask  usando conceito de Binding fechando novamente a screen que estava aberta
- Sem essa relação precisaria criar uma função ou outra alternativa para fazer essa comunicação indireta entre filho e pai

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
- Outro decorator útil e o [FocusState](https://www.hackingwithswift.com/quick-start/swiftui/how-to-dismiss-the-keyboard-for-a-textfield) com ele consigo fechar o teclado de um text field



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
- Aprendi aplicar um efeito bacana para ofuscar a tela de fundo 
- Usamos a propriedade blendMode e blur

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
- Para construir um navigation bar de forma customizada e só remover o toolbar usando hidden
- Existe um EditButton nativo do switUI para interagir com as listas
- Nesse projeto ele estava acionando o método onDelete 





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
- Aprendi construí meus próprios estilos customizados para os componentes nativos que swift disponibiliza
- Para aplicar um estilo customizado usamos  a propriedade Style, nesse caso era toggleStyle, dentro do sue construtor passo a função que criamos
- Abaixo também tem um exemplo de modificador para placeholder 


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

##
- Abaixo uma maneria de alterar uma propriedade d de forma reativa usando ObservedObject e [onReceive](https://developer.apple.com/documentation/swiftui/view/onreceive(_:perform:)
- Caso ocorra mudança no Item através do toogle, por exemplo, a propriedade foi de false para verdadeira, ira refletir e salvar  no core data


```swift
struct ListRowItemView: View {
	//MARK: - Properties
	@Environment(\.managedObjectContext) var viewContext
	@ObservedObject var item: Item
	
	var body: some View {
		Toggle(isOn: $item.completion) {
			Text(item.task ?? "")
				.font(.system(.title2,design: .rounded))
				.fontWeight(.bold)
				.foregroundColor(item.completion ? .pink : Color.primary)
				.padding(.vertical,12)
		}
		.toggleStyle(ToggleCustomStyle())
		.onReceive(item.objectWillChange) { _ in
			if self.viewContext.hasChanges {
			  try?	self.viewContext.save()
			}
		}
	
	}//Toggle
}

```






