//
//  ExtraViews.swift
//  Huge Fan
//
//  Created by Caleb Mesfien on 3/31/21.
//

import UIKit
import RealmSwift
import StoreKit


class InstagramPostViewController: UIViewController{
    var delegate: blackViewProtocol?
    var questionImageItem: UIImage?
    var answerImageItem: UIImage?
    var question: String?
    var answer: String?
    var fanUsername: String?
    var influencerUsernameItem: String?
    var dateItem: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(PanGestureFunc)))
        view.backgroundColor = .clear
        constraintContainer()
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
    fileprivate let whiteView: CustomView = {
        let view = CustomView()
        view.backgroundColor = UIColor(red: 12/255, green: 195/255, blue: 177/255, alpha: 1)
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let barView: CustomView = {
        let view = CustomView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 3
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let postView: UIView = {
        let view = UIView()
//        view.backgroundColor = UIColor(red: 255/255, green: 253/255, blue: 238/255, alpha: 1)
        view.backgroundColor = .clear
//        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let questionView: UIView = {
        let view = UIView()
        view.backgroundColor = TealConstantColor
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var questionImage: CustomUserImage = {
        let imageView = CustomUserImage()
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 45/2.5
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.image = questionImageItem
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()
    
    lazy var username: UILabel = {
       let lbl = UILabel()
        lbl.text = fanUsername
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textColor = .white
        lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    lazy var date: UILabel = {
       let lbl = UILabel()
        lbl.text = dateItem
        lbl.font = UIFont.boldSystemFont(ofSize: 13)
        lbl.textColor = .white
        lbl.backgroundColor = TealConstantColor
        lbl.clipsToBounds = true
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 8
//        lbl.alpha = 0
        lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    
    lazy var questionLbl: UILabel = {
       let lbl = UILabel()
        lbl.text = question
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 24)
        lbl.textColor = .white
        lbl.numberOfLines = 0
        lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
//    INFLUENCER VIEW
    lazy var answernLbl: UILabel = {
       let lbl = UILabel()
        lbl.text = answer
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 30)
        lbl.textColor = .white
        lbl.numberOfLines = 0
        lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    let answerView: UIView = {
     let view = UIView()
        view.backgroundColor = .systemBlue
//        view.layer.shadowColor = UIColor.lightGray.cgColor
//        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        view.layer.shadowRadius = 6.0
////        view.layer.shadowOpacity = 0.4
        view.layer.cornerRadius = 24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var answerImage: CustomUserImage = {
        let imageView = CustomUserImage()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
////        (view.frame.height*0.07)
        imageView.layer.cornerRadius = 68/2.5
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.image = answerImageItem
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()
    
    lazy var influencerUsername: UILabel = {
       let lbl = UILabel()
        lbl.text = influencerUsernameItem
        lbl.font = UIFont.boldSystemFont(ofSize: 28)
        lbl.textColor = .white
        lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    fileprivate lazy var sendBtn: UIButton = {
       let btn = UIButton()
        btn.backgroundColor = TealConstantColor
        btn.layer.cornerRadius = 8
        btn.setAttributedTitle(NSAttributedString(string: "Post", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold)]), for: .normal)
        btn.addTarget(self, action: #selector(SendBtnSelected), for: .touchUpInside)
//        btn.layer.shadowColor = UIColor.lightGray.cgColor
//        btn.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
//        btn.layer.shadowRadius = 5.0
//        btn.layer.shadowOpacity = 0.4
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let hugeFan: CustomLabel = {
        let lbl = CustomLabel()
        lbl.backgroundColor = TealConstantColor
        lbl.clipsToBounds = true
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 3
        lbl.attributedText = NSAttributedString(string: "Asked on Huge Fan", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold)])
         lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    func constraintContainer(){
        view.addSubview(whiteView)
        whiteView.addSubview(barView)
        
        view.addSubview(postView)
        postView.addSubview(questionView)
        questionView.addSubview(questionLbl)
        postView.addSubview(questionImage)
        postView.addSubview(username)
        
        postView.addSubview(answerView)
        postView.addSubview(answerImage)
        postView.addSubview(influencerUsername)
        postView.addSubview(date)
        answerView.addSubview(answernLbl)
        whiteView.addSubview(sendBtn)
        postView.addSubview(hugeFan)
        NSLayoutConstraint.activate([
            whiteView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            whiteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            whiteView.heightAnchor.constraint(equalToConstant: 600),
            whiteView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            barView.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 8),
            barView.widthAnchor.constraint(equalToConstant: 40),
            barView.heightAnchor.constraint(equalToConstant: 6),
            barView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            postView.topAnchor.constraint(equalTo: barView.bottomAnchor, constant: 8),
            postView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            postView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            postView.bottomAnchor.constraint(equalTo: sendBtn.topAnchor, constant: -12),
            
            questionView.topAnchor.constraint(equalTo: questionImage.bottomAnchor, constant: 4),
            questionView.leadingAnchor.constraint(equalTo: postView.leadingAnchor, constant: view.frame.width*0.15),
            questionView.trailingAnchor.constraint(equalTo: postView.trailingAnchor, constant: -view.frame.width*0.15),
            questionView.heightAnchor.constraint(equalTo: postView.heightAnchor, multiplier: 0.28),
            
            questionImage.topAnchor.constraint(equalTo: postView.topAnchor, constant: 8),
            questionImage.leadingAnchor.constraint(equalTo: questionView.leadingAnchor),
            questionImage.heightAnchor.constraint(equalToConstant: 45),
            questionImage.widthAnchor.constraint(equalTo: questionImage.heightAnchor),
            
            username.leadingAnchor.constraint(equalTo: questionImage.trailingAnchor, constant: 8),
            username.centerYAnchor.constraint(equalTo: questionImage.centerYAnchor),
            username.trailingAnchor.constraint(equalTo: questionView.trailingAnchor),
            username.heightAnchor.constraint(equalToConstant: username.intrinsicContentSize.height),

            questionLbl.topAnchor.constraint(equalTo: questionView.topAnchor, constant: 8),
            questionLbl.leadingAnchor.constraint(equalTo: questionView.leadingAnchor, constant: 16),
            questionLbl.trailingAnchor.constraint(equalTo: questionView.trailingAnchor, constant: -16),
            questionLbl.bottomAnchor.constraint(equalTo: questionView.bottomAnchor, constant: -12),
            
            
            
            
            
            
            answerView.bottomAnchor.constraint(equalTo: hugeFan.topAnchor, constant: -12),
            answerView.leadingAnchor.constraint(equalTo: postView.leadingAnchor, constant: 12),
            answerView.trailingAnchor.constraint(equalTo: postView.trailingAnchor, constant: -12),
            answerView.topAnchor.constraint(equalTo: answerImage.bottomAnchor, constant: 4),

            answerImage.topAnchor.constraint(equalTo: questionView.bottomAnchor, constant: 12),
            answerImage.leadingAnchor.constraint(equalTo: postView.leadingAnchor, constant: 12),
            answerImage.bottomAnchor.constraint(equalTo: date.bottomAnchor, constant: 4),
            answerImage.widthAnchor.constraint(equalTo: answerImage.heightAnchor),
            
//
            date.leadingAnchor.constraint(equalTo: answerImage.trailingAnchor, constant: 8),
            date.topAnchor.constraint(equalTo: influencerUsername.bottomAnchor),
            date.widthAnchor.constraint(equalToConstant: date.intrinsicContentSize.width + 16),
            date.heightAnchor.constraint(equalToConstant: date.intrinsicContentSize.height + 12),
            
            influencerUsername.leadingAnchor.constraint(equalTo: answerImage.trailingAnchor, constant: 8),
            influencerUsername.topAnchor.constraint(equalTo: answerImage.topAnchor),
            influencerUsername.trailingAnchor.constraint(equalTo: answerView.trailingAnchor),
            influencerUsername.heightAnchor.constraint(equalToConstant: influencerUsername.intrinsicContentSize.height),
            

            answernLbl.topAnchor.constraint(equalTo: answerView.topAnchor, constant: 12),
            answernLbl.leadingAnchor.constraint(equalTo: answerView.leadingAnchor, constant: 18),
            answernLbl.trailingAnchor.constraint(equalTo: answerView.trailingAnchor, constant: -18),
            answernLbl.bottomAnchor.constraint(equalTo: answerView.bottomAnchor, constant: -12),
            
            hugeFan.widthAnchor.constraint(equalToConstant: hugeFan.intrinsicContentSize.width+12),
            hugeFan.leadingAnchor.constraint(equalTo: postView.leadingAnchor, constant: 16),
            hugeFan.bottomAnchor.constraint(equalTo: postView.bottomAnchor),
            hugeFan.heightAnchor.constraint(equalToConstant: hugeFan.intrinsicContentSize.height+4),
            
            sendBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            sendBtn.heightAnchor.constraint(equalToConstant: 40),
            sendBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            sendBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),

        ])
    }
    @objc func SendBtnSelected(){
        delegate?.changeBlackView()
        self.dismiss(animated: true)
        
        let renderer = UIGraphicsImageRenderer(size: postView.bounds.size)
        let image = renderer.image { ctx in
            postView.drawHierarchy(in: postView.bounds, afterScreenUpdates: true)
        }
//        let color = .image?.getColors()
        if let storiesUrl = URL(string: "instagram-stories://share"){
            if UIApplication.shared.canOpenURL(storiesUrl) {
                guard let pngImage = image.pngData() else {return}
                let pastboardItems: [String: Any] = [
                    "com.instagram.sharedSticker.stickerImage": pngImage,
                    "com.instagram.sharedSticker.backgroundTopColor":"#0cc3b1",
                    "com.instagram.sharedSticker.backgroundBottomColor": "#05bbe6"
//                    "com.instagram.sharedSticker.backgroundTopColor": "#ffffff",
//                    "com.instagram.sharedSticker.backgroundBottomColor": "#ffffff"

                ]
                let pastboardOptions = [
                    UIPasteboard.OptionsKey.expirationDate: Foundation.Date().advanced(by: 300)
                ]

                UIPasteboard.general.setItems([pastboardItems], options: pastboardOptions)
                UIApplication.shared.open(storiesUrl, options: [:], completionHandler: nil)
            }else{
                print("User doesn't have instagram")
            }
        }    }
}




class BioEditSingleView: UIViewController,  UITextViewDelegate{
    var saveBtn: UIBarButtonItem?
    let realmObjc = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        view.backgroundColor = .white
        saveBtn = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveSelected))
        saveBtn!.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        navigationItem.rightBarButtonItem = saveBtn
        textField.becomeFirstResponder()
        textField.delegate = self
        constraintContainer()
    }
    @objc func saveSelected(){
        db.collection("user").document("I").collection("users").document(realmObjc.objects(userObject.self)[0].FID).updateData(["bio" : textField.text!])
        try! realmObjc.write {
                realmObjc.objects(userObject.self)[0].bio = textField.text!
            
        }

        showSpinner(onView: view.self)
        textField.resignFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.removeSpinner()
            self.navigationController?.popViewController(animated: true)
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    

    fileprivate let textFieldView: CustomView = {
       let view = CustomView()
        view.backgroundColor = .lightGray

       view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()

    fileprivate lazy var textField: UITextView = {
       let field = UITextView()
//        field.clearButtonMode = .whileEditing
        field.textContainer.maximumNumberOfLines = 3
        field.textContainer.lineBreakMode = .byWordWrapping
        field.backgroundColor = .clear
        field.keyboardAppearance = .light
        field.textColor = .black
        field.tintColor = .lightGray
        field.font = UIFont.boldSystemFont(ofSize: 15)
        field.delegate = self
        field.font?.lineHeight
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    fileprivate let reasonForName: CustomLabel = {
        let label = CustomLabel()
        label.attributedText = NSAttributedString(string: "3 Line Limit", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
//        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let countabel: CustomLabel = {
       let label = CustomLabel()
        label.attributedText = NSAttributedString(string: "0/80", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .bold)])
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func constraintContainer(){

        view.addSubview(textFieldView)
        textFieldView.addSubview(textField)
        view.addSubview(reasonForName)
        view.addSubview(countabel)
        NSLayoutConstraint.activate([

            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -8),
            textField.heightAnchor.constraint(equalToConstant:96),
            
            
            textFieldView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4),
            textFieldView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            textFieldView.heightAnchor.constraint(equalToConstant:0.8),
            
            reasonForName.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 8),
            reasonForName.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor),
            reasonForName.trailingAnchor.constraint(equalTo: countabel.leadingAnchor, constant: -32),

            countabel.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor),
            countabel.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 8),
            countabel.widthAnchor.constraint(equalToConstant: 50)

        ])
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        for letter in text{
            for i in "/:;()$&@\",?!'[]{}#%^*+=\\|~<>€£¥•,?!'"{
                if letter == i{
                    return false
                }
            }
        }
        guard let textFieldText = textView.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + text.count
        
        if textField.text!.count >= 5{
            saveBtn!.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue], for: .normal)
            saveBtn?.isEnabled = true
        }else{
            saveBtn!.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
            saveBtn?.isEnabled = false
        }
        countabel.text = "\(textField.text!.count)/80"

        return count <= 80
    }
}


