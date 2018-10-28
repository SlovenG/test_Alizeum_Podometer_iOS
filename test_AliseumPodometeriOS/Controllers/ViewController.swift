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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animationView = LOTAnimationView(name: "deadPoolGray")
        animationView.frame = CGRect(x: self.view.frame.maxX, y: self.titleLabel.frame.minY - 75, width: 250, height:  250)
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = 1
        animationView.loopAnimation = true
        
        self.view.insertSubview(animationView, at: 0)
        
        animationView.play()
        
        UIView.animate(withDuration: 3, animations: {
             animationView.frame = CGRect(x:120, y: self.titleLabel.frame.minY - 75 , width: 250, height: 250)
        }) { (finished) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.performSegue(withIdentifier: "dataStepsSegue", sender: self)
            }
        }
        
    }

}
