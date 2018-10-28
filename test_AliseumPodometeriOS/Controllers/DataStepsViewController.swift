//
//  DataStepsViewController.swift
//  test_AliseumPodometeriOS
//
//  Created by Sloven Graciet on 27/10/2018.
//  Copyright © 2018 sloven Graciet. All rights reserved.
//

import UIKit

class DataStepsViewController: UIViewController {
    
    var dataPastWeek : [(Int, Date, String)] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var parentTableView: UIView!
    @IBOutlet weak var emptyDataLabel: UILabel!
    
    var healthKitManager = HealthKitManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        healthKitManager.delegate = self
        
        self.initLayers()
        
    }
    
    func initLayers() {
        
        self.updateButton.layer.cornerRadius = 4
        self.parentTableView.layer.cornerRadius = 4
        self.tableView.layer.cornerRadius = 4
        self.tableView.estimatedRowHeight = 100
        
        self.parentTableView.layer.shadowColor = UIColor.black.cgColor
        self.parentTableView.layer.shadowOpacity = 0.4
        self.parentTableView.layer.shadowOffset = CGSize(width: 3, height: 5)
        self.parentTableView.layer.shadowRadius = 5
        
        self.updateButton.layer.shadowColor = UIColor.black.cgColor
        self.updateButton.layer.shadowOpacity = 0.4
        self.updateButton.layer.shadowOffset = CGSize(width: 1.5, height: 2.5)
        self.updateButton.layer.shadowRadius = 5
        
    }
    
    @IBAction func didTapedUpdateButton(_ sender: UIButton) {
        
        healthKitManager.pastWeekSteps { (dataPastWeek, error) in
            DispatchQueue.main.async {
                self.dataPastWeek = dataPastWeek 
                self.tableView.reloadData()
                if self.dataPastWeek.count > 0 {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    self.emptyDataLabel.isHidden = true
                }
                else {
                    self.emptyDataLabel.isHidden = false
                }
                
            }
            if let _ = error {
                print(error.debugDescription )
            }
        }
    }
    
}

extension DataStepsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataPastWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "stepsTableViewCell", for: indexPath) as? StepsTableViewCell  {
            if self.dataPastWeek.count > 0 {
                let data = self.dataPastWeek[self.dataPastWeek.count - 1 - indexPath.row]
                cell.initialize(day: data.1 , steps: "\(data.0)" , source: data.2)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension DataStepsViewController : HealthKitManagerDelegate {
    func notAllowedReceiveData() {
        let alert = UIAlertController(title: "Authorization refused", message: "you refuse the authorization to let us collect yours step", preferredStyle: .alert)
        self.present(alert, animated: true)

    }
    
}

