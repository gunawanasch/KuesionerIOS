//
//  ViewController.swift
//  KuesionerIOS
//
//  Created by Gunawan Aschari on 28/07/19.
//  Copyright © 2019 None. All rights reserved.
//

import UIKit
import Alamofire

class FormVC: UIViewController {
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var btnLanjutkan: UIButton!
    
    private var api: APIClient = APIClient()
    private var loadingView: LoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigation()
    }
    
    private func setupView() {
        lblTitle.font       = UIFont.systemFont(ofSize: 16)
        lblTitle.textColor  = UIColor.black
        lblTitle.text       = "Lengkapi data Anda terlebih dahulu"
        lblName.font        = UIFont.systemFont(ofSize: 14)
        lblName.textColor   = UIColor.black
        lblName.text        = "Nama"
        lblEmail.font       = UIFont.systemFont(ofSize: 14)
        lblEmail.textColor  = UIColor.black
        lblEmail.text       = "Email"
    
        tfEmail.keyboardType = .emailAddress
    
        btnLanjutkan.backgroundColor = UIColor.custom.green_light
        btnLanjutkan.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btnLanjutkan.setTitleColor(UIColor.white, for: .normal)
        btnLanjutkan.setTitle("LANJUTKAN", for: .normal)
    }
    
    private func setupNavigation() {
        navigationItem.title                                    = "Kuesioner"
        navigationItem.backBarButtonItem                        = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.backgroundColor     = UIColor.custom.green
        navigationController?.navigationBar.barTintColor        = UIColor.custom.green
        navigationController?.navigationBar.tintColor           = UIColor.white
    }

    @IBAction func actionLanjutkan(_ sender: Any) {
        let name: String    = tfName.text!
        let email: String   = tfEmail.text!
        if name.isEmpty || email.isEmpty {
            let alertController = UIAlertController(title: "", message: "Harap lengkapi data Anda.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            loadingView = LoadingView(frame: view.bounds)
            view.addSubview(loadingView)
            let parameters: Parameters = [
                "name": name,
                "email": email
            ]
            Alamofire.request(api.baseUrl + "Kuesioner_controller/addUser", method: .post, parameters: parameters).responseJSON {
                response in
                if let json = response.result.value {
                    let data  = json as! [String:Any]
                    let status = data["status"] as! Int
                    if status == 1 {
                        self.loadingView?.removeFromSuperview()
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let kuesionerVC = storyBoard.instantiateViewController(withIdentifier: "KuesionerVC") as! KuesionerVC
                        kuesionerVC.email = email
                        self.navigationController?.pushViewController(kuesionerVC, animated: true)
                    }
                    else {
                        self.loadingView?.removeFromSuperview()
                        let alertController = UIAlertController(title: "", message: (data["message"] as! String), preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                else {
                    self.loadingView?.removeFromSuperview()
                    let alertController = UIAlertController(title: "", message:"Gagal dalam mendapatkan respon.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
}

