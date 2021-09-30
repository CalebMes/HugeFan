//
//  RealmObjects.swift
//  NewsTestApp
//
//  Created by Caleb Mesfien on 12/5/20.
//

import UIKit
import RealmSwift


class userObject: Object {
    @objc dynamic var username = ""
    @objc dynamic var image: NSData?
    @objc dynamic var instagramHandle = ""
    @objc dynamic var tiktokHandle = ""
    @objc dynamic var FID = ""
    @objc dynamic var points = 0
    @objc dynamic var bio = "No Bio🤷"
    @objc dynamic var isInfluencer = false
}

class fanOfObject: Object{
    @objc dynamic var username: String?
    @objc dynamic var id: String?
    @objc dynamic var image: NSData?
}

class verifiedInfluencer: Object{
    @objc dynamic var verified = false
}

class answeredQuestions: Object{
    @objc dynamic var username = ""
    @objc dynamic var points = 0
    @objc dynamic var question = ""
    @objc dynamic var answer = ""
    @objc dynamic var date = ""
    @objc dynamic var userImage: NSData?
    
}


class usedQuestions: Object{
    @objc dynamic var id = ""
    @objc dynamic var date = ""
}

class usedPromotions: Object{
    @objc dynamic var id = ""
    @objc dynamic var itemCount = 0
    @objc dynamic var date = ""

}
