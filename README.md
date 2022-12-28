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
- Esse decorator e util para notificar um antecessor que o scuessor vai alterar suas propreidades
- Abaixo usando o toggle quando o sucessor modificar a propriedade notificara nossa interface
- Quando a task for salva na screen AddNewTaskView vou alterar a proreidade na tela ContentView
- Reapare qeu a screen AddNewTaskView e dinamica quando o state showButtonAddTask for verdadeiro ira mostrar a screen
- Assim que a task for salava na screen AddNewTask farei atravez do bind alterar a proreidade do showButtonAddTask assim fechando novametne a screen que etava abert

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




