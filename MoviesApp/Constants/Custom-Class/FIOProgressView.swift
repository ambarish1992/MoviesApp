//
//  FIOProgressView.swift
//  MoviesApp
//
//  Created by Ambarish Shivakumar on 15/09/24.
//

import Foundation
import UIKit

open class FIOProgressView {
    
    var containerView = UIView()
    var progressView = UIView()
    var dotsContainerView = UIView()
    
    open class var shared: FIOProgressView {
        struct Static {
            static let instance: FIOProgressView = FIOProgressView()
        }
        return Static.instance
    }
    
    open func showProgressView(_ view: UIView) {
        
        containerView.frame = view.frame
        containerView.center = view.center
        containerView.backgroundColor = UIColor(white: 0xffffff, alpha: 0.3)
        
        progressView.frame = CGRect(x: 0, y: 0, width: 120, height: 40)
        progressView.center = view.center
        progressView.backgroundColor = .clear
        progressView.clipsToBounds = true
        progressView.layer.cornerRadius = 10
        
        dotsContainerView.frame = CGRect(x: 0, y: 0, width: 120, height: 40)
        dotsContainerView.center = CGPoint(x: progressView.bounds.width / 2, y: progressView.bounds.height / 2)
        
        createDots()
        
        progressView.addSubview(dotsContainerView)
        containerView.addSubview(progressView)
        view.addSubview(containerView)
    }
    
    private func createDots() {
        let dotSize: CGFloat = 20
        let spacing: CGFloat = 20
        
        for i in 0..<3 {
            let dot = UIView(frame: CGRect(x: CGFloat(i) * (dotSize + spacing), y: 10, width: dotSize, height: dotSize))
            dot.backgroundColor = UIColor(displayP3Red: 92/255, green: 46/255, blue: 126/255, alpha: 1.0)
            dot.layer.cornerRadius = dotSize / 2
            
            dotsContainerView.addSubview(dot)
            animateDot(dot, delay: TimeInterval(i) * 0.3)
        }
    }
    
    private func animateDot(_ dot: UIView, delay: TimeInterval) {
          UIView.animate(withDuration: 0.5, delay: delay, options: [.autoreverse, .repeat], animations: {
              dot.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
          }, completion: nil)
      }
    
    open func hideProgressView() {
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
        }
    }
}
