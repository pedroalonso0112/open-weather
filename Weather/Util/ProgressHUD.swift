//
//  ProgressHUD.swift
//  Weather
//
//  Created by Pedro Alonso on 2021/6/7.
//

import JGProgressHUD

class ProgressHUD: NSObject {

    static let instance = ProgressHUD()

    var hud: JGProgressHUD?
    
    func show(parentView: UIView) {
        hud = JGProgressHUD(style: .dark)
        hud?.textLabel.text = "Loading"
        hud?.show(in: parentView)
    }
    
    func dismiss() {
        hud?.dismiss()
        hud = nil
    }

}
