//
//  HealthKitManager.swift
//  test_AliseumPodometeriOS
//
//  Created by Sloven Graciet on 26/10/2018.
//  Copyright © 2018 sloven Graciet. All rights reserved.
//

import Foundation
import UIKit
import HealthKit
import SwiftDate



protocol HealthKitManagerDelegate : class {
    func notAllowedReceiveData()
}

class HealthKitManager {
    
    weak var delegate: HealthKitManagerDelegate?

    var dataPastWeek : [(Int, Date, String)] = []

    let healthStore = HKHealthStore()
    
    init() {
        checkAuthorization()
    }
    
    func checkAuthorization()  {
        
        if HKHealthStore.isHealthDataAvailable() {
            
            guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
                 return print("unable to create stepType")
            }
           
            healthStore.requestAuthorization(toShare: nil, read: [stepType]) { (success, error) in
                guard success else {
                    if let del = self.delegate {
                        return del.notAllowedReceiveData()
                    }
                    return
                }
            }
        }
    }
    
    func recentSteps(completion: @escaping (Double, String,  Error?) ->() ){


        let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)

        let predicate = HKQuery.predicateForSamples(withStart: Date() - 1.days , end: Date(), options: [] )

        let query  = HKSampleQuery(sampleType: type!, predicate: predicate, limit: 0, sortDescriptors: nil) { (query, results, error) in

            var device : String!
            var steps : Double = 0
            
            if let r = results , r.count > 0 {
                
                // for test the result of HKSample.device is nil with the emulator, so i used HKSample.sourceRevision.productType to get some information to display
                
                device = results?.first?.sourceRevision.productType
                for result in results as! [HKQuantitySample] {
                    steps += result.quantity.doubleValue(for: HKUnit.count())
                }
            }
            completion(steps, device,error)
        }
        healthStore.execute(query)

    }
    
    
    func pastWeekSteps(completion: @escaping ([(Int, Date, String)], Error?) -> () ){
        
       self.checkAuthorization()
        
        let calendar = Calendar.current
        
        var interval = DateComponents()
        interval.day = 1

        let anchorComponents = calendar.dateComponents([.day, .month, .year , .weekday ], from: Date())
        
        guard let anchorDate = calendar.date(from: anchorComponents) else {
           return print("Unable to create a valid date")
        }
        
        guard let quantityType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
           return print("Unable to creat step count type")
        }
        
        self.dataPastWeek.removeAll()
        
        let query = HKStatisticsCollectionQuery(quantityType: quantityType,
                                                quantitySamplePredicate: nil,
                                                options: [],
                                                anchorDate: anchorDate,
                                                intervalComponents: interval)
        query.initialResultsHandler = { (query, results, error) in
            
            guard let statsCollection = results else {
                return print("unable to calculate statistics: \(String(describing: error))")
            }
            
            let endDate = Date()
            guard let startDate = calendar.date(byAdding: .day , value: -6, to: endDate) else {
                return print("Unable to calculate start date")
            }
            
            statsCollection.enumerateStatistics(from: startDate, to: endDate) { [unowned self] statistics, stop in
                
                if let quantity = statistics.sumQuantity() {
                    let date = statistics.startDate
                    let value = quantity.doubleValue(for: HKUnit.count())
                    
                    var device  = statistics.sources?.first?.name
                    if device == nil {
                        device = "Simulator"
                    }
                    self.dataPastWeek.append((Int(value), date, device!))
                }
            }
            completion(self.dataPastWeek, error)
            
        }
        healthStore.execute(query)
    }
    
}
