//
//  QuestionViews.swift
//  Huge Fan
//
//  Created by Caleb Mesfien on 3/15/21.
//

import UIKit
import RealmSwift
class AskAQuestionView: UIViewController, UITextViewDelegate{
    let realmObjc = try! Realm()
    var delegate: blackViewProtocol?
    var influencerName: String?{
        didSet{
            influencerLbl.text = "Question for "+influencerName!
            if influencerFid?.isEmpty == false{
                constraintContainer()
            }
        
        }
    }
    var influencerBottom: NSLayoutConstraint?
    var countBottom: NSLayoutConstraint?
    var influencerFid: String?{
        didSet{
            constraintContainer()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(PanGestureFunc)))
        view.backgroundColor = .clear
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)

    }
    @objc func handleKeyboardNotification(notification: NSNotification){
        if let userInfo = notification.userInfo{
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                UIView.animate(withDuration: 1) {
                    self.countBottom?.constant = -keyboardFrame!.height-8
                    self.influencerBottom?.constant = -keyboardFrame!.height-8
                    self.view.layoutIfNeeded()
                }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    var viewTranslation = CGPoint(x: 0, y: 0)
    @objc func PanGestureFunc(sender: UIPanGestureRecognizer){
        if sender.translation(in: view).y >= 0{
            switch sender.state {
            case .changed:
                viewTranslation = sender.translation(in: view)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
                    self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                } completion: { (_) in

                }
            case .ended:
                if viewTranslation.y < 200{
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
                        self.view.transform = .identity
                    } completion: { (_) in
                    }
                    
                    if viewTranslation.y >= sender.translation(in: view).y{
                        break
                    }

                }else {
                    delegate?.changeBlackView()
                    dismiss(animated: true, completion: nil)
                }
            default:
                break
            }
        }
    }

    fileprivate let viewBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 6
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    fileprivate let countabel: CustomLabel = {
       let label = CustomLabel()
        label.attributedText = NSAttributedString(string: "0/180", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold)])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
     lazy var influencerLbl: CustomLabel = {
       let label = CustomLabel()
        label.attributedText = NSAttributedString(string: "Question for 00000000000", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white , NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold)])
        label.backgroundColor = UIColor(red: 255/255, green: 90/255, blue: 95/255, alpha: 1)
        label.layer.cornerRadius = 6
        label.textAlignment = .center
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var questionImage: CustomUserImage = {
        let imageView = CustomUserImage()
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = (view.frame.height*0.05)/2
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.white.cgColor
        if let img = realmObjc.objects(userObject.self)[0].image{
            imageView.image = UIImage(data: img as Data)
        }else{
            imageView.image = UIImage(named: "placeholderProfileImage")
        }
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()
    lazy var username: UILabel = {
       let lbl = UILabel()
        lbl.text = realmObjc.objects(userObject.self)[0].username
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        lbl.textColor = .white
        lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let date: UILabel = {
       let lbl = UILabel()
        let date = Date()
        let df = DateFormatter()

        df.dateFormat = "h:mm a"
        let dateString = df.string(from: date)
        lbl.text = dateString
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.textColor = .darkGray
        lbl.backgroundColor = .white
        lbl.clipsToBounds = true
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 8
        lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()


    let continueBtn: UIButton = {
       let btn = UIButton()
        btn.backgroundColor = .darkGray
        btn.isEnabled = false
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: #selector(continueBtnSelected), for: .touchUpInside)
        btn.setAttributedTitle(NSAttributedString(string: "Send", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()


    fileprivate lazy var textView: UITextView = {
        let textView = UITextView()
//        label.numberOfLines = 0
//        label.adjustsFontSizeToFitWidth = true
        textView.textAlignment = .center
        textView.keyboardAppearance = .light
        textView.delegate = self
        textView.textColor = UIColor.white
        textView.backgroundColor = .clear
        textView.tintColor = .white
        textView.returnKeyType = .send
        textView.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()


    func constraintContainer(){
        
//        view.addSubview(MainWhiteView)
        view.addSubview(viewBar)
        viewBar.addSubview(countabel)
        view.addSubview(textView)

        view.addSubview(influencerLbl)
        view.addSubview(questionImage)
        view.addSubview(username)
        view.addSubview(date)
        view.addSubview(continueBtn)
        countBottom = viewBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        influencerBottom = influencerLbl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        NSLayoutConstraint.activate([

            questionImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            questionImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            questionImage.bottomAnchor.constraint(equalTo: date.bottomAnchor, constant: 4),
            questionImage.widthAnchor.constraint(equalTo: questionImage.heightAnchor),
            
            username.leadingAnchor.constraint(equalTo: questionImage.trailingAnchor, constant: 8),
            username.topAnchor.constraint(equalTo: questionImage.topAnchor),
            username.trailingAnchor.constraint(equalTo: continueBtn.leadingAnchor, constant: -12),
            username.heightAnchor.constraint(equalToConstant: username.intrinsicContentSize.height),
            
            date.leadingAnchor.constraint(equalTo: questionImage.trailingAnchor, constant: 8),
            date.topAnchor.constraint(equalTo: username.bottomAnchor),
            date.widthAnchor.constraint(equalToConstant: date.intrinsicContentSize.width + 16),
            date.heightAnchor.constraint(equalToConstant: date.intrinsicContentSize.height + 12),

            influencerLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            influencerLbl.widthAnchor.constraint(equalToConstant: influencerLbl.intrinsicContentSize.width + 16),
            influencerLbl.heightAnchor.constraint(equalToConstant: 28),
            influencerBottom!,
            
            countBottom!,
            viewBar.widthAnchor.constraint(equalToConstant: 70),
            viewBar.heightAnchor.constraint(equalToConstant: 28),
            viewBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),

            continueBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14),
            continueBtn.widthAnchor.constraint(equalToConstant: continueBtn.intrinsicContentSize.width+18),
            continueBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            continueBtn.heightAnchor.constraint(equalToConstant: 38),

            countabel.centerXAnchor.constraint(equalTo: viewBar.centerXAnchor),
            countabel.centerYAnchor.constraint(equalTo: viewBar.centerYAnchor),

            textView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textView.topAnchor.constraint(equalTo: questionImage.bottomAnchor, constant: 12),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            textView.heightAnchor.constraint(equalToConstant: textView.intrinsicContentSize.height)
        ])
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)

        if(text == "\n") && textView.text.count >= 5 {
            continueBtnSelected()
            return false
            }
        let numberOfChars = newText.count
        if numberOfChars > 180{
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count >= 5{
            continueBtn.isEnabled = true
            continueBtn.backgroundColor = .systemBlue
        }else{
            continueBtn.isEnabled = false
            continueBtn.backgroundColor = .darkGray
        }
        countabel.text = "\(textView.text.count)/180"
    }
    
    
    @objc func continueBtnSelected(){
        try! realmObjc.write{
            let objc = usedQuestions()
            objc.id = influencerFid!
            realmObjc.add(objc)
        }
        
        let hasImage = (realmObjc.objects(userObject.self)[0].image != nil)
//            return}
        
        db.collection("user").document("I").collection("users").document(influencerFid!).collection("unanswered").addDocument(data: ["id" : realmObjc.objects(userObject.self)[0].FID,"username":realmObjc.objects(userObject.self)[0].username, "question":textView.text!, "date": date.text!, "points":realmObjc.objects(userObject.self)[0].points, "hasImage":hasImage, "likes":0])
        dismiss(animated: true) {
            print(self.realmObjc.objects(usedQuestions.self).count)
            self.delegate?.changeBlackView()
        }

    }
    
}














class AnswerQuestionView: UIViewController, UITextViewDelegate{
    let realmObjc = try! Realm()
    var delegate: blackViewProtocol?
    
    var question: String?
    var transmitterUsername: String?
    var transmitterId: String?
    var points: Int?
    var hasImage: Bool?
    
    var influencerBottom: NSLayoutConstraint?
    var countBottom: NSLayoutConstraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(PanGestureFunc)))
        view.backgroundColor = .clear
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)

        constraintContainer()
    }
    @objc func handleKeyboardNotification(notification: NSNotification){
        if let userInfo = notification.userInfo{
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                UIView.animate(withDuration: 1) {
                    self.countBottom?.constant = -keyboardFrame!.height-8
                    self.influencerBottom?.constant = -keyboardFrame!.height-8
                    self.view.layoutIfNeeded()
                }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    var viewTranslation = CGPoint(x: 0, y: 0)
    @objc func PanGestureFunc(sender: UIPanGestureRecognizer){
        if sender.translation(in: view).y >= 0{
            switch sender.state {
            case .changed:
                viewTranslation = sender.translation(in: view)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
                    self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                } completion: { (_) in

                }
            case .ended:
                if viewTranslation.y < 200{
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
                        self.view.transform = .identity
                    } completion: { (_) in
                    }
                    
                    if viewTranslation.y >= sender.translation(in: view).y{
                        print("HEHE")
                        break
                    }

                }else {
                    delegate?.changeBlackView()
                    dismiss(animated: true, completion: nil)
                }
            default:
                break
            }
        }
    }

    fileprivate let viewBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 6
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    fileprivate let countabel: CustomLabel = {
       let label = CustomLabel()
        label.attributedText = NSAttributedString(string: "0/180", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold)])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var influencerLbl: CustomLabel = {
       let label = CustomLabel()
//        label.attributedText = NSAttributedString(string: "Question for", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white , NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .bold)])
        let attributedText = NSMutableAttributedString(string: "Question:\n", attributes:[NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedText.append(NSAttributedString(string: "\t"+question!, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.white]))
        label.attributedText = attributedText
//        label.backgroundColor = UIColor(red: 255/255, green: 90/255, blue: 95/255, alpha: 1)
        label.layer.cornerRadius = 6
        label.textAlignment = .center
        label.numberOfLines = 0
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var questionImage: CustomUserImage = {
        let imageView = CustomUserImage()
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = (view.frame.height*0.05)/2
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.white.cgColor
        if let img = realmObjc.objects(userObject.self)[0].image{
            imageView.image = UIImage(data: img as Data)
        }else{
            imageView.image = UIImage(named: "placeholderProfileImage")
        }
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()
    lazy var username: UILabel = {
       let lbl = UILabel()
        lbl.text = realmObjc.objects(userObject.self)[0].username
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        lbl.textColor = .white
        lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let date: UILabel = {
       let lbl = UILabel()
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "MMM d, yyyy, h:mm a"
        let dateString = df.string(from: date)
        lbl.text = dateString
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.textColor = .darkGray
        lbl.backgroundColor = .white
        lbl.clipsToBounds = true
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 8
        lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()


    let continueBtn: UIButton = {
       let btn = UIButton()
        btn.backgroundColor = .darkGray
        btn.isEnabled = false
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: #selector(continueBtnSelected), for: .touchUpInside)
        btn.setAttributedTitle(NSAttributedString(string: "Send", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()


    fileprivate lazy var textView: UITextView = {
        let textView = UITextView()
//        label.numberOfLines = 0
//        label.adjustsFontSizeToFitWidth = true
        textView.textAlignment = .center
        textView.keyboardAppearance = .light
        textView.delegate = self
        textView.textColor = UIColor.white
        textView.backgroundColor = .clear
        textView.tintColor = .white
        textView.returnKeyType = .send
        textView.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()


    func constraintContainer(){
        
//        view.addSubview(MainWhiteView)
        view.addSubview(viewBar)
        viewBar.addSubview(countabel)
        view.addSubview(textView)

        view.addSubview(influencerLbl)
        view.addSubview(questionImage)
        view.addSubview(username)
        view.addSubview(date)
        view.addSubview(continueBtn)
        countBottom = viewBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        influencerBottom = influencerLbl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        NSLayoutConstraint.activate([

            questionImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            questionImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            questionImage.bottomAnchor.constraint(equalTo: date.bottomAnchor, constant: 4),
            questionImage.widthAnchor.constraint(equalTo: questionImage.heightAnchor),
            
            username.leadingAnchor.constraint(equalTo: questionImage.trailingAnchor, constant: 8),
            username.topAnchor.constraint(equalTo: questionImage.topAnchor),
            username.trailingAnchor.constraint(equalTo: continueBtn.leadingAnchor, constant: -12),
            username.heightAnchor.constraint(equalToConstant: username.intrinsicContentSize.height),
            
            date.leadingAnchor.constraint(equalTo: questionImage.trailingAnchor, constant: 8),
            date.topAnchor.constraint(equalTo: username.bottomAnchor),
            date.widthAnchor.constraint(equalToConstant: date.intrinsicContentSize.width + 16),
            date.heightAnchor.constraint(equalToConstant: date.intrinsicContentSize.height + 12),

            influencerLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            influencerLbl.leadingAnchor.constraint(equalTo: viewBar.trailingAnchor, constant: 12),
            influencerBottom!,
            
            countBottom!,
            viewBar.widthAnchor.constraint(equalToConstant: 70),
            viewBar.heightAnchor.constraint(equalToConstant: 28),
            viewBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),

            continueBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14),
            continueBtn.widthAnchor.constraint(equalToConstant: continueBtn.intrinsicContentSize.width+18),
            continueBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            continueBtn.heightAnchor.constraint(equalToConstant: 38),

            countabel.centerXAnchor.constraint(equalTo: viewBar.centerXAnchor),
            countabel.centerYAnchor.constraint(equalTo: viewBar.centerYAnchor),

            textView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textView.topAnchor.constraint(equalTo: questionImage.bottomAnchor, constant: 12),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            textView.heightAnchor.constraint(equalToConstant: textView.intrinsicContentSize.height)
        ])
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)

        if (text == "\n") && textView.text.count >= 5{
            continueBtnSelected()
            return false
            }
        let numberOfChars = newText.count
        if numberOfChars > 180{
            return false
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count >= 5{
            continueBtn.isEnabled = true
            continueBtn.backgroundColor = .systemBlue
        }else{
            continueBtn.isEnabled = false
            continueBtn.backgroundColor = .darkGray
        }
        
        countabel.text = "\(textView.text.count)/180"
    }
    
    
    @objc func continueBtnSelected(){
//        db.collection("user").document("U").collection("users").document(transmitterId!).getDocument { (snapshot, error) in
//            let points = snapshot?.data()[
//        }
        let addToPoint = points!+1
        db.collection("user").document("U").collection("users").document(transmitterId!).updateData(["points" : addToPoint])
        
        db.collection("user").document("I").collection("users").document(realmObjc.objects(userObject.self)[0].FID).collection("answered").addDocument(data: ["date" : date.text!, "question":question!, "username":transmitterUsername!, "hasImage": hasImage!, "answer":textView.text!, "points":addToPoint, "id":transmitterId!])
        
        db.collection("user").document("I").collection("users").document(realmObjc.objects(userObject.self)[0].FID).updateData(["answerCount": realmObjc.objects(userObject.self)[0].points+1])
        
        db.collection("user").document("I").collection("users").document(realmObjc.objects(userObject.self)[0].FID).collection("unanswered").whereField("id", isEqualTo: transmitterId!).getDocuments { (snapshots, error) in
            snapshots?.documents.forEach({ (snap) in
                db.collection("user").document("I").collection("users").document(self.realmObjc.objects(userObject.self)[0].FID).collection("unanswered").document(snap.documentID).delete()
            })
        }
        
        try! realmObjc.write{
            realmObjc.objects(userObject.self)[0].points = realmObjc.objects(userObject.self)[0].points+1
            
            
            
            let item = answeredQuestions()
            item.answer = textView.text!
            item.question = question!
            item.date = date.text!
            item.username = transmitterUsername!
            if hasImage!{
                storage.reference().child(self.transmitterId! + "img.png").getData(maxSize: 1*1024*1024) { (data, error) in
                    if error == nil {
                        item.userImage = data as NSData?
                    }
                }
            }
            item.points = addToPoint
            realmObjc.add(item)
        }
        dismiss(animated: true) {
            self.delegate?.changeBlackView()
        }
    }
    
}

