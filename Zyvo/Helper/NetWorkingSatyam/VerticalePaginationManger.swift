//
//  VerticalePaginationManger.swift
//  Tradesman
//
//  Created by YATIN  KALRA on 07/08/24.
//


import Foundation
import UIKit



protocol VerticalPaginationManagerDelegate: AnyObject {
    func refreshAll(completion: @escaping (Bool) -> Void)
    func loadMore(completion: @escaping (Bool) -> Void)
}

class VerticalPaginationManager: NSObject {
    
    private var isLoading = false
    private var isObservingKeyPath: Bool = false
    private var tableView: UITableView!
    private var topLoader: UIView?
    private var bottomLoader: UIView?
    var refreshViewColor: UIColor = .white
    var loaderColor: UIColor = .white
    
    weak var delegate: VerticalPaginationManagerDelegate?
    
    init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        self.addTableViewOffsetObserver()
    }
    
    deinit {
        self.removeTableViewOffsetObserver()
    }
    
    func initialLoad() {
        self.delegate?.refreshAll(completion: { _ in })
    }
    
}

// MARK: ADD TOP LOADER
extension VerticalPaginationManager {
    
    private func addTopLoader() {
        let view = UIView()
        view.backgroundColor = self.refreshViewColor
        view.frame.origin = CGPoint(x: 0, y: -60)
        view.frame.size = CGSize(width: self.tableView.bounds.width,
                                 height: 60)
        let activity = UIActivityIndicatorView(style: .medium)
        activity.color = self.loaderColor
        activity.frame = view.bounds
        activity.startAnimating()
        view.addSubview(activity)
        self.tableView.contentInset.top = view.frame.height
        self.topLoader = view
        self.tableView.addSubview(view)
    }
    
    func removeTopLoader() {
        self.topLoader?.removeFromSuperview()
        self.topLoader = nil
        self.tableView.contentInset.top = 0
        self.tableView.setContentOffset(.zero, animated: true)
    }
    
}

// MARK: ADD BOTTOM LOADER
extension VerticalPaginationManager {
    
    private func addBottomLoader() {
        let view = UIView()
        view.backgroundColor = self.refreshViewColor
        view.frame.origin = CGPoint(x: 0, y: self.tableView.contentSize.height)
        view.frame.size = CGSize(width: self.tableView.bounds.width,
                                 height: 60)
        let activity = UIActivityIndicatorView(style: .medium)
        activity.color = self.loaderColor
        activity.frame = view.bounds
        activity.startAnimating()
        view.addSubview(activity)
        self.tableView.contentInset.bottom = view.frame.height
        self.bottomLoader = view
        self.tableView.addSubview(view)
    }
    
    func removeBottomLoader() {
        self.bottomLoader?.removeFromSuperview()
        self.bottomLoader = nil
    }
    
}

// MARK: OFFSET OBSERVER
extension VerticalPaginationManager {
    
    private func addTableViewOffsetObserver() {
        if self.isObservingKeyPath { return }
        self.tableView.addObserver(
            self,
            forKeyPath: "contentOffset",
            options: [.new],
            context: nil
        )
        self.isObservingKeyPath = true
    }
    
    private func removeTableViewOffsetObserver() {
        if self.isObservingKeyPath {
            self.tableView.removeObserver(self,
                                          forKeyPath: "contentOffset")
        }
        self.isObservingKeyPath = false
    }
    
    override public func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey : Any]?,
                                      context: UnsafeMutableRawPointer?) {
        guard let object = object as? UITableView,
            let keyPath = keyPath,
            let newValue = change?[.newKey] as? CGPoint,
            object == self.tableView, keyPath == "contentOffset" else { return }
        self.setContentOffset(newValue)
    }
    
    private func setContentOffset(_ offset: CGPoint) {
        let offsetY = offset.y
        if offsetY < -100 && !self.isLoading {
            self.isLoading = true
            self.addTopLoader()
            self.delegate?.refreshAll { success in
                self.isLoading = false
                self.removeTopLoader()
            }
            return
        }
        
        let contentHeight = self.tableView.contentSize.height
        let frameHeight = self.tableView.bounds.size.height
        let diffY = contentHeight - frameHeight
        if contentHeight > frameHeight,
        offsetY > (diffY + 130) && !self.isLoading {
            self.isLoading = true
            self.addBottomLoader()
            self.delegate?.loadMore { success in
                self.isLoading = false
                self.removeBottomLoader()
            }
        }
    }
    
}
