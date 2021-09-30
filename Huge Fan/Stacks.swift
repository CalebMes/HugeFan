//
//  File.swift
//  Huge Fan
//
//  Created by Caleb Mesfien on 4/1/21.
//

import UIKit

class FeedStack: UIView,  UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{
    var FeedViewControllerItem: LayoutController?
    var leftHorizontalBar: NSLayoutConstraint?
    var widthHorizontalBar: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)


        constraintContainer()
        setUpHorizontalBar()
        stackOptionCollectionView.selectItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, animated: true, scrollPosition: .init())
//        FeedViewControllerItem?.scrollToStackIndex(index: 0)

    }

    let stackOptionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear

        collectionView.register(FeedStackCollectionCell.self, forCellWithReuseIdentifier: "FeedStackCollectionCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    func setUpHorizontalBar(){
        let horizontalBarView = UIView()
        horizontalBarView.layer.cornerRadius = 2.5
        horizontalBarView.backgroundColor = .black
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)

//        87.5
//        68.5
        leftHorizontalBar = horizontalBarView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: UIScreen.main.bounds.width*0.176)
        leftHorizontalBar?.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        widthHorizontalBar = horizontalBarView.widthAnchor.constraint(equalToConstant: 18)
        widthHorizontalBar?.isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 5).isActive = true
    }

    func constraintContainer(){
        stackOptionCollectionView.delegate = self
        stackOptionCollectionView.dataSource = self
        addSubview(stackOptionCollectionView)

        self.addConstraintsWithFormat(format: "V:|[v0]|", views: stackOptionCollectionView)
        self.addConstraintsWithFormat(format: "H:|[v0]|", views: stackOptionCollectionView)
    }






    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 2
    }



    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let stackTitles = ["Trending", "Fan Of"]
        let stackImages = ["Trending", "FanOf"]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedStackCollectionCell", for: indexPath) as! FeedStackCollectionCell
        cell.title.text = stackTitles[indexPath.row]
        cell.image.image = UIImage(named: stackImages[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let size = CGSize(width: collectionView.frame.width/2, height: self.frame.height)
            return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let x = (UIScreen.main.bounds.width/3)*0.75

//        leftHorizontalBar?.constant = CGFloat(x)
//        if indexPath.row == 0{
//            widthHorizontalBar?.constant = 87.5
//        }else if indexPath.row == 1{
//            widthHorizontalBar?.constant = 120
//        }else{
//            widthHorizontalBar?.constant = 68.5
//        }

//        FeedViewControllerItem?.scrollToStackIndex(index: indexPath.row)

    }



    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//      MARK: STACKOPTIONCOLLECTIONVIEWCELL

class FeedStackCollectionCell: UICollectionViewCell{
    override init(frame: CGRect){
        super.init(frame: frame)
        print(title.frame.width, "Done is the name")
        addSubview(title)
        addSubview(image)
        NSLayoutConstraint.activate([
//            title.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            image.heightAnchor.constraint(equalToConstant: 22),
            image.widthAnchor.constraint(equalToConstant: 22),
            image.bottomAnchor.constraint(equalTo: title.topAnchor, constant: -8),
            
            title.widthAnchor.constraint(equalTo: widthAnchor),
            title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        print(title.intrinsicContentSize.width)
    }

    override var isHighlighted: Bool{
        didSet{
            title.alpha = isHighlighted ? 1 : 0.3
            image.alpha = isHighlighted ? 1 : 0.3
        }
    }

    override var isSelected: Bool{
        didSet{
            title.alpha = isSelected ? 1 : 0.3
            image.alpha = isSelected ? 1 : 0.3

        }
    }
    let title: CustomLabel = {
       let label = CustomLabel()
        label.textColor = .black
        label.textAlignment = .center
        label.alpha = 0.3
        label.font  = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let image: UIImageView = {
       let imageView = UIImageView()
//        imageView.backgroundColor = .red
        imageView.alpha = 0.5
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}






class FeedStackInfluencer: UIView,  UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{
    var FeedViewControllerItem: InfluecerLayoutController?
    var leftHorizontalBar: NSLayoutConstraint?
    var widthHorizontalBar: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)


        constraintContainer()
        setUpHorizontalBar()
        stackOptionCollectionView.selectItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, animated: true, scrollPosition: .init())
//        FeedViewControllerItem?.scrollToStackIndex(index: 0)

    }

    let stackOptionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear

        collectionView.register(FeedStackCollectionCell.self, forCellWithReuseIdentifier: "FeedStackCollectionCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    func setUpHorizontalBar(){
        let horizontalBarView = UIView()
        horizontalBarView.layer.cornerRadius = 2.5
        horizontalBarView.backgroundColor = .black
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)

//        87.5
//        68.5
        leftHorizontalBar = horizontalBarView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: UIScreen.main.bounds.width*0.176)
        leftHorizontalBar?.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        widthHorizontalBar = horizontalBarView.widthAnchor.constraint(equalToConstant: 18)
        widthHorizontalBar?.isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 5).isActive = true
    }

    func constraintContainer(){
        stackOptionCollectionView.delegate = self
        stackOptionCollectionView.dataSource = self
        addSubview(stackOptionCollectionView)

        self.addConstraintsWithFormat(format: "V:|[v0]|", views: stackOptionCollectionView)
        self.addConstraintsWithFormat(format: "H:|[v0]|", views: stackOptionCollectionView)
    }






    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 2
    }



    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let stackTitles = ["Un-Answered", "Answered"]
        let stackImages = ["unanswered", "answered"]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedStackCollectionCell", for: indexPath) as! FeedStackCollectionCell
        cell.title.text = stackTitles[indexPath.row]
        cell.image.image = UIImage(named: stackImages[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let size = CGSize(width: collectionView.frame.width/2, height: self.frame.height)
            return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let x = (UIScreen.main.bounds.width/3)*0.75

//        leftHorizontalBar?.constant = CGFloat(x)
//        if indexPath.row == 0{
//            widthHorizontalBar?.constant = 87.5
//        }else if indexPath.row == 1{
//            widthHorizontalBar?.constant = 120
//        }else{
//            widthHorizontalBar?.constant = 68.5
//        }

//        FeedViewControllerItem?.scrollToStackIndex(index: indexPath.row)

    }



    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




class profileStackView: UIView,  UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{
    var FeedViewControllerItem: ViewController?
    var leftHorizontalBar: NSLayoutConstraint?
    var widthHorizontalBar: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)


        constraintContainer()
        setUpHorizontalBar()
        stackOptionCollectionView.selectItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, animated: true, scrollPosition: .init())
