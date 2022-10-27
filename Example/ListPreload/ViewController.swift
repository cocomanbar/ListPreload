//
//  ViewController.swift
//  ListPreload
//
//  Created by cocomanbar on 10/26/2022.
//  Copyright (c) 2022 cocomanbar. All rights reserved.
//

import UIKit
import MJRefresh
import ListPreload

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "Test ListPreload"
        
        tableView.mj_header?.beginRefreshing()
        
        // 方式1
        tableView.startPreload(index: 5)
        
        // 方式2
//        tableView.startPreload(index: 5) { [weak self] in
//            guard let self = self else { return }
//            print("触发了一次预加载..")
//            self.tableView.mj_footer?.beginRefreshing()
//        }
    }
    
    
    let prepage = 20
    
    func refreshHead() {
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.rowHeights.removeAll()
            let rows = self.fetchRowHeight(prepage: self.prepage)
            self.rowHeights.append(contentsOf: rows)
            self.tableView.reloadData()
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.endRefreshing()
        }
    }
    
    let totol = 5
    let totol_all = 7
    var totol_now = 1
    
    func refreshFoot() {
        
        totol_now += 1
        
        // 模拟一次网络错误
        if totol_now == totol {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.tableView.reloadData()
                self.tableView.mj_footer?.endRefreshing()
                self.tableView.listPreload?.endRefreshing()
            }
            return
        }
        
        // 模拟一次加载完毕
        if totol_all <= totol_now {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.tableView.reloadData()
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                self.tableView.listPreload?.endRefreshing()
            }
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let rows = self.fetchRowHeight(prepage: self.prepage)
            self.rowHeights.append(contentsOf: rows)
            self.tableView.reloadData()
            self.tableView.mj_footer?.endRefreshing()
            self.tableView.listPreload?.endRefreshing()
        }
    }
    
    deinit {
        print("销毁了预加载测试控制器..")
    }
    
    // MARK: - LazyLoad
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.refreshHead()
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.refreshFoot()
        })
        view.addSubview(tableView)
        return tableView
    }()
    
    lazy var rowHeights: [NSNumber] = [NSNumber]()
}



extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rowHeights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objcCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") ?? UITableViewCell(style: .default, reuseIdentifier: "UITableViewCell")
        let number: NSNumber = self.rowHeights[indexPath.row]
        objcCell.textLabel?.text = String(indexPath.row) + " ---- " + number.stringValue + "pt"
        return objcCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let number: NSNumber = self.rowHeights[indexPath.row]
        return CGFloat((number.floatValue))
    }
    
    func fetchRowHeight(prepage: NSInteger) -> [NSNumber] {
        var rows = [NSNumber]()
        for _ in 0..<prepage {
            let height = arc4random()%100 + 50
            let number = NSNumber(value: height)
            rows.append(number)
            
        }
        return rows
    }
}