class EditSingleView: UIViewController,  UITextFieldDelegate{
    var saveBtn: UIBarButtonItem?
    let realmObjc = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        view.backgroundColor = .white
        saveBtn = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveSelected))
        saveBtn!.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        navigationItem.rightBarButtonItem = saveBtn
        textField.becomeFirstResponder()
        textField.delegate = self
        constraintContainer()
    }
    @objc func saveSelected(){
                if title == "Username"{
                    if realmObjc.objects(userObject.self)[0].isInfluencer{
                        db.collection("user").document("I").collection("users").document(realmObjc.objects(userObject.self)[0].FID).updateData(["username" : textField.text!])
                    }else{
                        db.collection("user").document("U").collection("users").document(realmObjc.objects(userObject.self)[0].FID).updateData(["username" : textField.text!])
                    }
                }else if title == "TikTok"{
                    db.collection("user").document("I").collection("users").document(realmObjc.objects(userObject.self)[0].FID).updateData(["tiktokHandle" : textField.text!])
                    
                }else if title == "Instagram"{
                    db.collection("user").document("I").collection("users").document(realmObjc.objects(userObject.self)[0].FID).updateData(["instagramHandle" : textField.text!])
                    
                }else{
                    db.collection("user").document("I").collection("users").document(realmObjc.objects(userObject.self)[0].FID).updateData(["bio" : textField.text!])
                }
        try! realmObjc.write {
            if title == "Username"{
                realmObjc.objects(userObject.self)[0].username = textField.text!
            }else if title == "TikTok"{
                realmObjc.objects(userObject.self)[0].tiktokHandle = textField.text!
            }else if title == "Instagram"{
                realmObjc.objects(userObject.self)[0].instagramHandle = textField.text!
            }else{
                realmObjc.objects(userObject.self)[0].bio = textField.text!
            }
        }

        showSpinner(onView: view.self)
        textField.resignFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.removeSpinner()
            self.navigationController?.popViewController(animated: true)
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    
    let usernameText: CustomLabel = {
        let label = CustomLabel()
        label.numberOfLines = 1
        label.text = "Username:"
        label.textColor = .black

        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    fileprivate let textFieldView: CustomView = {
       let view = CustomView()
        view.backgroundColor = .lightGray

       view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()

    fileprivate lazy var textField: UITextField = {
       let field = UITextField()
        field.clearButtonMode = .whileEditing
        field.keyboardAppearance = .light
        field.textColor = .black
        field.tintColor = .lightGray
        field.font = UIFont.boldSystemFont(ofSize: 15)
        field.autocorrectionType = .no
        field.delegate = self
        
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    fileprivate let reasonForName: CustomLabel = {
        let label = CustomLabel()
        label.attributedText = NSAttributedString(string: "", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
//        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let countabel: CustomLabel = {
       let label = CustomLabel()
        label.attributedText = NSAttributedString(string: "0/30", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .bold)])
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func constraintContainer(){

        view.addSubview(usernameText)
        view.addSubview(textFieldView)
        textFieldView.addSubview(textField)
        view.addSubview(reasonForName)
        view.addSubview(countabel)
        NSLayoutConstraint.activate([

            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            textField.leadingAnchor.constraint(equalTo: usernameText.trailingAnchor, constant: 4),
            textField.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -4),
            textField.heightAnchor.constraint(equalToConstant:36),
            
            usernameText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            usernameText.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor),
            usernameText.widthAnchor.constraint(equalToConstant: usernameText.intrinsicContentSize.width),
            usernameText.heightAnchor.constraint(equalToConstant:36),
            
            textFieldView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4),
            textFieldView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            textFieldView.heightAnchor.constraint(equalToConstant:0.8),
            
            reasonForName.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 8),
            reasonForName.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor),
            reasonForName.trailingAnchor.constraint(equalTo: countabel.leadingAnchor, constant: -32),

            countabel.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor),
            countabel.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 8),
            countabel.widthAnchor.constraint(equalToConstant: 50)

        ])
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text!.count >= 5{
            saveBtn!.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue], for: .normal)
            saveBtn?.isEnabled = true
        }else{
            saveBtn!.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
            saveBtn?.isEnabled = false
        }

        countabel.text = "\(textField.text!.count)/80"
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        for letter in string{
            for i in "/:;()$&@\",?!'[]{}#%^*+=\\|~<>€£¥•,?!'"{
                if letter == i{
                    return false
                }
            }
        }
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        if textField.text!.count >= 5{
            saveBtn!.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue], for: .normal)
            saveBtn?.isEnabled = true
        }else{
            saveBtn!.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
            saveBtn?.isEnabled = false
        }
        countabel.text = "\(textField.text!.count)/30"

        return count <= 30
    }
}

