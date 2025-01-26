//
//  ProfilePage.swift
//  BarbaraAI
//
//  Created by Vasisht Muduganti on 10/15/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
class ProfilePage: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var DeleteAccount: UIView!
    @IBOutlet weak var phoneField: UILabel!
    @IBOutlet weak var nameField: UILabel!
    var phone = ""
    var name = ""
    @objc func dismissKeyboard(){
        if smsField?.isEditing == true{
            print("bomb leg")
            //view.endEditing(true)
        }
    }
    var phoneTitleLabel:UILabel?
    override func viewDidAppear(_ animated: Bool) {
        
    }
    @objc func dismissPopup(){
        UIView.animate(withDuration: 0.4) {
            self.darkenBackground = 0.0
            self.popupView?.frame.origin.y = self.view.frame.height
        }
    }
    @objc func deleteAccountTapped(){
        
        UIView.animate(withDuration: 0.4) {
            self.darkenBackground = 0.5
            self.popupView?.center = self.view.center
        }
    }
    var popupView:UIView?
    func setupPopUp(){
        popupView = UIView(frame: CGRect(x: 20, y: view.frame.height / 2 - 150, width: view.frame.width - 40, height: 300))
        popupView?.layer.zPosition = 999999999
        popupView?.backgroundColor = .white
                popupView?.layer.cornerRadius = 20
                popupView?.layer.shadowColor = UIColor.black.cgColor
                popupView?.layer.shadowOpacity = 0.2
                popupView?.layer.shadowOffset = CGSize(width: 0, height: 2)
                popupView?.layer.shadowRadius = 10

                // Title Label
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 20, width: Int((popupView?.frame.width)!), height: 40))
                titleLabel.text = "Delete Account"
                titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
                titleLabel.textAlignment = .center
        titleLabel.textColor = .black
                
                // Description Label
        let descriptionLabel = UILabel(frame: CGRect(x: 20, y: 70, width: (popupView?.frame.width)! - 40, height: 80))
                descriptionLabel.text = "Are you sure you want to delete this account? The account will be permanently deleted after this."
                descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
                descriptionLabel.textAlignment = .center
                descriptionLabel.numberOfLines = 0
                descriptionLabel.textColor = UIColor(red: 0.15, green: 0.13, blue: 0.27, alpha: 1)
                
                // Cancel Button
                let cancelButton = UIButton(type: .system)
        cancelButton.frame = CGRect(x: 20, y: (popupView?.frame.height)! - 70, width: ((popupView?.frame.width)! / 2) - 30, height: 50)
                cancelButton.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 1.0, alpha: 1)
                cancelButton.setTitle("Cancel", for: .normal)
                cancelButton.setTitleColor(.white, for: .normal)
                cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
                cancelButton.layer.cornerRadius = 25
                
                // Add icon to Cancel Button
                let cancelIcon = UIImage(systemName: "xmark.circle.fill")
                cancelButton.setImage(cancelIcon, for: .normal)
                cancelButton.tintColor = .white
                cancelButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
                cancelButton.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)
                
                // Delete Button
                confirmDeleteButton = UIButton(type: .system)
        confirmDeleteButton?.frame = CGRect(x: cancelButton.frame.maxX + 20, y: (popupView?.frame.height)! - 70, width: ((popupView?.frame.width)! / 2) - 30, height: 50)
                confirmDeleteButton?.backgroundColor = UIColor(red: 1, green: 0.4, blue: 0.4, alpha: 1)
                confirmDeleteButton?.setTitle("Delete", for: .normal)
                confirmDeleteButton?.setTitleColor(.white, for: .normal)
                confirmDeleteButton?.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
                confirmDeleteButton?.layer.cornerRadius = 25
                
                // Add icon to Delete Button
                let trashIcon = UIImage(systemName: "trash.fill")
                confirmDeleteButton?.setImage(trashIcon, for: .normal)
                confirmDeleteButton?.tintColor = .white
                confirmDeleteButton?.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
                confirmDeleteButton?.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)

                // Add subviews to popup
                popupView?.addSubview(titleLabel)
                popupView?.addSubview(descriptionLabel)
                popupView?.addSubview(cancelButton)
        popupView?.addSubview(confirmDeleteButton!)
                
                // Add the popup view to the main view
        view.addSubview(popupView!)
        popupView?.frame.origin.y = view.frame.height
    }
    var confirmDeleteButton:UIButton?
    private var darkenView: UIView?
    
    var darkenBackground: CGFloat = 0 {
            didSet {
                if darkenView == nil {
                    darkenView = UIView(frame: view.bounds)
                    darkenView?.backgroundColor = UIColor.black.withAlphaComponent(0)
                    darkenView?.isUserInteractionEnabled = false
                    darkenView?.layer.zPosition = 99999999 // Below the side menu
                    if let darkenView = darkenView {
                        view.addSubview(darkenView)
                    }
                }
                darkenView?.backgroundColor = UIColor.black.withAlphaComponent(darkenBackground)
            }
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        var tappes = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tappes.cancelsTouchesInView = false
        view.addGestureRecognizer(tappes)
        
        //DeleteAccount.isUserInteractionEnabled = true
        //DeleteAccount.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteAccount(sender:))))
        container.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
         // Adjust font size as needed
        createVerificationPage()
        // Action for when the button is pressed
       
        
        cardView.layer.cornerRadius = 40
        cardView.backgroundColor = .white
        cardView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        let emailIcon = UIImageView(image: UIImage(systemName: "person.fill"))
                emailIcon.tintColor = UIColor(red: 0.4, green: 0.6, blue: 1.0, alpha: 1)
                emailIcon.contentMode = .scaleAspectFit
                emailIcon.frame = CGRect(x: 20, y: 100, width: 40, height: 40)
                
                let nameTitleLabel = UILabel()
        nameTitleLabel.text = "Name"
        nameTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        nameTitleLabel.textColor = UIColor(red: 0.4, green: 0.6, blue: 1.0, alpha: 1)
        nameTitleLabel.frame = CGRect(x: 70, y: 95, width: 200, height: 20)
                
                let nameValueLabel = UILabel()
        nameValueLabel.text = ""
        nameValueLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        nameValueLabel.textColor = .black
        nameValueLabel.frame = CGRect(x: 70, y: 115, width: 300, height: 25)
                
                // Add separator
                let separatorView1 = UIView()
                separatorView1.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
                separatorView1.frame = CGRect(x: 20, y: 160, width: view.frame.width - 40, height: 1)
                
                // 2. Create phone section (Icon + Label)
                let phoneIcon = UIImageView(image: UIImage(systemName: "phone.fill"))
                phoneIcon.tintColor = UIColor(red: 0.4, green: 0.6, blue: 1.0, alpha: 1)
                phoneIcon.contentMode = .scaleAspectFit
                phoneIcon.frame = CGRect(x: 20, y: 180, width: 40, height: 40)
                
                phoneTitleLabel = UILabel()
                phoneTitleLabel?.text = "Phone Number"
                phoneTitleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
                phoneTitleLabel?.textColor = UIColor(red: 0.4, green: 0.6, blue: 1.0, alpha: 1)
                phoneTitleLabel?.frame = CGRect(x: 70, y: 175, width: 200, height: 20)
                
                let phoneValueLabel = UILabel()
                phoneValueLabel.text = ""
                phoneValueLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        phoneValueLabel.textColor = .black
                phoneValueLabel.frame = CGRect(x: 70, y: 195, width: 300, height: 25)
                
                // Add separator
                let separatorView2 = UIView()
                separatorView2.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
                separatorView2.frame = CGRect(x: 20, y: 240, width: view.frame.width - 40, height: 1)
                
                // 3. Create "Delete Account" section
                let deleteTitleLabel = UILabel()
                deleteTitleLabel.text = "Delete Account"
                deleteTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        deleteTitleLabel.textColor = .black
                deleteTitleLabel.frame = CGRect(x: 20, y: 260, width: 200, height: 25)
                
                let deleteButton = UIButton(type: .system)
                deleteButton.frame = CGRect(x: view.frame.width - 140, y: 250, width: 120, height: 50)
                deleteButton.backgroundColor = UIColor(red: 1, green: 0.4, blue: 0.4, alpha: 1)
                deleteButton.setTitle("Delete", for: .normal)
                deleteButton.setTitleColor(.white, for: .normal)
                deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
                deleteButton.layer.cornerRadius = 25
                
                // Add icon to the delete button
                let trashIcon = UIImage(systemName: "trash.fill")
                deleteButton.setImage(trashIcon, for: .normal)
                deleteButton.tintColor = .white
                deleteButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
                
                // Add action for delete button (e.g., confirmation alert)
                deleteButton.addTarget(self, action: #selector(deleteAccountTapped), for: .touchUpInside)
                
                // Add all subviews to the main view
                cardView.addSubview(emailIcon)
                cardView.addSubview(nameTitleLabel)
                cardView.addSubview(nameValueLabel)
                cardView.addSubview(separatorView1)
                cardView.addSubview(phoneIcon)
                cardView.addSubview(phoneTitleLabel!)
                cardView.addSubview(phoneValueLabel)
                cardView.addSubview(separatorView2)
                cardView.addSubview(deleteTitleLabel)
                cardView.addSubview(deleteButton)
        
        var diff = 60.0
        nameTitleLabel.frame.origin.y -= diff
        emailIcon.frame.origin.y -= diff
        nameValueLabel.frame.origin.y -= diff
        separatorView1.frame.origin.y -= diff
        phoneIcon.frame.origin.y -= diff
        phoneTitleLabel?.frame.origin.y -= diff
        phoneValueLabel.frame.origin.y -= diff
        separatorView2.frame.origin.y -= diff
        deleteTitleLabel.frame.origin.y -= diff
        deleteButton.frame.origin.y -= diff
        
        if let user = Auth.auth().currentUser?.uid{
            db.collection("users").document(user).getDocument { [self] doc, err in
                if err == nil{
                    let data = doc?.data()
                    var name = data?["username"] as? String
                    var phone = data?["countryPhoneNumber"] as? String
                    phoneValueLabel.text = phone
                    nameValueLabel.text = name
                }
            }
            
        }
        setupPopUp()
        
        goBackView = UIView(frame: CGRect(x: 16, y: view.safeAreaInsets.top + 60, width: 70, height: 100)) // Adjust height for label space
        goBackView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissAlert)))
        goBackView?.layer.zPosition = 10000000 // Set zPosition to a high value
            
        
            // Create a circular background
            let circleView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) // Adjust size
        circleView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            circleView.layer.cornerRadius = 25 // Half of width/height to make it circular
            circleView.layer.masksToBounds = true
            
        goBackView?.addSubview(circleView)
            
            // Create an icon using UIImageView
            let iconImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20)) // Centered in the circle
            iconImageView.image = UIImage(systemName: "chevron.left")
            iconImageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) // Set icon color to white
            iconImageView.contentMode = .scaleAspectFill
        iconImageView.center = CGPoint(x: circleView.frame.width/2, y: circleView.frame.height/2)
            circleView.addSubview(iconImageView)
            
            // Create a label
            let label = UILabel()
            label.text = "Go Back"
            label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) // Set label color to white
            label.textAlignment = .center
            label.numberOfLines = 1 // Set number of lines to 1 to fit content
           // Adjusts the label size to fit the text
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
            // Set the label frame
        label.frame = CGRect(x: 0, y: 60, width: 70, height: 29)
        circleView.center.x = label.center.x
        // Positioned below the circle
            
        goBackView?.addSubview(label)
        view.addSubview(goBackView!)
        
        
        
        var profileView = UIView(frame: CGRect(x: 13, y: view.safeAreaInsets.top + 60, width: 70, height: 100)) // Adjust height for label space
        profileView.center.x = view.center.x
    
        //profileView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissAlert)))
        profileView.layer.zPosition = 10000000 // Set zPosition to a high value
            
        
            // Create a circular background
            let circleView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 65, height: 65)) // Adjust size
        circleView2.image = #imageLiteral(resourceName: "whiteProfile")
        circleView2.tintColor = .white
        circleView2.contentMode = .scaleAspectFill
        circleView2.layer.cornerRadius = circleView2.frame.height/2 // Half of width/height to make it circular
            circleView2.layer.masksToBounds = true
            
        profileView.addSubview(circleView2)
            
            // Create an icon using UIImageView
            let iconImageView2 = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20)) // Centered in the circle
            iconImageView2.image = #imageLiteral(resourceName: "barbaraLogo")
            iconImageView2.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) // Set icon color to white
            iconImageView2.contentMode = .scaleAspectFill
        iconImageView2.center = CGPoint(x: circleView2.frame.width/2, y: circleView2.frame.height/2)
            //circleView2.addSubview(iconImageView2)
            
            // Create a label
            let label2 = UILabel()
            label2.text = "Profile"
            label2.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) // Set label color to white
            label2.textAlignment = .center
            label2.numberOfLines = 1 // Set number of lines to 1 to fit content
           // Adjusts the label size to fit the text
        label2.adjustsFontSizeToFitWidth = true
        label2.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
            // Set the label frame
        label2.frame = CGRect(x: 0, y: 64, width: 70, height: 29)
        circleView2.center.x = label2.center.x
        // Positioned below the circle
        
        profileView.addSubview(label2)
        view.addSubview(profileView)
    }
    let db = Firestore.firestore()
    @objc func dismissAlert() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.impactOccurred()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
            self.dismiss(animated: true, completion: nil)
        })
        
    }
    @objc func deleteAccount(sender:UITapGestureRecognizer){
        confirmDeleteButton?.isUserInteractionEnabled = false
        confirmDeleteButton?.layer.opacity = 0.5
            let newPhoneNumber = "\(Auth.auth().currentUser?.phoneNumber ?? "")" // New phone number
            
            PhoneAuthProvider.provider().verifyPhoneNumber(newPhoneNumber, uiDelegate: nil) { [self] verificationID2, error in
                if let error = error {
                    print(error.localizedDescription)
                    //print("Error sending verification code: \(error.localizedDescription)")
                    
                } else if let verificationID2 = verificationID2 {
                    //UserDefaults.standard.set(verificationID2, forKey: "\(userID)phoneVerificationID2")
                    verificationID = verificationID2
                    var smsRequested = UserDefaults.standard.integer(forKey: "smsRequested")
                    smsRequested += 1
                    UserDefaults.standard.setValue(smsRequested, forKey: "smsRequested")
                  
                    
                }
            }
            UIView.animate(withDuration: 0.3) {
                self.codeView?.layer.opacity = 1.0
                self.popupView?.isUserInteractionEnabled = false
            }
            // Handle the account deletion process here
            
        

       
    }
    var goBackView:UIView?
    var verificationID = ""
    var button2: UIImageView?

    @IBOutlet weak var cardView: UIView!
    var smsField: UITextField?
    var codeView: UIView?
    var nextButton: UIImageView?
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
        
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("hellozone")
    }
    func createVerificationPage(){
        codeView = UIView(frame: CGRect(x: 0, y: view.frame.height, width: view.frame.width - 200, height: 230))
        codeView?.center = CGPoint(x: view.center.x, y: view.center.y)
        codeView?.layer.cornerRadius = 15
        codeView?.layer.opacity = 0.0
        codeView?.backgroundColor = .white
        codeView?.tag = -1
        codeView?.layer.zPosition = 10000000000000
        
        smsField = UITextField(frame: CGRect(x: 30, y: 20, width: (codeView?.frame.width)! - 60, height: 60))
        codeView?.addSubview(smsField!)
        smsField?.frame.origin = CGPoint(x: 30, y: 20)
        smsField?.layer.borderColor = UIColor.lightGray.cgColor
        smsField?.layer.borderWidth = 2
        smsField?.layer.cornerRadius = 15
        smsField?.layer.zPosition = 100000000000000
        smsField?.placeholder = "123456"
        smsField?.textColor = .black
        smsField?.font = UIFont(name: (smsField?.font!.fontName)!, size: 30)
        smsField?.textAlignment = .center
        smsField?.tag = -1
        smsField?.delegate = self
        smsField?.isUserInteractionEnabled = true
        smsField?.keyboardType = .numberPad
        codeView?.layer.shadowColor = UIColor.black.cgColor
        codeView?.layer.shadowOpacity = 0.5
        codeView?.layer.shadowOffset = CGSize(width: 2, height: 2)
        codeView?.layer.shadowRadius = 4
        codeView?.layer.masksToBounds = false
        
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
        
        
        button2 = UIImageView()
        button2?.frame = CGRect(x: -3, y: (codeView?.frame.origin.y)!, width: 40, height: 40)
     
       
        button2?.frame.origin.y = -10
        button2?.image = UIImage(systemName: "x.circle.fill")
        
        button2?.layer.opacity = 0.0
        button2?.layer.zPosition = 1000000
        button2?.tag = -1
        button2?.isUserInteractionEnabled = true
       // button2?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close(sender:))))
        
        codeView?.addSubview(button2!)
        view.addSubview(codeView!)
        
    }
    @objc func verifySMS(sender: UITapGestureRecognizer){
        let text = smsField?.text
        
        if let currentUser = Auth.auth().currentUser {
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID ?? "", verificationCode: text ?? "")
            
            currentUser.reauthenticate(with: credential) { result, err in
                if err == nil{
                    if let user = Auth.auth().currentUser?.uid{
                        print("brazos \(user)")
                        Auth.auth().currentUser?.delete { error in
                            if let error = error {
                                //print("Error deleting user account: \(error.localizedDescription)")
                                print(error.localizedDescription)
                                return
                            }
                            else{
                                print("successed")
                                self.db.collection("users").document(user).delete { err in
                                    print(user)
                                    if err != nil{
                                        print("LUXESS")
                                        print(err?.localizedDescription)
                                    }
                                    else{
                                        print("SUXXESS")
                                    }
                                }
                                
                            }
                        }
                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let regiloginVC = self.storyboard?.instantiateViewController(identifier: "SignUp")
                        ////print("signing out")
                        self.view.window?.rootViewController = regiloginVC
                        self.view.window?.makeKeyAndVisible()
                            
                        
                        
                
                    }
                }
                else{
                    print("Error")
                    //print(err)
                }
            }
        }
    }
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
