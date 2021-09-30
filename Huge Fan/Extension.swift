//
//  Extension.swift
//  Particle
//
//  Created by Caleb Mesfien on 10/15/20.
//  Copyright © 2020 Caleb Mesfien. All rights reserved.
//

import UIKit
import Lottie
import WebKit
let userDef = UserDefaults.standard



let testImages = ["defaultImage1", "defaultImage2", "defaultImage3","defaultImage4", "defaultImage5"]


protocol blackViewProtocol {
    func changeBlackView()
}

protocol LogOutDelegate {
    func logoutFunc()
}
protocol StartJoiningGroup {
    func joinGroup(ViewNum: Int)
}
extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
//let TealConstantColor = UIColor(red: 0/255, green: 191/255, blue: 152/255, alpha: 1)

let TealConstantColor = UIColor(red: 255/255, green: 90/255, blue: 95/255, alpha: 1)
//934BFF


//let BlackBackgroundColor = UIColor.white
//let subViewColor = UIColor.black
//    UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)


//let TealConstantColor = UIColor(red: 123/255, green: 0/255, blue: 255/255, alpha: 1)
let GreenConstantColor = UIColor(red: 33/255, green: 254/255, blue: 152/255, alpha: 1)
let MainPostColor = UIColor(red:97/255, green:75/255, blue:150/255, alpha:1)
let LightBlackColor =  UIColor(red: 47/255, green: 50/255, blue: 55/255, alpha: 1)
let PurpleConstantColor = UIColor(red: 142/255, green: 101/255, blue: 218/255, alpha: 1)
let BlueConstantColor = UIColor(red: 40/255, green: 96/255, blue: 215/255, alpha: 1)
//let RedConstantColor = UIColor(red: 255/255, green: 90/255, blue: 96/255, alpha: 1)


//class CollectionViewHelper{
//    let menuCollectionView = "menuCollectionView"
//    let partyCollectionView = "partyCollectionView"
//    let postCollectionView = "postCollectionView"
//    let imagePostCollectionView = "imagePostCollectionView"
//    let newPostCollectionView = "newPostCollectionView"
//    let AnswerCollectionView = "AnswerCollectionView"
//    
////    TABLE VIEW
//    let settingsTableView  = "settingsTableView"
//    let groupMembersTableView = "groupMembersTableView"
//    let postSearchTableView = "postSearchTableView"
//}

struct DefaultKey {
    static let signedIn = "SignedIn"
    static let formOfSignIn = "FormOfSignIn"
    static let userID = "userID"
    static let userProfileImageName = "userProfileImageName"
    static let username = "username"
    static let UserProfileImage  = "UserProfileImage"

}

let generator = UIImpactFeedbackGenerator()




protocol CreateNewProtocol {
    func presentCreateViewController()
    func shareGroup(GroupCode: String)
}

extension UIView{
    func addConstraintsWithFormat(format: String, views: UIView...){
        var viewDictionary: Dictionary = [String: UIView]()
        
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewDictionary))
    }
}


let imageCache = NSCache<NSString, AnyObject>()



extension UIViewController {

    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */

    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}

class CustomUserImage:  UIImageView {
    var imageUrlString: String?
    
    func loadImageUsingUrlString(urlString: String) {
        
        imageUrlString = urlString
        
        let url = NSURL(string: urlString)
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = imageFromCache
            return
    }
        
        URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
            
            if error != nil{
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                guard let imageToCache = UIImage(data: data!) else{return}
                
                
                guard let ciimage = CIImage(image: imageToCache) else {return}
                
                
                let blurFilter = CIFilter(name: "CIGaussianBlur")
                blurFilter?.setValue(ciimage, forKey: kCIInputImageKey)
                blurFilter?.setValue(75, forKey: kCIInputRadiusKey)
                
                guard let outputImage = blurFilter?.outputImage else {return}
                
                
                if self.imageUrlString == urlString {
//                    self.image = imageToCache
                    self.image = UIImage(ciImage:outputImage)
                }
//                imageCache.setObject(imageToCache!, forKey: urlString as NSString)
                imageCache.setObject(outputImage, forKey: urlString as NSString)

            }
        }.resume()
    }
}


extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}









extension String {
//    func htmlDecoded()->String {
//
//        guard (self != "") else { return self }
//
//        var newStr = self
//
//        let entities = [
//            "&quot;"    : "\"",
//            "&amp;"     : "&",
//            "&apos;"    : "'",
//            "&lt;"      : "<",
//            "&gt;"      : ">",
//            "&gt;"      : "'",
//        ]
//
//        for (name,value) in entities {
//            newStr = newStr.replacingOccurrences(of: name, with: value)
//        }
//        return newStr
//    }
//}
func htmlDecoded() -> String{

    guard let data = self.data(using: .utf8) else {
        return "nil"
    }

    let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
        .documentType: NSAttributedString.DocumentType.html,
        .characterEncoding: String.Encoding.utf8.rawValue
    ]

    guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
        return "nil"
    }
    return attributedString.string
}
}

//class CustomPostImageView:  UIImageView {
//    var imageNameFound: String?
//
//    func loadPostImagesProperly(imageName: String){
//
//        imageNameFound = imageName
//
//        image = nil
//        if let cachedImage = imageCache.object(forKey: imageName as NSString) as? UIImage{
//            if self.imageNameFound == imageName{
//            self.image = cachedImage
//            return
//            }
//        }
//            let imageRef = storageRef.reference(withPath:"/PostImages/\(imageName)")
//                    imageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
//                      if let error = error {
//                        print(error)
//                        self.image = UIImage(named: testImages.randomElement()!)
//                      }
//
//                        if let imageData = data{
//                        DispatchQueue.main.async {
//                            let downloadedImage = UIImage(data: imageData)!
//
//                            if self.imageNameFound == imageName{
//                                self.image = downloadedImage
//                        }
//                            imageCache.setObject(downloadedImage, forKey: imageName as NSString)
//                        }
//
//                    }
//                    }
//    }
//}



class CustomView: UIView {
    override var intrinsicContentSize: CGSize {
        let intrinsic = super.intrinsicContentSize
        return CGSize(width: intrinsic.width, height: intrinsic.height)
    }
}


class CustomLabel: UILabel {
    override var intrinsicContentSize: CGSize {
        let intrinsic = super.intrinsicContentSize
        return CGSize(width: intrinsic.width, height: intrinsic.height)
    }
}

class CustomImageView: UIImageView {
    override var intrinsicContentSize: CGSize {
        let intrinsic = super.intrinsicContentSize
        return CGSize(width: intrinsic.width, height: intrinsic.height)
    }
}



class AutoSizedCollectionView: UICollectionView {

    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}


extension String {
    func isEmptyOrWhitespace() -> Bool {
        
        // Check empty string
        if self.isEmpty {
            return true
        }
        // Trim and check empty string
        return (self.trimmingCharacters(in: .whitespaces) == "")
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}



var vSpinner : UIView?
 
extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        spinnerView.alpha = 0.6
        let ai = UIActivityIndicatorView.init(style: .medium)
        ai.startAnimating()
        ai.center = spinnerView.center
//        let ai = AnimationView()
//        ai.animation = Animation.named("LoadingAnimation")
//        ai.animationSpeed = 1.5
//        ai.play()
//        ai.loopMode = .loop
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
//
        vSpinner = spinnerView
//
    }
//
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
    }


extension UIImage{
    func getCropRatio() -> CGFloat {
        let widthRatio = CGFloat(self.size.width / self.size.height)
        return widthRatio
    }
}

class AboutView: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        constraintContainer()
    }
    var url: String?
    
    let webView: WKWebView = {
        let view = WKWebView()
        view.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
        view.load(URLRequest(url: URL(string: "https://chatter-1.flycricket.io/privacy.html")!))
//        view.load(URLRequest(url: URL(string: "https://apps.apple.com/us/app/id1514249158")!))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private func constraintContainer(){
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