class EditProfileView: UIViewController, UITextFieldDelegate{
    var settingsLabelText2 = [String()]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        title = "Edit Profile"
        navigationItem.backButtonTitle = ""
        view.backgroundColor = .white
        constraintContainer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }

    
    
    fileprivate lazy var profileImage: CustomUserImage = {
        let imageView = CustomUserImage()
        if realmObjc.objects(userObject.self)[0].image != nil{
            imageView.image = UIImage(data: realmObjc.objects(userObject.self)[0].image! as Data)
        }else{
            imageView.image = UIImage(named: "placeholderProfileImage")
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = (view.frame.height*0.12)/2
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()
    
    fileprivate let changeProfileImage: UIButton = {
       let btn = UIButton()
        btn.setAttributedTitle(NSAttributedString(string: "Change Profile Image", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.systemBlue]), for: .normal)
        btn.titleLabel?.tintColor = .systemBlue
        btn.titleLabel?.textAlignment = .center
        btn.addTarget(self, action: #selector(ChangeImageSelected), for: .touchUpInside)
        btn.titleLabel!.font = .systemFont(ofSize: 10, weight: .semibold)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    fileprivate lazy var settingsTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(MenuPopUpViewCell.self, forCellReuseIdentifier: "MenuPopUpViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    private func constraintContainer(){
        view.addSubview(profileImage)
        view.addSubview(changeProfileImage)
        view.addSubview(settingsTableView)
        NSLayoutConstraint.activate([
            
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12),
            profileImage.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12),

            changeProfileImage.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
            changeProfileImage.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor),
            
            settingsTableView.topAnchor.constraint(equalTo: changeProfileImage.bottomAnchor, constant: 32),
            settingsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

        ])
    }
    
    
    @objc func ChangeImageSelected(){
        showSpinner(onView: view.self)
        let pickerController = UIImagePickerController()
        pickerController.allowsEditing = true
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true, completion:{
            self.removeSpinner()
        })
    }
    
    
    
    

    let blackWindow = UIView()
    let realmObjc = try! Realm()
    @objc func continueSelected(){
        if realmObjc.objects(userObject.self).isEmpty{
//            SetUpComplete()
        }else{
//            updateProfile()
        }
    }
    
    
    
