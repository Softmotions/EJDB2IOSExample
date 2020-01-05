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
    db = try EJDB2Builder("todolist.db").open()
    try db.ensureStringIndex("tasks", "/id")
    try db.ensureIntIndex("tasks", "/ts")
    try loadAll()
  }
  
  deinit {
    try? db.close()
  }
  
  var db: EJDB2DB;
  
  @Published private(set) var tasks: [Task] = []
  
  func loadAll() throws {
    tasks = try db.createQuery("@tasks/* | desc /ts").list().map {
      try Task.fromJBDOC(self, $0)
    }
  }
  
  func delete(_ task: Task) throws {
    tasks.removeAll(where: {
      return $0.id == task.id
    })
    try db.createQuery("@tasks/[id = :?] | count")
      .setString(0, "\(task.id)")
      .executeScalarInt()
  }
}