//        FeedViewControllerItem?.scrollToStackIndex(index: 0)

    }

    let stackOptionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear

        collectionView.register(FeedStackCollectionCell.self, forCellWithReuseIdentifier: "FeedStackCollectionCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    func setUpHorizontalBar(){
        let horizontalBarView = UIView()
        horizontalBarView.layer.cornerRadius = 2.5
        horizontalBarView.backgroundColor = .black
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)

//        87.5
//        68.5
        leftHorizontalBar = horizontalBarView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: UIScreen.main.bounds.width*0.176)
        leftHorizontalBar?.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        widthHorizontalBar = horizontalBarView.widthAnchor.constraint(equalToConstant: 18)
        widthHorizontalBar?.isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 5).isActive = true
    }

    func constraintContainer(){
        stackOptionCollectionView.delegate = self
        stackOptionCollectionView.dataSource = self
        addSubview(stackOptionCollectionView)

        self.addConstraintsWithFormat(format: "V:|[v0]|", views: stackOptionCollectionView)
        self.addConstraintsWithFormat(format: "H:|[v0]|", views: stackOptionCollectionView)
    }






    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 2
    }



    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let stackTitles = ["Answered", "Unanswered"]
//        let stackImages = ["Trending", "FanOf"]
        let stackImages = ["answered","unanswered"]

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedStackCollectionCell", for: indexPath) as! FeedStackCollectionCell
        cell.title.text = stackTitles[indexPath.row]
        cell.image.image = UIImage(named: stackImages[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let size = CGSize(width: collectionView.frame.width/2, height: self.frame.height)
            return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let x = (UIScreen.main.bounds.width/3)*0.75

//        leftHorizontalBar?.constant = CGFloat(x)
//        if indexPath.row == 0{
//            widthHorizontalBar?.constant = 87.5
//        }else if indexPath.row == 1{
//            widthHorizontalBar?.constant = 120
//        }else{
//            widthHorizontalBar?.constant = 68.5
//        }

//        FeedViewControllerItem?.scrollToStackIndex(index: indexPath.row)

    }



    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}































