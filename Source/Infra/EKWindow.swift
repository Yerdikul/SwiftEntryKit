//
//  EKWindow.swift
//  SwiftEntryKit
//
//  Created by Daniel Huri on 4/19/18.
//  Copyright (c) 2018 huri000@gmail.com. All rights reserved.
//

import UIKit

class EKWindow: UIWindow {
    
    var isAbleToReceiveTouches = false
    
    init(with rootVC: UIViewController) {
        if #available(iOS 13.0, *) {
            // Attach the entry window to a scene so it is visible under the UIScene lifecycle.
            // Prefer the foreground-active scene; fall back to any connected window scene
            // (e.g. during cold start / returning from background / after system dialogs),
            // because an unscened window is not displayed in a scene-based app.
            let windowScenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
            if let scene = windowScenes.first(where: { $0.activationState == .foregroundActive }) ?? windowScenes.first {
                super.init(windowScene: scene)
            } else {
                super.init(frame: UIScreen.main.bounds)
            }
        } else {
            super.init(frame: UIScreen.main.bounds)
        }
        backgroundColor = .clear
        rootViewController = rootVC
        accessibilityViewIsModal = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if isAbleToReceiveTouches {
            return super.hitTest(point, with: event)
        }
        
        guard let rootVC = EKWindowProvider.shared.rootVC else {
            return nil
        }
        
        if let view = rootVC.view.hitTest(point, with: event) {
            return view
        }
        
        return nil
    }
}