//    func updateProfile(){
//        if hasImage{
//
//            let storageRef = storage.reference().child(realmObjc.objects(userObject.self)[0].FID + "img.png")
//            if let uploadData = self.profileImage.image!.jpegData(compressionQuality: 0.1){
//                storageRef.putData(uploadData, metadata: nil) { (StorageMetadata, error) in
//                    if error != nil{
//                        return
//                    }
//                }
//            }
//            try! realmObjc.write{
//                realmObjc.objects(userObject.self)[0].username = textField.text!
//                realmObjc.objects(userObject.self)[0].image = profileImage.image!.pngData()! as NSData
//            }
//        }else{
//            try! realmObjc.write{
//                realmObjc.objects(userObject.self)[0].username = textField.text!
//            }
//        }
//        navigationController?.popViewController(animated: true)
//    }

}

//let settingsLabelText2 = ["Username", "TikTok", "Instagram"]
let settingsLabelText = ["Rate App", "Terms & Conditions", "Version"]
let accountSettings = ["Log Out"]

extension EditProfileView: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            self.profileImage.image = image
            
            let storageRef = storage.reference().child(realmObjc.objects(userObject.self)[0].FID + "img.png")
            if let uploadData = image.jpegData(compressionQuality: 0.1){
                storageRef.putData(uploadData, metadata: nil) { (StorageMetadata, error) in
                    if error != nil{
                        return
                    }
                }
            }
            
            if realmObjc.objects(userObject.self)[0].image == nil{
                if realmObjc.objects(userObject.self)[0].isInfluencer{
                    db.collection("user").document("I").collection("users").document(realmObjc.objects(userObject.self)[0].FID).updateData(["hasProfileImage" : true])
                }else{
                    db.collection("user").document("U").collection("users").document(realmObjc.objects(userObject.self)[0].FID).updateData(["hasProfileImage" : true])
                }
            }
            try! realmObjc.write{
                realmObjc.objects(userObject.self)[0].image = image.pngData() as NSData?
            }
            dismiss(animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
extension EditProfileView: UITableViewDelegate, UITableViewDataSource{

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return settingsLabelText2.count
        }else if section == 1{
            return settingsLabelText.count
        }
        return accountSettings.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuPopUpViewCell", for: indexPath) as! MenuPopUpViewCell
        cell.selectionStyle = .none
        if indexPath.section == 0{
            if indexPath.row == 0{
                cell.interactiveCell = true
                cell.cellResponse.text = realmObjc.objects(userObject.self)[0].username
                cell.cellResponse.textColor = .lightGray
            }else
            if indexPath.row == 1{
                cell.interactiveCell = true
                cell.cellResponse.text = realmObjc.objects(userObject.self)[0].bio
                cell.cellResponse.textColor = .lightGray
            }else
            if indexPath.row == 2{
                cell.interactiveCell = true
                cell.cellResponse.text = realmObjc.objects(userObject.self)[0].tiktokHandle
                cell.cellResponse.textColor = .lightGray
            }else
            if indexPath.row == 3{
                cell.interactiveCell = true
                cell.cellResponse.text = realmObjc.objects(userObject.self)[0].instagramHandle
                cell.cellResponse.textColor = .lightGray
            }
            cell.cellLabel.text = settingsLabelText2[indexPath.row]

            return cell
            
        }else if indexPath.section == 1{
            
            if indexPath.row == 0{
                cell.interactiveCell = true
            }
            if indexPath.row == 1{
                cell.interactiveCell = true
            }
            if indexPath.row == 2{
                cell.cellResponse.text = "v0.1.1"
                cell.cellResponseActive = true
            }
            
            cell.cellLabel.text = settingsLabelText[indexPath.row]
            return cell
        }else{
            if indexPath.row == 0{
                cell.interactiveCell = true
            }
            cell.cellLabel.text = accountSettings[indexPath.row]
            return cell
        }
    }
    

    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 38
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let mainView = UIView()
        return mainView
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0{
            let vc = EditSingleView()
            if indexPath.row == 1{
                let item = BioEditSingleView()
//                vc.usernameText.text = "Bio:"
                vc.title = settingsLabelText2[indexPath.row]
                navigationController?.pushViewController(item, animated: true)
                return
            }
            vc.title = settingsLabelText2[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.section == 1{
            if indexPath.row == 0{
                let view = SKStoreProductViewController()
                view.delegate = self as? SKStoreProductViewControllerDelegate

                view.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: 1548108223])
                            present(view, animated: true, completion: nil)
            }else if indexPath.row == 1{
                let vc = AboutView()
                present(vc, animated: true)
            }
        }else{
            showSpinner(onView: view.self)
            try! realmObjc.write{
                realmObjc.deleteAll()
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                self.removeSpinner()
                self.navigationController?.pushViewController(WelcomeView(), animated: true)
                
            }
        }
    }
    
}





