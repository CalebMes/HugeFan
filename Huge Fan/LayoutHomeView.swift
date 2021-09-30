//
//  LayoutHomeView.swift
//  Huge Fan
//
//  Created by Caleb Mesfien on 3/17/21.
//

import UIKit
import StoreKit
import RealmSwift
import FirebaseFirestore
import FirebaseStorage


let db = Firestore.firestore()
let storage = Storage.storage()

struct searchItem {
    var username: String
    var Fid: String
}


class LayoutController: UIViewController, accountSelected, blackViewProtocol, UITextFieldDelegate{
    func changeBlackView() {
        UIView.animate(withDuration: 0.5) {
            self.blackWindow.alpha = 0
        }
    }
    func selectedAccount(id: String) {
        let vc = ViewController()
        vc.Fid = id
        navigationController?.pushViewController(vc, animated: true)
    }

    var featuredItems = [featuredUser](){
        didSet{
            self.constraintContainer()
        }
    }
    func fetchFeaturedData(){
//  db.collection("user").document("U").collection("users").document(realmObjc.objects(userObject.self)[0].FID)
//        "Featured")
//        "Trending")
//        "TikTok")
//        "Instagram"
//        "Youtube")
//        "Podcast")
        db.collection("user").document("I").collection("users").getDocuments { (snap, error) in
            snap?.documents.forEach({ (snapshot) in
                let username = snapshot.data()["username"] as! String
                let hasImage = snapshot.data()["hasProfileImage"] as! Bool
                let fanCount = snapshot.data()["fanCount"] as! Int
                let answeredCount = snapshot.data()["answerCount"] as! Int
                
                if hasImage{
                    storage.reference().child(snapshot.documentID + "img.png").getData(maxSize: 1*1024*1024) { (data, error) in
                        if error == nil {
                            let user = featuredUser(username: username, profileImg: UIImage(data: data!), answeredCount: String(answeredCount), rankedCount: "", fanCount: fanCount, id: snapshot.documentID)
                            self.featuredItems.append(user)
                        }
                    }
                }else{
                    let user = featuredUser(username: username, profileImg: nil, answeredCount: String(answeredCount), rankedCount: "", fanCount: fanCount, id:snapshot.documentID)
                    self.featuredItems.append(user)

                }
//                if self.featuredItems.count == snap?.count{

//                }
            })
        }
    
    }
    let realmObjc = try! Realm()
    let blackWindow = UIView()
    var searchList = [searchItem(username: "", Fid: "")]


    @objc func searchViewSelected(){
        textField.resignFirstResponder()
    }

    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(menuSelected)))
        fetchFeaturedData()
