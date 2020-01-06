//
//  Task.swift
//  EJDB2ExampleApp
//
//  Created by Anton Adamansky on 05.01.2020.
//  Copyright © 2020 Softmotions. All rights reserved.
//

import SwiftUI
import EJDB2

struct Task: Equatable, Hashable, Identifiable {

  static func create(_ store: AppStore, _ title: String) throws -> Task {
    let task = Task(id: UUID(), title: title, done: false, ts: UInt64(Date().timeIntervalSince1970 * 1000))
    try store.db.put("tasks", task.toJsonMap())
    return task
  }

  static func fromJBDOC(_ store: AppStore, _ doc: JBDOC) throws -> Task {
    let id = try UUID(uuidString: doc.at("/id")!)!
    let tsn: NSNumber = try doc.at("/ts")!
    return try Task(id: id, title: doc.at("/title") ?? "", done: doc.at("/done") ?? false, ts: tsn.uint64Value)
  }

  init(id: UUID, title: String, done: Bool, ts: UInt64) {
    self.id = id
    self.title = title
    self.done = done
    self.ts = ts
  }

  func toJsonMap() -> Any {
    return ["id": "\(id)", "ts": ts, "title": title, "done": done]
  }

  let id: UUID
  let ts: UInt64
  var title: String
  var done: Bool
}
