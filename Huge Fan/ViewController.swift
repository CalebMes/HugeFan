//
//  ViewController.swift
//  Huge Fan
//
//  Created by Caleb Mesfien on 3/14/21.
//

import UIKit
import Lottie
import RealmSwift
import ShimmerSwift
import VerticalCardSwiper

struct InfluUser {
    var username: String
    var profileImg: UIImage?
    var answeredCount: String?
    var rankedCount: String?
    var fanCount: Int?
    var instagramHandle: String?
    var tiktokHandle: String?
    var bio: String?
}
struct featuredUser {
    var username: String
    var profileImg: UIImage?
    var answeredCount: String?
    var rankedCount: String?
    var fanCount: Int?
    var id: String?
}
struct answeredQ{
    var username: String
    var points: Int
    var question: String
    var answer: String
    var date: String
    var id: String
    var hasImage: Bool
}






class ViewController: UIViewController, blackViewProtocol, completeRequest, questionSelected {
    func selectedQ(question: String, transmitterUsername: String, transmitterId: String, points: Int, hasImage: Bool,  Id: String) {
//        print(realmObjc.objects(usedPromotions.self).)
        if realmObjc.objects(usedPromotions.self).filter("id == %@", Fid!).isEmpty{
            
            let alert = UIAlertController(title: "Would you like to like this comment?", message:"You have a limited amount of likes. When you like this question, the question will go higher up on the list." , preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Nevermind", style: .destructive, handler: nil))
            alert.addAction(UIAlertAction(title: "Like", style: .default, handler: { (UIAlertAction) in
                let item = db.collection("user").document("I").collection("users").document(self.Fid!).collection("unanswered").document(Id)
                item.getDocument { (snap, error) in
                    item.updateData(["likes" : snap?.data()!["likes"] as! Int + 1])
                }
            }))
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"

            let obj = usedPromotions()
            obj.date = formatter.string(from: Date())
            obj.id = Fid!
            obj.itemCount = 1
            try! realmObjc.write{
                realmObjc.add(obj)
            }

            
            self.present(alert, animated: true)
        }else if realmObjc.objects(usedPromotions.self).filter("id == %@", Fid!)[0].itemCount < 3{
            let alert = UIAlertController(title: "Would you like to like this comment?", message:"You have a limited amount of likes. When you like this question, the question will go higher up on the list." , preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Nevermind", style: .destructive, handler: nil))
            alert.addAction(UIAlertAction(title: "Like", style: .default, handler: { (UIAlertAction) in
                let item = db.collection("user").document("I").collection("users").document(self.Fid!).collection("unanswered").document(Id)
                item.getDocument { (snap, error) in
                    item.updateData(["likes" : snap?.data()!["likes"] as! Int + 1])
                }
            }))
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            
            let count = realmObjc.objects(usedPromotions.self).filter("id == %@", Fid!)[0].itemCount
            try! realmObjc.write{
                realmObjc.objects(usedPromotions.self).filter("id == %@", Fid!)[0].itemCount = count+1
            }
                        
            self.present(alert, animated: true)
        }else{
            let alert = UIAlertController(title: "0 Likes Remaining", message:"To prevent spamming, every user is limited to three likes." , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func complete(item: Int, questionImage: UIImage, answerImage: UIImage, fanUsername: String, influencerUsername: String, date: String, question: String, answer:String) {
        if item == 0{
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
            let vc = InstagramPostViewController()
            vc.delegate = self
            vc.questionImageItem = questionImage
            vc.answerImageItem = answerImage
            vc.question = question
            vc.answer = answer
            vc.fanUsername = fanUsername
            vc.influencerUsernameItem = influencerUsername
            vc.dateItem = date
            vc.hidesBottomBarWhenPushed = true
            vc.modalPresentationStyle = .overCurrentContext
            self.tabBarController?.tabBar.isHidden = true
            
            present(vc, animated: true, completion: nil)
        }else{
            
        }
    }
    
    
    var TestViewHeight: NSLayoutConstraint?
    let blackWindow = UIView()
    var numOfAnswers: Int?
    let realmObjc = try! Realm()
    var userItem: InfluUser?{
        didSet{
            constraintContainer()
        }
    }
    var Fid: String?{
        didSet{
            let user = db.collection("user").document("I").collection("users").document(Fid!)

            user.getDocument { (snapshot, error) in
                let data = snapshot?.data()
                let username = data!["username"] as! String
                let answeredCount = data!["answerCount"] as? Int
                let rankedCount = data!["ranking"] ?? "NR"
                let fanCount = data!["fanCount"] as? Int
                let instagramHandle = data!["instagramHandle"] as? String
                let tiktokHandle = data!["tiktokHandle"] as? String
                let bio = data!["bio"] ?? "No Bio🤷"

                storage.reference().child(self.Fid! + "img.png").getData(maxSize: 1*1024*1024) { (data, error) in
                    if error == nil {
                        self.userItem = InfluUser(username: username, profileImg: UIImage(data: data!), answeredCount: String(answeredCount!), rankedCount: rankedCount as? String, fanCount: fanCount!, instagramHandle: instagramHandle!, tiktokHandle: tiktokHandle!, bio: bio as? String)
                    }
            }
            }
//            user.collection("answered").getDocuments { (snap, error) in
//                self.numOfAnswers = snap?.documents.count
//                snap?.documents.forEach({ (item) in
//                    let answer = item.data()["answer"] as! String
//                    let date = item.data()["date"] as! String
//                    let hasImage = item.data()["hasImage"] as! Bool
//                    let points = item.data()["points"] as! Int
//                    let question = item.data()["question"] as! String
//                    let username = item.data()["username"] as! String
//                    let id = item.data()["id"] ?? "adyupYuRdtgpMxyBPbhu"
//
//                    let dateFormatterGet = DateFormatter()
//                    let dateFormatter = DateFormatter()
//                    dateFormatterGet.dateFormat = "MMM d, yyyy, h:mm a"
//                    let Ndate = dateFormatterGet.date(from: (date))
//                    if Calendar.current.isDateInToday(Ndate!){
//                        dateFormatter.dateFormat = "h:mm a"
//                    }else{
//                        dateFormatter.dateFormat = "MMM d"
//                    }
//                    let newDate = dateFormatter.string(from: Ndate! as Date)
//
//
//
//                    let ansItem = answeredQ(username: username, points: points, question: question, answer: answer, date: newDate,id: id as! String, hasImage: hasImage)

//                    self.answeredQs.append(ansItem)
//                })
//            }
        }
    }
    var answeredQs = [answeredQ](){
        didSet{
            if answeredQs.count == numOfAnswers && userItem != nil{
                constraintContainer()
            }
        }
    }
    
    func changeBlackView() {
        UIView.animate(withDuration: 0.3) {
            self.blackWindow.alpha = 0
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        let favoritesBtn = UIBarButtonItem(image: UIImage(named: "blackShare"), style: .plain, target: self, action: #selector(shareSelected))
        navigationItem.rightBarButtonItem = favoritesBtn
        panView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(PanGestureFunc)))
        
        view.addSubview(shimmerProfileImage)
        view.addSubview(shimmerCollectionView)
        NSLayoutConstraint.activate([
            shimmerProfileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            shimmerProfileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shimmerProfileImage.heightAnchor.constraint(equalToConstant: (view.frame.height*0.65)*0.3),
            shimmerProfileImage.widthAnchor.constraint(equalTo: shimmerProfileImage.heightAnchor),
            
            shimmerCollectionView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.safeAreaLayoutGuide.layoutFrame.height*0.35),
            shimmerCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -8),
            shimmerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 8),
            shimmerCollectionView.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height*0.925+topbarHeight),
        ])

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    @objc func shareSelected(){
        
    }
    
    var viewTranslation = CGPoint(x: 0, y: 0)
    @objc func PanGestureFunc(sender: UIPanGestureRecognizer){
//        if sender.translation(in: view).y <= 0{
            switch sender.state {
            case .changed:
                viewTranslation = sender.translation(in: view)
                print(viewTranslation.y, "F")

                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
                    self.CollectionContainer.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                } completion: { (_) in

                }
            case .ended:
                print(viewTranslation.y)
                if viewTranslation.y > -100{
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
                        self.CollectionContainer.transform = .identity
                    } completion: { (_) in
                    }

                }else {
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
                        self.CollectionContainer.transform = CGAffineTransform(translationX: 0, y: -self.profileView.frame.height-8)
                    } completion: { (_) in
//                        self.CollectionView.isUserInteractionEnabled = true
                    }
                    print("DONE")
                }
            default:
                break
            }
//        }
    }

    lazy var shimmerProfileImage:ShimmeringView = {
       let view = ShimmeringView()
        view.shimmerSpeed = 10
        view.shimmerPauseDuration = 1.5
        let blackView = UIView()
        view.shimmerAnimationOpacity = 0.6
        blackView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)

        blackView.clipsToBounds = true
        blackView.layer.cornerRadius = (UIScreen.main.bounds.height*0.14)/2
        view.contentView = blackView
        view.isShimmering = true

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var shimmerCollectionView:ShimmeringView = {
       let view = ShimmeringView()
        view.shimmerSpeed = 10
        view.shimmerPauseDuration = 1.5
        let blackView = UIView()
        view.shimmerAnimationOpacity = 0.6
        blackView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)

        blackView.clipsToBounds = true
        blackView.layer.cornerRadius = (UIScreen.main.bounds.height*0.14)/2
        view.contentView = blackView
        view.isShimmering = true

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    

    
    let profileView: UIView = {
     let view = UIView()
//        view.backgroundColor = UIColor(red: 255/255, green: 254/255, blue: 242/255, alpha: 1)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    fileprivate lazy var profileImage: CustomUserImage = {
        let imageView = CustomUserImage()
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = (view.frame.height*0.14)/2
        imageView.image = userItem!.profileImg
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()
    lazy var usernameLbl: UILabel = {
        let label = UILabel()
//        name
        label.attributedText = NSAttributedString(string: userItem!.username, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: view.frame.height*0.045, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.black])
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    fileprivate lazy var bioText: UILabel = {
        let label = UILabel()
//        "Follow me on Tiktok and Instagram!😘\nFollow me on TikTok mannnnnnnn\n This is what you mean right or is that just me hehehehe"
        label.attributedText = NSAttributedString(string: userItem!.bio!, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: view.frame.height*0.017, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.black])
        label.textAlignment = .center
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    fileprivate lazy var spaceLbl: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "•", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: view.frame.height*0.018), NSAttributedString.Key.foregroundColor: UIColor.white])
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var fanCountLbl: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Fans:\n", attributes:[NSAttributedString.Key.font: UIFont.systemFont(ofSize: view.frame.height*0.016, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor.gray])
        attributedText.append(NSAttributedString(string: "\t \(userItem!.fanCount!)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: view.frame.height*0.021), NSAttributedString.Key.foregroundColor: UIColor.black]))
        label.attributedText = attributedText
        label.textAlignment = .left
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var rankingStatus: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Ranked:\n", attributes:[NSAttributedString.Key.font: UIFont.systemFont(ofSize: view.frame.height*0.016, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor.gray])
        attributedText.append(NSAttributedString(string: "\t"+userItem!.rankedCount!, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: view.frame.height*0.021), NSAttributedString.Key.foregroundColor: UIColor.black]))
        label.attributedText = attributedText
        label.textAlignment = .left
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var answeredStatus: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Answered:\n", attributes:[NSAttributedString.Key.font: UIFont.systemFont(ofSize: view.frame.height*0.016, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor.gray])
        attributedText.append(NSAttributedString(string: "\t"+userItem!.answeredCount!, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: view.frame.height*0.021), NSAttributedString.Key.foregroundColor: UIColor.black]))
        label.attributedText = attributedText
        label.textAlignment = .left
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var spaceLbl2: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "•", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: view.frame.height*0.018), NSAttributedString.Key.foregroundColor: UIColor.white])
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let rankedLottie: AnimationView = {
       let lottie = AnimationView()
        lottie.animation = Animation.named("rankAnimation")
        lottie.play()
        lottie.loopMode = .loop
        lottie.translatesAutoresizingMaskIntoConstraints = false
        return lottie
    }()
    
    
