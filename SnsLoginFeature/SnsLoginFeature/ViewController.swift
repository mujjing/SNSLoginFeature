//
//  ViewController.swift
//  SnsLoginFeature
//
//  Created by Jh's MacbookPro on 2020/05/26.
//  Copyright © 2020 JH. All rights reserved.
//

import UIKit
import GoogleSignIn
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import TwitterKit
import YJLoginSDK
import AuthenticationServices

@available(iOS 13.0, *)
class ViewController: UIViewController,GIDSignInDelegate {
    
    
    @IBOutlet weak var appleSignInBtn: ASAuthorizationAppleIDButton!
    @IBOutlet weak var googleSignInBtn: UIButton!
    @IBOutlet weak var facebookSignInBtn: UIButton!
    @IBOutlet weak var twitterSignInBtn: UIButton!
    @IBOutlet weak var yahooSignInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        googleSignInBtn.addTarget(self, action: #selector(googleLogin(_:)), for: .touchUpInside)
        facebookSignInBtn.addTarget(self, action: #selector(facebookLogin(_:)), for: .touchUpInside)
        twitterSignInBtn.addTarget(self, action: #selector(twitterLogin(_:)), for: .touchUpInside)
        yahooSignInBtn.addTarget(self, action: #selector(yahooLogin(_:)), for: .touchUpInside)
        appleSignInBtn.addTarget(self, action: #selector(appleLogin(_:)), for: .touchUpInside)
        googlePresent()
        
    }
    
    
    func googlePresent(){
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
    
    @objc func appleLogin(_ sender: UIButton){
        print("apple login")
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    @objc func googleLogin(_ sender: UIButton){
        
        GIDSignIn.sharedInstance()?.signIn()
        GIDSignIn.sharedInstance()?.delegate = self
    }
    @objc func facebookLogin(_ sender: UIButton){
        fblogin()
    }
    @objc func twitterLogin(_ sender: UIButton){
        TWTRTwitter.sharedInstance().logIn{
            (session, error) in
            if session != nil{
                UserDefaults.standard.set(session?.userID, forKey: "userId")
                UserDefaults.standard.set(session?.userName, forKey: "userName")
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                   let vc = storyboard.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
                                   vc.modalPresentationStyle = .fullScreen
                vc.paramId = "\(session?.userID ?? "")"
                vc.paramName = "\(session?.userName ?? "")"
                
                self.present(vc, animated: true)
                                  

            }else{
                print("error")
                print(error.debugDescription)
            }
        }
    }
    
    @objc func yahooLogin(_ sender : UIButton){
        LoginManager.shared.login(scopes: [.openid, .profile], nonce: "", codeChallenge: "E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM") { (result) in
            switch result {
            case .success(let loginResult):
                // ログイン成功
                print("yahoo login")
                print(loginResult.authorizationCode)
                    
                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
                vc.modalPresentationStyle = .fullScreen
                vc.paramId = "\(Scope.email)"
                vc.paramName = "\(Scope.profile)"
                vc.paramToken = "\(Scope.openid)"
                vc.yahooCode = loginResult.authorizationCode
                self.present(vc, animated: true)
                break
            case .failure(let error):
                // ログイン失敗
                print(error)
                break
            }
        }
    }
    func fblogin(){
        
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions:[.publicProfile, .email, .userFriends], viewController: self){ loginResult in
            switch loginResult{
            case .failed(let error) :
                //HUD.hide()
            print(error)
            case .cancelled :
            //HUD.hide()
            print("user cancelled login")
            case .success( _, _, _) :
            print("login")
            self.getFBUserData()
                
                            }
        }
    }
    func getFBUserData(){
        
         
        if AccessToken.current != nil {
            GraphRequest(graphPath: "me", parameters: ["fields" : "id, name, picture.type(large), email, gender"]).start(completionHandler: {(connection, result, error) -> Void in
                
                if error == nil {
                    let dic = result as! [String:AnyObject]
                    print(result!)
                    print(dic)
                    let pictureDic = dic as NSDictionary
                    let tmpURL1 = pictureDic.object(forKey: "picture") as! NSDictionary
                    let tmpURL2 = tmpURL1.object(forKey: "data") as! NSDictionary
                    let finalURL = tmpURL2.object(forKey: "url") as! String
                    
                    let nameOfUser = pictureDic.object(forKey: "name") as! String
                    
                    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
                    vc.modalPresentationStyle = .fullScreen
                    vc.paramToken = "\(AccessToken.current!)"
                    vc.paramName = nameOfUser
                    var  tmpEmailAdd = ""
                    if let emailAddress = pictureDic.object(forKey: "email"){
                        tmpEmailAdd = emailAddress as! String
                        vc.paramId = tmpEmailAdd

                    }else {
                        var usrName = nameOfUser
                        usrName = usrName.replacingOccurrences(of: " ", with: "")
                        tmpEmailAdd = usrName + "@facebook.com"
                    }
                    self.present(vc, animated: true)
                }
            })
        }

    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error{
            print(error)
        }else{
            if let gmailUser = user{
                //      let userId = user.userID                  // For client-side use only!
                //      let idToken = user.authentication.idToken // Safe to send to the server
                //      let fullName = user.profile.name
                //      let givenName = user.profile.givenName
                //      let familyName = user.profile.familyName
                //      let email = user.profile.email
                
                print("로그인 아이디는 \(gmailUser.profile.email!) \n 이름은 \(gmailUser.profile.name!) \n토큰은 \(gmailUser.authentication.idToken ?? "")입니다")
                
                let ad = UIApplication.shared.delegate as? AppDelegate
                ad?.googleDelegate = user
                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
                vc.modalPresentationStyle = .fullScreen
                vc.googleParam = user
                vc.paramId = "로그인 아이디는 \(gmailUser.profile.email!)"
                vc.paramName = "이름은 \(gmailUser.profile.name!) 입니다 "
                vc.paramToken = "토큰은 \(gmailUser.authentication.idToken!)"
                present(vc, animated: true)

                
            }
        }
    }
    
}

@available(iOS 13.0, *)
extension ViewController : ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding{
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error",error)
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential{
        case let credentials as ASAuthorizationAppleIDCredential:
            print(credentials)
            print("login success")
//            let user = User(credentials: credentials)
//            self.signUpSocial(emailAddress: user.mail, firstName: user.firstName, lastName : user.lastName, socialID : user.id, socialName : "Apple")
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
            vc.modalPresentationStyle = .fullScreen
            vc.appleParam = credentials
            vc.paramId = "로그인 아이디는 \(credentials.email ?? "")"
            vc.paramName = "이름은 \(credentials.fullName?.familyName ?? "")\(credentials.fullName?.givenName ?? "") 입니다 "
            vc.paramToken = "토큰은 \(credentials.identityToken!) 입니다"
            present(vc, animated: true)
            break
        default:
            break
        }
    }
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
       }
}


