//
//  KuesionerVC.swift
//  KuesionerIOS
//
//  Created by Gunawan Aschari on 30/07/19.
//  Copyright © 2019 None. All rights reserved.
//

import UIKit
import Alamofire

struct Kuesioner {
    public let idTitle: Int
    public let title: String
    public let idQuestion: Int
    public let question: String
    
    init(idTitle: Int, title: String, idQuestion: Int, question: String) {
        self.idTitle    = idTitle
        self.title      = title
        self.idQuestion = idQuestion
        self.question   = question
    }
}

struct Answer {
    public let idTitle: Int
    public let idQuestion: Int
    public let value: String
    public let selectedPosAnswer: Int
    
    init(idTitle: Int, idQuestion: Int, value: String, selectedPosAnswer: Int) {
        self.idTitle            = idTitle
        self.idQuestion         = idQuestion
        self.value              = value
        self.selectedPosAnswer  = selectedPosAnswer
    }
}

class KuesionerVC: UIViewController {
    @IBOutlet weak var tblvKuesioner: UITableView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    private var api: APIClient = APIClient()
    private var loadingView: LoadingView!
    private var kuesionerArray = [Kuesioner]()
    private var answerArray = [Answer]()
    public var email: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigation()
        getKuesioner()
    }
    
    private func setupView() {
        tblvKuesioner.delegate = self
        tblvKuesioner.dataSource = self
        tblvKuesioner.rowHeight = UITableView.automaticDimension
        tblvKuesioner.estimatedRowHeight = 190
        btnSubmit.backgroundColor = UIColor.custom.green_light
        btnSubmit.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btnSubmit.setTitleColor(UIColor.white, for: .normal)
        btnSubmit.setTitle("SUBMIT", for: .normal)
    }
    
    private func setupNavigation() {
        navigationItem.title                                    = "Daftar Pertanyaan"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.backgroundColor     = UIColor.custom.green
        navigationController?.navigationBar.barTintColor        = UIColor.custom.green
        navigationController?.navigationBar.tintColor           = UIColor.white
    }
    
    private func getKuesioner() {
        loadingView = LoadingView(frame: view.bounds)
        view.addSubview(loadingView)
        Alamofire.request(api.baseUrl + "Kuesioner_controller/getKuesioner", method: .get).responseJSON { response in
            if let json = response.result.value {
                let responseArray = json as! [[String:Any]]
                if responseArray.count > 0 {
                    for i in 0 ..< responseArray.count {
                        let data = responseArray[i] as! [String:Any]
                        let idTitle = data["id_title"] as! String
                        let title = data["title"] as! String
                        let idQuestion = data["id_question"] as! String
                        let question = data["question"] as! String
                        self.kuesionerArray.append(Kuesioner(idTitle: Int(idTitle) ?? 0, title: title, idQuestion: Int(idQuestion) ?? 0, question: question))
                        self.answerArray.append(Answer(idTitle: Int(idTitle) ?? 0, idQuestion: Int(idQuestion) ?? 0, value: "", selectedPosAnswer: 0))
                    }
                    DispatchQueue.main.async {
                        self.loadingView.removeFromSuperview()
                        if self.kuesionerArray.count > 0 {
                            self.answerArray.reserveCapacity(self.kuesionerArray.count)
                            self.tblvKuesioner.reloadData()
                        }
                    }
                }
            }
            else {
                let alertController = UIAlertController(title: "", message:"Gagal dalam mendapatkan respon.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func actionSubmit(_ sender: Any) {
        var idTitleArray = [Int]()
        var idQuestionArray = [Int]()
        var valueArray = [String]()
        for i in 0 ..< answerArray.count {
            if answerArray[i].value.isEmpty {
                let alertController = UIAlertController(title: "", message: "Anda belum menjawab semua pertanyaan.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                i == answerArray.count - 1
            }
            else if !answerArray[i].value.isEmpty {
                idTitleArray.append(answerArray[i].idTitle)
                idQuestionArray.append(answerArray[i].idQuestion)
                valueArray.append(answerArray[i].value)
                if i == answerArray.count - 1 {
                    loadingView = LoadingView(frame: view.bounds)
                    view.addSubview(loadingView)
                    let parameters: Parameters = [
                        "idTitle": idTitleArray,
                        "idQuestion": idQuestionArray,
                        "value": valueArray,
                        "email": email
                    ]
                    Alamofire.request(api.baseUrl + "Kuesioner_controller/addAnswer", method: .post, parameters: parameters).responseJSON {
                        response in
                        if let json = response.result.value {
                            let data  = json as! [String:Any]
                            let status = data["status"] as! Int
                            self.loadingView?.removeFromSuperview()
                            let alertController = UIAlertController(title: "", message: (data["message"] as! String), preferredStyle: UIAlertController.Style.alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        }
                        else {
                            self.loadingView?.removeFromSuperview()
                            let alertController = UIAlertController(title: "", message:"Gagal dalam mendapatkan respon.", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                            print("response failed = ", response)
                        }
                    }
                }
            }
        }
    }
    
}

extension KuesionerVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kuesionerArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KuesionerTVCell", for: indexPath) as! KuesionerTVCell
        if self.kuesionerArray.count > 0 {
            if indexPath.row == 0 {
                cell.vTitle.isHidden = false
                cell.lblTitle.text = kuesionerArray[indexPath.row].title
            }
            else {
                if kuesionerArray[indexPath.row].idTitle == kuesionerArray[indexPath.row-1].idTitle {
                    cell.vTitle.isHidden = true
                }
                else {
                    cell.vTitle.isHidden = false
                    cell.lblTitle.text = kuesionerArray[indexPath.row].title
                }
            }
            cell.lblQuestion.text = kuesionerArray[indexPath.row].question
            
            if answerArray.count > 0 && answerArray.count == kuesionerArray.count {
                if answerArray[indexPath.row].selectedPosAnswer == 1 {
                    cell.ivSering.image          = UIImage(named: "rb_checked")
                    cell.ivJarang.image          = UIImage(named: "rb_unchecked")
                    cell.ivTidakPernah.image     = UIImage(named: "rb_unchecked")
                }
                else if answerArray[indexPath.row].selectedPosAnswer == 2 {
                    cell.ivSering.image          = UIImage(named: "rb_unchecked")
                    cell.ivJarang.image          = UIImage(named: "rb_checked")
                    cell.ivTidakPernah.image     = UIImage(named: "rb_unchecked")
                }
                else if answerArray[indexPath.row].selectedPosAnswer == 3 {
                    cell.ivSering.image          = UIImage(named: "rb_unchecked")
                    cell.ivJarang.image          = UIImage(named: "rb_unchecked")
                    cell.ivTidakPernah.image     = UIImage(named: "rb_checked")
                }
                else {
                    cell.ivSering.image          = UIImage(named: "rb_unchecked")
                    cell.ivJarang.image          = UIImage(named: "rb_unchecked")
                    cell.ivTidakPernah.image     = UIImage(named: "rb_unchecked")
                }
            }
            cell.layoutMargins = UIEdgeInsets.zero
            cell.separatorInset = UIEdgeInsets.zero
            cell.selectedSering = { [weak self] in
                self?.answerArray.remove(at: indexPath.row)
                self?.answerArray.insert(Answer(idTitle: self?.kuesionerArray[indexPath.row].idTitle ?? 0, idQuestion:self?.kuesionerArray[indexPath.row].idQuestion ?? 0, value: "Sering", selectedPosAnswer: 1), at: indexPath.row)
                cell.ivSering.image          = UIImage(named: "rb_checked")
                cell.ivJarang.image          = UIImage(named: "rb_unchecked")
                cell.ivTidakPernah.image     = UIImage(named: "rb_unchecked")
            }
            cell.selectedJarang = { [weak self] in
                self?.answerArray.remove(at: indexPath.row)
                self?.answerArray.insert(Answer(idTitle: self?.kuesionerArray[indexPath.row].idTitle  ?? 0, idQuestion:self?.kuesionerArray[indexPath.row].idQuestion ?? 0, value: "Jarang", selectedPosAnswer: 2), at: indexPath.row)
                cell.ivSering.image          = UIImage(named: "rb_unchecked")
                cell.ivJarang.image          = UIImage(named: "rb_checked")
                cell.ivTidakPernah.image     = UIImage(named: "rb_unchecked")
            }
            cell.selectedTidakPernah = { [weak self] in
                self?.answerArray.remove(at: indexPath.row)
                self?.answerArray.insert(Answer(idTitle: self?.kuesionerArray[indexPath.row].idTitle ?? 0, idQuestion:self?.kuesionerArray[indexPath.row].idQuestion ?? 0, value: "Tidak Pernah", selectedPosAnswer: 3), at: indexPath.row)
                cell.ivSering.image          = UIImage(named: "rb_unchecked")
                cell.ivJarang.image          = UIImage(named: "rb_unchecked")
                cell.ivTidakPernah.image     = UIImage(named: "rb_checked")
            }
        }
        return cell
    }
}