//    CONTENT
    let CollectionContainer: UIView = {
     let view = UIView()
        view.backgroundColor = .white
        
//        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 6.0
        view.layer.shadowOpacity = 0.4
        view.layer.cornerRadius = 35
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let panView: UIView = {
     let view = UIView()
//        view.backgroundColor = UIColor(red: 255/255, green: 254/255, blue: 242/255, alpha: 1)
        
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    fileprivate lazy var upImageIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "BlackUpBtn")
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()
    
    
//    lazy var CollectionView: VerticalCardSwiper = {
//       let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 0
//        let collectionView = VerticalCardSwiper()
//        collectionView.delegate = self
//        collectionView.datasource = self
//        collectionView.isUserInteractionEnabled = false
//        collectionView.isSideSwipingEnabled = false
//        collectionView.backgroundColor = .clear
//        collectionView.register(cardCell.self, forCellWithReuseIdentifier: "testCell")
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        return collectionView
//    }()
//
    
    lazy var MainCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true

        collection.register(profileUnansweredQCell.self, forCellWithReuseIdentifier: "profileUnansweredQCell")
        collection.register(profileAnsweredQCell.self, forCellWithReuseIdentifier: "profileAnsweredQCell")

        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()

    
    
    
    lazy var StackCollection: profileStackView = {
       let stack = profileStackView()
        stack.FeedViewControllerItem = self
        stack.backgroundColor = .clear
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    lazy var backgroundImgView: UIView = {
      let imageView = UIView()
       var blurEffect = UIBlurEffect()
        imageView.backgroundColor = .white
        imageView.isUserInteractionEnabled = false
       let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.clear.cgColor,UIColor.white.cgColor]
        gradient.locations = [0.0,0.1]

       imageView.layer.mask = gradient
       imageView.clipsToBounds = true
       imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
   }()
    
    
    
    
    
    
    
    let instaBtn: UIButton = {
       let btn = UIButton()
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 34, bottom: 0, right: 0)
//        btn.backgroundColor = UIColor(red: 225/255, green: 48/255, blue: 108/255, alpha: 1)
        btn.backgroundColor = .white
//        btn.layer.borderColor = UIColor(red: 225/255, green: 210/255, blue:210/255, alpha: 1).cgColor
        
//        btn.layer.borderWidth = 1
//        btn.layer.borderColor = UIColor(red: 235/255, green: 52/255, blue: 97/255, alpha: 1).cgColor.copy(alpha: 0.6)
        btn.layer.cornerRadius = 4
        btn.layer.shadowColor = UIColor.lightGray.cgColor
        btn.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        btn.layer.shadowRadius = 3.0
        btn.layer.shadowOpacity = 0.4
//        btn.setAttributedTitle(NSAttributedString(string: "Instagram", attributes: [NSAttributedString.Key.foregroundColor:UIColor(red: 225/255, green: 48/255, blue: 108/255, alpha: 1), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold)]), for: .normal)
        btn.addTarget(self, action: #selector(instagramSelected), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let InstagramIcon: UIImageView = {
        let Instagram = UIImageView()
        Instagram.image = UIImage(named: "Instagram")
        Instagram.translatesAutoresizingMaskIntoConstraints = false
        return Instagram
    }()
    
    let TiktokIcon: UIImageView = {
        let Instagram = UIImageView()
        Instagram.image = UIImage(named: "Tiktok")
        Instagram.translatesAutoresizingMaskIntoConstraints = false
        return Instagram
    }()
    
    let TiktokBtn: UIButton = {
       let btn = UIButton()
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 34)
//        btn.backgroundColor = UIColor(red: 255/255, green: 248/255, blue: 248/255, alpha: 1)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 4
//        btn.layer.borderWidth = 1
//        btn.layer.borderColor = UIColor.darkGray.cgColor.copy(alpha: 0.6)
        btn.layer.shadowColor = UIColor.lightGray.cgColor
        btn.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        btn.layer.shadowRadius = 3.0
        btn.layer.shadowOpacity = 0.4
//        btn.setAttributedTitle(NSAttributedString(string: "Tiktok", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold)]), for: .normal)
        btn.addTarget(self, action: #selector(tiktokSelected), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var BecomeFanBtn: UIButton = {
       let btn = UIButton()
        btn.layer.cornerRadius = 21
        btn.addTarget(self, action: #selector(fanSelected), for: .touchUpInside)
        if realmObjc.objects(fanOfObject.self).filter("id = %@", Fid!).isEmpty{
            btn.backgroundColor = .white
            btn.setAttributedTitle(NSAttributedString(string: "🤩 Fan", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 235/255, green: 52/255, blue: 97/255, alpha: 1), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)]), for: .normal)
            btn.layer.borderColor = TealConstantColor.cgColor
            btn.layer.borderWidth = 1
        }else{
            btn.backgroundColor = TealConstantColor
            btn.setAttributedTitle(NSAttributedString(string: "I'm a Fan", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)]), for: .normal)
            btn.layer.borderWidth = 0
        }
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let QuestionBtn: UIButton = {
       let btn = UIButton()
//        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right:48)
//        btn.backgroundColor = UIColor(red: 255/255, green: 248/255, blue: 248/255, alpha: 1)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 21
//        btn.layer.shadowColor = UIColor.lightGray.cgColor
//        btn.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        btn.layer.shadowRadius = 6.0
//        btn.layer.shadowOpacity = 0.4
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.systemBlue.cgColor
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.setAttributedTitle(NSAttributedString(string: "🙋 Ask", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)]), for: .normal)
        btn.addTarget(self, action: #selector(askQuestionSelected), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    func constraintContainer(){
        DispatchQueue.main.async {
            self.shimmerCollectionView.removeFromSuperview()
            self.shimmerProfileImage.removeFromSuperview()
        }
        
        view.addSubview(profileView)
        profileView.addSubview(profileImage)
        profileView.addSubview(usernameLbl)
        profileView.addSubview(fanCountLbl)
        profileView.addSubview(spaceLbl)
        profileView.addSubview(spaceLbl2)
        profileView.addSubview(rankingStatus)
        profileView.addSubview(answeredStatus)
        profileView.addSubview(instaBtn)
        instaBtn.addSubview(InstagramIcon)
        profileView.addSubview(TiktokBtn)
        TiktokBtn.addSubview(TiktokIcon)
        profileView.addSubview(BecomeFanBtn)
        profileView.addSubview(QuestionBtn)
        
        profileView.addSubview(bioText)
        
        view.addSubview(CollectionContainer)
        CollectionContainer.addSubview(upImageIcon)
        CollectionContainer.addSubview(MainCollectionView)
        CollectionContainer.addSubview(panView)
        CollectionContainer.addSubview(backgroundImgView)
        CollectionContainer.addSubview(StackCollection)
        NSLayoutConstraint.activate([

            profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:12),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            profileView.bottomAnchor.constraint(equalTo: CollectionContainer.topAnchor, constant: -8),
            
            profileImage.topAnchor.constraint(equalTo: profileView.topAnchor, constant: 12),
            profileImage.centerXAnchor.constraint(equalTo: profileView.centerXAnchor),
            profileImage.heightAnchor.constraint(equalTo: profileView.heightAnchor, multiplier: 0.3),
            profileImage.widthAnchor.constraint(equalTo: profileImage.heightAnchor),
            
            usernameLbl.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 12),
            usernameLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameLbl.heightAnchor.constraint(equalToConstant: usernameLbl.intrinsicContentSize.height),
            
            fanCountLbl.centerYAnchor.constraint(equalTo: rankingStatus.centerYAnchor, constant: 0),
            fanCountLbl.leadingAnchor.constraint(equalTo: spaceLbl2.trailingAnchor, constant: 8),
            
            rankingStatus.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rankingStatus.topAnchor.constraint(equalTo: usernameLbl.bottomAnchor, constant: 4),
            rankingStatus.widthAnchor.constraint(equalToConstant: rankingStatus.intrinsicContentSize.width),
            
            spaceLbl2.leadingAnchor.constraint(equalTo: rankingStatus.trailingAnchor, constant: 8),
            spaceLbl2.centerYAnchor.constraint(equalTo: rankingStatus.centerYAnchor),
            spaceLbl2.widthAnchor.constraint(equalToConstant: spaceLbl2.intrinsicContentSize.width),
            
            spaceLbl.trailingAnchor.constraint(equalTo: rankingStatus.leadingAnchor, constant: -8),
            spaceLbl.centerYAnchor.constraint(equalTo: rankingStatus.centerYAnchor),
            spaceLbl.widthAnchor.constraint(equalToConstant: spaceLbl.intrinsicContentSize.width),
            
            answeredStatus.trailingAnchor.constraint(equalTo: spaceLbl.leadingAnchor, constant: -8),
            answeredStatus.centerYAnchor.constraint(equalTo: rankingStatus.centerYAnchor),
            
            instaBtn.topAnchor.constraint(equalTo: rankingStatus.bottomAnchor, constant: 8),
            instaBtn.widthAnchor.constraint(equalToConstant: view.frame.height*0.05),
            instaBtn.heightAnchor.constraint(equalToConstant: view.frame.height*0.05),
            instaBtn.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -8),
            
            InstagramIcon.heightAnchor.constraint(equalTo: instaBtn.heightAnchor, constant: -11),
            InstagramIcon.widthAnchor.constraint(equalTo: instaBtn.heightAnchor, constant: -11),
            InstagramIcon.centerXAnchor.constraint(equalTo: instaBtn.centerXAnchor),
            InstagramIcon.centerYAnchor.constraint(equalTo: instaBtn.centerYAnchor),
            
            TiktokBtn.topAnchor.constraint(equalTo: rankingStatus.bottomAnchor, constant: 8),
            TiktokBtn.widthAnchor.constraint(equalToConstant: view.frame.height*0.05),
            TiktokBtn.heightAnchor.constraint(equalToConstant: view.frame.height*0.05),
            TiktokBtn.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 8),
            
            TiktokIcon.heightAnchor.constraint(equalTo: TiktokBtn.heightAnchor, constant: -19),
            TiktokIcon.widthAnchor.constraint(equalTo: TiktokBtn.heightAnchor, constant: -19),
            TiktokIcon.centerXAnchor.constraint(equalTo: TiktokBtn.centerXAnchor),
            TiktokIcon.centerYAnchor.constraint(equalTo: TiktokBtn.centerYAnchor),
            
            bioText.topAnchor.constraint(equalTo: TiktokBtn.bottomAnchor, constant: 16),
            bioText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bioText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            BecomeFanBtn.topAnchor.constraint(equalTo: bioText.bottomAnchor, constant: 16),
            BecomeFanBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            BecomeFanBtn.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -12),
            BecomeFanBtn.heightAnchor.constraint(equalToConstant: BecomeFanBtn.intrinsicContentSize.height+18),
            
            QuestionBtn.topAnchor.constraint(equalTo: bioText.bottomAnchor, constant: 16),
            QuestionBtn.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 12),
            QuestionBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            QuestionBtn.heightAnchor.constraint(equalToConstant: QuestionBtn.intrinsicContentSize.height+18),
            