//        constraintContainer()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .darkContent
        navigationItem.backButtonTitle = ""
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification){
        if let userInfo = notification.userInfo{
            UIView.animate(withDuration: 0.8) {
                    self.searchView.alpha = 1
                    self.searchView.isUserInteractionEnabled = true
                
                self.returnBtn.transform = CGAffineTransform(translationX: 58, y: 0)
                self.profileImage.transform = CGAffineTransform(translationX: 58, y: 0)
                    self.view.layoutIfNeeded()
                }
        }
    }
    @objc func menuSelected(){
        let vc = EditProfileView()
        vc.settingsLabelText2 = ["Username"]
        navigationController?.pushViewController(vc, animated: true)
    }

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
        
        collection.register(TrendingMainCell.self, forCellWithReuseIdentifier: "TrendCell")
        collection.register(FanOfCell.self, forCellWithReuseIdentifier: "FanOfCell")

        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    
    
    
    lazy var StackCollection: FeedStack = {
       let stack = FeedStack()
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

    let textFieldView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var textField: UITextField = {
       let field = UITextField()
        field.delegate = self
        field.keyboardAppearance = .light
        field.returnKeyType = .search
        field.tintColor = .white
        field.attributedPlaceholder = NSAttributedString(string: "Search \"Addison Rae\"", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15)])
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    let searchIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "searchIconWhite")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    fileprivate lazy var profileImage: CustomUserImage = {
        let imageView = CustomUserImage()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 18
        imageView.layer.borderWidth = 2
        if realmObjc.objects(userObject.self)[0].image != nil{
            imageView.image = UIImage(data: realmObjc.objects(userObject.self)[0].image! as Data)
        }else{
            imageView.image = UIImage(named: "placeholderProfileImage")
        }
        imageView.layer.borderColor = TealConstantColor.cgColor
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()
    
    
//    SEARCH VIEW
    lazy var searchView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var searchCollectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: "SearchCell")
        collectionView.register(UICollectionReusableView.self,forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "searchHeader")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    fileprivate let returnBtn: UIButton = {
       let btn = UIButton()
        btn.setAttributedTitle(NSAttributedString(string: "Cancel", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.black]), for: .normal)
        btn.addTarget(self, action: #selector(returnBtnSelected), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    
    func constraintContainer(){
        view.addSubview(returnBtn)
        view.addSubview(textFieldView)
        textFieldView.addSubview(searchIcon)
        textFieldView.addSubview(textField)
        view.addSubview(profileImage)
        view.addSubview(MainCollectionView)
        view.addSubview(backgroundImgView)
        view.addSubview(searchView)
        searchView.addSubview(searchCollectionView)
        view.addSubview(StackCollection)
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: textFieldView.bottomAnchor),
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            searchCollectionView.topAnchor.constraint(equalTo: searchView.topAnchor),
            searchCollectionView.leadingAnchor.constraint(equalTo: searchView.leadingAnchor),
            searchCollectionView.trailingAnchor.constraint(equalTo: searchView.trailingAnchor),
            searchCollectionView.bottomAnchor.constraint(equalTo: searchView.bottomAnchor),


            textFieldView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textFieldView.trailingAnchor.constraint(equalTo: profileImage.leadingAnchor, constant: -12),
            textFieldView.heightAnchor.constraint(equalToConstant: 44),

            returnBtn.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor),
            returnBtn.centerYAnchor.constraint(equalTo: textFieldView.centerYAnchor),
            
            searchIcon.topAnchor.constraint(equalTo: textFieldView.topAnchor, constant: 12),
            searchIcon.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: -12),
            searchIcon.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 12),
            searchIcon.widthAnchor.constraint(equalTo: searchIcon.heightAnchor),

            textField.topAnchor.constraint(equalTo: textFieldView.topAnchor, constant:4),
            textField.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            textField.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: -4),

            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            profileImage.widthAnchor.constraint(equalToConstant: 44),
            profileImage.heightAnchor.constraint(equalToConstant: 44),
            
            MainCollectionView.topAnchor.constraint(equalTo: textFieldView.bottomAnchor),
            MainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            MainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            MainCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
