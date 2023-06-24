//
//  UITextField+Extension.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/06/22.
//

import UIKit

extension UITextField {
  func addLeftPadding(
    leftPaddingWidth: Int
  ) {
      let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: leftPaddingWidth, height: Int(self.frame.height)))
    self.leftView = paddingView
    self.leftViewMode = ViewMode.always
  }
}