//            CONTENT
            CollectionContainer.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.safeAreaLayoutGuide.layoutFrame.height*0.35),
            CollectionContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -8),
            CollectionContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 8),
            CollectionContainer.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height*0.925+topbarHeight),
            
            panView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            panView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            panView.topAnchor.constraint(equalTo: CollectionContainer.topAnchor),
            panView.heightAnchor.constraint(equalToConstant: 60),
            
            upImageIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            upImageIcon.topAnchor.constraint(equalTo: CollectionContainer.topAnchor, constant: 8),
            upImageIcon.widthAnchor.constraint(equalToConstant: 28),
            upImageIcon.heightAnchor.constraint(equalToConstant: 28),
            
            MainCollectionView.topAnchor.constraint(equalTo: upImageIcon.bottomAnchor, constant: 8),
            MainCollectionView.leadingAnchor.constraint(equalTo: CollectionContainer.leadingAnchor),
            MainCollectionView.trailingAnchor.constraint(equalTo: CollectionContainer.trailingAnchor),
            MainCollectionView.bottomAnchor.constraint(equalTo: CollectionContainer.bottomAnchor),
            
            StackCollection.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            StackCollection.heightAnchor.constraint(equalToConstant: 68),
            StackCollection.bottomAnchor.constraint(equalTo: CollectionContainer.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            StackCollection.centerXAnchor.constraint(equalTo: CollectionContainer.centerXAnchor),

            backgroundImgView.bottomAnchor.constraint(equalTo: CollectionContainer.bottomAnchor),
            backgroundImgView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImgView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImgView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
        ])
    }

    @objc func askQuestionSelected(){
        if realmObjc.objects(usedQuestions.self).filter("id = %@", Fid!).count == 0{
            generator.impactOccurred()
                    if let window = UIApplication.shared.keyWindow{
                        blackWindow.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
                        blackWindow.backgroundColor = UIColor(white: 0, alpha: 0.7)
                        blackWindow.alpha = 0
                        view.addSubview(blackWindow)

                        UIView.animate(withDuration: 0.5) {
                            self.blackWindow.alpha = 1
                        }
            }
            let vc = AskAQuestionView()
            vc.delegate = self
            vc.influencerFid = Fid
            vc.influencerName = usernameLbl.text

            vc.hidesBottomBarWhenPushed = true
            vc.modalPresentationStyle = .overCurrentContext
            self.tabBarController?.tabBar.isHidden = true
            present(vc, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "0 Questions Remaining", message:"To prevent spamming, every user is limited to one question." , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    @objc func fanSelected(){
        BecomeFanBtn.isEnabled = false
        
        let attributedText = NSMutableAttributedString(string: "Fans:\n", attributes:[NSAttributedString.Key.font: UIFont.systemFont(ofSize: self.view.frame.height*0.016, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        if BecomeFanBtn.backgroundColor == .white{
            BecomeFanBtn.backgroundColor = UIColor(red: 255/255, green: 90/255, blue: 95/255, alpha: 1)
            BecomeFanBtn.setAttributedTitle(NSAttributedString(string: "I'm a Fan", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)]), for: .normal)
            BecomeFanBtn.layer.borderWidth = 0
            
            let fanItem = fanOfObject()
            fanItem.id = Fid!
            fanItem.username = userItem!.username
            
            try! realmObjc.write{
                realmObjc.add(fanItem)
            }


            db.collection("user").document("U").collection("users").document(realmObjc.objects(userObject.self)[0].FID).collection("fanOf").addDocument(data: ["id" : Fid!, "username":userItem!.username])
            
            db.collection("user").document("I").collection("users").document(Fid!).getDocument { (snapshot, error) in
                if error == nil{
                    db.collection("user").document("I").collection("users").document(self.Fid!).updateData(["fanCount":snapshot?.data()!["fanCount"] as! Int + 1])}
                attributedText.append(NSAttributedString(string: "\t \(snapshot?.data()!["fanCount"] as! Int + 1)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: self.view.frame.height*0.021), NSAttributedString.Key.foregroundColor: UIColor.black]))
                self.fanCountLbl.attributedText = attributedText
            }
            
        }else{
            
            BecomeFanBtn.backgroundColor = .white
            BecomeFanBtn.setAttributedTitle(NSAttributedString(string: "🤩 Fan", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 235/255, green: 52/255, blue: 97/255, alpha: 1), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)]), for: .normal)
            BecomeFanBtn.layer.borderWidth = 1
            BecomeFanBtn.layer.borderColor = TealConstantColor.cgColor
            
            try! realmObjc.write{
                realmObjc.delete(realmObjc.objects(fanOfObject.self).filter("id = %@", Fid!))
            }
            
            db.collection("user").document("I").collection("users").document(Fid!).getDocument { (snapshot, error) in
                if error == nil{
                    db.collection("user").document("I").collection("users").document(self.Fid!).updateData(["fanCount":snapshot?.data()!["fanCount"] as! Int - 1])}
                attributedText.append(NSAttributedString(string: "\t \(snapshot?.data()!["fanCount"] as! Int - 1)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: self.view.frame.height*0.021), NSAttributedString.Key.foregroundColor: UIColor.black]))
                self.fanCountLbl.attributedText = attributedText
            }
            
           let item = db.collection("user").document("U").collection("users").document(realmObjc.objects(userObject.self)[0].FID).collection("fanOf")
            item.whereField("id", isEqualTo: Fid!).getDocuments { (snaps, error) in
                snaps?.documents.forEach({ (snap) in
                    item.document(snap.documentID).delete()
                })
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.BecomeFanBtn.isEnabled = true
        }
    }
    
    
    @objc func tiktokSelected(){
        UIApplication.shared.open((URL(string: "https://www.tiktok.com/@\(userItem!.tiktokHandle!)") ?? URL(string: "https://www.tiktok.com"))!, options: [:], completionHandler: nil)
    }
    @objc func instagramSelected(){
        let instagramHooks = "instagram://user?username"+userItem!.instagramHandle!
        let instagramUrl = NSURL(string: instagramHooks)
        if UIApplication.shared.canOpenURL(instagramUrl! as URL) {
            UIApplication.shared.openURL(instagramUrl! as URL)
        } else {
          //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.openURL(NSURL(string: "http://instagram.com/\(userItem!.instagramHandle!)")! as URL)
        }
    }
}







extension ViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{

//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset.x)
//    }
//    
//    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
//        return answeredQs.count
//    }
//
//    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
//        let cell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "testCell", for: index) as! cardCell
//        cell.answernLbl.text = answeredQs[index].answer
//        cell.date.text = "🕘 \(answeredQs[index].date)"
//        cell.influencerUsername.text = userItem?.username
//        cell.qAnswered.text = "✨ \(answeredQs[index].points) Points"
//        cell.username.text = answeredQs[index].username
//        cell.questionLbl.text = answeredQs[index].question
//
//        if answeredQs[index].hasImage{
//            storage.reference().child(answeredQs[index].id+"img.png").getData(maxSize: 1*1024*1024) { (data, error) in
//                if error == nil {
//                    cell.questionImage.image = UIImage(data: data! as Data)
//                }
//            }
//        }
//        cell.answerImage.image = userItem?.profileImg
//        cell.completeRequest = self
//        return cell
//    }
//
//    func sizeForItem(verticalCardSwiperView: VerticalCardSwiperView, index: Int) -> CGSize {
//        return CGSize(width: verticalCardSwiperView.frame.width, height: verticalCardSwiperView.frame.height-view.frame.height*0.05)
//    }

    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        StackCollection.widthHorizontalBar?.constant = 20

        StackCollection.leftHorizontalBar?.constant = (view.frame.width*0.176) + scrollView.contentOffset.x/(view.safeAreaLayoutGuide.layoutFrame.width*0.00607)
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let item = targetContentOffset.pointee.x/view.frame.width
        StackCollection.stackOptionCollectionView.selectItem(at: NSIndexPath(item: Int(item), section: 0) as IndexPath, animated: true, scrollPosition: .init())
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if indexPath.row == 0{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileAnsweredQCell", for: indexPath) as! profileAnsweredQCell
                cell.Fid = Fid
                //                cell.accountSelected = self
                cell.userItem = userItem!
                cell.completeRequest = self

                 return cell
                
            }else{

                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileUnansweredQCell", for: indexPath) as! profileUnansweredQCell
                cell.accountSelected = self
                cell.userId = Fid!
                return cell
            }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
    
    
    

}

class cardCell: CardCell{
    override init(frame: CGRect){
        super.init(frame: frame)
        constraintContainer()
    }
    var completeRequest: completeRequest?
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
        imageView.layer.cornerRadius = (frame.height*0.065)/1.5
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.image = UIImage(named: "placeholderProfileImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()
    
    let username: UILabel = {
       let lbl = UILabel()
        lbl.text = "Caleb Mesfien"
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        lbl.textColor = .white
        lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let date: UILabel = {
       let lbl = UILabel()
        lbl.text = "🕘 3:29 PM"
        lbl.font = UIFont.boldSystemFont(ofSize: 13)
        lbl.textColor = .white
        lbl.backgroundColor = TealConstantColor
        lbl.clipsToBounds = true
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 8
        lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    let qAnswered: UILabel = {
       let lbl = UILabel()
        lbl.text = "✨ 34 Points"
        lbl.font = UIFont.boldSystemFont(ofSize: 13)
        lbl.textColor = .darkGray
        lbl.backgroundColor = .white
        lbl.clipsToBounds = true
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 8
        lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    let questionLbl: UILabel = {
       let lbl = UILabel()
        lbl.text = "Fades away to me I don’t have a good app for the first thing I love the way I do this app is very good app to have it with me I have to say that it was worth the money and it was n"
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 24)
        lbl.textColor = .white
        lbl.numberOfLines = 0
        lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    
    
//    INFLUENCER VIEW
    let answernLbl: UILabel = {
       let lbl = UILabel()
        lbl.text = "Fades away to me I don’t have a good app for the first thing I love the way I do this app is very good app to have it with me I have to say that it was worth the money and it was n"
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 30)
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    let answerView: UIView = {
     let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 6.0
        view.layer.shadowOpacity = 0.3
        view.layer.cornerRadius = 30
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var answerImage: CustomUserImage = {
        let imageView = CustomUserImage()
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = (frame.height*0.07)/1.5
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.image = UIImage(named: "placeholderProfileImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()
    
    let influencerUsername: UILabel = {
       let lbl = UILabel()
        lbl.text = "Addison Rae"
        lbl.font = UIFont.boldSystemFont(ofSize: 28)
        lbl.textColor = .black
        lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    lazy var instagramStoriesBtn: UIButton = {
      let btn = UIButton()
        btn.backgroundColor = .clear
       btn.addTarget(self, action: #selector(instagramSelected), for: .touchUpInside)
//        btn.layer.cornerRadius = 8
       btn.translatesAutoresizingMaskIntoConstraints = false
       return btn
   }()
    
    lazy var instagramStoriesImg: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "blackInstagramStories")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    lazy var menuBtn: UIButton = {
      let btn = UIButton()
       btn.setImage(UIImage(named: "menu"), for: .normal)
       btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(menuSelected), for: .touchUpInside)
       btn.translatesAutoresizingMaskIntoConstraints = false
       return btn
   }()
   
    let instagramStoriesLabel: CustomLabel  = {
      let label = CustomLabel()
       label.numberOfLines = 2
        label.attributedText = NSAttributedString(string: "Add to\nInstagram Story", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11, weight: .bold)])
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()
    func constraintContainer(){
        addSubview(questionView)
        questionView.addSubview(questionLbl)
        questionView.addSubview(questionImage)
        questionView.addSubview(username)
        questionView.addSubview(qAnswered)
        
        addSubview(answerView)
        answerView.addSubview(answernLbl)
        answerView.addSubview(answerImage)
        answerView.addSubview(influencerUsername)
        answerView.addSubview(date)
        
        answerView.addSubview(instagramStoriesBtn)
        answerView.addSubview(menuBtn)
        instagramStoriesBtn.addSubview(instagramStoriesImg)
        instagramStoriesBtn.addSubview(instagramStoriesLabel)
        NSLayoutConstraint.activate([
            questionView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            questionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            questionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            questionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.32),
            
            questionImage.topAnchor.constraint(equalTo: questionView.topAnchor, constant: 12),
            questionImage.leadingAnchor.constraint(equalTo: questionView.leadingAnchor, constant: 12),
            questionImage.bottomAnchor.constraint(equalTo: qAnswered.bottomAnchor, constant: 4),
            questionImage.widthAnchor.constraint(equalTo: questionImage.heightAnchor),
            
            username.leadingAnchor.constraint(equalTo: questionImage.trailingAnchor, constant: 8),
            username.topAnchor.constraint(equalTo: questionImage.topAnchor),
            username.trailingAnchor.constraint(equalTo: questionView.trailingAnchor, constant: -12),
            username.heightAnchor.constraint(equalToConstant: username.intrinsicContentSize.height),
            
            qAnswered.leadingAnchor.constraint(equalTo: questionImage.trailingAnchor, constant: 8),
            qAnswered.topAnchor.constraint(equalTo: username.bottomAnchor),
            qAnswered.widthAnchor.constraint(equalToConstant: qAnswered.intrinsicContentSize.width + 16),
            qAnswered.heightAnchor.constraint(equalToConstant: qAnswered.intrinsicContentSize.height + 12),

            questionLbl.topAnchor.constraint(equalTo: questionImage.bottomAnchor, constant: 8),
            questionLbl.leadingAnchor.constraint(equalTo: questionView.leadingAnchor, constant: 16),
            questionLbl.trailingAnchor.constraint(equalTo: questionView.trailingAnchor, constant: -16),
            questionLbl.bottomAnchor.constraint(equalTo: questionView.bottomAnchor, constant: -12),
            
            
            answerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            answerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            answerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            answerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),

            answerImage.topAnchor.constraint(equalTo: answerView.topAnchor, constant: 12),
            answerImage.leadingAnchor.constraint(equalTo: answerView.leadingAnchor, constant: 12),
            answerImage.bottomAnchor.constraint(equalTo: date.bottomAnchor, constant: 4),
//            answerImage.heightAnchor.constraint(equalTo: answerView.heightAnchor, multiplier: 0.2),
            answerImage.widthAnchor.constraint(equalTo: answerImage.heightAnchor),
            
            
            date.leadingAnchor.constraint(equalTo: answerImage.trailingAnchor, constant: 8),
            date.topAnchor.constraint(equalTo: influencerUsername.bottomAnchor),
            date.widthAnchor.constraint(equalToConstant: date.intrinsicContentSize.width + 16),
            date.heightAnchor.constraint(equalToConstant: date.intrinsicContentSize.height + 12),
            
            influencerUsername.leadingAnchor.constraint(equalTo: answerImage.trailingAnchor, constant: 8),
            influencerUsername.topAnchor.constraint(equalTo: answerImage.topAnchor),
            influencerUsername.trailingAnchor.constraint(equalTo: answerView.trailingAnchor, constant: -12),
            influencerUsername.heightAnchor.constraint(equalToConstant: influencerUsername.intrinsicContentSize.height),
            

            answernLbl.topAnchor.constraint(equalTo: answerImage.bottomAnchor, constant: 8),
            answernLbl.leadingAnchor.constraint(equalTo: answerView.leadingAnchor, constant: 18),
            answernLbl.trailingAnchor.constraint(equalTo: answerView.trailingAnchor, constant: -18),
            answernLbl.bottomAnchor.constraint(equalTo: instagramStoriesBtn.topAnchor, constant: -12),
            
            instagramStoriesBtn.heightAnchor.constraint(equalToConstant: 30),
            instagramStoriesBtn.leadingAnchor.constraint(equalTo: answerView.leadingAnchor, constant: 8),
            instagramStoriesBtn.trailingAnchor.constraint(equalTo: menuBtn.leadingAnchor,constant: -12),
            instagramStoriesBtn.bottomAnchor.constraint(equalTo: answerView.bottomAnchor, constant: -12),
            
            instagramStoriesImg.bottomAnchor.constraint(equalTo: instagramStoriesBtn.bottomAnchor, constant: -2),
            instagramStoriesImg.leadingAnchor.constraint(equalTo:instagramStoriesBtn.leadingAnchor, constant: 8),
            instagramStoriesImg.topAnchor.constraint(equalTo: instagramStoriesBtn.topAnchor, constant: 2),
            instagramStoriesImg.widthAnchor.constraint(equalTo: instagramStoriesImg.heightAnchor),

            instagramStoriesLabel.leadingAnchor.constraint(equalTo: instagramStoriesImg.trailingAnchor, constant: 8),
            instagramStoriesLabel.topAnchor.constraint(equalTo: instagramStoriesBtn.topAnchor),
            instagramStoriesLabel.trailingAnchor.constraint(equalTo: instagramStoriesBtn.trailingAnchor),
            instagramStoriesLabel.bottomAnchor.constraint(equalTo: instagramStoriesBtn.bottomAnchor),
            
            menuBtn.trailingAnchor.constraint(equalTo: answerView.trailingAnchor, constant: -18),
            menuBtn.bottomAnchor.constraint(equalTo: answerView.bottomAnchor, constant: -12),
            menuBtn.widthAnchor.constraint(equalTo: menuBtn.heightAnchor),
            menuBtn.heightAnchor.constraint(equalTo: instagramStoriesBtn.heightAnchor, multiplier: 0.8),
            
        ])
    }
    
    @objc func instagramSelected(){
        completeRequest?.complete(item: 0, questionImage: questionImage.image!, answerImage: answerImage.image!, fanUsername: username.text!, influencerUsername: influencerUsername.text!, date: date.text!, question: questionLbl.text!, answer: answernLbl.text!)
        
    }
    @objc func menuSelected(){
//        completeRequest?.complete(item: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





class profileUnansweredQCell: UICollectionViewCell, questionSelected, updateList{
    func updateTheList(item: Int) {
        unAnsweredQList.remove(at: item)
        DispatchQueue.main.async {
            self.featuredCollectionView.reloadData()
        }
    }
    
    func selectedQ(question:String, transmitterUsername: String, transmitterId:String, points: Int, hasImage: Bool,  Id: String){
        accountSelected?.selectedQ(question: question, transmitterUsername: transmitterUsername, transmitterId:transmitterId, points: points, hasImage: hasImage, Id: Id)
    }
    
    let realmObjc = try! Realm()
    var accountSelected: questionSelected?
    var userId = String(){
        didSet{
            fetchFeaturedData(userId)
            
            if realmObjc.objects(usedPromotions.self).filter("id == %@", userId).isEmpty{
                countLbl.attributedText = NSAttributedString(string: "3", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 21)])
            }else{
                let item = realmObjc.objects(usedPromotions.self).filter("id == %@", userId)[0].itemCount
                countLbl.attributedText = NSAttributedString(string: "\(3-item)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 21)])
            }
        }
    }
    
    var unAnsweredQList = [UnAnsweredQuestions]()
    func fetchFeaturedData(_ userId: String){
//
        let database = db.collection("user").document("I").collection("users").document(userId).collection("unanswered")

        database.addSnapshotListener { (snapshots, error) in

            snapshots?.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    let snapshot = diff.document
                        let username = snapshot.data()["username"] as! String
                        let points = snapshot.data()["points"] as! Int
                        let date = snapshot.data()["date"] as! String
                        let question = snapshot.data()["question"] as! String
                        let id = snapshot.data()["id"] as! String
                        let hasImage = snapshot.data()["hasImage"] as! Bool
                        let like = snapshot.data()["likes"] as Any

                    let item = UnAnsweredQuestions(username: username, points: points, question: question, date: date, id: id, hasImage:hasImage, likes: like as! Int, questionId: snapshot.documentID)
                        self.unAnsweredQList.append(item)

                    let num = self.featuredCollectionView.numberOfItems(inSection: 0)
                        let lastItemIndex = IndexPath(item: num, section: 0)
                        self.featuredCollectionView.performBatchUpdates({ () -> Void in
                            self.featuredCollectionView.insertItems(at:[lastItemIndex])
                        }, completion: nil)

                    
                }
//                if (diff.type == .modified) {
//                    print("Modified city: \(diff.document.data())")
//                }
                if (diff.type == .removed) {
                    print("Removed city: \(diff.document.data())")
                    let firstIndex = self.unAnsweredQList.firstIndex(where: { $0.id == diff.document.data()["id"] as! String })
                    print("foundFOUND", firstIndex!)
                    self.unAnsweredQList.remove(at: firstIndex!)
//                    if self.unAnsweredQList.count == 0{
//                        self.featuredCollectionView.reloadData()
//                    }else{
                        let lastItemIndex = IndexPath(item: firstIndex!, section: 0)
                        self.featuredCollectionView.performBatchUpdates({ () -> Void in
                            self.featuredCollectionView.deleteItems(at:[lastItemIndex])
                        }, completion: nil)
//                    }
                }

            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    func setUp(){
        addSubview(remainingView)
        remainingView.addSubview(staticCountLbl)
        remainingView.addSubview(countLbl)
        addSubview(featuredCollectionView)
         NSLayoutConstraint.activate([
            remainingView.topAnchor.constraint(equalTo: topAnchor),
            remainingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            remainingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            remainingView.heightAnchor.constraint(equalToConstant: 50),
            
            staticCountLbl.leadingAnchor.constraint(equalTo: remainingView.leadingAnchor, constant: 8),
            staticCountLbl.centerYAnchor.constraint(equalTo: remainingView.centerYAnchor),
            
            countLbl.trailingAnchor.constraint(equalTo: remainingView.trailingAnchor, constant: -16),
            countLbl.centerYAnchor.constraint(equalTo: remainingView.centerYAnchor),
            
            featuredCollectionView.topAnchor.constraint(equalTo: remainingView.bottomAnchor, constant: 8),
             featuredCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
             featuredCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
             featuredCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
         ])
    }
    
    let staticCountLbl: UILabel = {
       let lbl = UILabel()
        lbl.attributedText = NSAttributedString(string: "Likes Remaining:", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1), NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    lazy var countLbl: UILabel = {
       let lbl = UILabel()

        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let remainingView: UIView = {
       let view = UIView()
//        view.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        view.layer.shadowColor = UIColor.systemBlue.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 5.0
        view.layer.shadowOpacity = 0.6
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 10

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var featuredCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout:layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        layout.minimumLineSpacing = 0

        collectionView.register(questionCell.self, forCellWithReuseIdentifier: "questionCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension profileUnansweredQCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if unAnsweredQList.count == 0{
            print("NOTHING IS HERE")
            return 0
        }
        return unAnsweredQList.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "questionCell", for: indexPath) as! questionCell
        cell.tag = indexPath.row
        if cell.tag == indexPath.row{
            cell.accountSelected = self
            cell.questionLbl.text = unAnsweredQList[indexPath.row].question
            cell.date.text = "🕘 \(unAnsweredQList[indexPath.row].date)"
            cell.likes.text = "\(unAnsweredQList[indexPath.row].likes)"
            if unAnsweredQList[indexPath.row].hasImage{
                storage.reference().child(unAnsweredQList[indexPath.row].id + "img.png").getData(maxSize: 1*1024*1024) { (data, error) in
                    if error == nil {
                        cell.questionImage.image = UIImage(data: data!)
                    }
                }
            }
        }
            return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeOfItem = CGSize(width: collectionView.frame.width-52, height: 1000)
        
        let item = NSString(string: unAnsweredQList[indexPath.row].question).boundingRect(with:sizeOfItem , options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24)], context: nil)
        
                    let size = CGSize(width:collectionView.frame.width, height: item.height + 92)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top:0, left: 0, bottom: frame.height*0.15, right: 0)
        }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedQ(question: unAnsweredQList[indexPath.row].question, transmitterUsername: unAnsweredQList[indexPath.row].username, transmitterId:unAnsweredQList[indexPath.row].id, points: unAnsweredQList[indexPath.row].points, hasImage: unAnsweredQList[indexPath.row].hasImage, Id: unAnsweredQList[indexPath.row].questionId)
    }
    
}


class profileAnsweredQCell: UICollectionViewCell, accountSelected, completeRequest{
    func complete(item: Int, questionImage: UIImage, answerImage: UIImage, fanUsername: String, influencerUsername: String, date: String, question: String, answer:String){
        completeRequest?.complete(item: item, questionImage: questionImage , answerImage: answerImage, fanUsername: fanUsername, influencerUsername: influencerUsername, date: date, question: question, answer: answer)
    }
    var numOfAnswers: Int?
    var userItem: InfluUser?{
        didSet{
     
        }
    }
    
    func selectedAccount(id: String) {
        accountSelected?.selectedAccount(id: id)
    }

    var Fid: String?{
        didSet{
            let user = db.collection("user").document("I").collection("users").document(Fid!)

            user.collection("answered").getDocuments { (snap, error) in
                self.numOfAnswers = snap?.documents.count
                snap?.documents.forEach({ (item) in
                    let answer = item.data()["answer"] as! String
                    let date = item.data()["date"] as! String
                    let hasImage = item.data()["hasImage"] as! Bool
                    let points = item.data()["points"] as! Int
                    let question = item.data()["question"] as! String
                    let username = item.data()["username"] as! String
                    let id = item.data()["id"] ?? "adyupYuRdtgpMxyBPbhu"
                    
                    let dateFormatterGet = DateFormatter()
                    let dateFormatter = DateFormatter()
                    dateFormatterGet.dateFormat = "MMM d, yyyy, h:mm a"
                    let Ndate = dateFormatterGet.date(from: (date))
                    if Calendar.current.isDateInToday(Ndate!){
                        dateFormatter.dateFormat = "h:mm a"
                    }else{
                        dateFormatter.dateFormat = "MMM d"
                    }
                    let newDate = dateFormatter.string(from: Ndate! as Date)
                    
                    
                    
                    let ansItem = answeredQ(username: username, points: points, question: question, answer: answer, date: newDate,id: id as! String, hasImage: hasImage)
                    
                    self.answeredQs.append(ansItem)
                })
            }
        }
    }
    
    
    var answeredQs = [answeredQ](){
        didSet{
            if answeredQs.count == numOfAnswers{
                addSubview(remainingView)
                remainingView.addSubview(staticCountLbl)
                remainingView.addSubview(countLbl)
                addSubview(featuredCollectionView)
                 NSLayoutConstraint.activate([
                    remainingView.topAnchor.constraint(equalTo: topAnchor),
                    remainingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
                    remainingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
                    remainingView.heightAnchor.constraint(equalToConstant: 50),
                    
                    staticCountLbl.leadingAnchor.constraint(equalTo: remainingView.leadingAnchor, constant: 8),
                    staticCountLbl.centerYAnchor.constraint(equalTo: remainingView.centerYAnchor),
                    
                    countLbl.trailingAnchor.constraint(equalTo: remainingView.trailingAnchor, constant: -16),
                    countLbl.centerYAnchor.constraint(equalTo: remainingView.centerYAnchor),
                    
                    
                    featuredCollectionView.topAnchor.constraint(equalTo: remainingView.bottomAnchor, constant: -28),
                    featuredCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    featuredCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    featuredCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
                ])
            }
        }
    }
    
    
    
    
    let realmObjc = try! Realm()
    var accountSelected: accountSelected?
    var completeRequest: completeRequest?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    let staticCountLbl: UILabel = {
       let lbl = UILabel()
        lbl.attributedText = NSAttributedString(string: "Questions Remaining:", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1), NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    lazy var countLbl: UILabel = {
       let lbl = UILabel()
        let item = realmObjc.objects(usedQuestions.self).filter("id = %@", Fid!).count
        if item == 0{
            lbl.attributedText = NSAttributedString(string: "1", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 21)])
        }else{
            lbl.attributedText = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 21)])
        }

        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let remainingView: UIView = {
       let view = UIView()
//        view.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        view.layer.shadowColor = UIColor.systemBlue.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 5.0
        view.layer.shadowOpacity = 0.6
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 10

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    


    lazy var featuredCollectionView: VerticalCardSwiper = {
       let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let collectionView = VerticalCardSwiper()
        collectionView.delegate = self
        collectionView.datasource = self
        collectionView.backgroundColor = .clear
        collectionView.isSideSwipingEnabled = false
        collectionView.register(cardCell.self, forCellWithReuseIdentifier: "profileAnsweredVert")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension profileAnsweredQCell:  VerticalCardSwiperDatasource, VerticalCardSwiperDelegate{

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            print(scrollView.contentOffset.x)
        }
        func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
            return answeredQs.count
        }
        
        func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
            let cell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "profileAnsweredVert", for: index) as! cardCell
            cell.answernLbl.text = answeredQs[index].answer
            cell.influencerUsername.text = userItem?.username
            cell.qAnswered.text = "✨ \(answeredQs[index].points) Points"
            cell.username.text = answeredQs[index].username
            cell.questionLbl.text = answeredQs[index].question
            
            cell.date.text = "🕘 \(answeredQs[index].date)"

            if let selfImg = userItem?.profileImg{
                cell.answerImage.image = userItem?.profileImg
            }
            if answeredQs[index].hasImage{
                storage.reference().child(answeredQs[index].id + "img.png").getData(maxSize: 1*1024*1024) { (data, error) in
                    if error == nil {
                        cell.questionImage.image = UIImage(data: data!)
                    }
                }
            }
            cell.layer.cornerRadius = 20
            cell.backgroundColor = .white
            cell.completeRequest = self

            return cell
        }
        
        func sizeForItem(verticalCardSwiperView: VerticalCardSwiperView, index: Int) -> CGSize {

            return CGSize(width: verticalCardSwiperView.frame.width, height: verticalCardSwiperView.frame.height-frame.height*0.1)
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 5
        }
    
}
