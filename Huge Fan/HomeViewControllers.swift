//
//  HomeViewController.swift
//  Huge Fan
//
//  Created by Caleb Mesfien on 3/16/21.
//

import UIKit
import RealmSwift
import ShimmerSwift

protocol accountSelected {
    func selectedAccount(id:String)
}






class TrendingMainCell: UICollectionViewCell, accountSelected{
    func selectedAccount(id: String) {
        accountSelected?.selectedAccount(id: id)
    }
    var featuredItems = [featuredUser]()
    var accountSelected: accountSelected?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        addSubview(shimmerOne)
//        addSubview(shimmerTwo)
//        NSLayoutConstraint.activate([
//            shimmerOne.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
//            shimmerOne.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
//            shimmerOne.heightAnchor.constraint(equalToConstant: 172),
//            shimmerOne.widthAnchor.constraint(equalToConstant: 280-24),
//
//            shimmerTwo.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
//            shimmerTwo.leadingAnchor.constraint(equalTo: shimmerOne.trailingAnchor, constant: 12),
//            shimmerTwo.heightAnchor.constraint(equalToConstant: 172),
//            shimmerTwo.widthAnchor.constraint(equalToConstant: 280-24),
//        ])
        
        
        
        addSubview(featuredCollectionView)
        NSLayoutConstraint.activate([
            featuredCollectionView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            featuredCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            featuredCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            featuredCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
//                                        280 w || 260-18 h
        ])
    }

    lazy var shimmerOne:ShimmeringView = {
       let view = ShimmeringView()
        view.shimmerSpeed = 10
        view.shimmerPauseDuration = 1.5
        let blackView = UIView()
        view.shimmerAnimationOpacity = 0.6
        blackView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)

        blackView.clipsToBounds = true
        blackView.layer.cornerRadius = 18
        view.contentView = blackView
        view.isShimmering = true

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var shimmerTwo:ShimmeringView = {
       let view = ShimmeringView()
        view.shimmerSpeed = 10
        view.shimmerPauseDuration = 1.5
        let blackView = UIView()
        view.shimmerAnimationOpacity = 0.6
        blackView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)

        blackView.clipsToBounds = true
        blackView.layer.cornerRadius = 18
        view.contentView = blackView
        view.isShimmering = true

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
        
        collectionView.register(featuredCell.self, forCellWithReuseIdentifier: "Featured")
        collectionView.register(featuredCell.self, forCellWithReuseIdentifier: "Trending")
        collectionView.register(featuredCell.self, forCellWithReuseIdentifier: "TikTok")
        collectionView.register(featuredCell.self, forCellWithReuseIdentifier: "Instagram")
        collectionView.register(featuredCell.self, forCellWithReuseIdentifier: "Youtube")
        collectionView.register(featuredCell.self, forCellWithReuseIdentifier: "Podcast")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension TrendingMainCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section{
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Featured", for: indexPath) as! featuredCell
            cell.accountSelected = self
            cell.TopicLabel.text = "Featured"
            cell.featuredItems = featuredItems
            cell.isBlurred = false
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Trending", for: indexPath) as! featuredCell
            cell.accountSelected = self
            cell.TopicLabel.text = "Trending"
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TikTok", for: indexPath) as! featuredCell
            cell.accountSelected = self
            cell.TopicLabel.text = "Tiktok"
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Instagram", for: indexPath) as! featuredCell
            cell.accountSelected = self
            cell.TopicLabel.text = "Instagram"
            return cell
        case 4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Youtube", for: indexPath) as! featuredCell
            cell.accountSelected = self
            cell.TopicLabel.text = "Youtube"
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Podcast", for: indexPath) as! featuredCell
            cell.TopicLabel.text = "Podcast"
            cell.accountSelected = self
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width, height: 260)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 5{
            return UIEdgeInsets(top:0, left: 0, bottom: frame.height*0.15, right: 0)
        }else{
            return UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
        }
        }
    
    
}






class featuredCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, accountSelected{
    
