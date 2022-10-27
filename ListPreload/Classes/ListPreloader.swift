//
//  ListPreloader.swift
//  ListPreload
//
//  Created by tanxl on 2022/10/26.
//

import Foundation
import MJRefresh

public enum ListPreloadState: Int {
    case normal     = 0
    case refreshing
}

/// TODO：目前仅 `vertical` 生效
public enum ListPreloadScrollDirection: Int {
    case vertical   = 0
    case horizontal
}

public class ListPreloader: NSObject {
    
    private var index: Int
    private var triBack: ListPreloadTrigger?
    private weak var scrollView: UIScrollView?
    private lazy var state: ListPreloadState = .normal
    private lazy var direction: ListPreloadScrollDirection = .vertical
    
    public init(index atReverse: Int, triBack: ListPreloadTrigger?) {
        self.index = atReverse
        self.triBack = triBack
        
        if atReverse <= 0 {
            self.index = 5
            assertionFailure("ListPreload atReverse index error")
        }
    }
    
    public func startPreload(at aScrollView: UIScrollView) {
        if aScrollView == scrollView {
            return
        }
        removeObservers()
        scrollView = aScrollView
        aScrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
    }
    
    public func endRefreshing() {
        state = .normal
    }
    
    public func removeObservers() {
        scrollView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            scrollViewContentOffsetDidChange(change)
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func scrollViewContentOffsetDidChange(_ change: [NSKeyValueChangeKey: Any]?) {
    
        if state == .refreshing {
            return
        }
        if let mj_footer = scrollView?.mj_footer {
            if mj_footer.state == .noMoreData || mj_footer.state == .refreshing {
                return
            }
        }
        
        var indexPath: IndexPath?
        if self.scrollView is UITableView {
            let tableView: UITableView = self.scrollView as! UITableView
            indexPath = tableView.indexPathsForVisibleRows?.last
        } else if self.scrollView is UICollectionView {
            let collectionView: UICollectionView = self.scrollView as! UICollectionView
            indexPath = collectionView.indexPathsForVisibleItems.last
        }
        if let indexPath = indexPath {
            let needRefresh: Bool = computeValidIndexPath(scrollView: scrollView, indexPath: indexPath)
            if needRefresh {
                executeCallBlock()
            }
        }
    }
    
    func computeValidIndexPath(scrollView: UIScrollView?, indexPath: IndexPath) -> Bool {
        var totalCount: NSInteger = 0
        var currentCount: NSInteger = 0
        let currentSection: NSInteger = indexPath.section
        if scrollView is UITableView {
            let tableView: UITableView = scrollView as! UITableView
            let section = tableView.numberOfSections
            for i in 0..<section {
                if i == currentSection {
                    currentCount += totalCount
                    currentCount += indexPath.row
                }
                totalCount += tableView.numberOfRows(inSection: i)
            }
        } else if scrollView is UICollectionView {
            let collectionView: UICollectionView = scrollView as! UICollectionView
            let section = collectionView.numberOfSections
            for i in 0..<section {
                if i == currentSection {
                    currentCount += totalCount
                    currentCount += indexPath.row
                }
                totalCount += collectionView.numberOfItems(inSection: i)
            }
        }
        if (totalCount - currentCount) <= self.index {
            return true
        }
        return false
    }
    
    func executeCallBlock() {
        
        state = .refreshing
        
        if let triBack = triBack {
            triBack()
        } else {
            if let mj_footer: MJRefreshFooter = self.scrollView?.mj_footer {
                mj_footer.beginRefreshing()
            } else {
                assertionFailure("ListPreload execute callBlock error")
            }
        }
    }
    
    deinit {
        
        removeObservers()
    }
}
