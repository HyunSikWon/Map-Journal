//
//  MemoListViewController.swift
//  Map Journal
//
//  Created by 원현식 on 2021/04/15.
//

import UIKit
import SnapKit
import Then

protocol MemoListViewPresenter {
  func fetchData()
  func willDeleteCell(_ indexPath: IndexPath)
  
}

// Entity와 별개로 두었을 때 장점은?
struct MemoViewItems {
  let title: String
  let date: String
  let feeling: String
  let weather: String
  let memo: String
}

class MemoListViewController: UIViewController, MemoListView {
 

  fileprivate var items: [MemoViewItems] = []
  // presenter
  var presenter: MemoListViewPresenter!
  
  // MARK: - View
  let tableView = UITableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
    setupAttribute()
    presenter.fetchData()
  }
  
  private func setupLayout() {
    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.left.right.top.bottom.equalTo(view)
    }
  }
  
  private func setupAttribute() {
    view.do {
      $0.backgroundColor = .white
    }
    
    tableView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.register(MemoListCell.self, forCellReuseIdentifier: MemoListCell.reuseIdentifier)
      $0.rowHeight = UITableView.automaticDimension
      $0.estimatedRowHeight = 300
      $0.tableFooterView = UIView()
      $0.allowsSelection = false
    }
  }
  
  
  // Presenter -> View
  func setMemoListViewItems(_ items: [MemoViewItems]) {
    self.items = items
    tableView.reloadData()
  }
  

}

extension MemoListViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListCell.reuseIdentifier) as? MemoListCell else {
      return UITableViewCell()
    }
    
    cell.update(items[indexPath.row])
    
    return cell
  }
}
