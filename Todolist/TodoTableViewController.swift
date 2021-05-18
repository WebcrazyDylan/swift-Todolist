//
//  TodoTableViewController.swift
//  Todolist
//
//  Created by Dylan Park on 2021-05-17.
//

import UIKit

class TodoTableViewController: UITableViewController, AddEditTodoTVCDelegate {
  private let cellId = "TodoCell"
    private let headers = ["High Priority", "Medium Priority", "Low Priority"]
  
  var todoItems: [TodoList] = [] {
    didSet {
      TodoList.saveToFile(todolist: todoItems)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: cellId)
    title = "Todo Items"
    navigationController?.navigationBar.prefersLargeTitles = true
    
    // edit button
    navigationItem.leftBarButtonItem = editButtonItem
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTodo))
    
    // dynamic row height
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 44.0
    
    if let savedTodo = TodoList.loadFromFile() {
      todoItems = savedTodo
    } else {
      todoItems = TodoList.sampleTodoItems
    }
    // path 
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    print("Document Path: ", documentsPath)
  }

  @objc func addNewTodo() {
    let addEditTVC = AddEditTodoTableViewController(style: .grouped)
    addEditTVC.delegate = self
    let addEditNC = UINavigationController(rootViewController: addEditTVC)
    
    present(addEditNC, animated: true, completion: nil)
  }
  
  func add(_ todo: TodoList) {
    todoItems.append(todo)
    tableView.insertRows(at: [IndexPath(row: todoItems.count - 1, section: 0)], with: .automatic)
  }
  
  func edit(_ todo: TodoList) {
    if let indexPath = tableView.indexPathForSelectedRow {
      todoItems.remove(at: indexPath.row)
      todoItems.insert(todo, at: indexPath.row)
      tableView.reloadRows(at: [indexPath], with: .automatic)
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }
  
  // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
      return 1
    }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todoItems.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let todo = todoItems[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TodoTableViewCell
    
    cell.update(with: todo)
    cell.showsReorderControl = true
    cell.accessoryType = .detailDisclosureButton
//    cell.selectionStyle = UITableViewCell.SelectionStyle.blue
    return cell
  }
  
  override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    // update model
    let removedTodoItem = todoItems.remove(at: sourceIndexPath.row)
    todoItems.insert(removedTodoItem, at: destinationIndexPath.row)
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    todoItems[indexPath.row].isChecked = !todoItems[indexPath.row].isChecked
    tableView.reloadData()
  }

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
            let addEditTVC = AddEditTodoTableViewController(style: .grouped)
            addEditTVC.delegate = self
            addEditTVC.todo = todoItems[indexPath.row]
            let addEditNC = UINavigationController(rootViewController: addEditTVC)

            present(addEditNC, animated: true, completion: nil)
    }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      todoItems.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    } else if editingStyle == .insert {
      // insert + button is tapped
    }
  }
  
  override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
  }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      return headers[section]
    }
}