//            StackCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            StackCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            StackCollection.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            StackCollection.heightAnchor.constraint(equalToConstant: 68),
            StackCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            StackCollection.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            backgroundImgView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImgView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImgView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImgView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
        ])
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if searchList.count == 1{
            searchList.removeAll()

            featuredItems.forEach { (item) in
                self.searchList.append(searchItem(username: item.username, Fid: item.id!))
            }
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    self.searchCollectionView.reloadData()
                    print(self.searchList.count)
                }
            
        }
    }
    @objc func returnBtnSelected(){
        textField.resignFirstResponder()
        UIView.animate(withDuration: 0.3) {
                self.searchView.alpha = 0
                self.searchView.isUserInteractionEnabled = false
                self.searchView.layoutSubviews()
                self.returnBtn.transform = CGAffineTransform(translationX: 0, y: 0)
                self.profileImage.transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.layoutIfNeeded()
            }
        
    }
}
extension LayoutController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        StackCollection.widthHorizontalBar?.constant = 20

        StackCollection.leftHorizontalBar?.constant = (view.frame.width*0.176) + scrollView.contentOffset.x/(view.safeAreaLayoutGuide.layoutFrame.width*0.00607)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let item = targetContentOffset.pointee.x/view.frame.width
        StackCollection.stackOptionCollectionView.selectItem(at: NSIndexPath(item: Int(item), section: 0) as IndexPath, animated: true, scrollPosition: .init())
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == searchCollectionView{
            return CGSize(width: collectionView.frame.width, height: 50)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == searchCollectionView{
            let Header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "searchHeader", for: indexPath)
            let lbl: CustomLabel = {
               let lbl = CustomLabel()
                lbl.font = UIFont.boldSystemFont(ofSize: 16)
                lbl.textColor = .lightGray
                lbl.adjustsFontSizeToFitWidth = true
                lbl.text = "Suggestions"
                lbl.translatesAutoresizingMaskIntoConstraints = false
                return lbl
            }()
            Header.addSubview(lbl)
            Header.addConstraintsWithFormat(format: "H:|-14-[v0]|", views: lbl)
            Header.addConstraintsWithFormat(format: "V:[v0]-4-|", views: lbl)
            return Header
        }else{
            return UICollectionReusableView()
        }

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == searchCollectionView{
            if searchList == nil{
                return 0
            }else{
                return searchList.count
                
            }
        }else{
            return 2
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == searchCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCell
            cell.backgroundColor = .white
            cell.title.text = searchList[indexPath.row].username
            return cell
        }else{
            if indexPath.row == 0{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendCell", for: indexPath) as! TrendingMainCell
                cell.accountSelected = self
                cell.featuredItems = featuredItems
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FanOfCell", for: indexPath) as! FanOfCell
                cell.accountSelected = self
                 return cell
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == searchCollectionView{
            return CGSize(width: collectionView.frame.width, height: 60)

        }else{
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           if collectionView == searchCollectionView{
            let vc = ViewController()
            vc.Fid = searchList[indexPath.row].Fid
            navigationController?.pushViewController(vc, animated: true)
           }
           
}
}



//
//class SearchView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, accountSelected{
//    func selectedAccount(profileImage: UIImage, name: String, fanCount: String, answerCount: String, ranking: String) {
//        accountSelected?.selectedAccount(profileImage: profileImage, name: name, fanCount: fanCount, answerCount: answerCount, ranking: ranking)
//
//    }
//    var accountSelected: accountSelected?
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addSubview(searchCollectionView)
//        addConstraintsWithFormat(format: "H:|[v0]|", views: searchCollectionView)
//        addConstraintsWithFormat(format: "V:|[v0]|", views: searchCollectionView)
//    }
//    lazy var searchCollectionView: UICollectionView = {
//       let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 0
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = .white
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: "SearchCell")
//        collectionView.register(UICollectionReusableView.self,forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "searchHeader")
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        return collectionView
//    }()
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//            return CGSize(width: frame.width, height: 50)
//    }
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let Header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "searchHeader", for: indexPath)
//        let lbl: CustomLabel = {
//           let lbl = CustomLabel()
//            lbl.font = UIFont.boldSystemFont(ofSize: 16)
//            lbl.textColor = .lightGray
//            lbl.adjustsFontSizeToFitWidth = true
//            lbl.text = "Suggestions"
//            lbl.translatesAutoresizingMaskIntoConstraints = false
//            return lbl
//        }()
//        Header.addSubview(lbl)
//        Header.addConstraintsWithFormat(format: "H:|-14-[v0]|", views: lbl)
//        Header.addConstraintsWithFormat(format: "V:[v0]-4-|", views: lbl)
//        return Header
//    }
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return searchList!.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//            return 0
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCell
//        cell.backgroundColor = .white
//        cell.title.text = self.searchList![indexPath.row]
//        return cell
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.width, height: 60)
//    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView == searchCollectionView{
//            accountSelected?.selectedAccount(profileImage: UIImage(named: "addisonRaeProfileImg")!, name: "Addison Rae", fanCount: "3.2M", answerCount: "335", ranking: "24")
//
//        }else{
//        }
//    }
//
//}
class SearchCell: UICollectionViewCell{
    override init(frame: CGRect){
        super.init(frame: frame)
        constraintContainer()
    }
    fileprivate lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "SearchIcon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()
    let title: CustomLabel = {
        let textLabel = CustomLabel()
        textLabel.textColor = .black
//        textLabel.text = "Addison Rae"
        textLabel.font = .systemFont(ofSize: 14, weight: .bold)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    let arrowImage: UIImageView = {
       let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.image = UIImage(named: "BlackRightArrow")
        img.translatesAutoresizingMaskIntoConstraints = false
       return img
    }()
    func constraintContainer(){
        self.addSubview(profileImage)
        self.addSubview(title)
        self.addSubview(arrowImage)
        NSLayoutConstraint.activate([
            profileImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -18),
            profileImage.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            profileImage.widthAnchor.constraint(equalTo: profileImage.heightAnchor),
            profileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            title.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            title.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 12),
            title.trailingAnchor.constraint(equalTo: arrowImage.leadingAnchor, constant: -12),
            
            arrowImage.widthAnchor.constraint(equalToConstant: 25),
            arrowImage.heightAnchor.constraint(equalToConstant: 25),
            arrowImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            arrowImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





