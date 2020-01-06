import SwiftUI

struct TaskListView: View {

  @EnvironmentObject var store: AppStore
  @State var draftTitle: String = ""
  @State var isEditing: Bool = false

  var body: some View {
    List {
      TextField("Create a New Task...", text: $draftTitle, onCommit: self.createTask)
      ForEach(store.tasks) { task in
        TaskItemView(task: task, isEditing: self.$isEditing)
      }
    }
        .navigationBarTitle(Text("Tasks 👀"))
        .navigationBarItems(trailing: Button(action: { self.isEditing.toggle() }) {
          if !self.isEditing {
            Text("Edit")
          } else {
            Text("Done").bold()
          }
        })
  }

  private func createTask() {
    try! store.create(title: draftTitle)
    draftTitle = ""
  }
}
