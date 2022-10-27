//
//  ListPreloadable.swift
//  ListPreload
//
//  Created by tanxl on 2022/10/26.
//

import Foundation

public typealias ListPreloadTrigger = (()->())

@objc public protocol ListPreloadable: NSObjectProtocol {
    
    /// 初始化预加载，触发预加载通过 mj_footer?.beginRefreshing() 内部主动触发
    @objc func startPreload(index atReverse: Int)
    
    /// 初始化预加载，触发预加载通过 triBack?() 触发回调
    @objc func startPreload(index atReverse: Int, triBack: ListPreloadTrigger?)
}

extension UITableView: ListPreloadable {
    
    public func startPreload(index atReverse: Int) {
        startPreload(index: atReverse, triBack: nil)
    }
    
    public func startPreload(index atReverse: Int, triBack: ListPreloadTrigger?) {
        
        if let _ = listPreload {
            return
        }
        listPreload = ListPreloader(index: atReverse, triBack: triBack)
        listPreload?.startPreload(at: self)
    }
}

extension UICollectionView: ListPreloadable {
    
    public func startPreload(index atReverse: Int) {
        startPreload(index: atReverse, triBack: nil)
    }
    
    public func startPreload(index atReverse: Int, triBack: ListPreloadTrigger?) {
        
        if let _ = listPreload {
            return
        }
        listPreload = ListPreloader(index: atReverse, triBack: triBack)
        listPreload?.startPreload(at: self)
    }
}

private var kListPreloadKey = "kListPreloadKey"

extension UIScrollView {
    
    public var listPreload: ListPreloader? {
        get {
            objc_getAssociatedObject(self, &kListPreloadKey) as? ListPreloader
        }
        set {
            objc_setAssociatedObject(self, &kListPreloadKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
