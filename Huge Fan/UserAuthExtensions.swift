//
//  UserAuthExtensions.swift
//  NewsTestApp
//
//  Created by Caleb Mesfien on 12/5/20.
//

import AuthenticationServices

class AppleSignInClient: NSObject{
    var complectionHandler: (_ fullname: String?, _ email: String?, _ userID: String?) -> Void = {
        _, _, _ in}
    
    @objc func handleAppleIdRequest(block: @escaping (_ fullname: String?, _ email: String?, _ userID: String?) -> Void) {
        complectionHandler = block
        let appleIdProvider = ASAuthorizationAppleIDProvider()
        let request = appleIdProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    
    func getCredentialState(userID: String) {
        let appleIdProvider = ASAuthorizationAppleIDProvider()
        appleIdProvider.getCredentialState(forUserID: userID) { credentialState, _ in
            switch credentialState {
            case .authorized:
                print("First")
                break
            case .revoked:
                print("Second")
                
                break
            case .notFound:
                print("Thrid")
                break
                
            default:
                break
            }
        }
    }
}

extension AppleSignInClient: ASAuthorizationControllerDelegate{
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIdCredential.user
            let fullName = appleIdCredential.fullName
            let email = appleIdCredential.email
            print(userIdentifier, fullName, email)
            
            complectionHandler(fullName?.givenName, email, userIdentifier)
            
            getCredentialState(userID: userIdentifier)
            
    }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error has occured: ", error)
    }
    
    
}
