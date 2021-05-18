//
//  TodoList.swift
//  Todolist
//
//  Created by Dylan Park on 2021-05-17.
//

import Foundation

struct TodoList: Codable {
  var subject: String
  var description: String
  var isChecked: Bool = false
  
  static var archiveURL: URL {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let archiveURL = documentsURL.appendingPathComponent("todolist").appendingPathExtension("plist")
    
    return archiveURL
  }
  
  static var sampleTodoItems: [TodoList] {
    return [
      TodoList(subject: "Exercise", description: "Take a walk."),
      TodoList(subject: "Study", description: "Study Design patten."),
      TodoList(subject: "Study", description: "Study IOS."),
      TodoList(subject: "Job", description: "Update a resume"),
      TodoList(subject: "Break time", description: "Watch Youtube"),
    ]
  }
  
  static func saveToFile(todolist: [TodoList]) {
    let encoder = PropertyListEncoder()
    do {
      let encodedEmojis = try encoder.encode(todolist)
      try encodedEmojis.write(to: TodoList.archiveURL)
    } catch {
      print("Error encoding TodoList: \(error.localizedDescription)")
    }
  }
  
  static func loadFromFile() -> [TodoList]? {
    guard let todoData = try? Data(contentsOf: TodoList.archiveURL) else { return nil }
    
    do {
      let decoder = PropertyListDecoder()
      let decodedTodolist = try decoder.decode([TodoList].self, from: todoData)
      
      return decodedTodolist
    } catch {
      print("Error decoding TodoList: \(error)")
      return nil
    }
  }
}
