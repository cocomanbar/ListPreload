# ListPreload

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ListPreload is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ListPreload'
```


```ruby

 若要列表支持预加载，使用请注意：
 
     1.控件要求，使用刷新组件MJRefresh，或改源码支持其他刷新库，这里以MJ为例
        Header控件无要求
        Footer控件请仅用Auto-Footer系列，否则列表会有一定的抖动和偏移现象
        
     2.Footer刷新完成请重置组件的预加载状态
         self.tableView.mj_footer?.endRefreshing()
         self.tableView.listPreload?.endRefreshing()
    
     3.初始化方式
         
         此协议启动预加载，触发预加载方式 通过获取 Footer 控制执行 scrollview?.mj_footer?.beginRefreshing() 
         func startPreload(index atReverse: Int)
            
            eg：tableView.startPreload(index: 5)
            
         此协议启动预加载，触发预加载方式 通过 triBlock 回调业务层
         func startPreload(index atReverse: Int, triBack: ListPreloadTrigger?)
    
```

## Author

cocomanbar, 125322078@qq.com

## License

ListPreload is available under the MIT license. See the LICENSE file for more info.
