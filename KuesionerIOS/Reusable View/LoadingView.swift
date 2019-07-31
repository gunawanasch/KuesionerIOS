//
//  LoadingView.swift
//  KuesionerIOS
//
//  Created by Gunawan Aschari on 30/07/19.
//  Copyright © 2019 None. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    @IBOutlet var rootView: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var lblLoading: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    fileprivate func commonInit() {
        Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)
        addSubview(rootView)
        rootView.frame = self.bounds
        rootView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        indicatorView.startAnimating()
        rootView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }


}
