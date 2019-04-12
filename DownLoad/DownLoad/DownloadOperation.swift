//
//  DownloadOperation.swift
//  DownLoad
//
//  Created by WangBing on 2019/4/12.
//  Copyright © 2019年 WangBing. All rights reserved.
//

import UIKit

class DownloadOperation: Operation {
    
    //下载任务
    var dataTask: URLSessionDataTask?
    
    var fileUrl:URL?
    
    let complete: (UIImage?) -> Void
    
    init(execute: @escaping (UIImage?) -> Void) {
        
        _isExecuting =  false
        _isFinished  =  false
         complete    =  execute
    }
    
    private var _isExecuting: Bool {
        willSet { willChangeValue(forKey: "isExecuting") }
        didSet { didChangeValue(forKey: "isExecuting") }
    }
    
    private var _isFinished: Bool {
        willSet { willChangeValue(forKey: "isFinished") }
        didSet { didChangeValue(forKey: "isFinished") }
    }
    
    
    
    override var isExecuting: Bool {
        return _isExecuting
    }
    
    override var isFinished: Bool {
        
        return _isFinished
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    
    override func start() {
//        semop.wait()
//        defer {
//            semop.signal()
//        }
//        if isCancelled {
//            wrongHandler?(.cancel)
//            _isFinished = true
//            return
//        }
//        Thread.detachNewThreadSelector(#selector(main), toTarget: self, with: nil)
//        _isExecuting = true
        
        
        
        
        
//        do {
//            if isCancelled {
//                _isFinished = true
//                return
//            }
//            _isExecuting = true
//            DispatchQueue.main.async {
////                self.giftView?.showOperationView(name: self.imageStr ?? "", isfinished: { [weak self](value) in
////                    guard let `self` = self else { return }
////                    self._isFinished = value
////                })
//            }
//        } catch {
//            print(error)
//        }
        
        
        if !isCancelled {
            _isExecuting = true
            _isFinished = false
            startOperation()
        } else {
            _isFinished = true
        }
        
        if let url = fileUrl {
            
            let dataTask = URLSession.shared.dataTask(with: url, completionHandler: {[weak self](data, response, error) in
                if let data = data {
                    let image = UIImage(data: data)
                    self?.endOperationWith(image: image)
                } else {
                    self?.endOperationWith(image: nil)
                }
            })
            
            dataTask.resume()
        } else {
            self.endOperationWith(image: nil)
        }
    }
    
    
    override func cancel() {

        if !isCancelled {
            cancelOperation()
        }
        guard !isFinished else { return }
        super.cancel()
        
        if isExecuting {
            _isExecuting = false
        }
        if !isFinished {
            _isFinished = true
        }
        completeOperation()
    }
    
    
    //    MARK: - 自定义对外的方法
    func startOperation() {
        
        completeOperation()
    }
    
    
    
    func cancelOperation() {
        
        dataTask?.cancel()
    }
    
    func completeOperation() {
        if isExecuting && !isFinished {
            
            _isExecuting = false
            
            _isFinished = true
        }
    }
    func endOperationWith(image: UIImage?) {
        if !isCancelled {
            
            complete(image)
            
            completeOperation()
        }
    }
}
