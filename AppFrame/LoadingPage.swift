//
//  LoadingPage.swift
//  BarbaraAI
//
//  Created by Vasisht Muduganti on 10/24/24.
//

import UIKit

class LoadingPage: UIViewController {
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
        
            print("loadesth")
            
        
        // Do any additional setup after loading the view.
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