    func selectedAccount(id: String) {
        accountSelected?.selectedAccount(id:id)
        }
    var accountSelected: accountSelected?
    var isBlurred = true
    var featuredItems = [featuredUser]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        constraintContainer()
    }

        let title: CustomLabel = {
            let label = CustomLabel()
            label.textColor = .lightGray
            label.text = "Trending Influencers in"
            label.font = .systemFont(ofSize: 14, weight: .semibold)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
    }()
        let TopicLabel: CustomLabel = {
            let label = CustomLabel()
            label.textColor = .darkGray
            label.font = .systemFont(ofSize: 20, weight: .bold)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
    }()



    let cardView: UIView = {
       let view = UIView()
        view.layer.masksToBounds = false
    //        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
        lazy var TrendingCollection: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.isScrollEnabled = true
            collectionView.backgroundColor = .clear

            collectionView.register(SecondTrendingCollectionItem.self, forCellWithReuseIdentifier: "SecondTrendingCollectionItem")
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            return collectionView
        }()




    func constraintContainer(){
        
        addSubview(cardView)
        cardView.addSubview(title)
        cardView.addSubview(TopicLabel)
        cardView.addSubview(TrendingCollection)

        addConstraintsWithFormat(format:"H:|[v0]|", views: cardView)
        addConstraintsWithFormat(format:"V:|[v0]|", views: cardView)
        cardView.addConstraintsWithFormat(format:"H:|[v0]|", views: TrendingCollection)
        
        
        NSLayoutConstraint.activate([
            TrendingCollection.topAnchor.constraint(equalTo: TopicLabel.bottomAnchor, constant: 0),
            TrendingCollection.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -8),
                                        
            title.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            title.leadingAnchor.constraint(equalTo: cardView.leadingAnchor,constant: 8),
                                        
            TopicLabel.topAnchor.constraint(equalTo: title.bottomAnchor),
            TopicLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor,constant: 24),

        ])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isBlurred{
            return 8
        }else{
            if featuredItems.count == 0{
                return 0
            }else{
                return featuredItems.count
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SecondTrendingCollectionItem", for: indexPath) as! SecondTrendingCollectionItem
        if isBlurred{
            if indexPath.row % 2 == 0{
                cell.backgroundImgView.image = UIImage(named: "ElonMusk")
                cell.profileImage.image = UIImage(named: "ElonMusk")
            }else if indexPath.row % 2 == 1{
                cell.backgroundImgView.image = UIImage(named: "vlogsquad")
                cell.profileImage.image = UIImage(named: "vlogsquad")
            }else{
                cell.backgroundImgView.image = UIImage(named: "addisonRaeProfileImg")
                cell.profileImage.image = UIImage(named: "addisonRaeProfileImg")
            }
            cell.rankingStatus.attributedText = NSAttributedString(string: "#493", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.black])
            cell.usernameLbl.attributedText = NSAttributedString(string: "Addison Rae", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.black])
            cell.isBlurred = isBlurred
        }else{
            if featuredItems[indexPath.row].profileImg != nil{
                cell.backgroundImgView.image = featuredItems[indexPath.row].profileImg
                cell.profileImage.image = featuredItems[indexPath.row].profileImg
            }
            cell.usernameLbl.attributedText = NSAttributedString(string: featuredItems[indexPath.row].username, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.black])
            cell.fanCountLbl.text = String(featuredItems[indexPath.row].fanCount!)
            cell.answeredStatus.text = featuredItems[indexPath.row].answeredCount
        }
            return cell
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 280, height: (collectionView.frame.height)-18)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isBlurred == false{
            accountSelected?.selectedAccount(id: featuredItems[indexPath.row].id!)
        }
        
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    }



class SecondTrendingCollectionItem: UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        constraintContainer()
    }
    var isBlurred = false{
        didSet{
            if isBlurred{
                let blurEffect = UIBlurEffect(style: .light)
                let blurredEffectView = UIVisualEffectView(effect: blurEffect)
                blurredEffectView.clipsToBounds = true
                blurredEffectView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(blurredEffectView)
                blurredEffectView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
                blurredEffectView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
                blurredEffectView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
                blurredEffectView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
                blurredEffectView.layer.cornerRadius = 18
                mainView.addSubview(blurredEffectView)
            }
        }
    }
    lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
//        if isBlurred == false{
            view.layer.shadowColor = UIColor.lightGray.cgColor
            view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            view.layer.shadowRadius = 8.0
            view.layer.shadowOpacity = 0.3
            view.layer.cornerRadius = 18
