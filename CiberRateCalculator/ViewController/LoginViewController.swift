//
//  LoginViewController.swift
//  CiberRateCalculator
//
//  Created by Selvakumar on 02/03/20.
//  Copyright © 2020 Selvakumar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var userNameTextField:UITextField?
    @IBOutlet weak var passwordTextField:UITextField?
    var userNameString : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
 @IBAction func loginButtonPressed()
 {
    if userNameTextField?.text != nil && passwordTextField?.text != nil && userNameTextField?.text ?? "" != "" && passwordTextField?.text ?? "" != ""
    {
         if (validate(userName:userNameTextField?.text ?? "", password: passwordTextField?.text ?? ""))
         {
            print("Username or Password is Correct")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let  welcomeDashboardViewController = storyBoard.instantiateViewController(withIdentifier: "WelcomeDashboardViewController") as! WelcomeDashboardViewController
            welcomeDashboardViewController.modalPresentationStyle = .fullScreen
            welcomeDashboardViewController.userName = userNameString
            self.present(welcomeDashboardViewController, animated:true, completion:nil)
            self.userNameTextField?.text = ""
            self.passwordTextField?.text = ""

         }
        else
         {
            print("Username or Password is incorrect")
            let alert = UIAlertController(title: "", message: "Username or Password is incorrect", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
         }
    }
    else
    {
        print("Please Enter Username and Password")
        let alert = UIAlertController(title: "", message: "Please Enter Username and Password", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
 }
    
    func validate(userName:String,password:String) -> Bool {
        switch userName {
        case "Kishore":
            if (password=="123@Welcome") {
                userNameString = userName
                return true
            }
            else
            {return false}
            
            case "Ramki":
                if (password=="123Welcome@") {
                    userNameString = userName
                    return true
                }
            else
                {return false}
            
            case "Vel":
                if (password=="123Welcome") {
                    userNameString = userName
                    return true
                }
            else
                {return false}
            
            case "Mohan":
                if (password=="12345@Welcome") {
                    userNameString = userName
                    return true
                }
            else
                {return false}
            case "Selva":
                if (password=="12345Welcome@") {
                    userNameString = userName
                    return true
                }
            else
                {return false}
            // New User 
            case "HTCUSER":
                if (password=="12345Welcome") {
                    userNameString = userName
                    return true
                }
            else
                {return false}
            // new user added
        default:
            return false
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
