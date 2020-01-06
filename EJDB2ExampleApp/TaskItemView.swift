//
// Created by Anton Adamansky on 06.01.2020.
// Copyright (c) 2020 Softmotions. All rights reserved.
//

import SwiftUI

struct TaskItemView: View {

  @EnvironmentObject var store: AppStore
  let task: Task
  @Binding var isEditing: Bool

  var body: some View {
    HStack {
      if self.isEditing {
        Image(systemName: "minus.circle")
            .foregroundColor(.red)
            .onTapGesture(count: 1) {
              try! self.delete()
            }
        NavigationLink(destination: TaskEditView(task: task).environmentObject(self.store)) {
          Text(task.title)
        }
      } else {
        Button(action: { try! self.toggleDone() }) {
          Text(self.task.title)
        }
        Spacer()
        if task.done {
          Image(systemName: "hand.thumbsup.fill").foregroundColor(.green)
        }
      }
    }
  }

  private func toggleDone() throws {
    guard  !isEditing else {
      return
    }
    try store.toggleDone(task)
  }

  private func delete() throws {
    try store.delete(task)
    if store.tasks.isEmpty {
      isEditing = false
    }
  }
}
