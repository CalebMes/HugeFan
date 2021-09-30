//
//  FirstViews.swift
//  Huge Fan
//
//  Created by Caleb Mesfien on 3/19/21.
//

import UIKit
import Realm
import WebKit
import Firebase
import RealmSwift
import GoogleSignIn
import FirebaseFirestore
import AuthenticationServices

var accountTypeMain: String?
class WelcomeView: UIViewController, blackViewProtocol, SelectedLoginOption, GIDSignInDelegate {
    var timer =  Timer()
    let realmObjc = try! Realm()
    let appleProvider = AppleSignInClient()
    let item = 3
    

    func loginOptions(OptionNum: Int) {
        if OptionNum == 0{
            appleProvider.handleAppleIdRequest { (fullName, email, userID)  in
                guard let id = userID else{return}
                let dbItem = db.collection("user").document(accountTypeMain!).collection("users")
                    
                    dbItem.whereField("userId", isEqualTo: id).getDocuments { (QuerySnapshot, error) in
                    if let error = error{
                        print(error)
                    }else{

                        self.showSpinner(onView: self.view)
                        if QuerySnapshot!.isEmpty{
                            if email == nil{
                                let alert = UIAlertController(title: "Settings > Apple ID > Password & Security > Apps Using Apple ID > Huge Fan", message:"Due to deleting a past account, you will have to remove Huge Fan from 'Apps Using Apple ID'\n\nOnce you arrive, select 'Stop Using Apple Id' and continue to sign up and create an account" , preferredStyle: .alert)

                                alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))

                                self.present(alert, animated: true)
                            }else{
                            if accountTypeMain == "I"{
                                if self.realmObjc.objects(verifiedInfluencer.self).isEmpty{
                                    self.removeSpinner()
                                    let alert = UIAlertController(title: "No Account Found.", message: "To create a Influencer account, you will need to select \"Create Account\"", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
                                    self.present(alert, animated: true)
                                }else{
                                    let vc = usernameView()
                                    vc.fetchedId = id
                                    vc.fetchedEmail = email
                                    vc.fetchedName = fullName
                                    vc.textField.text = fullName!.replacingOccurrences(of: " ", with: "")
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }else{
                                let vc = usernameView()
                                vc.fetchedId = id
                                vc.fetchedEmail = email
                                vc.fetchedName = fullName
                                vc.textField.text = fullName!.replacingOccurrences(of: " ", with: "")
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            }
                        }else{
                            guard let DocID = QuerySnapshot?.documents[0] else{return}
                            let item = userObject()
                            item.FID = String(describing: DocID.documentID)
                            item.username = DocID.data()["username"] as! String
                            if accountTypeMain == "I"{
                                item.isInfluencer = true
                                item.points = DocID.data()["answerCount"] as! Int
                                item.bio = DocID.data()["bio"] as! String
                                item.instagramHandle = DocID.data()["instagramHandle"] as! String
                                item.tiktokHandle = DocID.data()["tiktokHandle"] as! String

                            }else{
                                item.points = DocID.data()["points"] as! Int
                            }


                            if DocID.data()["hasProfileImage"] as! Bool{
                                storage.reference().child(DocID.documentID + "img.png").getData(maxSize: 1*1024*1024) { (data, error) in
                                    if error == nil {
                                        try! self.realmObjc.write(){
                                            item.image = (data! as NSData)
                                        }
                                    }else{
                                        try! self.realmObjc.write(){
                                            item.image = nil
                                        }
                                    }
                                }
                            }else{
                                try! self.realmObjc.write(){
                                    item.image = nil
                                }
                            }

                                try! self.realmObjc.write(){
                                    self.realmObjc.add(item)
                            }
                            
                            
//                            ANSWERES
                            dbItem.document(DocID.documentID).collection("answered").getDocuments { (snapshot, error) in
                                snapshot?.documents.forEach({ (snap) in
                                    let answerItem = answeredQuestions()
                                    answerItem.username = snap.data()["username"] as! String
                                    answerItem.answer = snap.data()["answer"] as! String
                                    answerItem.question = snap.data()["question"] as! String
                                    answerItem.points = snap.data()["points"] as! Int
                                    answerItem.date = snap.data()["date"] as! String

                                if snap.data()["hasImage"] as! Bool{
                                    storage.reference().child(snap.data()["id"] as! String + "img.png").getData(maxSize: 1*1024*1024) { (data, error) in
                                            if error == nil {
                                                try! self.realmObjc.write(){
                                                    answerItem.userImage = (data! as NSData)
                                                }
                                            }else{
                                                try! self.realmObjc.write(){
                                                    answerItem.userImage = nil
                                                }
                                            }
                                        }
                                    }else{
                                        try! self.realmObjc.write(){
                                            answerItem.userImage = nil
                                        }
                                    }

                                    try! self.realmObjc.write{
                                        self.realmObjc.add(answerItem)
                                    }
                                })
                            }
                            
                            

                            
                            
                            if accountTypeMain == "I"{
                                let vc = InfluecerLayoutController()
                                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                                    self.removeSpinner()
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }else{
                                let vc = LayoutController()
                                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                                    self.removeSpinner()
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                        }

                    }
                }

            }


        }else if OptionNum == 1{
//            GOOGLE SIGN IN
            GIDSignIn.sharedInstance()?.signIn()

        }else if OptionNum == 2{
            let alert = UIAlertController(title: "If you meet the requirment, you will be contacted within the hour.", message:.none , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            
        }else if OptionNum == 3{
            generator.impactOccurred()
                    if let window = UIApplication.shared.keyWindow{
                        blackWindow.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
                        blackWindow.backgroundColor = UIColor(white: 0, alpha: 0.5)
                        blackWindow.alpha = 0
                        view.addSubview(blackWindow)

                        UIView.animate(withDuration: 0.5) {
                            self.blackWindow.alpha = 1
                        }
            }

        let vc = SignupOptions()
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.selectedOptions = self
        navigationController?.present(vc, animated: true)
        }else if OptionNum == 4{
            generator.impactOccurred()
                    if let window = UIApplication.shared.keyWindow{
                        blackWindow.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
                        blackWindow.backgroundColor = UIColor(white: 0, alpha: 0.9)
                        blackWindow.alpha = 0
                        view.addSubview(blackWindow)

                        UIView.animate(withDuration: 0.5) {
                            self.blackWindow.alpha = 1
                        }
            }

        let vc = UserTypeView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.selectedOptions = self
        navigationController?.present(vc, animated: true)
        }
    }
    func presentCreateViewController() {
        UIApplication.shared.statusBarStyle = .darkContent
        navigationController?.pushViewController(LayoutController(), animated: true)
    }

    func changeBlackView() {
            self.blackWindow.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.backButtonTitle = ""
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self

        let index = NSIndexPath(item: 1, section: 0)
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.introCollectionView.scrollToItem(at: index as IndexPath, at: .init(), animated: true)
        }
        constraintContainer()
    }
    func fireTimer(_ int: Int){
        var itemInt = int
        var scroll = false
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (Timer) in

            if scroll{
                self.introCollectionView.scrollToItem(at: NSIndexPath(row: itemInt, section: 0) as IndexPath, at: .init(), animated: true)
                if itemInt != self.item {
                    itemInt += 1
                }else{
                    itemInt = 0
                }
            }else{
                scroll = true
            }
        }
        timer.fire()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    

    
    
    
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard let user = user else{
            dismiss(animated: true)
            return
        }

        let dbItem = db.collection("user").document(accountTypeMain!).collection("users")
            
        dbItem.whereField("userId", isEqualTo: user.userID!).getDocuments { (QuerySnapshot, error) in
            if let error = error{
                print(error)
            }else{


                self.showSpinner(onView: self.view)
                if QuerySnapshot!.isEmpty{
                    if accountTypeMain == "I"{
                        if self.realmObjc.objects(verifiedInfluencer.self).isEmpty{
                            self.removeSpinner()
                            let alert = UIAlertController(title: "No Account Found.", message: "To create a Influencer account, you will need to select \"Create Account\"", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
                            self.present(alert, animated: true)
                        }else{
                            let vc = usernameView()
                            let name = user.profile.name.replacingOccurrences(of: " ", with: "")
                            vc.textField.text = name
                            vc.fetchedEmail = user.profile.email
                            vc.fetchedId = user.userID
                            vc.fetchedName = user.profile.name
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }else{
                        
                            let vc = usernameView()
                            let name = user.profile.name.replacingOccurrences(of: " ", with: "")
                            vc.textField.text = name
                            vc.fetchedEmail = user.profile.email
                            vc.fetchedId = user.userID
                            vc.fetchedName = user.profile.name
                            self.navigationController?.pushViewController(vc, animated: true)
                    }
                }else{
                    
                    
                    
                    guard let DocID = QuerySnapshot?.documents[0] else{return}

                    let item = userObject()
                    item.FID = String(describing: DocID.documentID)
                    item.username = DocID.data()["username"] as! String
                    if accountTypeMain == "I"{
                        item.isInfluencer = true
                        item.points = DocID.data()["answerCount"] as! Int
                        item.bio = DocID.data()["bio"] as! String
                        item.instagramHandle = DocID.data()["instagramHandle"] as! String
                        item.tiktokHandle = DocID.data()["tiktokHandle"] as! String

                    }else{
                        item.points = DocID.data()["points"] as! Int
                    }


                    if DocID.data()["hasProfileImage"] as! Bool{
                        storage.reference().child(DocID.documentID + "img.png").getData(maxSize: 1*1024*1024) { (data, error) in
                            if error == nil {
                                try! self.realmObjc.write(){
                                    item.image = (data! as NSData)
                                }
                            }else{
                                try! self.realmObjc.write(){
                                    item.image = nil
                                }
                            }
                        }
                    }else{
                        try! self.realmObjc.write(){
                            item.image = nil
                        }
                    }

                        try! self.realmObjc.write(){
                            self.realmObjc.add(item)
                    }
                    
                    
                    
//                            ANSWERES
                            dbItem.document(DocID.documentID).collection("answered").getDocuments { (snapshot, error) in
                                snapshot?.documents.forEach({ (snap) in
                                    let answerItem = answeredQuestions()
                                    answerItem.username = snap.data()["username"] as! String
                                    answerItem.answer = snap.data()["answer"] as! String
                                    answerItem.question = snap.data()["question"] as! String
                                    answerItem.points = snap.data()["points"] as! Int
                                    answerItem.date = snap.data()["date"] as! String

                                if snap.data()["hasImage"] as! Bool{
                                    storage.reference().child(snap.data()["id"] as! String + "img.png").getData(maxSize: 1*1024*1024) { (data, error) in
                                            if error == nil {
                                                try! self.realmObjc.write(){
                                                    answerItem.userImage = (data! as NSData)
                                                }
                                            }else{
                                                try! self.realmObjc.write(){
                                                    answerItem.userImage = nil
                                                }
                                            }
                                        }
                                    }else{
                                        try! self.realmObjc.write(){
                                            answerItem.userImage = nil
                                        }
                                    }

                                    try! self.realmObjc.write{
                                        self.realmObjc.add(answerItem)
                                    }
                                })
                            }
                                                
                    
                    
                    
                    
                    if accountTypeMain == "I"{
                        let vc = InfluecerLayoutController()
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                            self.removeSpinner()
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }else{
                        let vc = LayoutController()
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                            self.removeSpinner()
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }

                }
            }
        }
    }
    
    
    
    
    
    
    
    fileprivate let startButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 27
        button.clipsToBounds = true
        button.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        button.setAttributedTitle(NSAttributedString(string: "Get started",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)]), for: .normal)
        button.addTarget(self, action: #selector(continueSelected), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let iconImg: UIImageView = {
       let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.layer.cornerRadius = 15
        img.clipsToBounds = true
        img.image = UIImage(named: "Logo")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let phraseLbl: CustomLabel = {
        let label = CustomLabel()
        label.numberOfLines = 2
        label.text = "Welcome to Huge Fan\nAsk Questions"
//        label.textColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        label.textColor = UIColor.black
        label.textAlignment = .center

        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    fileprivate let signInBtn: UIButton = {
        let button = UIButton()
            button.titleLabel?.textAlignment = .center
        let attributedText = NSMutableAttributedString(string: "Are you an Influencer? ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)])
        attributedText.append(NSAttributedString(string: "Yes, I'm a influencer.", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor:TealConstantColor]))
        button.setAttributedTitle(attributedText, for: .normal)
//        button.titleLabel?.numberOfLines = 2
//        button.titleLabel?.textAlignment = .center
//        button.setAttributedTitle(NSAttributedString(string: "By signing up, you agree with\n the Terms of use and Privacy Policy", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]), for: .normal)
        button.addTarget(self, action: #selector(signInBtnSelected), for: .touchUpInside)
////        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let lineView: UIView = {
       let view = UIView()
//        view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var introCollectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.register(FirstViewCells.self, forCellWithReuseIdentifier: "FirstViewCells")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    
    fileprivate func constraintContainer(){
        view.addSubview(iconImg)
        view.addSubview(phraseLbl)
        view.addSubview(introCollectionView)
        view.addSubview(startButton)
        view.addSubview(lineView)
        view.addSubview(signInBtn)

        NSLayoutConstraint.activate([

            iconImg.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height*0.09),
            iconImg.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImg.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.13),
            iconImg.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.13),

            phraseLbl.topAnchor.constraint(equalTo: iconImg.bottomAnchor, constant: 8),
            phraseLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            introCollectionView.topAnchor.constraint(equalTo: phraseLbl.bottomAnchor, constant: 12),
            introCollectionView.bottomAnchor.constraint(equalTo: startButton.topAnchor,constant: -12),
            introCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            introCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            startButton.bottomAnchor.constraint(equalTo: lineView.topAnchor, constant: -8),
            startButton.heightAnchor.constraint(equalToConstant: 54),
            
            lineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lineView.bottomAnchor.constraint(equalTo: signInBtn.topAnchor, constant: -12),
            lineView.heightAnchor.constraint(equalToConstant: 0.3),
            
            signInBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            signInBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            signInBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
        ])
    }
    let blackWindow = UIView()

    @objc func continueSelected(){
        accountTypeMain = "U"
                generator.impactOccurred()
                        if let window = UIApplication.shared.keyWindow{
                            blackWindow.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
                            blackWindow.backgroundColor = UIColor(white: 0, alpha: 0.85)
                            blackWindow.alpha = 0
                            view.addSubview(blackWindow)

                            UIView.animate(withDuration: 0.5) {
                                self.blackWindow.alpha = 1
                            }
                }

        let vc = SignupOptions()
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.selectedOptions = self
//

        navigationController?.present(vc, animated: true)
//        let vc = usernameView()
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func signInBtnSelected(){
        accountTypeMain = "I"

        generator.impactOccurred()
                if let window = UIApplication.shared.keyWindow{
                    blackWindow.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
                    blackWindow.backgroundColor = UIColor(white: 0, alpha: 0.5)
                    blackWindow.alpha = 0
                    view.addSubview(blackWindow)

                    UIView.animate(withDuration: 0.5) {
                        self.blackWindow.alpha = 1
                    }
        }

    let vc = SignInUserType()
    vc.modalPresentationStyle = .overCurrentContext
    vc.delegate = self
    vc.selectedOptions = self
    navigationController?.present(vc, animated: true)
    }
}






extension WelcomeView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let topics = ["Stay Private", "Be Creative", "Be Respectful"]
        let infoText = ["Other users will only see the username and profile image you provide, you can keep your data, it's not needed.", "With text, gifs, and voice coming soon, the user can express themselves clearly.", "Huge Fan is a platform, therefore abusive content is not tolerated, respect other users."]
        let images = ["privacyImg", "creativeImg", "respectImg"]
//        let topicImg = ["TechnologyIntro", "SportsIntro", "EntertainmentIntro", "PoliticsIntro", "BuisnessIntro", "MoreIntro"]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirstViewCells", for: indexPath) as! FirstViewCells
        cell.tag = indexPath.row
        if cell.tag == indexPath.row{
            timer.invalidate()
            fireTimer(indexPath.row)
            cell.topicTitle.text = infoText[indexPath.row]
            cell.introTitle.text = topics[indexPath.row]
            cell.imgIcons.image = UIImage(named: images[indexPath.row])
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


class FirstViewCells: UICollectionViewCell{
    override init(frame: CGRect){
        super.init(frame: frame)
        addSubview(imgIcons)
        addSubview(introTitle)
        addSubview(topicTitle)
        
        NSLayoutConstraint.activate([

            imgIcons.bottomAnchor.constraint(equalTo: introTitle.topAnchor, constant: -8),
            imgIcons.widthAnchor.constraint(equalToConstant: 40),
            imgIcons.heightAnchor.constraint(equalToConstant: 40),
            imgIcons.centerXAnchor.constraint(equalTo: centerXAnchor),

            introTitle.bottomAnchor.constraint(equalTo: topicTitle.topAnchor, constant: -8),
            introTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            topicTitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            topicTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            topicTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            topicTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)

            
        ])
    }
    let introTitle: CustomLabel = {
        let label = CustomLabel()
//        label.textColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        label.textColor = .black
        label.text = "Some in"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let imgIcons: UIImageView = {
       let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.layer.cornerRadius = 8
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let topicTitle: CustomLabel = {
        let label = CustomLabel()
        label.text = "-"
        label.textAlignment = .center
        label.numberOfLines = 0
//        label.textColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


protocol SelectedLoginOption{
    func loginOptions(OptionNum: Int)
}


class UserTypeView: UIViewController, UITextFieldDelegate {
    var delegate: blackViewProtocol?
    var selectedOptions: SelectedLoginOption?
    let sides = ["TikTok", "Instagram", "Youtube"]
    let realmObjc = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(PanGestureFunc)))
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)

        constraintContainer()
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification){
        if let userInfo = notification.userInfo{
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            UIView.animate(withDuration: 0.8) {
                self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame!.height-self.topbarHeight)
                    self.view.layoutIfNeeded()
                }
        }
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
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let viewBar: CustomView = {
        let view = CustomView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 3
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    fileprivate let viewDescription: CustomLabel = {
        let label = CustomLabel()
        label.numberOfLines = 2
        label.attributedText = NSAttributedString(string: "Are you a influencer or a fan?", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold)])
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints  = false
        return label
    }()
    
    
    
    fileprivate let FanBtn: UIButton = {
        let button  = UIButton()
        button.layer.cornerRadius = 27
        button.clipsToBounds = true
        button.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)

        button.setAttributedTitle(NSAttributedString(string: "🤩 Continue as Fan", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]), for: .normal)
        button.addTarget(self, action: #selector(FanSelected), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    fileprivate let InfluencerBtn: UIButton = {
        let button  = UIButton()
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 27
        button.clipsToBounds = true
        button.layer.borderColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1).cgColor
        button.setAttributedTitle(NSAttributedString(string: "✨ Continue as Influencer", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1), NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]), for: .normal)

        button.addTarget(self, action: #selector(influencerSelected), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    
//    INFLUENCER SELECTED
    fileprivate let MainInfluencerView: CustomView = {
        let view = CustomView()
//        view.backgroundColor = .white
        view.clipsToBounds = true
//        view.layer.cornerRadius = 20
//        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    fileprivate let InfluencerwhiteView: CustomView = {
        let view = CustomView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    fileprivate let influencerLbl: CustomLabel = {
        let label = CustomLabel()
        label.numberOfLines = 0
//        label.attributedText = NSAttributedString(string: "To obtain a influencer account, you will have to meet one of these requirments.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 2, weight: .bold)])
        let attributedText = NSMutableAttributedString(string: "To obtain a influencer account, you will have to meet ", attributes:[NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedText.append(NSAttributedString(string: "one", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]))
        attributedText.append(NSAttributedString(string: " of these requirments.", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.white]))

        label.attributedText = attributedText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints  = false
        return label
    }()
    let TiktokIcon: UIImageView = {
        let Instagram = UIImageView()
        Instagram.image = UIImage(named: "Tiktok")
        Instagram.backgroundColor = .white
        Instagram.layer.shadowColor = UIColor.lightGray.cgColor
        Instagram.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        Instagram.layer.shadowRadius = 3.0
        Instagram.layer.shadowOpacity = 0.4
        Instagram.layer.cornerRadius = 8
        Instagram.translatesAutoresizingMaskIntoConstraints = false
        return Instagram
    }()
    fileprivate let TiktokLbl: CustomLabel = {
        let label = CustomLabel()
        label.numberOfLines = 2
        let attributedText = NSMutableAttributedString(string: "TikTok", attributes:[NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.black])
        attributedText.append(NSAttributedString(string: "\n100k+", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints  = false
        return label
    }()
    let YoutubeIcon: UIImageView = {
        let Instagram = UIImageView()
        Instagram.image = UIImage(named: "Youtube")
        Instagram.backgroundColor = .white
        Instagram.layer.shadowColor = UIColor.lightGray.cgColor
        Instagram.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        Instagram.layer.shadowRadius = 3.0
        Instagram.layer.shadowOpacity = 0.4
        Instagram.layer.cornerRadius = 8
        Instagram.translatesAutoresizingMaskIntoConstraints = false
        return Instagram
    }()
    fileprivate let YoutubeLabel: CustomLabel = {
        let label = CustomLabel()
        label.numberOfLines = 2
        let attributedText = NSMutableAttributedString(string: "Youtube", attributes:[NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.black])
        attributedText.append(NSAttributedString(string: "\n50k+", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints  = false
        return label
    }()
    let InstagramIcon: UIImageView = {
        let Instagram = UIImageView()
        Instagram.image = UIImage(named: "Instagram")
        Instagram.backgroundColor = .white
        Instagram.layer.shadowColor = UIColor.lightGray.cgColor
        Instagram.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        Instagram.layer.shadowRadius = 3.0
        Instagram.layer.shadowOpacity = 0.4
        Instagram.layer.cornerRadius = 8

        Instagram.translatesAutoresizingMaskIntoConstraints = false
        return Instagram
    }()
    fileprivate let InstagramLbl: CustomLabel = {
        let label = CustomLabel()
        label.numberOfLines = 2
        let attributedText = NSMutableAttributedString(string: "Instagram", attributes:[NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.black])
        attributedText.append(NSAttributedString(string: "\n10k+", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints  = false
        return label
    }()
    fileprivate let selectLbl: CustomLabel = {
        let label = CustomLabel()
        label.numberOfLines = 0
        label.attributedText = NSAttributedString(string: "Select one account and provide the accounts username. If you meet the requirment, you will be contacted within the hour.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)])
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints  = false
        return label
    }()

    lazy var segmentedController: UISegmentedControl = {
       let segment = UISegmentedControl(items: sides)

        segment.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        segment.selectedSegmentTintColor = .white
        segment.selectedSegmentIndex = 0
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)], for: .normal)
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)], for: .selected)

        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    fileprivate let signInBtn: UIButton = {
        let button = UIButton()
            button.titleLabel?.textAlignment = .center
        let attributedText = NSMutableAttributedString(string: "Already have a code?  ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold)])
        attributedText.append(NSAttributedString(string: "Login", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor:TealConstantColor]))
        button.setAttributedTitle(attributedText, for: .normal)
//        button.titleLabel?.numberOfLines = 2
//        button.titleLabel?.textAlignment = .center
//        button.setAttributedTitle(NSAttributedString(string: "By signing up, you agree with\n the Terms of use and Privacy Policy", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]), for: .normal)
        button.addTarget(self, action: #selector(signInBtnSelected), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let usernameText: CustomLabel = {
        let label = CustomLabel()
        label.numberOfLines = 1
        label.text = "Username:"
        label.textColor = .white

        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    fileprivate let textFieldView: CustomView = {
       let view = CustomView()
        view.backgroundColor = .white

       view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()

    lazy var textField: UITextField = {
       let field = UITextField()
        field.clearButtonMode = .whileEditing
        field.keyboardAppearance = .light
        field.textColor = .white
        field.tintColor = .white
        field.returnKeyType = .done
        field.font = UIFont.boldSystemFont(ofSize: 16)
        field.autocorrectionType = .no
        field.delegate = self
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    
    
//    HAVE THE CODE VIEW
    
    fileprivate let codeView: CustomView = {
        let view = CustomView()
//        view.backgroundColor = .white
        view.clipsToBounds = true
//        view.layer.cornerRadius = 20
//        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    fileprivate let codeLbl: CustomLabel = {
        let label = CustomLabel()
        label.numberOfLines = 0
        label.attributedText = NSAttributedString(string: "Provide the one time code that was sent to you. Once the code is verified, you will be able to create a account.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)])
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints  = false
        return label
    }()
    
    let codeText: CustomLabel = {
        let label = CustomLabel()
        label.numberOfLines = 1
        label.text = "Code:"
        label.textColor = .white

        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    fileprivate let CodetextFieldView: CustomView = {
       let view = CustomView()
        view.backgroundColor = .white
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()

    lazy var codeTextField: UITextField = {
       let field = UITextField()
        field.clearButtonMode = .whileEditing
        field.keyboardAppearance = .light
        field.textColor = .white
        field.tintColor = .white
        field.returnKeyType = .done
        field.font = UIFont.boldSystemFont(ofSize: 16)
        field.autocorrectionType = .no
        field.delegate = self
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private func constraintContainer(){
        
//        view.addSubview(whiteView)
//        whiteView.addSubview(viewBar)
//        whiteView.addSubview(viewDescription)
//        whiteView.addSubview(FanBtn)
//        whiteView.addSubview(InfluencerBtn)
        
        view.addSubview(MainInfluencerView)
        MainInfluencerView.addSubview(influencerLbl)
        MainInfluencerView.addSubview(InfluencerwhiteView)
        InfluencerwhiteView.addSubview(TiktokLbl)
        InfluencerwhiteView.addSubview(TiktokIcon)
        InfluencerwhiteView.addSubview(InstagramIcon)
        InfluencerwhiteView.addSubview(InstagramLbl)
        InfluencerwhiteView.addSubview(YoutubeIcon)
        InfluencerwhiteView.addSubview(YoutubeLabel)
        
        MainInfluencerView.addSubview(selectLbl)
        MainInfluencerView.addSubview(segmentedController)
        MainInfluencerView.addSubview(usernameText)
        MainInfluencerView.addSubview(textFieldView)
        MainInfluencerView.addSubview(textField)
        MainInfluencerView.addSubview(signInBtn)
        
        view.addSubview(codeView)
        codeView.addSubview(codeLbl)
        codeView.addSubview(codeText)
        codeView.addSubview(CodetextFieldView)
        codeView.addSubview(codeTextField)

        NSLayoutConstraint.activate([
//            viewBar.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 8),
//            viewBar.widthAnchor.constraint(equalToConstant: 40),
//            viewBar.heightAnchor.constraint(equalToConstant: 6),
//            viewBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//
//            whiteView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            whiteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            whiteView.heightAnchor.constraint(equalToConstant: 248),
//            whiteView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//
//            viewDescription.topAnchor.constraint(equalTo: viewBar.bottomAnchor, constant: 16),
//            viewDescription.widthAnchor.constraint(equalTo: whiteView.widthAnchor),
//
//            FanBtn.topAnchor.constraint(equalTo: viewDescription.bottomAnchor, constant: 28),
//            FanBtn.leadingAnchor.constraint(equalTo:whiteView.leadingAnchor, constant: 16),
//            FanBtn.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -16),
//            FanBtn.heightAnchor.constraint(equalToConstant: 54),
//
//
//            InfluencerBtn.topAnchor.constraint(equalTo: FanBtn.bottomAnchor, constant: 16),
//            InfluencerBtn.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 16),
//            InfluencerBtn.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -16),
//            InfluencerBtn.heightAnchor.constraint(equalToConstant:54),
    
            
//            VIEW
            MainInfluencerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            MainInfluencerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            MainInfluencerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            MainInfluencerView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            
            
            influencerLbl.topAnchor.constraint(equalTo: MainInfluencerView.topAnchor, constant:8),
            influencerLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            influencerLbl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            
            InfluencerwhiteView.topAnchor.constraint(equalTo: influencerLbl.bottomAnchor, constant: 12),
            InfluencerwhiteView.widthAnchor.constraint(equalToConstant: 239),
            InfluencerwhiteView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            InfluencerwhiteView.heightAnchor.constraint(equalToConstant: 228),
            
            TiktokIcon.topAnchor.constraint(equalTo: InfluencerwhiteView.topAnchor, constant: 12),
            TiktokIcon.widthAnchor.constraint(equalToConstant: 60),
            TiktokIcon.heightAnchor.constraint(equalToConstant: 60),
            TiktokIcon.leadingAnchor.constraint(equalTo: InfluencerwhiteView.leadingAnchor, constant: 28),
            
            TiktokLbl.topAnchor.constraint(equalTo: TiktokIcon.topAnchor),
            TiktokLbl.leadingAnchor.constraint(equalTo: TiktokIcon.trailingAnchor, constant: 12),
            TiktokLbl.bottomAnchor.constraint(equalTo: TiktokIcon.bottomAnchor),
            
            InstagramIcon.topAnchor.constraint(equalTo: TiktokIcon.bottomAnchor, constant: 12),
            InstagramIcon.widthAnchor.constraint(equalToConstant: 60),
            InstagramIcon.heightAnchor.constraint(equalToConstant: 60),
            InstagramIcon.leadingAnchor.constraint(equalTo: InfluencerwhiteView.leadingAnchor, constant: 28),
            
            InstagramLbl.topAnchor.constraint(equalTo: InstagramIcon.topAnchor),
            InstagramLbl.leadingAnchor.constraint(equalTo: TiktokIcon.trailingAnchor, constant: 12),
            InstagramLbl.bottomAnchor.constraint(equalTo: InstagramIcon.bottomAnchor),
            
            YoutubeIcon.topAnchor.constraint(equalTo: InstagramIcon.bottomAnchor, constant: 12),
            YoutubeIcon.widthAnchor.constraint(equalToConstant: 60),
            YoutubeIcon.heightAnchor.constraint(equalToConstant: 60),
            YoutubeIcon.leadingAnchor.constraint(equalTo: InfluencerwhiteView.leadingAnchor, constant: 28),
            
            YoutubeLabel.topAnchor.constraint(equalTo: YoutubeIcon.topAnchor),
            YoutubeLabel.leadingAnchor.constraint(equalTo: TiktokIcon.trailingAnchor, constant: 12),
            YoutubeLabel.bottomAnchor.constraint(equalTo: YoutubeIcon.bottomAnchor),
            
            selectLbl.bottomAnchor.constraint(equalTo: segmentedController.topAnchor, constant: -12),
            selectLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectLbl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            segmentedController.leadingAnchor.constraint(equalTo: MainInfluencerView.leadingAnchor, constant: 16),
            segmentedController.trailingAnchor.constraint(equalTo: MainInfluencerView.trailingAnchor, constant: -16),
            segmentedController.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -16),
            segmentedController.heightAnchor.constraint(equalToConstant: 54),
            
            textField.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: -2),
            textField.leadingAnchor.constraint(equalTo: usernameText.trailingAnchor, constant: 4),
            textField.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -4),
            textField.heightAnchor.constraint(equalToConstant:36),
            
            usernameText.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: -2),
            usernameText.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor),
            usernameText.widthAnchor.constraint(equalToConstant: usernameText.intrinsicContentSize.width),
            usernameText.heightAnchor.constraint(equalToConstant:36),
            
            textFieldView.bottomAnchor.constraint(equalTo: signInBtn.topAnchor, constant: -16),
            textFieldView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            textFieldView.heightAnchor.constraint(equalToConstant:0.8),
            
            signInBtn.bottomAnchor.constraint(equalTo: MainInfluencerView.bottomAnchor, constant: -16),
            signInBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            signInBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
//            HAVE CODE
            codeView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 200),
            codeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            codeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            codeView.heightAnchor.constraint(equalToConstant: 200),
            
            codeLbl.topAnchor.constraint(equalTo: codeView.topAnchor, constant: 8),
            codeLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            codeLbl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
//            cod
            codeTextField.bottomAnchor.constraint(equalTo: CodetextFieldView.bottomAnchor, constant: -2),
            codeTextField.leadingAnchor.constraint(equalTo: codeText.trailingAnchor, constant: 4),
            codeTextField.trailingAnchor.constraint(equalTo: CodetextFieldView.trailingAnchor, constant: -4),
            codeTextField.heightAnchor.constraint(equalToConstant:36),
            
            codeText.bottomAnchor.constraint(equalTo: CodetextFieldView.bottomAnchor, constant: -2),
            codeText.leadingAnchor.constraint(equalTo: CodetextFieldView.leadingAnchor),
            codeText.widthAnchor.constraint(equalToConstant: codeText.intrinsicContentSize.width),
            codeText.heightAnchor.constraint(equalToConstant: 36),
            
            CodetextFieldView.bottomAnchor.constraint(equalTo: codeView.bottomAnchor, constant: -16),
            CodetextFieldView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            CodetextFieldView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            CodetextFieldView.heightAnchor.constraint(equalToConstant:0.8),
        ])
        
    }

    @objc func signInBtnSelected(){
        UIView.animate(withDuration: 0.5) {
            self.MainInfluencerView.transform = CGAffineTransform(translationX: 0, y: 1000)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            UIView.animate(withDuration: 1) {
                self.codeView.transform = CGAffineTransform(translationX: 0, y: -200-self.topbarHeight-200)
                self.codeTextField.becomeFirstResponder()
            }
        }
    }
    @objc func FanSelected(){
        accountTypeMain = "U"
        dismiss(animated: true) {
            self.delegate?.changeBlackView()
            self.selectedOptions?.loginOptions(OptionNum: 3)
        }
    }
    @objc func influencerSelected(){
        if realmObjc.objects(verifiedInfluencer.self).isEmpty{
            UIView.animate(withDuration: 0.5) {
                self.whiteView.transform = CGAffineTransform(translationX: 0, y: 500)
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                UIView.animate(withDuration: 1) {
                    self.MainInfluencerView.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height+self.topbarHeight)
                }
            }
        }else{
            accountTypeMain = "I"
            dismiss(animated: true) {
                self.delegate?.changeBlackView()
                self.selectedOptions?.loginOptions(OptionNum: 3)
            }
        }
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == codeTextField{
            if textField.text?.count != 0{
            db.collection("codes").document(codeTextField.text!).getDocument { (snapshot, error) in
                if snapshot?.exists == false{
//                    return false
                }else{
                    db.collection("codes").document(self.codeTextField.text!).delete()
                    accountTypeMain = "I"
                    let ver = verifiedInfluencer()
                    try! self.realmObjc.write({
                        ver.verified = true
                        self.realmObjc.add(ver)
                    })
                    self.dismiss(animated: true) {
                        self.delegate?.changeBlackView()
                        self.selectedOptions?.loginOptions(OptionNum: 3)
                    }
                }
            }
            }
                        return true
            
        }else{
            print("NOT")
            db.collection("verifyUsers").document().setData(["username" : textField.text!, "platform":sides[segmentedController.selectedSegmentIndex]])
            dismiss(animated: true) {
                self.delegate?.changeBlackView()
                self.selectedOptions?.loginOptions(OptionNum: 2)
            }
            return true
        }
    }

    @objc func TermsOfUseSelected(){
        let vc = AboutView()
        present(vc, animated: true)
    }
        

}








class SignupOptions: UIViewController {
    var delegate: blackViewProtocol?
    var selectedOptions: SelectedLoginOption?
    var accountType: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(PanGestureFunc)))

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
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let viewBar: CustomView = {
        let view = CustomView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 3
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let viewTitle: CustomLabel = {
        let label = CustomLabel()
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: "Welcome", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 32)])
        
        label.translatesAutoresizingMaskIntoConstraints  = false
        return label
    }()
    
    
    fileprivate let viewDescription: CustomLabel = {
        let label = CustomLabel()
        label.numberOfLines = 2
        label.attributedText = NSAttributedString(string: "Before we start, continue \nwith one of these options.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)])
        
        label.translatesAutoresizingMaskIntoConstraints  = false
        return label
    }()
    
    
    
    fileprivate let appleButton: UIButton = {
        let button  = UIButton()
        
        
        
        
        button.layer.cornerRadius = 27
        button.clipsToBounds = true
        button.backgroundColor = .black

        button.setAttributedTitle(NSAttributedString(string: "Continue with Apple", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]), for: .normal)
        button.addTarget(self, action: #selector(AppleLoginSelected), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    fileprivate let appleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "appleIcon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()

    
    fileprivate let emailButton: UIButton = {
        let button  = UIButton()
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 27
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.setAttributedTitle(NSAttributedString(string: "Continue with Google", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]), for: .normal)

        button.addTarget(self, action: #selector(GoogleLoginSelected), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    fileprivate let emailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "googleLogo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()

    private func constraintContainer(){
        
        view.addSubview(whiteView)
            whiteView.addSubview(viewBar)
            whiteView.addSubview(viewTitle)
            whiteView.addSubview(viewDescription)
        
        whiteView.addSubview(appleButton)
            appleButton.addSubview(appleImageView)
        whiteView.addSubview(emailButton)
            emailButton.addSubview(emailImageView)

        NSLayoutConstraint.activate([
            viewBar.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 8),
            viewBar.widthAnchor.constraint(equalToConstant: 40),
            viewBar.heightAnchor.constraint(equalToConstant: 6),
            viewBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            whiteView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            whiteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            whiteView.heightAnchor.constraint(equalToConstant: 284),
            whiteView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            viewTitle.topAnchor.constraint(equalTo: viewBar.topAnchor, constant: 8),
            viewTitle.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 16),
            viewTitle.heightAnchor.constraint(equalToConstant: viewTitle.intrinsicContentSize.height),
            
            viewDescription.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 8),
            viewDescription.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 16),
            viewDescription.widthAnchor.constraint(equalTo: whiteView.widthAnchor),
            
            appleButton.topAnchor.constraint(equalTo: viewDescription.bottomAnchor, constant: 16),
            appleButton.leadingAnchor.constraint(equalTo:whiteView.leadingAnchor, constant: 16),
            appleButton.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -16),
            appleButton.heightAnchor.constraint(equalToConstant: 54),

        
            emailButton.topAnchor.constraint(equalTo: appleButton.bottomAnchor, constant: 16),
            emailButton.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 16),
            emailButton.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -16),
            emailButton.heightAnchor.constraint(equalToConstant:54),

            emailImageView.centerYAnchor.constraint(equalTo: emailButton.centerYAnchor),
            emailImageView.heightAnchor.constraint(equalToConstant: 22),
            emailImageView.widthAnchor.constraint(equalToConstant: 22),
            emailImageView.leadingAnchor.constraint(equalTo: emailButton.leadingAnchor, constant: 16),

            appleImageView.centerYAnchor.constraint(equalTo: appleButton.centerYAnchor),
            appleImageView.heightAnchor.constraint(equalToConstant: 22),
            appleImageView.widthAnchor.constraint(equalToConstant: 23),
            appleImageView.leadingAnchor.constraint(equalTo: appleButton.leadingAnchor, constant: 16),
        ])
        
    }

    @objc func AppleLoginSelected(){
        self.delegate?.changeBlackView()
        dismiss(animated: true){
            self.selectedOptions?.loginOptions(OptionNum: 0)
        }
    }
    @objc func GoogleLoginSelected(){
        self.delegate?.changeBlackView()
        dismiss(animated: true){
            self.selectedOptions?.loginOptions(OptionNum: 1)
        }
    }

    @objc func TermsOfUseSelected(){
        let vc = AboutView()
        present(vc, animated: true)
    }
        

}


































