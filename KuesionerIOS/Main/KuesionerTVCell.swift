//
//  KuesionerTVCell.swift
//  KuesionerIOS
//
//  Created by Gunawan Aschari on 30/07/19.
//  Copyright © 2019 None. All rights reserved.
//

import UIKit

class KuesionerTVCell: UITableViewCell {
    @IBOutlet weak var svTitle: UIStackView!
    @IBOutlet weak var vTitle: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vQuestion: UIView!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var vSering: UIView!
    @IBOutlet weak var ivSering: UIImageView!
    @IBOutlet weak var lblSering: UILabel!
    @IBOutlet weak var vJarang: UIView!
    @IBOutlet weak var ivJarang: UIImageView!
    @IBOutlet weak var lblJarang: UILabel!
    @IBOutlet weak var vTidakPernah: UIView!
    @IBOutlet weak var ivTidakPernah: UIImageView!
    @IBOutlet weak var lblTidakPernah: UILabel!
    
    var selectedSering: (() -> Void)?
    var selectedJarang: (() -> Void)?
    var selectedTidakPernah: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.font           = UIFont.boldSystemFont(ofSize: 15)
        lblTitle.textColor      = UIColor.black
        lblQuestion.font        = UIFont.systemFont(ofSize: 14)
        lblQuestion.textColor   = UIColor.black
        
        vSering.isUserInteractionEnabled    = true
        vSering.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedSering(_:))))
        ivSering.image                      = UIImage(named: "rb_unchecked")
        lblSering.font                      = UIFont.systemFont(ofSize: 14)
        lblSering.textColor                 = UIColor.black
        lblSering.text                      = "Sering"
        
        vJarang.isUserInteractionEnabled    = true
        vJarang.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedJarang(_:))))
        ivJarang.image                      = UIImage(named: "rb_unchecked")
        lblJarang.font                      = UIFont.systemFont(ofSize: 14)
        lblJarang.textColor                 = UIColor.black
        lblJarang.text                      = "Jarang"
        
        vTidakPernah.isUserInteractionEnabled   = true
        vTidakPernah.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedTidakPernah(_:))))
        ivTidakPernah.image                     = UIImage(named: "rb_unchecked")
        lblTidakPernah.font                     = UIFont.systemFont(ofSize: 14)
        lblTidakPernah.textColor                = UIColor.black
        lblTidakPernah.text                     = "Tidak Pernah"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc private func tappedSering(_ sender: UITapGestureRecognizer) {
        selectedSering?()
    }
    
    @objc private func tappedJarang(_ sender: UITapGestureRecognizer) {
        selectedJarang?()
    }
    
    @objc private func tappedTidakPernah(_ sender: UITapGestureRecognizer) {
        selectedTidakPernah?()
    }
    
}
