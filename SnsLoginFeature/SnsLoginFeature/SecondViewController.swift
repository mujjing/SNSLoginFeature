//
//  SecondViewController.swift
//  SnsLoginFeature
//
//  Created by Jh's MacbookPro on 2020/05/26.
//  Copyright © 2020 JH. All rights reserved.
//

import UIKit
import GoogleSignIn
import FacebookLogin
import FacebookCore
import FBSDKLoginKit
import AuthenticationServices


@available(iOS 13.0, *)
class SecondViewController: UIViewController {
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var tokenLbl: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var loginLbl: UILabel!
    var paramName = ""
    var paramId = ""
    var paramToken = ""
    var yahooCode : String?
    var googleParam : GIDGoogleUser?
    var appleParam : ASAuthorizationAppleIDCredential?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutBtn.addTarget(self, action: #selector(logoutEvent(_:)), for: .touchUpInside)
        self.nameLbl.text = paramName
        self.idLbl.text = paramId
        self.tokenLbl.text = paramToken
        
        if googleParam != nil{
            self.loginLbl.text = "google login"
        }else if AccessToken.current != nil {
            self.loginLbl.text = "facebook login"
        }else if appleParam != nil{
            self.loginLbl.text = "apple login"
        }
        self.nextBtn.addTarget(self, action: #selector(nextBtnEvent(_:)), for: .touchUpInside)
    }
    @objc func nextBtnEvent(_ sender: UIButton){
        let st : UIStoryboard = UIStoryboard(name: "Test", bundle: nil)
        let vc = st.instantiateViewController(withIdentifier: "TestViewController") as! TestViewController
        vc.paramText = googleParam!
        //navigationController?.pushViewController(vc, animated: true)
        present(vc, animated: true)
    }
    
    @objc func logoutEvent(_ sender: UIButton){
        if AccessToken.current != nil{
            AccessToken.current = nil
            print("페이스북 로그아웃")
            dismiss(animated: true, completion: nil)
        }else if googleParam != nil{
            GIDSignIn.sharedInstance()?.signOut()
            print("구글 로그아웃")
            dismiss(animated: true, completion: nil)
        }else if yahooCode != nil{
            print("야후 로그아웃")
            dismiss(animated: true, completion: nil)
        }else{
            print("에러")
        }
       

    }
    
}