class MenuPopUpViewCell: UITableViewCell{
    let realmObjc = try! Realm()
    var interactiveCell = false {
        didSet{
            if interactiveCell == true{
                self.addSubview(arrowImage)
                self.addSubview(cellResponse)

                NSLayoutConstraint.activate([
                    arrowImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18),
                    arrowImage.heightAnchor.constraint(equalToConstant: 18),
                    arrowImage.widthAnchor.constraint(equalToConstant: 18),
                    arrowImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                    
                    cellResponse.trailingAnchor.constraint(equalTo: arrowImage.leadingAnchor, constant: -8),
                    cellResponse.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                    cellResponse.leadingAnchor.constraint(equalTo: cellLabel.trailingAnchor, constant: 16)
                ])

            }
        }
    }
    var cellResponseActive = false {
        didSet{
            if cellResponseActive == true{
                self.addSubview(cellResponse)

                NSLayoutConstraint.activate([
                    cellResponse.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18),
                    cellResponse.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                    cellResponse.leadingAnchor.constraint(equalTo: cellLabel.trailingAnchor, constant: 12)
                ])

            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        constraintContainer()
    }
    
    
    fileprivate let cellLabel: CustomLabel = {
       let label = CustomLabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    fileprivate lazy var arrowImage: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "BlackRightArrow")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate let cellResponse: CustomLabel = {
       let label = CustomLabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate func constraintContainer(){
        self.addSubview(cellLabel)
        NSLayoutConstraint.activate([
            cellLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            cellLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
//            cellLabel.widthAnchor.constraint(equalToConstant: 115)
        
        ])
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

