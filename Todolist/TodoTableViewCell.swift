//
//  TodoTableViewCell.swift
//  Todolist
//
//  Created by Dylan Park on 2021-05-17.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
  
  let todoCheckedLabel: UILabel = {
    let lb = UILabel()
    lb.setContentHuggingPriority(.required, for: .horizontal)
    return lb
  }()
  
  let todoSubjectLabel: UILabel = {
    let lb = UILabel()
    lb.font = .boldSystemFont(ofSize: 20)
    return lb
  }()
 
  let todoDescriptionLabel: UILabel =  {
    let lb = UILabel()
    lb.numberOfLines = 0
    return lb
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    let vStackView = VerticalStackView(arrangedSubviews: [
      todoSubjectLabel,
      todoDescriptionLabel
    ], spacing: 0, alignment: .fill,distribution: .fill)
    
    let hStackView = HorizontalStackView(arrangedSubviews: [
      todoCheckedLabel, vStackView
    ], spacing: 16, alignment: .fill, distribution: .fill)
    
    contentView.addSubview(hStackView)
    hStackView.matchParent(padding: .init(top: 8, left: 16, bottom: 8, right: 16))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func update(with todoItem: TodoList) {
    todoSubjectLabel.text = todoItem.subject
    todoDescriptionLabel.text = todoItem.description
    todoCheckedLabel.text = todoItem.isChecked ? "✓" : ""
  }
}
