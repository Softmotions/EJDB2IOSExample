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

  static func ==(lhs: Task, rhs: Task) -> Bool {
    return lhs.id == rhs.id
  }

  static func create(_ store: AppStore, _ title: String) throws -> Task {
    let task = Task(store: store, id: UUID(), title: title, done: false, ts: UInt64(Date().timeIntervalSince1970 * 1000))
    try store.db.put("tasks", task.toJsonMap())
    return task
  }

  static func fromJBDOC(_ store: AppStore, _ doc: JBDOC) throws -> Task {
    let id = try UUID(uuidString: doc.at("/id")!)
    let tsn: NSNumber = try doc.at("/ts")!
    return try Task(store: store, id: id!, title: doc.at("/title") ?? "", done: doc.at("/done") ?? false, ts: tsn.uint64Value)
  }

  private init(store: AppStore, id: UUID, title: String, done: Bool, ts: UInt64) {
    self.store = store
    self.id = id
    self.title = title
    self.done = done
    self.ts = ts
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  mutating func patch(_ patch: Any) throws {
    try store.db.createQuery("@tasks/[id = :?] | apply :? | count")
            .setString(0, "\(id)")
            .setJson(1, patch)
            .executeCount()
  }

  mutating func toggleDone() throws {
    done.toggle()
    try patch(["done": done])
  }

  mutating func updateTitle(_ title: String) throws {
    self.title = title
    try patch(title)
  }

  func delete() throws {
    try store.delete(self)
  }

  func toJsonMap() -> Any {
    return ["id": "\(id)", "ts": ts, "title": title, "done": done]
  }

  let store: AppStore
  let id: UUID
  let ts: UInt64
  private(set) var title: String
  private(set) var done: Bool
}
