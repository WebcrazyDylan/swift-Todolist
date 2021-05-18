//
//  AddEditEmojiTableViewController.swift
//  Todolist
//
//  Created by Dylan Park on 2021-05-17.
//

import UIKit

protocol AddEditTodoTVCDelegate: AnyObject {
  func add(_ todo: TodoList)
  func edit(_ todo: TodoList)
}

class AddEditTodoTableViewController: UITableViewController {
  
  private let headers = ["Subject", "Description"]
  lazy var saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTodoItem))
  
  let subjectCell = AddEditTodoTableViewCell()
  let descriptionCell = AddEditTodoTableViewCell()
  
  weak var delegate: AddEditTodoTVCDelegate?
  var todo: TodoList?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if todo == nil {
      title = "Add Todo Item"
    } else {
      title = "Edit Todo Item"
      subjectCell.textField.text = todo?.subject
      descriptionCell.textField.text = todo?.description
    }
    
    // cancel button
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissViewController))
    // save button
    navigationItem.rightBarButtonItem = saveButton
    
    // textfields add target action
    subjectCell.textField.addTarget(self, action: #selector(textEditingChanged(_:)), for: .editingChanged)
    descriptionCell.textField.addTarget(self, action: #selector(textEditingChanged(_:)), for: .editingChanged)
    
    updateSaveButtonState()
  }
  
  @objc func textEditingChanged(_ sender: UITextField) {
    updateSaveButtonState()
  }
  
  @objc func dismissViewController() {
    dismiss(animated: true)
  }
  
  @objc func saveTodoItem() {
    // 1. create a new Todo Item
    // 2. pass the Emoji back to EmojiTableViewController & append to the emojis array
    // 3. update table view
    let newEmoji = TodoList(subject: subjectCell.textField.text!, description: descriptionCell.textField.text!)
    if todo == nil {
      delegate?.add(newEmoji)
    } else {
      delegate?.edit(newEmoji)
    }
    
    dismiss(animated: true, completion: nil)
  }
  
  private func updateSaveButtonState() {
    let subjectText = subjectCell.textField.text ?? ""
    let descriptionText = descriptionCell.textField.text ?? ""
    saveButton.isEnabled = !subjectText.isEmpty && !descriptionText.isEmpty
//    saveButton.isEnabled = containsSingleTodo(subjectCell.textField) && !descriptionText.isEmpty
  }
  
  private func containsSingleTodo(_ textField: UITextField) -> Bool {
    guard let text = textField.text, text.count == 1 else { return false }
    return text.unicodeScalars.first?.properties.isEmojiPresentation ?? false
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath {
    case [0, 0]:
      return subjectCell
    case [1, 0]:
      return descriptionCell
    default:
      fatalError("Invalid number of cells")
    }
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return headers[section]
  }
  
}