//        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    fileprivate lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 28
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()
    fileprivate lazy var usernameLbl: UILabel = {
        let label = UILabel()
        label.attributedText =  NSAttributedString(string: "A", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.black])
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var backgroundImgView: UIImageView = {
      let imageView = UIImageView()
       var blurEffect = UIBlurEffect()
//        imageView.backgroundColor = .cyan

        blurEffect = UIBlurEffect(style: .systemThinMaterialLight) // .extraLight or .dark
       let blurEffectView = UIVisualEffectView(effect: blurEffect)
       blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       blurEffectView.frame = imageView.frame
       imageView.addSubview(blurEffectView)

       let gradient = CAGradientLayer()
       gradient.frame = bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
//        gradient.startPoint = CGPoint(x: 0, y: 0.0)
//        gradient.endPoint = CGPoint(x: 0, y: 0.2)
        gradient.locations = [0,0.6]

       imageView.layer.mask = gradient
//        imageView.layer.addSublayer(gradient)

       imageView.clipsToBounds = true
       imageView.layer.cornerRadius = 18
//        imageView.alpha = 0
       imageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
       imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
   }()
    fileprivate lazy var fanCountHeader: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "🤩 Fans", attributes:[NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.black])
        label.attributedText = attributedText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var fanCountLbl: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "2.8K", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white])
        label.textAlignment = .center
        label.backgroundColor = TealConstantColor
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    fileprivate lazy var answeredHeader: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "🙌 Answered", attributes:[NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.black])
        label.attributedText = attributedText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    fileprivate lazy var answeredStatus: UILabel = {
        let label = UILabel()

        label.attributedText = NSAttributedString(string: "23", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white])
        label.textAlignment = .center
        label.backgroundColor = TealConstantColor
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var rankingStatus: UILabel = {
        let lbl = UILabel()
        lbl.text = "NR"
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
    fileprivate lazy var spaceLbl: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "•", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.black])
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    func constraintContainer(){
        addSubview(mainView)
        mainView.addSubview(backgroundImgView)
        mainView.addSubview(profileImage)
        mainView.addSubview(usernameLbl)
        mainView.addSubview(spaceLbl)
        mainView.addSubview(fanCountLbl)
        mainView.addSubview(fanCountHeader)
        mainView.addSubview(answeredStatus)
        mainView.addSubview(answeredHeader)
        mainView.addSubview(rankingStatus)
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            mainView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            mainView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            backgroundImgView.topAnchor.constraint(equalTo: mainView.topAnchor),
            backgroundImgView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            backgroundImgView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            backgroundImgView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            
            profileImage.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 8),
            profileImage.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 75),
            profileImage.heightAnchor.constraint(equalToConstant: 75),
            
            usernameLbl.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 4),
            usernameLbl.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            usernameLbl.heightAnchor.constraint(equalToConstant: usernameLbl.intrinsicContentSize.height),
            
            rankingStatus.widthAnchor.constraint(equalToConstant: rankingStatus.intrinsicContentSize.width + 16),
            rankingStatus.heightAnchor.constraint(equalToConstant: rankingStatus.intrinsicContentSize.height + 12),
            rankingStatus.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -8),
            rankingStatus.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 8),

            fanCountHeader.topAnchor.constraint(equalTo: usernameLbl.bottomAnchor, constant: 4),
            fanCountHeader.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 8),
            fanCountHeader.trailingAnchor.constraint(equalTo: spaceLbl.leadingAnchor, constant: -16),
            
            fanCountLbl.topAnchor.constraint(equalTo: fanCountHeader.bottomAnchor, constant: 4),
            fanCountLbl.centerXAnchor.constraint(equalTo: fanCountHeader.centerXAnchor),
            fanCountLbl.widthAnchor.constraint(equalToConstant: fanCountLbl.intrinsicContentSize.width + 16),
            fanCountLbl.heightAnchor.constraint(equalToConstant: fanCountLbl.intrinsicContentSize.height + 6),
            
            spaceLbl.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            spaceLbl.widthAnchor.constraint(equalToConstant: spaceLbl.intrinsicContentSize.width),
            spaceLbl.topAnchor.constraint(equalTo: usernameLbl.bottomAnchor, constant: 4),
            spaceLbl.heightAnchor.constraint(equalToConstant: spaceLbl.intrinsicContentSize.height),

            answeredHeader.topAnchor.constraint(equalTo: usernameLbl.bottomAnchor, constant: 4),
            answeredHeader.leadingAnchor.constraint(equalTo: spaceLbl.trailingAnchor, constant: 16),
            answeredHeader.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -8),
            
            answeredStatus.topAnchor.constraint(equalTo: answeredHeader.bottomAnchor, constant: 4),
            answeredStatus.centerXAnchor.constraint(equalTo: answeredHeader.centerXAnchor),
            answeredStatus.widthAnchor.constraint(equalToConstant: answeredStatus.intrinsicContentSize.width + 16),
            answeredStatus.heightAnchor.constraint(equalToConstant: answeredStatus.intrinsicContentSize.height + 6),
            
            
        ])

        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}











// FAN OF CELL





class FanOfCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, accountSelected{
    func selectedAccount(id: String) {
        accountSelected?.selectedAccount(id:id)
    }
    var accountSelected: accountSelected?
    let realmObjc = try! Realm()
    var userItems = [featuredUser](){
        didSet{
            self.FanOfCollectionView.reloadData()
            self.layoutSubviews()
            print("FOUND", userItems.count)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(FanOfCollectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: FanOfCollectionView)
        addConstraintsWithFormat(format: "V:|-[v0]|", views: FanOfCollectionView)
        fetchItems()
    }
    func fetchItems(){
        realmObjc.objects(fanOfObject.self).forEach { (fan) in
            db.collection("user").document("I").collection("users").document(fan.id!).getDocument { (snapshot, error) in
                let username = snapshot?.data()!["username"] as! String
                let hasImage = snapshot?.data()!["hasProfileImage"] as! Bool
                let fanCount = snapshot?.data()!["fanCount"] as! Int
                let answeredCount = snapshot?.data()!["answerCount"] as! Int
                
                if hasImage{
                    storage.reference().child(fan.id! + "img.png").getData(maxSize: 1*1024*1024) { (data, error) in
                        if error == nil {
                            let user = featuredUser(username: username, profileImg: UIImage(data: data!), answeredCount: String(answeredCount), rankedCount: "", fanCount: fanCount, id: fan.id)
                            self.userItems.append(user)
                        }
                    }
                }else{
                    let user = featuredUser(username: username, profileImg: nil, answeredCount: String(answeredCount), rankedCount: "", fanCount: fanCount, id: fan.id)
                    self.userItems.append(user)
                }

//                let num = self.FanOfCollectionView.numberOfItems(inSection: 0)
//                let lastItemIndex = IndexPath(item: num, section: 0)
//                self.FanOfCollectionView.performBatchUpdates({ () -> Void in
//                    self.FanOfCollectionView.insertItems(at:[lastItemIndex])
//                }, completion: nil)
            }
        }
    }
    
    
    lazy var FanOfCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout:layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        layout.minimumLineSpacing = 0
        collectionView.register(UICollectionReusableView.self,forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SubHeader")
        collectionView.register(FanMiniCell.self, forCellWithReuseIdentifier: "FanMiniCell")

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: frame.width, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let Header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SubHeader", for: indexPath)
        let lbl: CustomLabel = {
           let lbl = CustomLabel()
            lbl.font = UIFont.boldSystemFont(ofSize: 20)
            lbl.textColor = .lightGray
            lbl.adjustsFontSizeToFitWidth = true
            lbl.text = "Influencers you follow🤩"
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
        Header.addSubview(lbl)
        Header.addConstraintsWithFormat(format: "H:|-14-[v0]|", views: lbl)
        Header.addConstraintsWithFormat(format: "V:[v0]-4-|", views: lbl)
        return Header
    }

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if userItems.count == 0{
            return 0
        }else{
            return userItems.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top:0, left: 0, bottom: frame.height*0.15, right: 0)
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FanMiniCell", for: indexPath) as! FanMiniCell
        if userItems[indexPath.row].profileImg != nil{
            cell.backgroundImgView.image = userItems[indexPath.row].profileImg
            cell.profileImage.image = userItems[indexPath.row].profileImg
        }
        cell.usernameLbl.attributedText = NSAttributedString(string: userItems[indexPath.row].username, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.black])
        cell.fanCountLbl.text = String(userItems[indexPath.row].fanCount!)
        cell.answeredStatus.text = userItems[indexPath.row].answeredCount
        
//        cell.rankingStatus.attributedText = NSAttributedString(string: "#493", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.white])

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        accountSelected?.selectedAccount(id: userItems[indexPath.row].id!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





class FanMiniCell: UICollectionViewCell{
    override init(frame: CGRect){
        super.init(frame: frame)
        constraintContainer()
    }
    let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        view.layer.shadowRadius = 8.0
        view.layer.shadowOpacity = 0.3
        view.layer.cornerRadius = 18
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    fileprivate lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 32
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()
    fileprivate lazy var usernameLbl: UILabel = {
        let label = UILabel()
        label.attributedText =  NSAttributedString(string: "A", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.black])
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var backgroundImgView: UIImageView = {
      let imageView = UIImageView()
       var blurEffect = UIBlurEffect()
//        imageView.backgroundColor = .cyan

        blurEffect = UIBlurEffect(style: .systemThinMaterialLight) // .extraLight or .dark
       let blurEffectView = UIVisualEffectView(effect: blurEffect)
       blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       blurEffectView.frame = imageView.frame
       imageView.addSubview(blurEffectView)

       let gradient = CAGradientLayer()
       gradient.frame = bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
        gradient.locations = [0,0.99]
        imageView.alpha = 0.5
       imageView.layer.mask = gradient

       imageView.clipsToBounds = true
       imageView.layer.cornerRadius = 18
       imageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
       imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
   }()

    
    fileprivate lazy var fanCountHeader: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "🤩 Fans:", attributes:[NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.black])
        label.attributedText = attributedText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var fanCountLbl: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "100", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white])
        label.textAlignment = .center
        label.backgroundColor = TealConstantColor
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    fileprivate lazy var answeredHeader: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "🙌 Answered:", attributes:[NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.black])
        label.attributedText = attributedText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    fileprivate lazy var answeredStatus: UILabel = {
        let label = UILabel()

        label.attributedText = NSAttributedString(string: "23", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white])
        label.textAlignment = .center
        label.backgroundColor = TealConstantColor
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    lazy var rankingStatus: UILabel = {
        let lbl = UILabel()
        lbl.text = "NR"
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.textColor = .white
        lbl.backgroundColor = TealConstantColor
        lbl.clipsToBounds = true
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 8
        lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    fileprivate lazy var spaceLbl: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "•", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.black])
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func constraintContainer(){
        addSubview(mainView)
        mainView.addSubview(backgroundImgView)
        mainView.addSubview(profileImage)
        mainView.addSubview(usernameLbl)
//        mainView.addSubview(spaceLbl)
        mainView.addSubview(fanCountLbl)
        mainView.addSubview(fanCountHeader)
        mainView.addSubview(answeredStatus)
        mainView.addSubview(answeredHeader)
        mainView.addSubview(rankingStatus)
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            mainView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            mainView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            
            backgroundImgView.topAnchor.constraint(equalTo: mainView.topAnchor),
            backgroundImgView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            backgroundImgView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            backgroundImgView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            
            profileImage.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 8),
            profileImage.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 12),
            profileImage.widthAnchor.constraint(equalTo: profileImage.heightAnchor),
            profileImage.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -12),
            
            usernameLbl.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 12),
            usernameLbl.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 8),
            usernameLbl.trailingAnchor.constraint(equalTo: rankingStatus.trailingAnchor, constant: -8),
            
            rankingStatus.widthAnchor.constraint(equalToConstant: rankingStatus.intrinsicContentSize.width + 16),
            rankingStatus.heightAnchor.constraint(equalToConstant: rankingStatus.intrinsicContentSize.height + 12),
            rankingStatus.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -8),
            rankingStatus.centerYAnchor.constraint(equalTo: usernameLbl.centerYAnchor),
            
            fanCountHeader.topAnchor.constraint(equalTo: usernameLbl.bottomAnchor, constant: 4),
            fanCountHeader.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 8),
