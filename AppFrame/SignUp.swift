//
//  SignUp.swift
//  BarbaraAI
//
//  Created by Vasisht Muduganti on 10/14/24.
//

import UIKit
import Foundation
import FirebaseAuth
import FirebaseFirestore

class SignUp: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var headerName: UILabel!
    
    @IBOutlet weak var sendCode: UILabel!
    var loadingScreen:UIView?
    var owlImage:UIImageView?
    func setGradientBackground() {
        let colorTop = #colorLiteral(red: 0.5112794042, green: 0.6752337217, blue: 0.9972773194, alpha: 1)
            let colorBottom = #colorLiteral(red: 0.3846601248, green: 0.5937280655, blue: 1, alpha: 1)
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
                
        self.loadingScreen?.layer.insertSublayer(gradientLayer, at:0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        /*loadingScreen = UIView(frame: view.frame)
        loadingScreen?.backgroundColor = #colorLiteral(red: 0.4478189349, green: 0.6284964085, blue: 0.9998626113, alpha: 1)
        owlImage = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 300, height: 300)))
        owlImage?.image = #imageLiteral(resourceName: "barbaraLogo")
        owlImage?.contentMode = .scaleAspectFill
        owlImage?.center = view.center
        
        //owlImage?.frame = view.frame
        owlImage?.contentMode = .scaleAspectFit
        loadingScreen?.layer.zPosition = 10000000000000000
        owlImage?.layer.zPosition = 100000000000000000
        view.addSubview(loadingScreen!)
        loadingScreen?.addSubview(owlImage!)
        setGradientBackground()
        
        let nameTitleLabel = UILabel()
        nameTitleLabel.text = "Barbara"
        nameTitleLabel.font = UIFont.systemFont(ofSize: 40, weight: .semibold)
        nameTitleLabel.textColor = .white
        nameTitleLabel.textAlignment = .center
        nameTitleLabel.frame = CGRect(x: 0, y: 95, width: view.frame.width, height: 40)
        nameTitleLabel.layer.zPosition = 100000000000000000
        nameTitleLabel.center.x = view.center.x
        
        nameTitleLabel.frame.origin.y = (owlImage?.frame.maxY)! - 10
        loadingScreen?.addSubview(nameTitleLabel)*/
        setupUI()
        //sendVerification()
        // Do any additional setup after loading the view.*/
    }
    func dismissLoader(){
        print(dismissLoader)
        UIView.animate(withDuration: 0.4) {
            self.loadingScreen?.layer.opacity = 0.0
            print("jock", self.loadingScreen?.layer.opacity)
        } completion: { done in
            if(done){
                print("pock", self.loadingScreen?.layer.opacity)
            }
        }

        UIView.animate(withDuration: 0.4) {
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            print(self.loadingScreen?.layer.opacity)
        })
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Prevent the "+" from being deleted
        if textField == prefixField {
            let currentText = textField.text ?? ""
            // Ensure the "+" is always present at the start
            if range.location == 0 && range.length == 1 && string.isEmpty {
                return false // Prevent deletion of the "+"
            }
        }
        return true
    }
    
    func setupUI(){
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        firstName.layer.borderWidth = 2.0
        firstName.layer.cornerRadius = 10
        
        numberField.layer.borderWidth = 2.0
        numberField.layer.cornerRadius = 10
        
        prefixField.layer.borderWidth = 2.0
        prefixField.layer.cornerRadius = 10
        prefixField.text = "+1"
        prefixField.delegate = self
        
        firstName.center.x = view.center.x
        firstName.frame.origin.y = headerName.frame.maxY + 30
        prefixField.frame.origin.y = firstName.frame.maxY + 30
        numberField.frame.origin.y = firstName.frame.maxY + 30
        prefixField.frame.origin.x = firstName.frame.origin.x
        prefixField.frame.size.width = 60
        numberField.frame.origin.x = prefixField.frame.maxX + 30
        numberField.frame.size.width = (firstName.frame.maxX - numberField.frame.origin.x)
        
        sendCode.frame.origin.y = numberField.frame.maxY + 60
        sendCode.center.x = view.center.x
        sendCode.layer.cornerRadius = 10
        sendCode.isUserInteractionEnabled = true
        sendCode.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendVerification)))
        
        if isCancellable{
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "xmark") // SF Symbol for "X"
            imageView.tintColor = UIColor.label
            imageView.frame = CGRect(x: 20, y: 60, width: 40, height: 40)
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView(sender:))))
            view.addSubview(imageView)
        }
        
        
        
    }
    @objc func dismissView(sender: UITapGestureRecognizer){
        view.endEditing(true)
        dismiss(animated: true)
    }
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var prefixField: UITextField!
    @IBOutlet weak var firstName: UITextField!
    func validatePhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneNumberRegex = "^\\d{7,10}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        return phonePredicate.evaluate(with: phoneNumber)
    }
    let db = Firestore.firestore()
    @objc func sendVerification() {
        
        //showVerificationPage()
        
        //if UserDefaults.standard.integer(forKey: "smsRequested") < 3{
            
            
            if(validatePhoneNumber(numberField.text ?? "")){
                
                
                ////print("\(prefixField.text!)\(emailField.text!)")
                
                db.collection("users").whereField("countryPhoneNumber", isEqualTo: "\(prefixField.text!)\(numberField.text!)").limit(to: 1).getDocuments { [self] snapshot2, err2 in
                    if(snapshot2?.documents.count == 0){
                        
                        
                        PhoneAuthProvider.provider().verifyPhoneNumber("\(prefixField.text!)\(numberField.text!)", uiDelegate: nil) { [weak self] verificationID, err in
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
                            self?.isSMSOpen = true
                        
                            
                            // UserDefaults.standard.set(nameField.text, forKey: "phoneNumber")
                            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                            self?.showVerificationPage()
                            
                            ////print(verificationID)
                        }
                    }
                    else{
                        showAlert(on: self, title: "This number cannot be used for registration")
                       
                        //stopAnimating()
                    }
                }
            }
            else{
                //stopAnimating()
                
                showAlert(on: self, title: "invalid phone number format. (example: 1234567890)")
            }
        /*}
        else{
            showAlert(on: self, title: "Reached SMS limit, try again in 12 hours.")
           
        }*/
    }
    func showAlert(on viewController: UIViewController, title: String) {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    var isCancellable = false
    @objc func toVerificationPage() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "VerificationPage") as? VerificationPage
        print(verificationID)
        vc?.prefix = prefixField.text ?? ""
        vc?.number = numberField.text ?? ""
        vc?.firstName = firstName.text ?? ""
        vc?.verificationID = verificationID
        //presentTransition = RightToLeftTransition()
        //dismissTransition = LeftToRightTransition()
       
        vc?.modalPresentationStyle = .fullScreen
   

       
        
        //present(vc!, animated: true)
        present(vc!, animated: true, completion: nil)
    }
    func showVerificationPage(){
        toVerificationPage()
    }
    var isSMSOpen = false
    var verificationID = ""

                    

}
class PaddedTextField: UITextField {
    
    var textPadding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    // Override this method to add padding to the text
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

    // Override this method to add padding to the placeholder
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

    // Override this method to add padding while editing
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
}