class usernameView: UIViewController, UITextFieldDelegate, blackViewProtocol{
   
    
    var fetchedName: String?
    var fetchedId: String?
    var fetchedEmail: String?
    
    var providedName = String()
    var listOfInterests: [String]?
    var hasImage = false


    func SetUpComplete() {
        showSpinner(onView: view)
        let dateJoined = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM-dd-yyyy"
        let date = dateFormatter.string(from: dateJoined)


        guard let usernameText = textField.text?.lowercased() else{return}
        let realmObjc = try! Realm()

        db.collection("user").document(accountTypeMain!).collection("users").whereField("userId", isEqualTo:fetchedId!).getDocuments { [self] (QuerySnapshot, error) in
            if let error = error{
                print(error)
            }else{
                if QuerySnapshot!.isEmpty{
                    print("Not Found!")
                    try! realmObjc.write({
                        realmObjc.delete(realmObjc.objects(verifiedInfluencer.self))
                    })
                    let doc = db.collection("user").document(accountTypeMain!).collection("users").document()
                    if accountTypeMain! == "I"{
                        doc.setData(["userId" : fetchedId!, "name":fetchedName!, "e-mail": fetchedEmail!, "username":usernameText, "joined":date, "hasProfileImage":hasImage,"answerCount": 0, "bio":"No Bio🤷", "fanCount":0, "instagramHandle": "", "tiktokHandle":""])
                    }else{
                        doc.setData(["userId" : fetchedId!, "name":fetchedName!, "e-mail": fetchedEmail!, "username":usernameText, "joined":date, "hasProfileImage":hasImage,"points": 0])
                    }


                    let item = userObject()

                    if hasImage{
                        let storageRef = storage.reference().child(doc.documentID + "img.png")
                        if let uploadData = self.profileImage.image!.jpegData(compressionQuality: 0.1){
                            storageRef.putData(uploadData, metadata: nil) { (StorageMetadata, error) in
                                if error != nil{
                                    return
                                }
                            }
                        }
                        item.image = profileImage.image?.pngData() as NSData?
                    }else{
                        item.image = nil
                    }
                    if accountTypeMain == "I"{
                        item.isInfluencer = true
                    }
                    
                    
                    try! realmObjc.write(){
                        item.FID = String(describing: doc.documentID)
                        item.username = usernameText
                            realmObjc.add(item)
                        }
//                    }
                    print(usernameText, "This is it")

                    DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                        if accountTypeMain == "I"{
                            navigationController?.pushViewController(InfluecerLayoutController(), animated: true)
                        }else{
                            navigationController?.pushViewController(LayoutController(), animated: true)
                        }
                    }

                }else{

                }
            }
        }
    }
    
    
    
    
    func changeBlackView() {
        self.blackWindow.alpha = 0
        self.blackWindow.removeFromSuperview()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        title = ""
        view.backgroundColor = .white
        textField.delegate = self
        textFieldApearing()
        if accountTypeMain == "U"{
            if textField.text?.isEmpty == false{
                continueButton.backgroundColor = TealConstantColor
                continueButton.isEnabled = true
            }
        }
        constraintContainer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
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
        field.font = UIFont.boldSystemFont(ofSize: 16)
        field.autocorrectionType = .no
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    
    
    fileprivate lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named:"placeholderProfileImage")
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
    
    fileprivate let welcomeLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.attributedText = NSAttributedString(string: "We Don't Need Your\nPersonal Data", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)])
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    fileprivate let reasonForName: CustomLabel = {
        let label = CustomLabel()
        label.attributedText = NSAttributedString(string: "Huge Fan only requires a username and profile image. So what would you like yours to be?", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    
    fileprivate let continueButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 27
        button.clipsToBounds = true
        button.isEnabled = false
        button.setAttributedTitle(NSAttributedString(string: "Done",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold)]), for: .normal)
        button.backgroundColor = UIColor(red: 52/255, green: 54/255, blue: 66/255, alpha: 1)
        button.addTarget(self, action: #selector(continueSelected), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    

    
    private func constraintContainer(){
        view.addSubview(profileImage)
        view.addSubview(changeProfileImage)
        view.addSubview(welcomeLabel)
        view.addSubview(usernameText)
        view.addSubview(textFieldView)
        textFieldView.addSubview(textField)
        
        view.addSubview(reasonForName)
        view.addSubview(continueButton)
        
        NSLayoutConstraint.activate([

            textField.topAnchor.constraint(equalTo: reasonForName.bottomAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: usernameText.trailingAnchor, constant: 4),
            textField.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -4),
            textField.heightAnchor.constraint(equalToConstant:36),
            
            usernameText.topAnchor.constraint(equalTo: reasonForName.bottomAnchor, constant: 8),
            usernameText.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor),
            usernameText.widthAnchor.constraint(equalToConstant: usernameText.intrinsicContentSize.width),
            usernameText.heightAnchor.constraint(equalToConstant:36),
            
            textFieldView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4),
            textFieldView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            textFieldView.heightAnchor.constraint(equalToConstant:0.8),
            
            
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12),
            profileImage.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12),

            changeProfileImage.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
            changeProfileImage.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor),
            
            welcomeLabel.topAnchor.constraint(equalTo: changeProfileImage.bottomAnchor, constant: 30),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            
            reasonForName.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 8),
            reasonForName.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            reasonForName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            continueButton.widthAnchor.constraint(equalToConstant: 150),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.heightAnchor.constraint(equalToConstant: 54),

            

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
    
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        for letter in string{
            for i in "/:;()$&@\",?!'[]{}#%^*+=\\|~<>€£¥•,?!' "{
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
        if accountTypeMain == "I"{
            if count >= 3 && hasImage{
                continueButton.backgroundColor = TealConstantColor
                continueButton.isEnabled = true
            }else{
                continueButton.backgroundColor = UIColor(red: 52/255, green: 54/255, blue: 66/255, alpha: 1)
                continueButton.isEnabled = false
            }
        }else{
            if count >= 3{
                continueButton.backgroundColor = TealConstantColor
                continueButton.isEnabled = true
            }else{
                continueButton.backgroundColor = UIColor(red: 52/255, green: 54/255, blue: 66/255, alpha: 1)
                continueButton.isEnabled = false
            }
        }
        return count <= 30
    }
    
    func textFieldApearing(){
            self.textField.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(notification: Notification){
        let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 1) {
            self.continueButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -keyboardRect.height-40).isActive = true
        }

    }
    let blackWindow = UIView()
    let realmObjc = try! Realm()
    @objc func continueSelected(){
        if realmObjc.objects(userObject.self).isEmpty{
            SetUpComplete()
        }else{
            updateProfile()
        }
        continueButton.isEnabled = false
    }
    
    
    
    func updateProfile(){
        if hasImage{
            
            let storageRef = storage.reference().child(realmObjc.objects(userObject.self)[0].FID + "img.png")
            if let uploadData = self.profileImage.image!.jpegData(compressionQuality: 0.1){
                storageRef.putData(uploadData, metadata: nil) { (StorageMetadata, error) in
                    if error != nil{
                        return
                    }
                }
            }
            try! realmObjc.write{
                realmObjc.objects(userObject.self)[0].username = textField.text!
                realmObjc.objects(userObject.self)[0].image = profileImage.image!.pngData()! as NSData
            }
        }else{
            try! realmObjc.write{
                realmObjc.objects(userObject.self)[0].username = textField.text!
            }
        }
        navigationController?.popViewController(animated: true)
    }

}
extension usernameView: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            self.profileImage.image = image
            hasImage = true
            if textField.text!.count >= 3{
                continueButton.backgroundColor = TealConstantColor
                continueButton.isEnabled = true
            }
            dismiss(animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}







