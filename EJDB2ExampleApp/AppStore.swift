//
//  AppStore.swift
//  EJDB2ExampleApp
//
//  Created by Anton Adamansky on 05.01.2020.
//  Copyright © 2020 Softmotions. All rights reserved.
//

import Foundation
import Combine
import EJDB2

final class AppStore: ObservableObject {

  init() throws {
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    print(documentsPath)
    db = try EJDB2Builder("\(documentsPath)/todolist.db").open()
    try db.ensureStringIndex("tasks", "/id", unique: true)
    try db.ensureIntIndex("tasks", "/ts")
    try loadAll()
  }

  deinit {
    try? db.close()
  }

  var db: EJDB2DB;

  @Published var tasks: [Task] = []

  func loadAll() throws {
    tasks = try db.createQuery("@tasks/* | desc /ts").list().map {
      print("Loaded: \($0)")
      return try Task.fromJBDOC(self, $0)
    }
  }

  func create(title: String) throws {
    let task = try Task.create(self, title)
    tasks.insert(task, at: 0)
  }

  func delete(_ task: Task) throws {
    try db.createQuery("@tasks/[id = :?] | count")
          .setString(0, "\(task.id)")
          .executeCount()
    tasks.removeAll(where: {
      $0.id == task.id
    })
  }

  func patch(_ task: Task, _ patch: Any) throws {
    try db.createQuery("@tasks/[id = :?] | apply :? | count")
          .setString(0, "\(task.id)")
          .setJson(1, patch)
          .executeCount()
  }

  func toggleDone(_ task: Task) throws {
    try patch(task, ["done": !task.done])
    guard let idx = tasks.firstIndex(where: { $0.id == task.id }) else {
      return
    }
    tasks[idx].done.toggle()
  }

  func updateTitle(_ task: Task, _ title: String) throws {
    try patch(task, ["title": title])
    guard let idx = tasks.firstIndex(where: { $0.id == task.id }) else {
      return
    }
    tasks[idx].title = title
  }
}
