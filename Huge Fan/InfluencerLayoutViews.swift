//
//  InfluencerViews.swift
//  Huge Fan
//
//  Created by Caleb Mesfien on 3/20/21.
//

import UIKit
import RealmSwift
import VerticalCardSwiper
protocol questionSelected {
    func selectedQ(question: String, transmitterUsername: String, transmitterId:String, points: Int, hasImage: Bool, Id: String)
}

struct UnAnsweredQuestions {
    var username: String
    var points: Int
    var question: String
    var date: String
    var id: String
    var hasImage: Bool
    var likes: Int
    var questionId: String
}

protocol completeRequest {
    func complete(item: Int, questionImage: UIImage, answerImage: UIImage, fanUsername: String, influencerUsername: String, date: String, question: String, answer:String)
}


class InfluecerLayoutController: UIViewController, questionSelected, blackViewProtocol, UITextFieldDelegate, completeRequest{
    func complete(item: Int, questionImage: UIImage, answerImage: UIImage, fanUsername: String, influencerUsername: String, date: String, question: String, answer:String){
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
    

    func changeBlackView() {
        UIView.animate(withDuration: 0.5) {
            self.blackWindow.alpha = 0
        }
    }
    func selectedQ(question: String, transmitterUsername: String, transmitterId:String, points: Int, hasImage: Bool, Id: String){
        generator.impactOccurred()
                if let window = UIApplication.shared.keyWindow{
                    blackWindow.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
                    blackWindow.backgroundColor = UIColor(white: 0, alpha: 0.8)
                    blackWindow.alpha = 0
                    view.addSubview(blackWindow)

                    UIView.animate(withDuration: 0.5) {
                        self.blackWindow.alpha = 1
                    }
        }
        let vc = AnswerQuestionView()
        vc.delegate = self
        vc.question = question
        vc.transmitterUsername = transmitterUsername
        vc.transmitterId = transmitterId
        vc.points = points
        vc.hasImage = hasImage

        
        vc.hidesBottomBarWhenPushed = true
        vc.modalPresentationStyle = .overCurrentContext
        self.tabBarController?.tabBar.isHidden = true

        present(vc, animated: true, completion: nil)
    }
    
    let realmObjc = try! Realm()
    let blackWindow = UIView()
    


    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .white
        constraintContainer()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .darkContent
        navigationItem.backButtonTitle = ""
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
        
        collection.register(unansweredQCell.self, forCellWithReuseIdentifier: "unansweredQCell")
        collection.register(answeredQCell.self, forCellWithReuseIdentifier: "answeredQCell")

        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    
    
    
    lazy var StackCollection: FeedStackInfluencer = {
       let stack = FeedStackInfluencer()
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

    let editBtn: UIButton = {
       let view = UIButton()
//        view.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        view.layer.shadowColor = UIColor.systemBlue.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 5.0
        view.layer.shadowOpacity = 0.6
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 10
        view.setAttributedTitle(NSAttributedString(string: "Menu", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]), for: .normal)
        view.addTarget(self, action: #selector(editProfileSelected), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()


    fileprivate lazy var profileImage: CustomUserImage = {
        let imageView = CustomUserImage()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.layer.borderWidth = 2
        if let img = realmObjc.objects(userObject.self)[0].image{
            imageView.image = UIImage(data: img as Data)
        }else{
            imageView.image = UIImage(named: "placeholderProfileImage")
        }
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()
    
    
//    SEARCH VIEW
    
    func constraintContainer(){
        view.addSubview(editBtn)
        editBtn.addSubview(profileImage)
        view.addSubview(MainCollectionView)
        view.addSubview(backgroundImgView)
        view.addSubview(StackCollection)
        NSLayoutConstraint.activate([

            editBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            editBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            editBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            editBtn.heightAnchor.constraint(equalToConstant: 50),

            profileImage.topAnchor.constraint(equalTo:editBtn.topAnchor, constant: 6),
            profileImage.leadingAnchor.constraint(equalTo: editBtn.leadingAnchor, constant: 11),
            profileImage.widthAnchor.constraint(equalTo: profileImage.heightAnchor),
            profileImage.bottomAnchor.constraint(equalTo: editBtn.bottomAnchor, constant: -6),
            
            MainCollectionView.topAnchor.constraint(equalTo: editBtn.bottomAnchor),
            MainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            MainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            MainCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

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
    
    @objc func editProfileSelected(){
        let vc = EditProfileView()
        vc.settingsLabelText2 = ["Username","Bio", "TikTok", "Instagram"]
        navigationController?.pushViewController(vc, animated: true)
    }

}










extension InfluecerLayoutController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{

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
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "unansweredQCell", for: indexPath) as! unansweredQCell
                cell.accountSelected = self
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "answeredQCell", for: indexPath) as! answeredQCell
//                cell.accountSelected = self
                cell.completeRequest = self

                 return cell
            }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}






protocol updateList {
    func updateTheList(item: Int)
}

class unansweredQCell: UICollectionViewCell, questionSelected, updateList{
    func updateTheList(item: Int) {
        unAnsweredQList.remove(at: item)
        DispatchQueue.main.async {
            self.featuredCollectionView.reloadData()
        }
    }
    
    func selectedQ(question:String, transmitterUsername: String, transmitterId:String, points: Int, hasImage: Bool,  Id: String){
        accountSelected?.selectedQ(question: question, transmitterUsername: transmitterUsername, transmitterId:transmitterId, points: points, hasImage: hasImage, Id: Id )
    }
    
    let realmObjc = try! Realm()
    var accountSelected: questionSelected?
    var unAnsweredQList = [UnAnsweredQuestions]()
    func fetchFeaturedData(){
//
        let database = db.collection("user").document("I").collection("users").document(realmObjc.objects(userObject.self)[0].FID).collection("unanswered")

        database.addSnapshotListener { (snapshots, error) in

            snapshots?.documentChanges.forEach { diff in
                if (diff.type == .added) {
//                    snapshot?.documents.forEach({ (snapshot) in
                    let snapshot = diff.document
                        let username = snapshot.data()["username"] as! String
                        let points = snapshot.data()["points"] as! Int
                        let date = snapshot.data()["date"] as! String
                        let question = snapshot.data()["question"] as! String
                        let id = snapshot.data()["id"] as! String
                        let hasImage = snapshot.data()["hasImage"] as! Bool
                        let likes = snapshot.data()["likes"] as! Int

                    let item = UnAnsweredQuestions(username: username, points: points, question: question, date: date, id: id, hasImage:hasImage, likes: likes, questionId: snapshot.documentID)
                        print(item)
                        self.unAnsweredQList.append(item)
//                    if self.unAnsweredQList.count != 1{
                        let num = self.featuredCollectionView.numberOfItems(inSection: 0)
                        let lastItemIndex = IndexPath(item: num, section: 0)
                        self.featuredCollectionView.performBatchUpdates({ () -> Void in
                            self.featuredCollectionView.insertItems(at:[lastItemIndex])
                        }, completion: nil)
//                    }
                    
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
        fetchFeaturedData()

    }

    func setUp(){
        addSubview(featuredCollectionView)
         NSLayoutConstraint.activate([
             featuredCollectionView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
             featuredCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
             featuredCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
             featuredCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
         ])
    }
    
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
extension unansweredQCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
            cell.username.text = unAnsweredQList[indexPath.row].username
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
        let sizeOfItem = CGSize(width: collectionView.frame.width-56, height: 1000)
        
        let item = NSString(string: unAnsweredQList[indexPath.row].question).boundingRect(with:sizeOfItem , options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24)], context: nil)
        
                    let size = CGSize(width:collectionView.frame.width, height: item.height + 92)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top:0, left: 0, bottom: frame.height*0.15, right: 0)
        }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedQ(question: unAnsweredQList[indexPath.row].question, transmitterUsername: unAnsweredQList[indexPath.row].username, transmitterId:unAnsweredQList[indexPath.row].id, points: unAnsweredQList[indexPath.row].points, hasImage: unAnsweredQList[indexPath.row].hasImage,  Id: unAnsweredQList[indexPath.row].questionId)
    }
    
}
class questionCell: UICollectionViewCell,questionSelected{

    
    func selectedQ(question:String, transmitterUsername: String, transmitterId:String, points: Int, hasImage: Bool, Id: String){
        accountSelected?.selectedQ(question: question, transmitterUsername: transmitterUsername, transmitterId:transmitterId, points: points, hasImage: hasImage, Id: Id)
    }
    var accountSelected: questionSelected?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        constraintContainer()
        
    }


    lazy var cardView: UIView = {
       let view = UIView()
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 24
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 6.0
        view.layer.shadowOpacity = 0.3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var questionImage: CustomUserImage = {
        let imageView = CustomUserImage()
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40/2.5
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.systemBlue.cgColor
        imageView.image = UIImage(named: "placeholderProfileImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()
    
    let username: UILabel = {
       let lbl = UILabel()
        lbl.text = "Caleb Mesfien"
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textColor = .darkGray
        lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    let questionLbl: UILabel = {
       let lbl = UILabel()
        lbl.text = "Fades away to me I don’t have a good app for the first thing I love the way I do this app is very good app to have it with me I have to say that it was worth the money and it was n"
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 24)
        lbl.textColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    let date: UILabel = {
       let lbl = UILabel()
        lbl.text = "🕘 12:29 PM"
        lbl.font = UIFont.boldSystemFont(ofSize: 13)
        lbl.textColor = .lightGray
        lbl.backgroundColor = .clear
        lbl.clipsToBounds = true
        lbl.textAlignment = .center
//        lbl.layer.cornerRadius = 13
        lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let likes: UILabel = {
       let lbl = UILabel()
        lbl.text = "9"
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textColor = .white
        lbl.backgroundColor = TealConstantColor
        lbl.clipsToBounds = true
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 12
        lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    func constraintContainer(){
        addSubview(cardView)
        cardView.addSubview(questionLbl)
        cardView.addSubview(questionImage)
        cardView.addSubview(username)
        cardView.addSubview(date)
        cardView.addSubview(likes)

        addConstraintsWithFormat(format:"H:|-12-[v0]-12-|", views: cardView)
        addConstraintsWithFormat(format:"V:|-[v0]-|", views: cardView)
        NSLayoutConstraint.activate([
            
            questionImage.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            questionImage.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            questionImage.heightAnchor.constraint(equalToConstant: 40),
            questionImage.widthAnchor.constraint(equalTo: questionImage.heightAnchor),
            
            likes.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            likes.centerYAnchor.constraint(equalTo: questionImage.centerYAnchor),
            likes.widthAnchor.constraint(equalToConstant: likes.intrinsicContentSize.width + 24),
            likes.heightAnchor.constraint(equalToConstant: likes.intrinsicContentSize.height + 4),
            
            date.leadingAnchor.constraint(equalTo: questionImage.trailingAnchor, constant: 8),
            date.bottomAnchor.constraint(equalTo: questionImage.bottomAnchor, constant: -2),
            
            username.leadingAnchor.constraint(equalTo: questionImage.trailingAnchor, constant: 8),
            username.bottomAnchor.constraint(equalTo: questionImage.centerYAnchor),
            username.trailingAnchor.constraint(equalTo: likes.leadingAnchor, constant: -12),
            username.heightAnchor.constraint(equalToConstant: username.intrinsicContentSize.height),

            questionLbl.topAnchor.constraint(equalTo: questionImage.bottomAnchor, constant: 8),
            questionLbl.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            questionLbl.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            questionLbl.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),

        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    }








class answeredQCell: UICollectionViewCell, accountSelected, completeRequest{
    func complete(item: Int, questionImage: UIImage, answerImage: UIImage, fanUsername: String, influencerUsername: String, date: String, question: String, answer:String){
        completeRequest?.complete(item: item, questionImage: questionImage , answerImage: answerImage, fanUsername: fanUsername, influencerUsername: influencerUsername, date: date, question: question, answer: answer)
    }
    
    func selectedAccount(id: String) {
        accountSelected?.selectedAccount(id: id)
    }
    let realmObjc = try! Realm()
    var accountSelected: accountSelected?
    var completeRequest: completeRequest?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(featuredCollectionView)
        NSLayoutConstraint.activate([
            featuredCollectionView.topAnchor.constraint(equalTo: topAnchor),
            featuredCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            featuredCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            featuredCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    lazy var featuredCollectionView: VerticalCardSwiper = {
       let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let collectionView = VerticalCardSwiper()
        collectionView.delegate = self
        collectionView.datasource = self
        collectionView.backgroundColor = .clear
        collectionView.isSideSwipingEnabled = false
        collectionView.register(cardCell.self, forCellWithReuseIdentifier: "answeredVert")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension answeredQCell:  VerticalCardSwiperDatasource, VerticalCardSwiperDelegate{

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            print(scrollView.contentOffset.x)
        }
    
        func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
            return realmObjc.objects(answeredQuestions.self).count
        }
    
    
    
    
        
        func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
            let cell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "answeredVert", for: index) as! cardCell
            cell.answernLbl.text = realmObjc.objects(answeredQuestions.self)[index].answer
            cell.influencerUsername.text = realmObjc.objects(userObject.self)[0].username
            cell.qAnswered.text = "✨ \(realmObjc.objects(answeredQuestions.self)[index].points) Points"
            cell.username.text = realmObjc.objects(answeredQuestions.self)[index].username
            cell.questionLbl.text = realmObjc.objects(answeredQuestions.self)[index].question
            
            
            let dateFormatterGet = DateFormatter()
            let dateFormatter = DateFormatter()
            dateFormatterGet.dateFormat = "MMM d, yyyy, h:mm a"
            let Ndate = dateFormatterGet.date(from: (realmObjc.objects(answeredQuestions.self)[index].date))
            if Calendar.current.isDateInToday(Ndate!){
                dateFormatter.dateFormat = "h:mm a"
            }else{
                dateFormatter.dateFormat = "MMM d"
            }
            let newDate = dateFormatter.string(from: Ndate! as Date)
            cell.date.text = "🕘 \(newDate)"

            if let selfImg = realmObjc.objects(userObject.self)[0].image{
                cell.answerImage.image = UIImage(data: selfImg as Data)
            }
            if let img = realmObjc.objects(answeredQuestions.self)[index].userImage{
                cell.questionImage.image = UIImage(data: img as Data)
            }
            cell.layer.cornerRadius = 20
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

