//
//  TestViewController.swift
//  SnsLoginFeature
//
//  Created by Jh's MacbookPro on 2020/06/03.
//  Copyright © 2020 JH. All rights reserved.
//

import UIKit
import GoogleSignIn

@available(iOS 13.0, *)
class TestViewController: UIViewController {
    

    @IBOutlet weak var lbl: UILabel!
    var paramText : GIDGoogleUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let ad = UIApplication.shared.delegate as? AppDelegate

        let googleLogin = ad?.googleDelegate
        self.lbl.text = googleLogin?.profile.email

    }
}
