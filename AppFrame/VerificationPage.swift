//
//  VerificationPage.swift
//  BarbaraAI
//
//  Created by Vasisht Muduganti on 10/15/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class VerificationPage: UIViewController, UITextFieldDelegate {
    @objc func resign(sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       //verificationID = ""
        var tapper = UITapGestureRecognizer(target: self, action: #selector(resign(sender:)))
        tapper.cancelsTouchesInView = false
        view.addGestureRecognizer(tapper)
        
        createVerificationPage()
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var weTextedACodeLabel: UILabel!
    var smsField: UITextField?
    var codeView: UIView?
    var codeView2: UIView?
    var nextButton: UIImageView?
    var nextButton2: UIImageView?
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
                   let textRange = Range(range, in: text) {
                   let updatedText = text.replacingCharacters(in: textRange,
                                                               with: string)
            if(updatedText.count > 6 && textField.tag == -1){
                return false
            }
        if(updatedText.count == 6 && textField.tag == -1){
            ////print("bazingorna")
            nextButton?.tintColor = UIColor(red: 18/255, green: 96/255, blue: 252/255, alpha: 1.0)
            nextButton?.isUserInteractionEnabled = true
            
        }
        else if(textField.tag == -1){
            nextButton?.tintColor = UIColor(red: 125/255, green: 165/255, blue: 245/255, alpha: 1.0)
            nextButton?.isUserInteractionEnabled = false
        }
        }
        if(textField.tag == 3000){
        if let text = textField.text,
                   let textRange = Range(range, in: text) {
                   let updatedText = text.replacingCharacters(in: textRange,
                                                               with: string)
           
            if(updatedText.first != "+" && updatedText.count < 4){
                return false
            }
        }
        }
        return true
    }
    func createVerificationPage(){
        codeView = UIView(frame: CGRect(x: 0, y: view.frame.height, width: view.frame.width - 200, height: 230))
        codeView?.center = CGPoint(x: view.center.x, y: view.center.y)
        codeView?.frame.origin.y = weTextedACodeLabel.frame.maxY
        codeView?.layer.cornerRadius = 15
        codeView?.layer.opacity = 1.0
        codeView?.backgroundColor = .white
     
        codeView?.tag = -1
        codeView?.layer.zPosition = 1000000
        
        smsField = UITextField(frame: CGRect(x: 30, y: 20, width: (codeView?.frame.width)! - 60, height: 60))
        codeView?.addSubview(smsField!)
        smsField?.frame.origin = CGPoint(x: 30, y: 20)
        smsField?.layer.borderColor = UIColor.lightGray.cgColor
        smsField?.layer.borderWidth = 2
        smsField?.layer.cornerRadius = 15
        smsField?.placeholder = "123456"
        smsField?.textColor = .black
        smsField?.font = UIFont(name: (smsField?.font!.fontName)!, size: 30)
        smsField?.textAlignment = .center
        smsField?.tag = -1
        smsField?.delegate = self
        smsField?.keyboardType = .numberPad
        
        
        let text = UILabel(frame: CGRect(x: 30, y: 90, width: (codeView?.frame.width)! - 60, height: 40))
        text.numberOfLines = 0
        codeView?.addSubview(text)
        text.frame.origin = CGPoint(x: 30, y: 90)
        text.adjustsFontSizeToFitWidth = true
        text.minimumScaleFactor = 0.2
        text.textColor = .lightGray
        text.text = "Wait a few seconds for an SMS containing a verification code"
        text.font = UIFont(name: text.font.familyName, size: 20)
        text.tag = -1
        
        let resetLabel = UILabel(frame: CGRect(x: 30, y: 136, width: (codeView?.frame.width)! - 60, height: 20))
        resetLabel.textColor = .blue
        resetLabel.text = "Resend Text"
       // codeView?.addSubview(resetLabel)
        resetLabel.textAlignment = .center
        resetLabel.tag = -1
        //resetLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resendCode(sender:))))
        
        nextButton = UIImageView(frame: CGRect(x: 0, y: 151, width: 60, height: 60))
        nextButton?.tintColor = UIColor(red: 125/255, green: 165/255, blue: 245/255, alpha: 1.0)
        nextButton?.isUserInteractionEnabled = false
        nextButton?.center.x = (codeView?.frame.width)!/2
        nextButton?.image = UIImage(systemName: "arrow.right.circle.fill")
        nextButton?.isUserInteractionEnabled = false
        nextButton?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(verifySMS(sender:))))
        nextButton?.tag = -1
        codeView?.addSubview(nextButton!)
        
        
        
        view.addSubview(codeView!)
        
        let label1 = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        label1.text = "Didn't recieve a code?"
        label1.center.x = view.center.x
        label1.textAlignment = .center
        label1.frame.origin.y = CGFloat(Int((codeView?.frame.origin.y)!) + Int((codeView?.frame.height)!))
        
        label2 = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        label2?.text = "Resend new code"
        label2?.textColor = .link
        label2?.center.x = view.center.x
        label2?.textAlignment = .center
        label2?.frame.origin.y = CGFloat(Int((label1.frame.origin.y)) + Int((label1.frame.height)))
        label2?.isUserInteractionEnabled = true
        label2?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resendCode)))
        
        view.addSubview(label1)
        view.addSubview(label2!)
        
        
    }
    var label2:UILabel?
    @objc func resendCode(){
        label2?.isUserInteractionEnabled = false
        label2?.textColor = .gray
        PhoneAuthProvider.provider().verifyPhoneNumber("\(prefix)\(number)", uiDelegate: nil) { [weak self] verificationID, err in
            guard let verificationID = verificationID, err == nil else{
                print(err?.localizedDescription)
                self?.showAlert(on: self!, title: "Error")
               
             
                return
            }
            var smsRequested = UserDefaults.standard.integer(forKey: "smsRequested")
            smsRequested += 1
         
            UserDefaults.standard.setValue(smsRequested, forKey: "smsRequested")
            self?.verificationID = verificationID
            print(self?.verificationID)
            print(verificationID)
            print("olaaa")
            
            ////print("norigami")
            
            // UserDefaults.standard.set(nameField.text, forKey: "phoneNumber")
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
           
            
            ////print(verificationID)
        }
    }
    var verificationID = ""
    @objc func toHomePage() {
        print("To Home!")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "VoicePage") as? VoicePage
        vc?.isFirstVerification = true
           
        
        vc?.userID = Auth.auth().currentUser?.uid ?? ""
        print(Auth.auth().currentUser?.uid, "karma")
    vc?.modalPresentationStyle = .fullScreen
   
        
        //present(vc!, animated: true)
        present(vc!, animated: true, completion: nil)
    }
    @objc func verifySMS(sender: UITapGestureRecognizer){
        let text = smsField?.text
        
        verifyCode(smsCode: text!) { done in
            print("bazushs")
            if done == true{
                self.toHomePage()
            }
        }
    }
    
    func showAlert(on viewController: UIViewController, title: String) {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    var prefix = ""
    var number = ""
    var firstName = ""
    public func verifyCode(smsCode: String, completion: @escaping (Bool) -> Void){
        let db = Firestore.firestore()
        let verificationID = verificationID
        print("garumba")
        if verificationID == ""{
            print("chummy")
            completion(false)
            return
        }
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: smsCode)
        
        Auth.auth().signIn(with: credential) { [self] result, err in
            guard result != nil, err == nil else{
                completion(false)
                print(err?.localizedDescription)
                showAlert(on: self, title: "error")
                return
            }
            ////print("SIGNED IN")
            
            UserDefaults.standard.set(nil, forKey: "authVerificationID")
            var random = Int.random(in: 1...6)
            
            db.collection("users").document(result!.user.uid).setData(["username": firstName, "uid": result!.user.uid, "countryPhoneNumber": "\(prefix)\(number)", "phoneNumber": "\(number)"]) { (err) in
                if(err != nil){
                    //Show error message
                    
                }
                else{
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    UserDefaults.standard.synchronize()
                     
                }
            }
            completion(true)
        }
    }
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var button2: UIImageView?
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
