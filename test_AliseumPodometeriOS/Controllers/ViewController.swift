//
//  ViewController.swift
//  test_AliseumPodometeriOS
//
//  Created by Sloven Graciet on 26/10/2018.
//  Copyright © 2018 sloven Graciet. All rights reserved.
//

import UIKit
import HealthKit
import Lottie

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    var positionAnim: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.setOffsetPositionAnim()
        
        let animationView = LOTAnimationView(name: "deadPoolGray")
        animationView.frame = CGRect(x: self.view.frame.maxX, y: positionAnim.y, width: 250, height:  250)
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = 1
        animationView.loopAnimation = true
        
        self.view.insertSubview(animationView, at: 0)
        
        animationView.play()
        
        UIView.animate(withDuration: 3, animations: {
             animationView.frame = CGRect(x:self.positionAnim.x, y: self.positionAnim.y , width: 250, height: 250)
        }) { (finished) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.performSegue(withIdentifier: "dataStepsSegue", sender: self)
            }
        }
        
    }
    
    func setOffsetPositionAnim(){
        switch UIDevice.current.screenType {
        case .iPhone_XR,.iPhone_XSMax,.iPhones_X_XS:
            self.positionAnim = CGPoint(x: 120, y: 210)
        case .iPhones_6_6s_7_8:
            self.positionAnim = CGPoint(x: 100, y: 90)
        case .iPhones_6Plus_6sPlus_7Plus_8Plus:
            self.positionAnim = CGPoint(x: 120, y: 125)
        default:
            self.positionAnim = CGPoint(x: 100, y: 50)
        }
    }

}
