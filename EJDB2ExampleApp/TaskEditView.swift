import SwiftUI

struct TaskEditView: View {

  @EnvironmentObject var store: AppStore
  let task: Task
  var draftTitle: State<String>

  init(task: Task) {
    self.task = task
    self.draftTitle = .init(initialValue: task.title)
  }


  var body: some View {
    let inset = EdgeInsets(top: -8, leading: -10, bottom: -7, trailing: -10)
    return VStack {
      TextField(
          "Enter New Title...",
          text: draftTitle.projectedValue,
          onEditingChanged: { _ in try! self.updateTask() },
          onCommit: {}
      ).background(
          RoundedRectangle(cornerRadius: 5)
              .fill(Color.clear)
              .border(Color(red: 0.7, green: 0.7, blue: 0.7), width: 1 / UIScreen.main.scale)
              .cornerRadius(5)
              .padding(inset)
      ).padding(EdgeInsets(
          top: 15 - inset.top,
          leading: 20 - inset.leading,
          bottom: 15 - inset.bottom,
          trailing: 20 - inset.trailing
      ))
      Spacer()
    }.navigationBarTitle(Text("Edit Task 📝"))
  }

  private func updateTask() throws {
    try store.updateTitle(task, draftTitle.wrappedValue)
  }
}