//            fanCountHeader.trailingAnchor.constraint(equalTo: spaceLbl.leadingAnchor, constant: -16),
            
            fanCountLbl.topAnchor.constraint(equalTo: fanCountHeader.bottomAnchor, constant: 4),
            fanCountLbl.leadingAnchor.constraint(equalTo: fanCountHeader.trailingAnchor, constant: -12),
            fanCountLbl.widthAnchor.constraint(equalToConstant: fanCountLbl.intrinsicContentSize.width + 16),
            fanCountLbl.heightAnchor.constraint(equalToConstant: fanCountLbl.intrinsicContentSize.height + 6),
            
//            spaceLbl.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
//            spaceLbl.widthAnchor.constraint(equalToConstant: spaceLbl.intrinsicContentSize.width),
//            spaceLbl.topAnchor.constraint(equalTo: usernameLbl.bottomAnchor, constant: 4),
//            spaceLbl.heightAnchor.constraint(equalToConstant: spaceLbl.intrinsicContentSize.height),

            answeredHeader.topAnchor.constraint(equalTo: usernameLbl.bottomAnchor, constant: 4),
            answeredHeader.leadingAnchor.constraint(equalTo: fanCountLbl.trailingAnchor, constant: 8),
//            answeredHeader.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -8),
            
            answeredStatus.topAnchor.constraint(equalTo: answeredHeader.bottomAnchor, constant: 4),
            answeredStatus.leadingAnchor.constraint(equalTo: answeredHeader.trailingAnchor, constant: -8),
            answeredStatus.widthAnchor.constraint(equalToConstant: answeredStatus.intrinsicContentSize.width + 16),
            answeredStatus.heightAnchor.constraint(equalToConstant: answeredStatus.intrinsicContentSize.height + 6),
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