class SignInUserType: UIViewController, UITextFieldDelegate {
    var delegate: blackViewProtocol?
    var selectedOptions: SelectedLoginOption?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(PanGestureFunc)))
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)

        constraintContainer()
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification){
        if let userInfo = notification.userInfo{
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            UIView.animate(withDuration: 0.8) {
                self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame!.height-self.topbarHeight)
                    self.view.layoutIfNeeded()
                }
        }
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
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let viewBar: CustomView = {
        let view = CustomView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 3
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    fileprivate let viewDescription: CustomLabel = {
        let label = CustomLabel()
        label.numberOfLines = 2
        label.attributedText = NSAttributedString(string: "Do you already have an influencer account?", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold)])
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints  = false
        return label
    }()
    
    
    
    fileprivate let appleButton: UIButton = {
        let button  = UIButton()
        button.layer.cornerRadius = 27
        button.clipsToBounds = true
        button.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)

        button.setAttributedTitle(NSAttributedString(string: "Create Account", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]), for: .normal)
        button.addTarget(self, action: #selector(UserSelected), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    fileprivate let emailButton: UIButton = {
        let button  = UIButton()
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 27
        button.clipsToBounds = true
        button.layer.borderColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1).cgColor
        button.setAttributedTitle(NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1), NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]), for: .normal)

        button.addTarget(self, action: #selector(signInSelected), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private func constraintContainer(){
        
        view.addSubview(whiteView)
        whiteView.addSubview(viewBar)
        whiteView.addSubview(viewDescription)
        whiteView.addSubview(appleButton)
        whiteView.addSubview(emailButton)
        


        NSLayoutConstraint.activate([
            viewBar.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 8),
            viewBar.widthAnchor.constraint(equalToConstant: 40),
            viewBar.heightAnchor.constraint(equalToConstant: 6),
            viewBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            whiteView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            whiteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            whiteView.heightAnchor.constraint(equalToConstant: 262),
            whiteView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            viewDescription.topAnchor.constraint(equalTo: viewBar.bottomAnchor, constant: 16),
            viewDescription.widthAnchor.constraint(equalTo: whiteView.widthAnchor, multiplier: 0.85),
            viewDescription.centerXAnchor.constraint(equalTo: whiteView.centerXAnchor),
            
            appleButton.topAnchor.constraint(equalTo: viewDescription.bottomAnchor, constant: 28),
            appleButton.leadingAnchor.constraint(equalTo:whiteView.leadingAnchor, constant: 16),
            appleButton.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -16),
            appleButton.heightAnchor.constraint(equalToConstant: 54),

        
            emailButton.topAnchor.constraint(equalTo: appleButton.bottomAnchor, constant: 16),
            emailButton.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 16),
            emailButton.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -16),
            emailButton.heightAnchor.constraint(equalToConstant:54),
    

        ])
        
    }

    @objc func UserSelected(){
        dismiss(animated: true) {
            self.delegate?.changeBlackView()
            self.selectedOptions?.loginOptions(OptionNum: 4)
        }
    }
    @objc func signInSelected(){
        dismiss(animated: true) {
            self.delegate?.changeBlackView()
            self.selectedOptions?.loginOptions(OptionNum: 3)
        }
    }


}
