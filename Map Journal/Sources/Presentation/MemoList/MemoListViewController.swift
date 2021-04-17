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


class MemoListViewController: UIViewController, MemoListView {
 

  fileprivate var viewData: [MemoViewData] = []
 
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
  func setMemoListViewItems(_ viewData: [MemoViewData]) {
    self.viewData = viewData
    tableView.reloadData()
  }
  

}

extension MemoListViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListCell.reuseIdentifier) as? MemoListCell else {
      return UITableViewCell()
    }
    
    cell.update(viewData[indexPath.row])
    
    return cell
  }
}
