//
//  CreateEstimateViewController.swift
//  CiberRateCalculator
//
//  Created by Selvakumar on 14/10/19.
//  Copyright © 2019 Selvakumar. All rights reserved.
//

import UIKit
import CoreData

//    struct Area: Codable {
//        var areaId:Int
//        var areaName:String
//    }


extension String {
    func isValidDouble(maxDecimalPlaces: Int) -> Bool {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true // Default is true, be explicit anyways
        let decimalSeparator = formatter.decimalSeparator ?? "."
        if formatter.number(from: self) != nil {
            // Split our string at the decimal separator
            let split = self.components(separatedBy: decimalSeparator)
            let digits = split.count == 2 ? split.last ?? "" : ""
            // Finally check if we're <= the allowed digits
            return digits.characters.count <= maxDecimalPlaces    // TODO: Swift 4.0 replace with digits.count, YAY!
        }
        return false // couldn't turn string into a valid number
    }
}
class CreateEstimateViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,DropDownViewDelegate,HTCDropDownDelegate,UITextFieldDelegate,UIAlertViewDelegate {
    @IBOutlet weak var noResultsLabel : UILabel!
    @IBOutlet weak var blendedGB : UILabel!
    @IBOutlet weak var estimatedRevenue : UILabel!
    @IBOutlet weak var numberOfResource : UILabel!
    @IBOutlet weak var overView : UIView!
    @IBOutlet weak var segmentControl : UISegmentedControl!
    @IBOutlet weak var estimateTableView : UITableView!
    var tableViewTextFlagArea : Bool = false
    var tableViewTextFlagJobTitle : Bool = false
    var tableViewTextFlagJobLevel : Bool = false

    var strLabel :UILabel =  UILabel()
    var activityIndicator :UIActivityIndicatorView =  UIActivityIndicatorView()
    let effectView :UIView = UIView()
    var keyboardHeight:CGFloat = 0
    var tableViewBounds:CGRect = CGRect.zero
    
    var estimateArray = Array<EstimateDataModal>()
    let createEstimateArray = EstimateDataModal()

    var indexPathValue = IndexPath(row: 0, section: 0)
    var indexValue : Int = 0
    var selectedIndexValue : Int = 0
    var regionID : Int = 0
    var jobTitleID : Int = 0
    var jobLevelID : Int = 0
    var listOfArea : NSMutableArray = []
    var listOfJobTitle : NSMutableArray = []
    var listOfJobLevel : NSMutableArray = []
    var selectedString : String = ""
    var noOfScreenCount : Int = 0
    var verversionDictionary : NSDictionary = NSDictionary()
    //DropDown
    var dropDownController : DropDownViewController?
    var dropDownControllerJobTitle : DropDownJobTitleViewController?
    var dropDownControllerJobLevel : DropDownJobLevelViewController?

    var dataModelArr : Array<HTCDropDownModel> = []
    var dataModelArrayJobTitle : Array<HTCDropDownModel> = []
    var dataModelArrarJobLevel : Array<HTCDropDownModel> = []
    var dataModelArrarMinimamBillRate : Array<HTCDropDownModel> = []
    var retriveArray : Array<HTCDropDownModel> = []
    var retriveArrayJobTitile : Array<HTCDropDownModel> = []
    var retriveArrayJobLevel : Array<HTCDropDownModel> = []
    var retriveArraySalary : Array<HTCDropDownModel> = []
    var selectedSalaryArray : Array<HTCDropDownModel> = []
    var versionArray : Array<HTCDropDownModel> = []


             // MARK:- CoreData calls
    func GetAllData() {
        
        let networkReachableStatus = NetworkManager.sharedInstance.isReachable()
        if networkReachableStatus == false
        {
            let alert = UIAlertController(title: "No internet connection", message: "Please check your internet connection and try again", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
              // Set up the URL request
              //let todoEndpoint: String = "http://mapp2.htcindia.com:8080/ciber/calculator/getalldata" // https://jsonplaceholder.typicode.com/todos/1
              let todoEndpoint: String = "http://mapp2.htcindia.com:8080/ciber/calculator/getarea"
              guard let url = URL(string: todoEndpoint) else {
                  print("Error: cannot create URL")
                  return
              }
              let urlRequest = URLRequest(url: url)
              
              // set up the session
              let config = URLSessionConfiguration.default
              let session = URLSession(configuration: config)
              
              // make the request
              let task = session.dataTask(with: urlRequest) {
                  (data, response, error) in
                  // check for any errors
                  guard error == nil else {
                      print("error calling GET on /todos/1")
                      print(error!)
                      return
                  }
                  // make sure we got data
                  guard let responseData = data else {
                      print("Error: did not receive data")
                      return
                  }

                  // parse the result as JSON, since that's what the API provides
                  do {
                      guard let todo = try JSONSerialization.jsonObject(with: responseData, options: [])
                          as? [String: Any] else {
                              print("error trying to convert data to JSON")
                              return
                      }
                      
                      let responseDict = todo as NSDictionary
                      //let reponseArray = responseDict["value"] as! NSArray
                      let reponsedataArray = responseDict["area"] as! NSArray
                      let reponsedataArrayJobTitle = responseDict["jobTitle"] as! NSArray
                      let reponsedataArrayAlldata = responseDict["jobRole"] as! NSArray
                      let reponsedataVersionArray = responseDict["version"] as! NSArray
                      let responseDataSalarArray  =  responseDict["salary"] as! NSArray
                      let responseDataFixedCostArray  =  responseDict["salaryFixedPercent"] as! NSArray
                      let responseDataRateFixedPercent = responseDict["rateFixedPercent"] as! NSArray

                    // Set vertion and timestamp in system
                        let versionDic = reponsedataVersionArray[0] as! NSDictionary
                        UserDefaults.standard.set(versionDic["versionID"] as? Int, forKey: "versionID")  //Integer
                        UserDefaults.standard.set(versionDic["lastUpdatedDateTime"], forKey: "lastUpdatedDateTime") //setObject
                    // Set fixed cost in system
                    let fixedCost = responseDataFixedCostArray[0] as! NSDictionary
                    UserDefaults.standard.set(fixedCost["fixedPercentage"], forKey: "fixedPercentage") //setObject
                    // Set fixed percentage in system
                    let fixedPercentage = responseDataRateFixedPercent[0] as! NSDictionary
                    UserDefaults.standard.set(fixedPercentage["fixedGP"], forKey: "fixedGP") //setObject
                    UserDefaults.standard.set(fixedPercentage["fixedEstimatedHours"], forKey: "fixedEstimatedHours") //setObject


                    print("Print count",reponsedataArray.count,reponsedataArrayJobTitle.count,reponsedataArrayAlldata.count,reponsedataVersionArray.count,responseDataSalarArray.count)
                    if reponsedataArray.count > 0
                    {
                        self.dataModelArr.removeAll()
                        for  i in 0 ..< reponsedataArray.count {
                            let array1 = reponsedataArray[i] as! NSDictionary
                            let dropDownModelObj = HTCDropDownModel()
                            let idValue  = array1["areaId"] as! Int
                            dropDownModelObj.modelId = String(idValue)
                            let areaName : String = "Area "+String(i+1)
                            dropDownModelObj.modelData = areaName
                             dropDownModelObj.cityString = array1["areaName"] as Any as! String
                        // if Int(dropDownModelObj.modelId) ?? -1 >= 0 {
                             self.dataModelArr.insert(dropDownModelObj, at: i)
                         //}
                             
                        }
                    }
                    
                    
                    if reponsedataArrayJobTitle.count > 0
                    {
                        self.retriveArrayJobTitile.removeAll()
                        for  i in 0 ..< reponsedataArrayJobTitle.count {
                            let dictObject = reponsedataArrayJobTitle[i] as! NSDictionary
                            let dropDownModelObj = HTCDropDownModel()
                            let idValue  = dictObject["jobTitleID"] as! Int
                            dropDownModelObj.modelId = String(idValue)
                             dropDownModelObj.modelData = dictObject["jobTitleName"] as Any as! String
                             self.retriveArrayJobTitile.insert(dropDownModelObj, at: i)
                        }
                    }
                    
                    if reponsedataArrayAlldata.count > 0
                    {
                        self.retriveArrayJobLevel.removeAll()
                        for  i in 0 ..< reponsedataArrayAlldata.count {
                            let dictObject = reponsedataArrayAlldata[i] as! NSDictionary
                            let dropDownModelObj = HTCDropDownModel()
                            let idValue  = dictObject["roleID"] as! Int
                            dropDownModelObj.modelId = String(idValue)
                            let idJobValue  = dictObject["jobTitleID"] as! Int
                            dropDownModelObj.modelSecondData = String(idJobValue)
                             dropDownModelObj.modelData = dictObject["roleName"] as Any as! String
                             self.retriveArrayJobLevel.insert(dropDownModelObj, at: i)
                        }
                    }
                    
                    if responseDataSalarArray.count > 0
                    {
                        self.retriveArraySalary.removeAll()
                        for  i in 0 ..< responseDataSalarArray.count {
                            let dictObject = responseDataSalarArray[i] as! NSDictionary
                            let dropDownModelObj = HTCDropDownModel()
                            let idValue  = dictObject["roleID"] as! Int
                            dropDownModelObj.roleID = String(idValue)
                            let idJobValue  = dictObject["jobTitleID"] as! Int
                            dropDownModelObj.jobTitleID = String(idJobValue)
                            dropDownModelObj.areaID = String(dictObject["areaID"] as! Int)
                            dropDownModelObj.minSalary = String(dictObject["minSalary"] as! Int)
                            dropDownModelObj.maxSalary = String(dictObject["maxSalary"] as! Int)
                            dropDownModelObj.averageSalary = String(dictObject["averageSalary"] as! Int)
                             self.retriveArraySalary.insert(dropDownModelObj, at: i)
                        }
                    }

                    DispatchQueue.main.async {
                        self.saveUserData(self.dataModelArr)
                        self.saveJobTitle(self.retriveArrayJobTitile)
                        self.saveJobLevelFromJobTitle(self.retriveArrayJobLevel)
                        self.saveSalary(self.retriveArraySalary)
                    }

                  } catch  {
                      print("error trying to convert data to JSON")
                      return
                  }
              }
              task.resume()
          }
    
    
    func deleteAllDataFromEndity(EntityName:String) {

    let appDel:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
    let context:NSManagedObjectContext = appDel.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityName)
        fetchRequest.returnsObjectsAsFaults = false

        do
        {
            let results = try context.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Deleted all my data in myEntity error : \(error) \(error.userInfo)")
        }
    }
    
    func deleteData(){
               
               //As we know that container is set up in the AppDelegates so we need to refer that container.
               guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
               
               //We need to create a context from this container
               let managedContext = appDelegate.persistentContainer.viewContext
               
               let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Area")
               fetchRequest.predicate = NSPredicate(format: "areaId = %@", "5")
              
               do
               {
                   let test = try managedContext.fetch(fetchRequest)
                   let objectToDelete = test[0] as! NSManagedObject
                   managedContext.delete(objectToDelete)
                   
                   do{
                       try managedContext.save()
                   }
                   catch
                   {
                       print(error)
                   }
                   
               }
               catch
               {
                   print(error)
               }
           }
    
    
    
    //  Saving Salary
          
          func saveSalary(_ areas: [HTCDropDownModel]) {
              let appDelegate = UIApplication.shared.delegate as! AppDelegate
              let context = appDelegate.persistentContainer.viewContext
              do {
                      if areas.count > 0
                      {
                                 for  i in 0 ..< areas.count { //for user in areas {
                                     // print("areas.count",areas.count)
                                  let dropDownModelObj = areas[i]
                                      let newUser = NSEntityDescription.insertNewObject(forEntityName: "Salary", into: context)
                                    newUser.setValue(dropDownModelObj.roleID, forKey: "roleID")
                                      newUser.setValue(dropDownModelObj.jobTitleID, forKey: "jobTitleID")
                                      newUser.setValue(dropDownModelObj.areaID, forKey: "areaID")
                                    newUser.setValue(dropDownModelObj.minSalary, forKey: "minSalary")
                                    newUser.setValue(dropDownModelObj.maxSalary, forKey: "maxSalary")
                                    newUser.setValue(dropDownModelObj.averageSalary, forKey: "averageSalary")
                                    //print("saveSalary",dropDownModelObj.roleID,dropDownModelObj.jobTitleID,dropDownModelObj.minSalary,dropDownModelObj.roleID,dropDownModelObj.maxSalary,dropDownModelObj.averageSalary)
                                  }
                          try context.save()
                          print("Success")
                           DispatchQueue.main.async {
                          //self.deleteData()
                          //self.retrieveJobLevelFromJobTitle()
                          //let retriveArrayVal = self.retrieveSavedUsers()
                          //print("Number of revied array ",retriveArrayVal ?? [],retriveArrayVal?.count ?? 0)
                          }
                     }

              } catch {
                  print("Error saving: \(error)")
              }
          }
    
    
    //  Saving JobLevel from JobTitle
          
          func saveJobLevelFromJobTitle(_ areas: [HTCDropDownModel]) {
              let appDelegate = UIApplication.shared.delegate as! AppDelegate
              let context = appDelegate.persistentContainer.viewContext
              do {
                      if areas.count > 0
                      {
                                 for  i in 0 ..< areas.count { //for user in areas {
                                     // print("areas.count",areas.count)
                                  let dropDownModelObj = areas[i]
                                      let newUser = NSEntityDescription.insertNewObject(forEntityName: "JobLevel", into: context)
                                    newUser.setValue(dropDownModelObj.modelId, forKey: "roleID")
                                      newUser.setValue(dropDownModelObj.modelSecondData, forKey: "jobTitleID")
                                      newUser.setValue(dropDownModelObj.modelData, forKey: "roleName")
                                      //print("saveUserData",dropDownModelObj.modelId,dropDownModelObj.modelData,dropDownModelObj.modelSecondData)
                                  }
                          try context.save()
                          print("Success")
                           DispatchQueue.main.async {
                          //self.deleteData()
                          //self.retrieveJobLevelFromJobTitle()
                          //let retriveArrayVal = self.retrieveSavedUsers()
                          //print("Number of revied array ",retriveArrayVal ?? [],retriveArrayVal?.count ?? 0)
                          }
                     }

              } catch {
                  print("Error saving: \(error)")
              }
          }
    
    
    
      //  retrieveData Salary
    
    func retrieveSalary(areaID: String,jobTitleID: String,roleID: String) {
                  //As we know that container is set up in the AppDelegates so we need to refer that container.
                  guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                  //We need to create a context from this container
                  let managedContext = appDelegate.persistentContainer.viewContext
                  //Prepare the request of type NSFetchRequest  for the entity
            
                  let p1 = NSPredicate(format: "areaID = %@", areaID)
                  let p2 = NSPredicate(format: "jobTitleID = %@", jobTitleID)
                  let p3 = NSPredicate(format: "roleID = %@", roleID)
                  let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Salary")
                  fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2,p3])
                  self.selectedSalaryArray.removeAll()
                  do {
                                    let result = try managedContext.fetch(fetchRequest)
                                      for data in result as! [NSManagedObject] {
                                          print(data.value(forKey: "roleID") as? String as Any)
                                          let dropDownModelObj = HTCDropDownModel()
                                          guard let roleID = data.value(forKey: "roleID") as? String else { return  }
                                          guard let jobTitleID = data.value(forKey: "jobTitleID") as? String else { return  }
                                          guard let areaID = data.value(forKey: "areaID") as? String else { return  }
                                          guard let maxSalary = data.value(forKey: "maxSalary") as? String else { return  }
                                          guard let minSalary = data.value(forKey: "minSalary") as? String else { return  }
                                          guard let averageSalary = data.value(forKey: "averageSalary") as? String else { return  }

                                          dropDownModelObj.roleID = roleID
                                          dropDownModelObj.jobTitleID = jobTitleID
                                          dropDownModelObj.areaID = areaID
                                          dropDownModelObj.maxSalary = maxSalary
                                          dropDownModelObj.minSalary = minSalary
                                          dropDownModelObj.averageSalary = averageSalary
                                          self.selectedSalaryArray.append(dropDownModelObj)
                                         // print("ReceivedArrayCountSalary",self.selectedSalaryArray.count)
                      }
                  } catch {
                      print("Failed")
                  }
                
                print("selectedIndexValue",selectedIndexValue)
        if self.selectedSalaryArray.count > 0 && selectedIndexValue >= 0
        {
            
            let dictObject = self.selectedSalaryArray[0]
            estimateArray[selectedIndexValue].maximumSalary = Float(dictObject.maxSalary) ?? 0.0
            //self.calculateEstimatedRevenue()
            let GBvalue = estimateArray[selectedIndexValue].estimateGB
            let estimatedHours = estimateArray[selectedIndexValue].estimateHours
            let maximumSalary : Float = estimateArray[selectedIndexValue].maximumSalary
            let fixedCost : String = (UserDefaults.standard.string(forKey: "fixedPercentage") ?? "0.4236")
            let fixedAnnualHours : String = (UserDefaults.standard.string(forKey: "fixedAnnualBillableHours")) ?? "2080"
            self.GetRevenueBillRate(salary: Int(maximumSalary), estimatedHours: Int(estimatedHours), fixedPercentage: Float(fixedCost)!, GP: GBvalue, fixedAnnualHour: Int(Float(fixedAnnualHours)!))
        }


    }
    
    // New changes requseted on this calculation part which is on Nov 29
        func calculateEstimatedRevenue()  {
        let GBvalue = estimateArray[selectedIndexValue].estimateGB
        let estimatedHours = estimateArray[selectedIndexValue].estimateHours
        let maximumSalary : Float = estimateArray[selectedIndexValue].maximumSalary
     
        let fixedCost : String = (UserDefaults.standard.string(forKey: "fixedPercentage") ?? "0.4236")
        let fixedCostInPercentage = ((Float(fixedCost))!/100.0)
        let fixedAnnualHours : String = (UserDefaults.standard.string(forKey: "fixedAnnualBillableHours")) ?? "2080"
            
            
            let payRate = (Double(maximumSalary)/(Double(fixedAnnualHours) ?? 2080))
            let directCost = ((estimatedHours*(Float(payRate)))*(1+fixedCostInPercentage))
            let revenue = (directCost/(1-(GBvalue/100)))
            let billRate = (revenue/estimatedHours)
       
        let region : Int = estimateArray[selectedIndexValue].regionId
        let jobTitile : Int = estimateArray[selectedIndexValue].jobTitleId
        let jobLevel : Int = estimateArray[selectedIndexValue].jobLevelId
               /*
//        let fixedCost : String = (UserDefaults.standard.string(forKey: "fixedPercentage") ?? "0.4236")
//        let fixedCostInPercentage = ((Float(fixedCost))!/100.0)

        
        let GBinPercentage = (GBvalue/100)
        let variableA = Float(maximumSalary)/estimatedHours
        let variableB = variableA  + (variableA * Float(fixedCostInPercentage))
        let variableC = variableB + (variableB * GBinPercentage) // Minimum Bill rate
        let variableD = (variableC * estimatedHours)            // Estimated Revenue
        estimateArray[selectedIndexValue].miimumBillRateSalary = variableC
        estimateArray[selectedIndexValue].estimatedTotalRevenueSalary = variableD
 */
        estimateArray[selectedIndexValue].miimumBillRateSalary = billRate
        estimateArray[selectedIndexValue].estimatedTotalRevenueSalary = revenue
        var estimatedRevenueSalary :Float = 0.0
        for i in (0..<estimateArray.count)
        {
            estimatedRevenueSalary += estimateArray[i].estimatedTotalRevenueSalary
        }
        //self.estimatedRevenue.text = self.uscurrencyFormatFromInt(minimamBillRate: Int(estimatedRevenueSalary))
        //let aString = self.uscurrencyFormatFromInt(minimamBillRate: Int(estimatedRevenueSalary))
        let aString = self.uscurrencyFormatFrom(minimamBillRate: estimatedRevenueSalary)
        let revenueNew = aString.replacingOccurrences(of: ".00", with: "")
        self.estimatedRevenue.text = revenueNew
        //self.estimatedRevenue.text = self.uscurrencyFormatFrom(minimamBillRate: estimatedRevenueSalary)
        //self.estimateTableView.reloadData()
        
        
        print("GBvalue",GBvalue)
        print("estimatedHours",estimatedHours)
        print("regionID for cuurent Selection",region)
        print("jobTitileID for cuurent Selection",jobTitile)
        print("jobLevelID for cuurent Selection",jobLevel)
        print("maximumSalary",maximumSalary)
        print("fixedCostInPercentage",fixedCostInPercentage)
    }
    
    
    
    
    /*
 // CalculateEstimatedRevenue
    func calculateEstimatedRevenue()  {
        let GBvalue = estimateArray[selectedIndexValue].estimateGB
        let estimatedHours = estimateArray[selectedIndexValue].estimateHours
        let maximumSalary : Float = estimateArray[selectedIndexValue].maximumSalary

        let region : Int = estimateArray[selectedIndexValue].regionId
        let jobTitile : Int = estimateArray[selectedIndexValue].jobTitleId
        let jobLevel : Int = estimateArray[selectedIndexValue].jobLevelId
        let fixedCost : String = (UserDefaults.standard.string(forKey: "fixedPercentage") ?? "0.4236")
        let fixedCostInPercentage = ((Double(fixedCost))!/100.0)

        
        let GBinPercentage = (GBvalue/100)
        let variableA = Float(maximumSalary)/estimatedHours
        let variableB = variableA  + (variableA * Float(fixedCostInPercentage))
        let variableC = variableB + (variableB * GBinPercentage) // Minimum Bill rate
        let variableD = (variableC * estimatedHours)            // Estimated Revenue
        estimateArray[selectedIndexValue].miimumBillRateSalary = variableC
        estimateArray[selectedIndexValue].estimatedTotalRevenueSalary = variableD
        var estimatedRevenueSalary :Float = 0.0
        for i in (0..<estimateArray.count)
        {
            estimatedRevenueSalary += estimateArray[i].estimatedTotalRevenueSalary
        }
        //self.estimatedRevenue.text = self.uscurrencyFormatFromInt(minimamBillRate: Int(estimatedRevenueSalary))
        let aString = self.uscurrencyFormatFromInt(minimamBillRate: Int(estimatedRevenueSalary))
        let revenue = aString.replacingOccurrences(of: ".00", with: "")
        self.estimatedRevenue.text = revenue
        //self.estimatedRevenue.text = self.uscurrencyFormatFrom(minimamBillRate: estimatedRevenueSalary)
        //self.estimateTableView.reloadData()
        
        
        print("GBvalue",GBvalue)
        print("estimatedHours",estimatedHours)
        print("regionID for cuurent Selection",region)
        print("jobTitileID for cuurent Selection",jobTitile)
        print("jobLevelID for cuurent Selection",jobLevel)
        print("maximumSalary",maximumSalary)
        print("fixedCostInPercentage",fixedCostInPercentage)
    }
 */
    
    
    
      //  retrieveData JobLevel from JobTitle
    
    func retrieveJobLevelFromJobTitle(jobTitleID: String) {
                  
        self.activityIndicator("Loading")
                  //As we know that container is set up in the AppDelegates so we need to refer that container.
                  guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                  //We need to create a context from this container
                  let managedContext = appDelegate.persistentContainer.viewContext
                  //Prepare the request of type NSFetchRequest  for the entity
                  let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "JobLevel")
                    fetchRequest.predicate = NSPredicate(format: "jobTitleID == %@", jobTitleID) // JobTitleID = self.estimateArray[self.selectedIndexValue].jobLevelId
//                    let sortDescriptor = NSSortDescriptor(key: "jobTitleID", ascending: true)
//                    let sortDescriptors = [sortDescriptor]
//                    fetchRequest.sortDescriptors = sortDescriptors
                let sectionSortDescriptor = NSSortDescriptor(key: "roleID", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
                  //let sectionSortDescriptor = NSSortDescriptor(key: "roleName", ascending: true)
                  let sortDescriptors = [sectionSortDescriptor]
                  fetchRequest.sortDescriptors = sortDescriptors
                  self.dataModelArrarJobLevel.removeAll()
                  do {
                                     // let result = try managedContext.fetch(fetchRequest)
                                    let result = try managedContext.fetch(fetchRequest)
                                      for data in result as! [NSManagedObject] {
                                          print(data.value(forKey: "roleID") as? String as Any)
                                          print(data.value(forKey: "roleName") as? String as Any)
                                          let dropDownModelObj = HTCDropDownModel()
                                          guard let modelId = data.value(forKey: "roleID") as? String else { return  }
                                          guard let modelData = data.value(forKey: "roleName") as? String else { return  }
                                          dropDownModelObj.modelId = modelId
                                          dropDownModelObj.modelData = modelData
                      //                    dropDownModelObj.modelId = data.value(forKey: "areaId") as? String as Any as! String
                      //                    dropDownModelObj.modelData = data.value(forKey: "areaName") as? String as Any as! String
                                          //dropDownModelObj.cityString = cityString
                                           self.dataModelArrarJobLevel.append(dropDownModelObj)
                                          //print("ReceivedArrayCount",self.dataModelArrarJobLevel.count)
                      }
                  } catch {
                      print("Failed")
                  }
        self.removeActivity()
        
              }
              
          
    
    
    
    
    //  Saving saveJobTitle
          
          func saveJobTitle(_ areas: [HTCDropDownModel]) {
              let appDelegate = UIApplication.shared.delegate as! AppDelegate
              let context = appDelegate.persistentContainer.viewContext
              do {
                      if areas.count > 0
                      {
                                 for  i in 0 ..< areas.count { //for user in areas {
                                      //print("areas.count",areas.count)
                                  let dropDownModelObj = areas[i]
                                      let newUser = NSEntityDescription.insertNewObject(forEntityName: "JobTitle", into: context)
                                      newUser.setValue(dropDownModelObj.modelId, forKey: "jobTitleID")
                                      newUser.setValue(dropDownModelObj.modelData, forKey: "jobTitleName")
                                      //print("saveUserData",dropDownModelObj.modelId,dropDownModelObj.modelData,dropDownModelObj.cityString)
                                  }
                          try context.save()
                          print("Success")
                           DispatchQueue.main.async {
                          //self.deleteData()
                          self.retrieveJobTitle()
                          //let retriveArrayVal = self.retrieveSavedUsers()
                          //print("Number of revied array ",retriveArrayVal ?? [],retriveArrayVal?.count ?? 0)
                          }
                     }

              } catch {
                  print("Error saving: \(error)")
              }
              
              
          }
      //  retrieveData saveJobTitle
    
              func retrieveJobTitle() {
                  //As we know that container is set up in the AppDelegates so we need to refer that container.
                  guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                  //We need to create a context from this container
                  let managedContext = appDelegate.persistentContainer.viewContext
                  //Prepare the request of type NSFetchRequest  for the entity
                  let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "JobTitle")
                let sectionSortDescriptor = NSSortDescriptor(key: "jobTitleID", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
                //let sectionSortDescriptor = NSSortDescriptor(key: "jobTitleID", ascending: true)
                let sortDescriptors = [sectionSortDescriptor]
                fetchRequest.sortDescriptors = sortDescriptors
                
               //let sort = NSSortDescriptor(key: "contentid", ascending: true, selector: "localizedStandardCompare:")

                
                  self.dataModelArrayJobTitle.removeAll()
                  do {
                                      let result = try managedContext.fetch(fetchRequest)
                                      for data in result as! [NSManagedObject] {
//                                          print("jobTitleID",data.value(forKey: "jobTitleID") as? String as Any)
//                                          print(data.value(forKey: "jobTitleName") as? String as Any)
                                          let dropDownModelObj = HTCDropDownModel()
                                          guard let modelId = data.value(forKey: "jobTitleID") as? String else { return  }
                                          guard let modelData = data.value(forKey: "jobTitleName") as? String else { return  }
                                          print("jobLevelID",modelId)
                                          dropDownModelObj.modelId = modelId
                                          dropDownModelObj.modelData = modelData
                      //                    dropDownModelObj.modelId = data.value(forKey: "areaId") as? String as Any as! String
                      //                    dropDownModelObj.modelData = data.value(forKey: "areaName") as? String as Any as! String
                                          //dropDownModelObj.cityString = cityString
                                           self.dataModelArrayJobTitle.append(dropDownModelObj)
                                         // print("ReceivedArrayCount",self.dataModelArrayJobTitle.count)
                      }
                  } catch {
                      print("Failed")
                  }
                
                   // self.removeActivity()
                
              }
              
          
    
           
            // Area Saving
        
        func saveUserData(_ areas: [HTCDropDownModel]) {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            do {
                    if areas.count > 0
                    {
                               for  i in 0 ..< areas.count { //for user in areas {
                                    //print("areas.count",areas.count)
                                let dropDownModelObj = areas[i]
                                    let newUser = NSEntityDescription.insertNewObject(forEntityName: "Area", into: context)
                                    newUser.setValue(dropDownModelObj.modelId, forKey: "areaId")
                                    newUser.setValue(dropDownModelObj.modelData, forKey: "areaName")
                                    newUser.setValue(dropDownModelObj.cityString, forKey: "cityString")
                                   // print("saveUserData",dropDownModelObj.modelId,dropDownModelObj.modelData,dropDownModelObj.cityString)
                                }
                        try context.save()
                        print("Success")
                         DispatchQueue.main.async {
                        //self.deleteData()
                        self.retrieveData()
                        //let retriveArrayVal = self.retrieveSavedUsers()
                        //print("Number of revied array ",retriveArrayVal ?? [],retriveArrayVal?.count ?? 0)
                        }
                   }

            } catch {
                print("Error saving: \(error)")
            }
            
            
        }
    // Area retrieveData
            func retrieveData() {
                //As we know that container is set up in the AppDelegates so we need to refer that container.
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                //We need to create a context from this container
                let managedContext = appDelegate.persistentContainer.viewContext
                //Prepare the request of type NSFetchRequest  for the entity
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Area")
                let sectionSortDescriptor = NSSortDescriptor(key: "areaId", ascending: true)
                let sortDescriptors = [sectionSortDescriptor]
                fetchRequest.sortDescriptors = sortDescriptors
                self.retriveArray.removeAll()
                do {
                                    let result = try managedContext.fetch(fetchRequest)
                                    for data in result as! [NSManagedObject] {
                                        print(data.value(forKey: "areaId") as? String as Any)
                                        print(data.value(forKey: "areaName") as? String as Any)
                                        let dropDownModelObj = HTCDropDownModel()
                                        guard let modelId = data.value(forKey: "areaId") as? String else { return  }
                                        guard let modelData = data.value(forKey: "areaName") as? String else { return  }
                                        guard let cityString = data.value(forKey: "cityString") as? String else { return  }
                                        dropDownModelObj.modelId = modelId
                                        dropDownModelObj.modelData = modelData
                                        dropDownModelObj.cityString = cityString
                    //                    dropDownModelObj.modelId = data.value(forKey: "areaId") as? String as Any as! String
                    //                    dropDownModelObj.modelData = data.value(forKey: "areaName") as? String as Any as! String
                                        //dropDownModelObj.cityString = cityString
                                         self.retriveArray.append(dropDownModelObj)
                                        //print("ReceivedArrayCount",self.retriveArray.count)
                    }
                } catch {
                    print("Failed")
                }
            }
            
        
    
    
    // MARK:- API Calls
    
    // Get version tile
    func getVersion()
    {
        // Set up the URL request
               let todoEndpoint: String = "http://mapp2.htcindia.com:8080/ciber/calculator/getversion" // https://jsonplaceholder.typicode.com/todos/1
               guard let url = URL(string: todoEndpoint) else {
                   print("Error: cannot create URL")
                   return
               }
               let urlRequest = URLRequest(url: url)
               
               // set up the session
               let config = URLSessionConfiguration.default
               let session = URLSession(configuration: config)
               
               // make the request
               let task = session.dataTask(with: urlRequest) {
                   (data, response, error) in
                   // check for any errors
                   guard error == nil else {
                       print("error calling GET on /todos/1")
                       print(error!)
                       return
                   }
                   // make sure we got data
                   guard let responseData = data else {
                       print("Error: did not receive data")
                       return
                   }
                   let jsonEncoder = JSONEncoder()
                   // parse the result as JSON, since that's what the API provides
                   do {
                       guard let todo = try JSONSerialization.jsonObject(with: responseData, options: [])
                           as? [String: Any] else {
                               print("error trying to convert data to JSON")
                               return
                       }
                       // now we have the todo
                       // let's just print it to prove we can access it
                       print("The todo is: " + todo.description)
                       
                       let responseDict = todo as NSDictionary
                       //let reponseArray = responseDict["value"] as! NSArray
                       let reponsedataArray = responseDict["data"] as! NSArray
                       self.versionArray.removeAll()
                           for  i in 0 ..< reponsedataArray.count {
                               self.verversionDictionary = reponsedataArray[i] as! NSDictionary
                               let dropDownModelObj = HTCDropDownModel()
                               let idValue  = self.verversionDictionary["versionID"] as! Int
                               dropDownModelObj.modelId = String(idValue)
                               dropDownModelObj.modelData = self.verversionDictionary["lastUpdatedDateTime"] as Any as! String
                               self.versionArray.insert(dropDownModelObj, at: i)
                            print("self.verversionDictionary",self.versionArray)
                            self.removeActivity()
                           }
                   } catch  {
                       print("error trying to convert data to JSON")
                       return
                   }
               }
               task.resume()
    }
    
    //https://stackoverflow.com/questions/48285694/swift-json-login-rest-with-post-and-get-response-example
    
    func GetArea() {
        // Set up the URL request
        let todoEndpoint: String = "http://mapp2.htcindia.com:8080/ciber/calculator/getarea" // https://jsonplaceholder.typicode.com/todos/1
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            let jsonEncoder = JSONEncoder()
            // parse the result as JSON, since that's what the API provides
            do {
                guard let todo = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                // now we have the todo
                // let's just print it to prove we can access it
                print("The todo is: " + todo.description)
                
                let responseDict = todo as NSDictionary
                //let reponseArray = responseDict["value"] as! NSArray
                let reponsedataArray = responseDict["data"] as! NSArray
                    for  i in 0 ..< reponsedataArray.count {
                        let array1 = reponsedataArray[i] as! NSDictionary
                        let dropDownModelObj = HTCDropDownModel()
                        let idValue  = array1["areaId"] as! Int
                        dropDownModelObj.modelId = String(idValue)
                        let areaName : String = "Area "+String(i+1)
                        dropDownModelObj.modelData = areaName
                        dropDownModelObj.cityString = array1["areaName"] as Any as! String
                        self.dataModelArr.insert(dropDownModelObj, at: i)
                    }
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
    
    func GetJobTitle() {
        // Set up the URL request
        let todoEndpoint: String = "http://mapp2.htcindia.com:8080/ciber/calculator/getjobtitle"
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            let jsonEncoder = JSONEncoder()
            // parse the result as JSON, since that's what the API provides
            do {
                guard let todo = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                // now we have the todo
                // let's just print it to prove we can access it
                print("The todo is: " + todo.description)
                
                let responseDict = todo as NSDictionary
                //let reponseArray = responseDict["value"] as! NSArray
                let reponsedataArray = responseDict["data"] as! NSArray
                for  i in 0 ..< reponsedataArray.count {
                    let array1 = reponsedataArray[i] as! NSDictionary
                    let dropDownModelObj = HTCDropDownModel()
                    let idValue  = array1["jobTitleID"] as! Int
                    dropDownModelObj.modelId = String(idValue)
                    dropDownModelObj.modelData = array1["jobTitleName"] as Any as! String
                    self.dataModelArrayJobTitle.insert(dropDownModelObj, at: i)
                }
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    // Get Joblevel from API
    func GetJobLevel(region:Int, jobTitle:Int) {
        
        let todoEndpoint: String = "http://mapp2.htcindia.com:8080/ciber/calculator/getjobrole/areaid/\(region)/jobtitleid/\(jobTitle)"
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            let jsonEncoder = JSONEncoder()
            // parse the result as JSON, since that's what the API provides
            do {
                guard let todo = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                // now we have the todo
                // let's just print it to prove we can access it
                print("The todo is: " + todo.description)
                
                let responseDict = todo as NSDictionary
                //let reponseArray = responseDict["value"] as! NSArray
                 self.dataModelArrarJobLevel.removeAll()
                if responseDict["data"] as? NSArray != nil {
                    let reponsedataArray = responseDict["data"] as! NSArray
                    for  i in 0 ..< reponsedataArray.count {
                        if ((reponsedataArray[i] as? NSDictionary) != nil)
                        {
                            let array1 = reponsedataArray[i] as! NSDictionary
                            let dropDownModelObj = HTCDropDownModel()
                            let idValue  = array1["roleID"] as! Int
                            dropDownModelObj.modelId = String(idValue)
                            dropDownModelObj.modelData = array1["roleName"] as Any as! String
                            self.dataModelArrarJobLevel.insert(dropDownModelObj, at: i)
                        }

                    }
                    
                }

            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
        
    }
    
    // Segnetation for Rate and Salary
    @IBAction func segmentedControlButtonClickAction(_ sender: UISegmentedControl) {
        
       if sender.selectedSegmentIndex == 0 {
          print("First Segment Select")
       }
       else {
          print("Second Segment Select")
       }
        var minimamBillRateValue_calculated : Float = 0.0
        DispatchQueue.main.async {
                for i in (0..<self.estimateArray.count)
                {
                    if self.segmentControl.selectedSegmentIndex == 0
                    {
                        minimamBillRateValue_calculated += Float(self.estimateArray[i].estimatedTotalRevenue)
                    }
                    else
                    {
                        minimamBillRateValue_calculated += Float(self.estimateArray[i].estimatedTotalRevenueSalary)

                    }
                }
            
            self.estimatedRevenue.text = self.uscurrencyFormatFrom(minimamBillRate: minimamBillRateValue_calculated)
            self.estimateTableView.reloadData()
        }
        
    }
    // USA currency format conversion from Float value to String value
    func uscurrencyFormatFrom(minimamBillRate:Float) -> String {
        //let myDouble = 9999.99
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale.current
        // We'll force unwrap with the !, if you've got defined data you may need more error checking
        let priceString = currencyFormatter.string(from: NSNumber(value: minimamBillRate))!
        return priceString
    }
    
    func uscurrencyFormatFrom_salary(minimamBillRate:Float) -> String {
        //let myDouble = 9999.99
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale.current
        // We'll force unwrap with the !, if you've got defined data you may need more error checking
        let priceString = currencyFormatter.string(from: NSNumber(value: roundf(minimamBillRate)))!
        return priceString
    }
    
     // USA currency format conversion from Int value to String value
    func uscurrencyFormatFromInt(minimamBillRate:Int) -> String {
        //let myDouble = 9999.99
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        //currencyFormatter.locale = Locale.current
        // We'll force unwrap with the !, if you've got defined data you may need more error checking
        let priceString = currencyFormatter.string(from: NSNumber(value: minimamBillRate))!
        return priceString
    }
    
    
    
    
    
    
    // reset as default value while data tried to save without Internet
    func resetSelectedIndex()  {
        print("selectedIndexValue to reset",selectedIndexValue)
        estimateArray[selectedIndexValue].regionId   = 0
         estimateArray[selectedIndexValue].jobTitleId = 0
         estimateArray[selectedIndexValue].jobLevelId = 0
         estimateArray[selectedIndexValue].region   = "Area"
         estimateArray[selectedIndexValue].jobTitle = "Job Title"
         estimateArray[selectedIndexValue].jobLevel = "Job Level"
         estimateArray[selectedIndexValue].miimumBillRateSalary = 0.00
         estimateArray[selectedIndexValue].miimumBillRate = 0.00
        estimateArray[selectedIndexValue].tableViewTextFlagArea = false
        estimateArray[selectedIndexValue].tableViewTextFlagJobTitle = false
        estimateArray[selectedIndexValue].tableViewTextFlagJobLevel = false
            var defaultFixedGP = (UserDefaults.standard.integer(forKey: "fixedGP") )
            if defaultFixedGP <= 0
            {
                defaultFixedGP = (Int)(35.0)
            }
            var defaultEstimatedHours = UserDefaults.standard.integer(forKey: "fixedEstimatedHours")
            if defaultEstimatedHours <= 0
            {
                defaultEstimatedHours = (Int)(2000)
            }
            estimateArray[selectedIndexValue].estimateHours = Float(defaultEstimatedHours)  //2000
            estimateArray[selectedIndexValue].estimateGB = Float(defaultFixedGP) //35.00
        estimateArray[selectedIndexValue].estimatedTotalRevenueSalary = 0
        estimateArray[selectedIndexValue].estimatedTotalRevenue = 0
        self.estimateArray[self.selectedIndexValue].miimumBillRate = 0
        self.estimateArray[self.selectedIndexValue].miimumBillRateSalary = 0
        self.calculateRevenue()
    }
    
    // New calculation has been made by this API
    func GetRevenueBillRate(salary:Int, estimatedHours:Int,fixedPercentage:Float,GP:Float,fixedAnnualHour:Int)
     {
        let networkReachableStatus = NetworkManager.sharedInstance.isReachable()
        if networkReachableStatus == false
        {
            let alert = UIAlertController(title: "No internet connection", message: "Please check your internet connection and try again", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.resetSelectedIndex()
        }
        else
        {
           let todoEndpoint: String = "https://home.htcindia.com/rateestimator/calculator/getbillrateandestimatedrevenue/salary/\(salary)/estimatedHours/\(estimatedHours)/gp/\(GP)/fixedPercentage/\(fixedPercentage)/fixedAnnualBillableHours/\(fixedAnnualHour)"
            //let todoEndpoint: String = "http://mapp2.htcindia.com:8080/rateestimator/calculator/getbillrateandestimatedrevenue/salary/\(salary)/estimatedHours/\(estimatedHours)/gp/\(GP)/fixedPercentage/\(fixedPercentage)/fixedAnnualBillableHours/\(fixedAnnualHour)"
            
            print("URLString",todoEndpoint)
            guard let url = URL(string: todoEndpoint) else {
                print("Error: cannot create URL")
                return
            }
            let urlRequest = URLRequest(url: url)
            // set up the session
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            // make the request
            let task = session.dataTask(with: urlRequest) {
                (data, response, error) in
                // check for any errors
                guard error == nil else {
                    print("error calling GET on /todos/1")
                    print(error!)
                    return
                }
                // make sure we got data
                guard let responseData = data else {
                    print("Error: did not receive data")
                    return
                }
                //let jsonEncoder = JSONEncoder()
                // parse the result as JSON, since that's what the API provides
                do {
                    guard let todo = try JSONSerialization.jsonObject(with: responseData, options: [])
                        as? [String: Any] else {
                            print("error trying to convert data to JSON")
                            return
                    }
                    // now we have the todo
                    // let's just print it to prove we can access it
                    print("The todo is: " + todo.description)
                    
                    let responseDict = todo as NSDictionary
                    //let reponseArray = responseDict["value"] as! NSArray
                    if responseDict != nil
                    {
                        let array1 = responseDict["data"] as! NSDictionary
                            let dropDownModelObj = HTCDropDownModel()
                            let idValue  = array1["minBillRate"] as Any as! Double
                            dropDownModelObj.modelId = String(idValue)
                            dropDownModelObj.modelData = String(array1["estimatedRevenueByRate"] as Any as! Double)
                            dropDownModelObj.modelSecondData = String(array1["minBillRateBySalary"] as Any as! Double)
                            dropDownModelObj.modelThirdData = String(array1["estimatedRevenueBySalary"]  as Any as! Double)
                            self.dataModelArrarMinimamBillRate.insert(dropDownModelObj, at: 0)
                            //let revenueTotal = String(array1["estimatedRevenueByRate"]  as Any as! Double)
                            //let revenue = String(array1["minBillRateBySalary"] as!  Int)
                            if self.estimateArray.count > 0
                            {
                                self.estimateArray[self.selectedIndexValue].miimumBillRate = Float(array1["minBillRate"]  as Any as! Double)
                                self.estimateArray[self.selectedIndexValue].estimatedTotalRevenue = Float(array1["estimatedRevenueByRate"]  as Any as! Double)
                                self.estimateArray[self.selectedIndexValue].estimatedTotalRevenueSalary = Float(array1["estimatedRevenueBySalary"]  as Any as! Double)
                                self.estimateArray[self.selectedIndexValue].miimumBillRateSalary = Float(array1["minBillRateBySalary"]  as Any as! Double)
                            }
                        self.calculateRevenue()
                    }
                    else
                    {
                        print("Something went wrong on get data from API")
                    }

                } catch  {
                    print("error trying to convert data to JSON")
                    return
                }
            }
            task.resume()
        }
        
    }
    // Internal calculation for UI update for Revenue text field
    func calculateRevenue()  {
        self.loadBlendedValue()
        var minimamBillRateValue_calculated :Float = 0.0
        DispatchQueue.main.async {
            for i in (0..<self.estimateArray.count)
            {
                if self.segmentControl.selectedSegmentIndex == 0
                {
                    minimamBillRateValue_calculated += Float(self.estimateArray[i].estimatedTotalRevenue)
                }
                else
                {
                    minimamBillRateValue_calculated += Float(self.estimateArray[i].estimatedTotalRevenueSalary)
                }
                

                let indexPath = IndexPath(row:i, section:0)
                let cell : EstimateTableViewCell? = self.estimateTableView.cellForRow(at: indexPath as IndexPath) as! EstimateTableViewCell?
                cell?.minimumBillRateTextField.text = String(self.estimateArray[i].estimateBillRate)
                var minimamBillRateValue_calculated : Float = 0.0
                if self.segmentControl.selectedSegmentIndex == 0
                {
                    minimamBillRateValue_calculated += Float(self.estimateArray[i].miimumBillRate)
                }
                else
                {
                    minimamBillRateValue_calculated += Float(self.estimateArray[i].miimumBillRateSalary)
                }
                //cell1.minimumBillRateTextField.text = String("$"+String(format: "%.2f", arguments:[minimamBillRateValue_calculated]))
                cell?.minimumBillRateTextField.text = self.uscurrencyFormatFrom(minimamBillRate: minimamBillRateValue_calculated)
            }
            let fullDigit: String = String(self.uscurrencyFormatFrom_salary(minimamBillRate: minimamBillRateValue_calculated))
            let fullDigitArr = fullDigit.components(separatedBy: ".")
            //let aString = self.uscurrencyFormatFrom(minimamBillRate: minimamBillRateValue_calculated)//(minimamBillRate:Int(minimamBillRateValue_calculated))
            //let revenueNew = String(format: "%.2f", aString)
            //let revenueNew = aString.replacingOccurrences(of: ".00", with: "")
            self.estimatedRevenue.text = String(fullDigitArr[0])
            //self.estimateTableView.reloadData()
        }
    }
    // Getting mimum Billrate & Total revenue from API using 
    func GetMinimumBillrate(region:Int, jobTitle:Int,jobLevel:Int,GP:Int,estimatedHours:Int)
     {
        //http://mapp2.htcindia.com:8080/ciber/calculator/getbillrateandestimatedrevenue/areaid/\(region)/jobtitleid/\(jobTitle)/roleid/\(jobLevel)/gp/\(GP)/estimatedhours/\(estimatedHours)
        
        let todoEndpoint: String = "http://mapp2.htcindia.com:8080/ciber/calculator/getbillrateandestimatedrevenue/areaid/\(region)/jobtitleid/\(jobTitle)/roleid/\(jobLevel)/gp/\(GP)/estimatedhours/\(estimatedHours)"
        print("URLString",todoEndpoint)
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            let jsonEncoder = JSONEncoder()
            // parse the result as JSON, since that's what the API provides
            do {
                guard let todo = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                // now we have the todo
                // let's just print it to prove we can access it
                print("The todo is: " + todo.description)
                
                let responseDict = todo as NSDictionary
                //let reponseArray = responseDict["value"] as! NSArray
                if responseDict != nil
                {
                    let array1 = responseDict["data"] as! NSDictionary
                        let dropDownModelObj = HTCDropDownModel()
                        let idValue  = array1["minBillRate"] as Any as! Double
                        dropDownModelObj.modelId = String(idValue)
                        dropDownModelObj.modelData = String(array1["estimatedRevenueByRate"] as Any as! Double)
                        dropDownModelObj.modelSecondData = String(array1["minBillRateBySalary"] as Any as! Double)
                        dropDownModelObj.modelThirdData = String(array1["estimatedRevenueBySalary"]  as Any as! Double)
                        self.dataModelArrarMinimamBillRate.insert(dropDownModelObj, at: 0)
                        let revenueTotal = String(array1["estimatedRevenueByRate"]  as Any as! Double)
                        //let revenue = String(array1["minBillRateBySalary"] as!  Int)
                        if self.estimateArray.count > 0
                        {
                            self.estimateArray[self.selectedIndexValue].miimumBillRate = Float(array1["minBillRate"]  as Any as! Double)
                            self.estimateArray[self.selectedIndexValue].estimatedTotalRevenue = Float(array1["estimatedRevenueByRate"]  as Any as! Double)
                            self.estimateArray[self.selectedIndexValue].estimatedTotalRevenueSalary = Float(array1["estimatedRevenueBySalary"]  as Any as! Double)
                            self.estimateArray[self.selectedIndexValue].miimumBillRateSalary = Float(array1["minBillRateBySalary"]  as Any as! Double)
                        }
                        var minimamBillRateValue_calculated :Float = 0.0
                        DispatchQueue.main.async {
                            for i in (0..<self.estimateArray.count)
                            {
                                if self.segmentControl.selectedSegmentIndex == 0
                                {
                                    minimamBillRateValue_calculated += Float(self.estimateArray[i].estimatedTotalRevenue)
                                }
                                else
                                {
                                    minimamBillRateValue_calculated += Float(self.estimateArray[i].estimatedTotalRevenueSalary)
                                }
                            }
                        //self.estimatedRevenue.text = String("$"+String(Int(minimamBillRateValue_calculated)))
                        //self.estimatedRevenue.text = self.uscurrencyFormatFrom(minimamBillRate: minimamBillRateValue_calculated)
                        //self.estimateTableView.reloadData()
                    }
                    
                }
                else
                {
                    print("Something went wrong on get data from API")
                }

            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
    func getTimeStamp(lastUpdateDateTime:String) -> Int
    {
        // 2019-11-06 11:10:50 server timestamp format
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy-MM-dd hh:mm:ss"
        let date = dfmatter.date(from: lastUpdateDateTime)
        let dateStamp:TimeInterval = date!.timeIntervalSince1970
        let dateSt:Int = Int(dateStamp)
        return dateSt
    }
    
    func generateCurrentTimeStamp () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return (formatter.string(from: Date()) as NSString) as String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //overView.layer.cornerRadius = 5;
        overView.layer.masksToBounds = true;
        overView.layer.cornerRadius = 20.0
        overView.layer.shadowColor = UIColor.gray.cgColor
        overView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        overView.layer.shadowRadius = 12.0
        overView.layer.shadowOpacity = 0.7
        print("noOfScreenCount",noOfScreenCount)
        
        self.retrieveData()
        self.retrieveJobTitle()
//        self.GetArea()
//        self.GetJobTitle()
  /*
        let timestamp = (UserDefaults.standard.string(forKey: "lastUpdatedDateTime"))
        let version = UserDefaults.standard.integer(forKey: "versionID")
        //let timestamCurrent = self.generateCurrentTimeStamp()
        print("timestam old from server",timestamp as Any)
        //let serverTimeNewUpdate = self.verversionDictionary["lastUpdatedDateTime"] as! String
        let timeStampCurrent = Date.currentTimeStamp
        print("CurrentTimestamp",timeStampCurrent)
        
      
//        let networkStatus = NetworkManager.sharedInstance.isReachable()
//       if networkStatus == true
//        {
//            self.activityIndicator("Loading")
//            DispatchQueue.main.async {
//                 self.getVersion()
//            }
//
//        }
//        else
//        {
//            self.retrieveData()
//            self.retrieveJobTitle()
//        }
       
        var latestUpadeTimefromServer : String = ""
        if self.versionArray.count == 1
        {
            latestUpadeTimefromServer =  self.versionArray[0].modelData
            print("latestUpadeTimefromServer",latestUpadeTimefromServer)
        }

                    if Int(version) == 0
                    {
                        let alert = UIAlertView(title: "", message: "Master Data will be downloaded for offline use. Depending on your connection speed, this may take a while", delegate: self as? UIAlertViewDelegate, cancelButtonTitle: nil, otherButtonTitles: "OK" )
                        alert.tag = 405
                        alert.show()
                        
                        
            //            self.activityIndicator("Loading")
            //            self.GetAllData()

                    }
                    else if timestamp != latestUpadeTimefromServer  && self.versionArray.count > 0 {  //!=
                        self.deleteAllDataFromEndity(EntityName: "Area")
                        self.deleteAllDataFromEndity(EntityName: "JobLevel")
                        self.deleteAllDataFromEndity(EntityName: "JobTitle")
                        self.deleteAllDataFromEndity(EntityName: "Salary")

                        let alert = UIAlertView(title: "", message: "New updates found. Please click ok to download the latest Master Data", delegate: self as? UIAlertViewDelegate, cancelButtonTitle: nil, otherButtonTitles: "OK" )
                        alert.tag = 405
                        alert.show()
                    }
                    else
                    {
                        self.retrieveData()
                        self.retrieveJobTitle()
                    }
            */
        
        DispatchQueue.main.async
            {
                self.noResultsLabel.isHidden  = true
           }
        let nib12 = UINib(nibName: "EstimateTableViewCell", bundle: nil)
        estimateTableView.register(nib12, forCellReuseIdentifier: "EstimateTableViewCell")
        estimateTableView.separatorColor = UIColor.clear
        estimateTableView.tag = 101
        estimateTableView.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 0, right: 0)
        estimateTableView.delegate = self
        estimateTableView.dataSource = self
        estimateTableView.reloadData()
        estimateTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        estimateTableView.separatorColor = UIColor.clear
        self.estimatedRevenue.text = String("$0")

//        let josonValue = self.readJSONFromFile(fileName: "EstimateCalculator")
//        let areaVal = josonValue as! NSDictionary
//        let dict = areaVal[0]
//        let dict2 = areaVal[1]
        //DropDown
        dropDownController = self.storyboard?.instantiateViewController(withIdentifier: "DropDownViewController") as? DropDownViewController
        dropDownControllerJobLevel = self.storyboard?.instantiateViewController(withIdentifier: "DropDownJobLevelViewController") as?DropDownJobLevelViewController
        dropDownControllerJobTitle = self.storyboard?.instantiateViewController(withIdentifier: "DropDownJobTitleViewController") as?DropDownJobTitleViewController
         self.segmentControl.selectedSegmentIndex = 1
       
        /*
        // Area Data Modal
        let area1:NSDictionary = ["id":1,"name":"Area1","soruce":"Central Illinois, Harrisburg"]
        let area2:NSDictionary = ["id":2,"name":"Area2","soruce":"htcinc"]
        let area3:NSDictionary = ["id":3,"name":"Area3","soruce":"zm-htcinc"]
        let area4:NSDictionary = ["id":4,"name":"Area4","soruce":"ciber"]
        //let CiberNA:NSDictionary = ["id":4,"name":"Area5","soruce":"ciber-na"]
        let area5:NSDictionary = ["id":5,"name":"Area5","soruce":"cts-dom"]
        listOfArea =  NSMutableArray(array: [area1,area2,area3,area4,area5]) //,CiberNA
        
        var areaArray = NSMutableArray()
        for var i in (0..<listOfArea.count)
        {
            let accountObject1 = DropDownModel()
            let dict : NSDictionary = (listOfArea[i] as? NSDictionary)!
            accountObject1.modelIdString = Int32(dict.value(forKey: "id") as! Int)
            accountObject1.modelDataString = dict.value(forKey: "name") as! String
            accountObject1.modelCategoryString = dict.value(forKey: "soruce") as! String
            areaArray.insert(accountObject1, at: i)
        }
        createEstimateArray.listOfAreaArray = areaArray
        
        // JobTitle Data Modal
        let jobTitle1:NSDictionary = ["id":1,"name":"APPLICATIONS PROGRAMMER/DEVELOPER","soruce":"Central Illinois, Harrisburg"]
        let jobTitle2:NSDictionary = ["id":2,"name":"ARCHITECT*","soruce":"htcinc"]
        let jobTitle3:NSDictionary = ["id":3,"name":"BUSINESS INTELLIGENCE AND ANALYTICS","soruce":"zm-htcinc"]
        let jobTitle4:NSDictionary = ["id":4,"name":"BUSINESS SYSTEMS ANALYST","soruce":"ciber"]
        let jobTitle5:NSDictionary = ["id":5,"name":"DATABASE ADMINISTRATOR","soruce":"cts-dom"]
        listOfJobTitle =  NSMutableArray(array: [jobTitle1,jobTitle2,jobTitle3,jobTitle4,jobTitle5]) //,CiberNA
        
        var jobTitleArray = NSMutableArray()
        for var i in (0..<listOfJobTitle.count)
        {
            let accountObject1 = DropDownModel()
            let dict : NSDictionary = (listOfJobTitle[i] as? NSDictionary)!
            accountObject1.modelIdString = Int32(dict.value(forKey: "id") as! Int)
            accountObject1.modelDataString = dict.value(forKey: "name") as! String
            accountObject1.modelCategoryString = dict.value(forKey: "soruce") as! String
            jobTitleArray.insert(accountObject1, at: i)
        }
        createEstimateArray.listOfJobTitleArray = jobTitleArray
        
        // JobLevel Data Modal
        let jobLevel1:NSDictionary = ["id":1,"name":"ASSOCIATE","soruce":"Central Illinois, Harrisburg","avg":"41"]
        let jobLevel2:NSDictionary = ["id":2,"name":"CONSULTANT","soruce":"htcinc","avg":"50"]
        let jobLevel3:NSDictionary = ["id":3,"name":"SENIOR","soruce":"zm-htcinc","avg":"59"]
        let jobLevel4:NSDictionary = ["id":4,"name":"PRINCIPAL","soruce":"ciber","avg":"70"]
        let jobLevel5:NSDictionary = ["id":5,"name":"ENTERPRISE ARCHITECT - PRINCIPAL","soruce":"cts-dom","avg":"107"]
        listOfJobLevel =  NSMutableArray(array: [jobLevel1,jobLevel2,jobLevel3,jobLevel4,jobLevel5]) //,CiberNA
        
        var jobLevelArray = NSMutableArray()
        for var i in (0..<listOfJobLevel.count)
        {
            let accountObject1 = DropDownModel()
            let dict : NSDictionary = (listOfJobLevel[i] as? NSDictionary)!
            accountObject1.modelIdString = Int32(dict.value(forKey: "id") as! Int)
            accountObject1.modelDataString = dict.value(forKey: "name") as! String
            accountObject1.modelCategoryString = dict.value(forKey: "avg") as! String
            jobLevelArray.insert(accountObject1, at: i)
        }
        createEstimateArray.listOfJobLevelArray = jobLevelArray*/
        if noOfScreenCount>=1 {
            self.createEstimateButton(cellCount: noOfScreenCount)
        }
        else{
            self.createEstimateButton(cellCount: 1)
        }
        self.numberOfResource.text = "No. of Resources : 0"
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
//        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    
        // Do any additional setup after loading the view.
    }
    
    

    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            tableViewBounds = estimateTableView.bounds
            UIView.animate(withDuration: 0.2, animations:{
                self.estimateTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.keyboardHeight + 20, right: 0)
                self.estimateTableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: (self.keyboardHeight + 20), right: 0)
            })
        }
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        
        UIView.animate(withDuration: 0.2, animations:{
            self.estimateTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.estimateTableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        })
        
    }
    
    // Back Button Pressed
       @IBAction func backButtonPressed()
       {
        if estimateArray.count > 0
        {
//            if estimateArray[selectedIndexValue].miimumBillRateSalary > 0
//            {
                let alert = UIAlertView(title: "", message: "Values will be cleared. Do you want to proceed?", delegate: self as? UIAlertViewDelegate, cancelButtonTitle: "NO", otherButtonTitles: "YES" )
                alert.tag = 403
                alert.show()
          //  }
        }
        else
        {
            self.dismiss(animated: false, completion: nil)
        }

        
       }
    // Refresh the button action
    @IBAction func refreshButtonPressed(_ sender:UIButton)
    {
        if estimateArray.count > 0
        {
//            if estimateArray[selectedIndexValue].miimumBillRateSalary > 0
//            {
        let alert = UIAlertView(title: "", message: "Do you want to reset the values?", delegate: self as? UIAlertViewDelegate, cancelButtonTitle: "NO", otherButtonTitles: "YES" )
        alert.tag = 402
        deletIndex = sender.tag
        alert.show()
           // }
            
        }
//        else
//        {
//            self.dismiss(animated: false, completion: nil)
//        }
    }
    
    //Bring the cell on top of the view
    func scrollToFirstRow() {
        let indexPath = NSIndexPath(row: 0, section: 0)
        self.estimateTableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
    }
    // New estimate action
    
   @IBAction func createEstimateButtonPressed()
   {
    var defaultFixedGP = (UserDefaults.standard.integer(forKey: "fixedGP") )
    if defaultFixedGP <= 0
    {
        defaultFixedGP = (Int)(35.0)
    }
    var defaultEstimatedHours = UserDefaults.standard.integer(forKey: "fixedEstimatedHours")
    if defaultEstimatedHours <= 0
    {
        defaultEstimatedHours = (Int)(2000)
    }
//    tableViewTextFlagArea = false
//    tableViewTextFlagJobTitle = false
//    tableViewTextFlagJobLevel = false
    let  estimateDataModal = EstimateDataModal()
    //let estimateDict = (estimateArray[indexValue] as? NSDictionary)!
    estimateDataModal.estimateId = indexValue
    estimateDataModal.estimateHours = Float(defaultEstimatedHours)  //2000
    estimateDataModal.estimateGB = Float(defaultFixedGP) //35.00
    estimateDataModal.estimateBillRate = 0.0
    estimateDataModal.region = "Area"
    estimateDataModal.jobTitle = "Job Title"
    estimateDataModal.jobLevel = "Job Level"
    estimateDataModal.tableViewTextFlagArea = false
    estimateDataModal.tableViewTextFlagJobTitle = false
    estimateDataModal.tableViewTextFlagJobLevel = false
    estimateDataModal.regionId = 0
    estimateDataModal.jobTitleId = 0
    estimateDataModal.jobLevelId = 0

    
    self.estimateArray.append(estimateDataModal)
    if self.estimateArray.count >= 1 {
        self.estimateTableView.reloadData()
        //self.calculationUpdate(selectedValue: 0)
        if self.estimateArray.count >= 1{
        let indexPath = NSIndexPath(row: self.estimateArray.count-1, section: 0)
        self.estimateTableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
        }
        //self.numberOfResource.text = "No. of Resources : \(estimateArray.count)"
    }
    self.loadBlendedValue()
   }
    
   func createEstimateButton (cellCount:Int)
    {
//        tableViewTextFlagArea = false
//        tableViewTextFlagJobTitle = false
//        tableViewTextFlagJobLevel = false
        var defaultFixedGP = (UserDefaults.standard.integer(forKey: "fixedGP") )
        if defaultFixedGP <= 0
        {
            defaultFixedGP = (Int)(35.0)
        }
        var defaultEstimatedHours = UserDefaults.standard.integer(forKey: "fixedEstimatedHours")
        if defaultEstimatedHours <= 0
        {
            defaultEstimatedHours = (Int)(2000)
        }
        
         for _ in 0..<cellCount {
            print("new row insertion")
            let  estimateDataModal = EstimateDataModal()
            //let estimateDict = (estimateArray[indexValue] as? NSDictionary)!
            estimateDataModal.estimateId = indexValue
            estimateDataModal.estimateHours = Float(defaultEstimatedHours)  //2000
            estimateDataModal.estimateGB = Float(defaultFixedGP) //35.00
            estimateDataModal.estimateBillRate = 0.0
            estimateDataModal.estimatedTotalRevenue = 0.0
            estimateDataModal.region = "Area"
            estimateDataModal.jobTitle = "Job Title"
            estimateDataModal.jobLevel = "Job Level"
            estimateDataModal.regionId = 0
            estimateDataModal.jobTitleId = 0
            estimateDataModal.jobLevelId = 0
            estimateDataModal.tableViewTextFlagArea = false
            estimateDataModal.tableViewTextFlagJobTitle = false
            estimateDataModal.tableViewTextFlagJobLevel = false
            self.estimateArray.append(estimateDataModal)
            
            
        }
        
        /*
        estimateDataModal.estimateId = (estimateDict["estimateId"] as? Int)!
        estimateDataModal.estimateHours = (estimateDict["estimateHours"] as? Int)!
        estimateDataModal.estimateGB = (estimateDict["estimateGB"] as? Float)!
        estimateDataModal.estimateBillRate = (estimateDict["estimateBillRate"] as? Float)!
        if estimateDict["region"]  != nil && ((estimateDict["region"]  as? NSNull) == nil)  {
            estimateDataModal.region = (estimateDict["region"] as? String)!
        }
        if estimateDict["jobTitle"]  != nil && ((estimateDict["jobTitle"]  as? NSNull) == nil)  {
            estimateDataModal.jobTitle = (estimateDict["jobTitle"] as? String)!
        }
        if estimateDict["jobLevel"]  != nil && ((estimateDict["jobLevel"]  as? NSNull) == nil)  {
            estimateDataModal.jobTitle = (estimateDict["jobLevel"] as? String)!
        }
        */
        
//        if self.estimateArray.count >= 1 {
//            //self.estimateTableView.reloadData()
//            self.calculationUpdate(selectedValue: 0)
//            self.numberOfResource.text = "No. of Resources : \(estimateArray.count)"
//        }
       
    }
    
    //Read the json from the its file
     func readJSONFromFile(fileName: String) -> Any?

    {
        var json: Any?
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                // Getting data from JSON file using the file URL
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                json = try? JSONSerialization.jsonObject(with: data)
            } catch {
                // Handle error here
            }
        }
        return json
    }
    
    /*
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
     
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
     
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
     
        txtMobileNumber.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        txtMobileNumber.resignFirstResponder()
    }
    */
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
        // MARK:- TableView Delegat
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if self.estimateArray.count > 0{
            DispatchQueue.main.async
                {
                    self.noResultsLabel.isHidden  = true
                    self.estimateTableView.isHidden = false
                    //self.bottomRevenueView.isHidden = false
            }
        }
        else{
            DispatchQueue.main.async
                {
                    self.noResultsLabel.isHidden  = false
                    self.estimateTableView.isHidden = true
                    //self.bottomRevenueView.isHidden = true
            }
        }
        return self.estimateArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let reuseIdent = "EstimateTableViewCell"
        var cell1:EstimateTableViewCell;
        cell1 = estimateTableView.dequeueReusableCell(withIdentifier: reuseIdent, for: indexPath) as! EstimateTableViewCell
        cell1.selectionStyle = UITableViewCell.SelectionStyle.none
        indexValue = indexPath.row
//        cell1.cellView.layer.cornerRadius = 20.0
//        cell1.cellView.layer.shadowColor = UIColor.gray.cgColor
//        cell1.cellView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        cell1.cellView.layer.shadowRadius = 12.0
//        cell1.cellView.layer.shadowOpacity = 0.7
        let selectedColor = hexStringToUIColor(hex: "#4c4c7f")
        let defaultColor = hexStringToUIColor(hex: "#666666")
        
        
        
        if indexPath.row < self.estimateArray.count
        {
        let estimateValueDict = estimateArray[indexValue] as! EstimateDataModal
            //let estimateValueDict = estimateValueDict1 as NSDictionary
            //let list = self.estimateArray.object(at: indexPath.row) as! EstimateDataModal
            //cell1.estimateId = (estimateDict["estimateId"] as? Int)!
            let estimateval = Int(estimateValueDict.estimateHours)
            cell1.extimatedHoursTextField.text = String(estimateval)
            cell1.GPValueTextField.text = String(format: "%.2f", arguments: [estimateValueDict.estimateGB])

            var minimamBillRateValue_calculated : Float = 0.0
            if self.segmentControl.selectedSegmentIndex == 0
            {
                minimamBillRateValue_calculated += Float(estimateValueDict.miimumBillRate)
            }
            else
            {
                minimamBillRateValue_calculated += Float(estimateValueDict.miimumBillRateSalary)
            }
            
            //cell1.minimumBillRateTextField.text = String("$"+String(format: "%.2f", arguments:[minimamBillRateValue_calculated]))
            cell1.minimumBillRateTextField.text = self.uscurrencyFormatFrom(minimamBillRate: minimamBillRateValue_calculated)

            if estimateValueDict.region != nil && ((estimateValueDict.region  as? NSNull) == nil)  {
                if estimateValueDict.tableViewTextFlagArea == true
                {
                    //cell1.regionButton.titleLabel?.textColor = Color(red: 1.0, green: 0.0, blue: 0.0)
                    cell1.regionButton.setTitleColor(selectedColor, for: .normal)
                    cell1.regionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)

                }
                else
                {
                    cell1.regionButton.setTitleColor(defaultColor, for: .normal)
                    cell1.regionButton.titleLabel?.font = UIFont.init(name: "OpenSans", size:15 )

                }

                cell1.regionButton.setTitle(estimateValueDict.region , for: .normal)
                cell1.regionButton.tag = indexPath.row
                cell1.regionButton.addTarget(self, action: #selector(regionButtonPressed), for: .touchUpInside)
           }
            if estimateValueDict.jobTitle  != nil && ((estimateValueDict.jobTitle  as? NSNull) == nil)  {
              



                if estimateValueDict.tableViewTextFlagJobTitle == true
                {
                     cell1.jobTitleButton.setTitleColor(selectedColor, for: .normal)
                    cell1.jobTitleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)

                }
                else
                {
                    cell1.jobTitleButton.setTitleColor(defaultColor, for: .normal)
                    cell1.jobTitleButton.titleLabel?.font = UIFont.init(name: "OpenSans", size:15 )
                }

                cell1.jobTitleButton.setTitle(estimateValueDict.jobTitle, for: .normal)
                cell1.jobTitleButton.tag = indexPath.row
                cell1.jobTitleButton.titleLabel?.numberOfLines = 2
                cell1.jobTitleButton.addTarget(self, action: #selector(self.jobTitleButtonPressed), for: .touchUpInside)
            }
            if estimateValueDict.jobLevel  != nil && ((estimateValueDict.jobLevel  as? NSNull) == nil)  {
                if estimateValueDict.tableViewTextFlagJobLevel == true
                {
                     cell1.jobLevelButton.setTitleColor(selectedColor, for: .normal)
                     cell1.jobLevelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)

                }
                else
                {
                    cell1.jobLevelButton.setTitleColor(defaultColor, for: .normal)
                    cell1.jobLevelButton.titleLabel?.font = UIFont.init(name: "OpenSans", size:15 )
                }
                cell1.jobLevelButton.setTitle(estimateValueDict.jobLevel, for: .normal)
                cell1.jobLevelButton.tag = indexPath.row
                cell1.jobLevelButton.titleLabel?.numberOfLines = 2
                cell1.jobLevelButton.addTarget(self, action: #selector(self.jobLevelButtonPressed), for: .touchUpInside)
            }
            
            //cell1.deleteButton.setTitle(estimateValueDict.jobLevel, for: .normal)
            cell1.deleteButton.tag = indexPath.row
            cell1.deleteButton.addTarget(self, action: #selector(self.deletButtonPressed), for: .touchUpInside)
            
            cell1.resourceCount.text  = "Resource " + String(indexPath.row+1)
                
            cell1.GPValueTextField.tag = indexPath.row
            cell1.GPValueTextField.delegate = self
            cell1.minimumBillRateTextField.tag = indexPath.row
            //cell1.minimumBillRateTextField.delegate = self
            cell1.minimumBillRateTextField.isUserInteractionEnabled = false
            //cell1.minimumBillRateTextField.text = String(estimateValueDict.miimumBillRate)
            cell1.extimatedHoursTextField.tag = indexPath.row
            cell1.extimatedHoursTextField.delegate = self
        }
        return cell1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 360.0
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            print("testDelete")
//            self.estimateArray.remove(at: indexPath.row)
//            self.estimateTableView.deleteRows(at: [indexPath], with: .automatic)
//            if self.estimateArray.count > 0{
//                self.calculationUpdate(selectedValue: 0)
//            }
//        }
//    }
    
//    // this should give yuo currently visible cell for indexPath
//    if; var ratableCell: <# Type #> = tableView.cellForRow(at: indexPath) as? RatableCell {
//        // instead of telling tableView to reload this cell, just configure here
//        // the changed data, e.g.:
//        ratableCell.configureRate(10)
//    }
    
    
    // MARK:- DropDown Delegat
    // Area dropdown button action
    @objc func regionButtonPressed(sender: UIButton)  {
        self.view.endEditing(true)
         self.selectedString = "region"
        selectedIndexValue = sender.tag
        regionID = 1
        print("ButtonTag",sender.tag)
        dropDownController?.modelListArray.removeAll()
        //dropDownController?.modelListArray = dataModelArr
        dropDownController?.modelListArray = retriveArray
        //delegate
        dropDownController?.dropdownDelegate = self
        dropDownController?.allowSearching = true
        dropDownController?.modalPresentationStyle = .fullScreen
        if self.estimateArray[self.selectedIndexValue].regionId == 0 {
            dropDownController?.selectedIndex = -1
        } else {
            let filteredArray = dropDownController?.modelListArray.filter({$0.modelId == "\(self.estimateArray[self.selectedIndexValue].regionId)" })
            if (filteredArray?.count ?? 0) > 0 {
                dropDownController?.selectedIndex = dropDownController?.modelListArray.index(of: filteredArray!.first!) ?? -1
            }
        }
        present(dropDownController!, animated: true, completion: nil)
    }
    
    // JobTitle dropdown button action
    @objc func jobTitleButtonPressed(sender: UIButton)  {
        self.selectedString = "jobTitle"
        selectedIndexValue = sender.tag
        if estimateArray[selectedIndexValue].region != "Area" && dataModelArrayJobTitle.count > 0 {
            //contactButton.setTitle(a,for: .normal)
            dropDownControllerJobTitle?.modelListArray.removeAll()
            dropDownControllerJobTitle?.modelListArray = dataModelArrayJobTitle
            //delegate
            dropDownControllerJobTitle?.dropdownDelegate = self
            dropDownControllerJobTitle?.textColor = UIColor.blue
            //Custom colour change for drop down
            dropDownControllerJobTitle?.backgroundColor = UIColor.white
            //Custom text label font
            dropDownControllerJobTitle?.allowSearching = true
            dropDownControllerJobTitle?.modalPresentationStyle = .fullScreen
            if self.estimateArray[self.selectedIndexValue].jobTitleId == 0 {
                dropDownControllerJobTitle?.selectedIndex = -1
            } else {
                let filteredArray = dropDownControllerJobTitle?.modelListArray.filter({$0.modelId == "\(self.estimateArray[self.selectedIndexValue].jobTitleId)" })
                if (filteredArray?.count ?? 0) > 0 {
                    dropDownControllerJobTitle?.selectedIndex = dropDownControllerJobTitle?.modelListArray.index(of: filteredArray!.first!) ?? -1
                }
            }
            present(dropDownControllerJobTitle!, animated: true, completion: nil)
        }
        else
        {
//            let alert = UIAlertView(title: "", message:"Please select a Region to proceed ", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Ok" )
//            alert.show()
        }
    }
    
    
    @objc func jobLevelButtonPressed(sender: UIButton)  {
        self.selectedIndexValue = sender.tag
        self.selectedString = "jobLevel"
        if self.estimateArray[self.selectedIndexValue].jobTitleId <= 0 {
            return
        }
//         DispatchQueue.main.async {
//            if self.estimateArray[self.selectedIndexValue].regionId > 0 && self.estimateArray[self.selectedIndexValue].jobTitleId > 0 {
//                //self.GetJobLevel(region:self.estimateArray[self.selectedIndexValue].regionId,jobTitle:self.estimateArray[self.selectedIndexValue].jobTitleId)
//                    }
            //self.activityIndicator("Loading")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) { //2.0
                    if self.regionID >= 1 && self.jobTitleID >= 1 && self.estimateArray[self.selectedIndexValue].jobTitle != "Job Title" && self.estimateArray[self.selectedIndexValue].region != "Area" && self.dataModelArrarJobLevel.count > 0 {
                        self.dropDownControllerJobLevel?.modelListArray.removeAll()
                        self.estimateArray[self.selectedIndexValue].estimatedTotalRevenueSalary = 0
                        self.estimateArray[self.selectedIndexValue].estimatedTotalRevenue = 0
                        self.estimateArray[self.selectedIndexValue].miimumBillRate = 0
                        self.estimateArray[self.selectedIndexValue].miimumBillRateSalary = 0
                        self.calculateRevenue()
                        self.retrieveJobLevelFromJobTitle(jobTitleID: "\(self.estimateArray[self.selectedIndexValue].jobTitleId)")
                        self.dropDownControllerJobLevel?.modelListArray = self.dataModelArrarJobLevel
                                //delegate
                        self.dropDownControllerJobLevel?.dropdownDelegate = self
                                //                dropDownController?.dropDownType = DropDownType.DropDownTypeMultipleSelection
                                //                dropDownController?.dropDownType = DropDownType.DropDownTypeSingleSelectionWithImage
                                //Custom colour change for label text
                        self.dropDownControllerJobLevel?.textColor = UIColor.blue
                                //Custom colour change for drop down
                        self.dropDownControllerJobLevel?.backgroundColor = UIColor.white
                                //Custom text label font
                        //self.dropDownControllerJobLevel?.textFont = UIFont.init(name: "OpenSans-Regular", size: 17.0)!
                        self.dropDownControllerJobLevel?.allowSearching = true
                            }
                            else
                            {
                    //            let alert = UIAlertView(title: "", message:"Please select the Region and Job Title ", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Ok" )
                    //            alert.show()
                            }
                //self.removeActivity()
                self.dropDownControllerJobLevel?.modalPresentationStyle = .fullScreen
                if self.estimateArray[self.selectedIndexValue].jobLevelId == 0 {
                    self.dropDownControllerJobLevel?.selectedIndex = -1
                } else {
                    let filteredArray = self.dropDownControllerJobLevel?.modelListArray.filter({$0.modelId == "\(self.estimateArray[self.selectedIndexValue].jobLevelId)" })
                    if (filteredArray?.count ?? 0) > 0 {
                        self.dropDownControllerJobLevel?.selectedIndex = self.dropDownControllerJobLevel?.modelListArray.index(of: filteredArray!.first!) ?? -1
                    }
                }
                    self.present(self.dropDownControllerJobLevel!, animated: true, completion: nil)
                    sender.isUserInteractionEnabled = true
                }
            
            sender.isUserInteractionEnabled = false
            
       // }


       // (DropDownView.defaultDropDownControl() as AnyObject).showDropDown(forData:self.createEstimateArray.listOfJobLevelArray, dropDownType: DropDownType.singleSelectionDefault, withFrame: CGRect.zero, in: self.view, delegate: self, withSelectedModelID: nil)
    }
    
    func activityIndicator(_ title: String) {
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = .systemFont(ofSize: 14, weight: .medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        effectView.frame = self.view.bounds
        effectView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        activityIndicator.center = CGPoint(x: self.view.bounds.width/2.0,y: self.view.bounds.height/2.0)
        effectView.addSubview(activityIndicator)
        //effectView.addSubview(strLabel)
        view.addSubview(effectView)
        effectView.bringSubviewToFront(view)
    }
    
    func removeActivity() {
        //strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
    }
    
    
    
    var deletIndex : Int = 0
    @objc func deletButtonPressed(sender: UIButton)  {
        
        let alert = UIAlertView(title: "", message: "Do you want to delete this record?", delegate: self as? UIAlertViewDelegate, cancelButtonTitle: "NO", otherButtonTitles: "YES" )
        alert.tag = 401
        deletIndex = sender.tag
        alert.show()

       // self.estimateTableView.deleteRows(at: [sender.tag], with: .automatic)
//        if self.estimateArray.count > 0{
//            self.calculationUpdate(selectedValue: 0)
//        }
    }
    
    
            // MARK:- Alert Delegate
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int)
    {
        if alertView.tag == 401{
            if buttonIndex == 0
            {
               print("No to process the delete operation")
            }
            else
            {
            DispatchQueue.main.async {
                self.deleteAction()
            }
            }
        }
        if alertView.tag == 402{
            if buttonIndex == 0
            {
               print("No to process the refresh operation")
            }
            else
            {
            DispatchQueue.main.async {
                self.refreshAction()
            }
            }
        }
        
        if alertView.tag == 403{
            if buttonIndex == 0
            {
               print("No to process the back action")
            }
            else
            {
            DispatchQueue.main.async {
                NotificationCenter.default.removeObserver(self)
                       self.dismiss(animated: false, completion: nil)
            }
            }
        }
            if alertView.tag == 405{
                if buttonIndex == 0
                {
                  self.activityIndicator("Loading")
                  self.GetAllData()
                }
                else
                {
                DispatchQueue.main.async {
                    NotificationCenter.default.removeObserver(self)
                           self.dismiss(animated: false, completion: nil)
                }
                }
            
            
            }
        
    }
            

        
    var refreshcount : Int = 0
    func refreshAction() {
        if self.estimateArray.count > 0{
                refreshcount = self.estimateArray.count
                    DispatchQueue.main.async {
                if self.estimateArray.count>0
                {
                    self.estimateArray.removeAll()
                    //self.estimateTableView.reloadData()
                }
                self.createEstimateButton(cellCount: self.refreshcount)
                self.estimateTableView.reloadData()
                self.estimatedRevenue.text =  String("$"+"0")
                self.calculateRevenue()
                //self.scrollToFirstRow()
                        
            }
        }

    }
    
    
    func deleteAction()  {
        print("Delete Pressed")
            if deletIndex <=  self.estimateArray.count
            {
              self.estimateArray.remove(at: deletIndex)
              var minimamBillRateValue_calculated : Float = 0.0
              DispatchQueue.main.async {
                      for i in (0..<self.estimateArray.count)
                      {
                          if self.segmentControl.selectedSegmentIndex == 0
                          {
                              minimamBillRateValue_calculated += Float(self.estimateArray[i].estimatedTotalRevenue)
                          }
                          else
                          {
                              minimamBillRateValue_calculated += Float(self.estimateArray[i].estimatedTotalRevenueSalary)

                          }
                      }
                  if minimamBillRateValue_calculated > 1
                  {
                     // self.estimatedRevenue.text = String("$"+String(Int(minimamBillRateValue_calculated)))
                    
                    //self.estimatedRevenue.text = self.uscurrencyFormatFrom(minimamBillRate: minimamBillRateValue_calculated)
                    let aString = self.uscurrencyFormatFromInt(minimamBillRate: Int(minimamBillRateValue_calculated))
                    let revenue = aString.replacingOccurrences(of: ".00", with: "")
                    self.estimatedRevenue.text = revenue

                  }
                  else
                  {
                      self.estimatedRevenue.text =  String("$"+"0")
                  }
                self.loadBlendedValue()
                  //self.estimateTableView.reloadData()
                //self.numberOfResource.text = "No. of Resources : \(self.estimateArray.count)"
                //self.calculateBlendedGB()
              }
              
              self.estimateTableView.reloadData()
              //self.numberOfResource.text = "No. of Resources : \(estimateArray.count)"

              if self.estimateArray.count >= 1 {
                self.noResultsLabel.isHidden  = false
                  //self.scrollToFirstRow()
                if deletIndex >= 1{
                let indexPath = NSIndexPath(row: deletIndex-1, section: 0)
                self.estimateTableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
                }
              }
              else
              {
                // Show No resource found
                self.noResultsLabel.isHidden  = true
              }
        }
        
    }
    
    
        // MARK:- DropDown Delegate
    
    func selectedData(_ dataObject: DropDownModel!) {
        
//        estimateDataModal.region = "Please select Region"
//        estimateDataModal.jobTitle = "Please select Job Title"
//        estimateDataModal.jobLevel = "Please select Job Level"
        
        //listOfArea
        let a = dataObject.modelDataString
        if self.selectedString == "region"
        {
            //contactButton.setTitle(a,for: .normal)
            print("SelectedIndex = ",selectedIndexValue)
            print(dataObject.modelIdString)
            regionID = Int(dataObject.modelIdString)
           // let estimateValueDict = estimateArray[selectedIndexValue] as! EstimateDataModal
            estimateArray[selectedIndexValue].region = dataObject.modelDataString
            estimateTableView.reloadData()
            //contactId = Int(dataObject.modelIdString)
            // accIdstr = dataObject.modelIdStringNew
        }
        if self.selectedString == "jobTitle"
        {
            if regionID >= 1 && estimateArray[selectedIndexValue].region != "Area"{
            //contactButton.setTitle(a,for: .normal)
            print("SelectedIndex = ",selectedIndexValue)
            jobTitleID = Int(dataObject.modelIdString)
            estimateArray[selectedIndexValue].jobTitle = dataObject.modelDataString
            estimateTableView.reloadData()
            }
            else
            {
//                let alert = UIAlertView(title: "", message:"Please select a Region to proceed ", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Ok" )
//                alert.show()
            }
        }
        if self.selectedString == "jobLevel"
        {
            if regionID >= 1 && jobTitleID >= 1 && estimateArray[selectedIndexValue].jobTitle != "Job Title" && estimateArray[selectedIndexValue].region != "Area"{
            print("SelectedIndex = ",selectedIndexValue)
            estimateArray[selectedIndexValue].jobLevel = dataObject.modelDataString
            let minimumBillRateHour = String(format: "%.2f", Float(dataObject.modelCategoryString) ?? 0)
            estimateArray[selectedIndexValue].miimumBillRate = Float(minimumBillRateHour) ?? 0
            calculationUpdate(selectedValue: selectedIndexValue)
            //estimateTableView.reloadData()
            }
            else
            {
//                let alert = UIAlertView(title: "", message:"Please select the Region and Job Title", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Ok" )
//                alert.show()
            }
        }
        (DropDownView.defaultDropDownControl() as AnyObject).hideDropDown()

    }
    
    func selectedDataArray(_ dataArray: NSMutableArray!) {
        
    }
    
    func selectedData1(_ selectedDataStr: String!) {
        
    }
      var checkFlag : Int = 0
    //DropDown Action
    func dropDownClicked(selectedArr : Array<HTCDropDownModel>){
        var titleString : String = ""
        var cityString : String = ""
        var selectedIndex : Int = 0
      
        var titleModel : HTCDropDownModel?
        for model in selectedArr{
            titleModel = (model as AnyObject) as? HTCDropDownModel
            cityString = (titleModel?.cityString)!
            selectedIndex = Int((titleModel?.modelId)!)!
            print("selectedIndex In DropDown ",selectedIndex)
            print("selectedIndex In Table ",selectedIndexValue)

            if (titleString.isEmpty){
                titleString = (titleModel?.modelData)!
            }
            else{
                titleString += "|"
                titleString += (titleModel?.modelData)!
            }
            //                titleString?.append((titleModel?.modelData)!)
            //                titleString! += (titleModel?.modelData)!
        }
        
        if self.selectedString == "region"
        {
            
            if self.estimateArray[self.selectedIndexValue].regionId > 0 && self.estimateArray[self.selectedIndexValue].regionId != selectedIndex
            {
                self.estimateArray[self.selectedIndexValue].jobTitleId = 0
                self.estimateArray[self.selectedIndexValue].jobTitle = "Job Title"
                self.estimateArray[self.selectedIndexValue].jobLevelId = 0
                self.estimateArray[self.selectedIndexValue].jobLevel = "Job Level"
                estimateArray[selectedIndexValue].tableViewTextFlagJobTitle = false
                estimateArray[selectedIndexValue].tableViewTextFlagJobLevel = false
                self.estimateArray[self.selectedIndexValue].estimatedTotalRevenueSalary = 0
                self.estimateArray[self.selectedIndexValue].estimatedTotalRevenue = 0
                self.estimateArray[self.selectedIndexValue].miimumBillRate = 0
                self.estimateArray[self.selectedIndexValue].miimumBillRateSalary = 0
                self.calculateRevenue()

            }
             estimateArray[selectedIndexValue].tableViewTextFlagArea = true
            estimateArray[selectedIndexValue].region = titleString
            estimateArray[selectedIndexValue].regionId = selectedIndex
            regionID = selectedIndex
            dropDownController?.dismiss(animated: true, completion: nil)

        }
         if self.selectedString == "jobTitle"
        {
            if self.estimateArray[self.selectedIndexValue].jobTitleId > 0 && estimateArray[selectedIndexValue].jobTitleId != selectedIndex
            {
                self.estimateArray[self.selectedIndexValue].jobLevelId = 0
                self.estimateArray[self.selectedIndexValue].jobLevel = "Job Level"
                estimateArray[selectedIndexValue].tableViewTextFlagJobLevel = false
                self.estimateArray[self.selectedIndexValue].estimatedTotalRevenueSalary = 0
                self.estimateArray[self.selectedIndexValue].estimatedTotalRevenue = 0
                self.estimateArray[self.selectedIndexValue].miimumBillRate = 0
                self.estimateArray[self.selectedIndexValue].miimumBillRateSalary = 0
                self.calculateRevenue()
            }
            
            jobTitleID = selectedIndex
            self.retrieveJobLevelFromJobTitle(jobTitleID: String(selectedIndex))
            //tableViewTextFlagJobTitle = true
            estimateArray[selectedIndexValue].tableViewTextFlagJobTitle = true
            estimateArray[selectedIndexValue].jobTitle = titleString
            estimateArray[selectedIndexValue].jobTitleId = selectedIndex
            dropDownControllerJobTitle?.dismiss(animated: true, completion: nil)
//            if regionID > 0{
//            checkFlag = selectedIndexValue
//            self.GetJobLevel(region:regionID,jobTitle:jobTitleID)
//            }
//            else
//            {
//                let alert = UIAlertView(title: "", message:"Please select the Region ", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Ok" )
//                alert.show()
//            }


        }
        
           if self.selectedString == "jobLevel"
           {
            
            estimateArray[selectedIndexValue].jobLevel = titleString
            let minimumBillRateHour = String(format: "%.2f", Float(selectedIndex) ?? 0)
            estimateArray[selectedIndexValue].miimumBillRate = Float(minimumBillRateHour) ?? 0
            
            estimateArray[selectedIndexValue].tableViewTextFlagJobLevel = true
            jobLevelID = selectedIndex
            estimateArray[selectedIndexValue].jobLevelId = selectedIndex
            estimateArray[selectedIndexValue].jobLevel = titleString
            dropDownControllerJobLevel?.dismiss(animated: true, completion: nil)
//            let GBvalue = estimateArray[selectedIndexValue].estimateGB
//            let estimatedHours = estimateArray[selectedIndexValue].estimateHours
            let region : Int = estimateArray[selectedIndexValue].regionId
            let jobTitile : Int = estimateArray[selectedIndexValue].jobTitleId
            let jobLevel : Int = estimateArray[selectedIndexValue].jobLevelId
            self.retrieveSalary(areaID: String(region), jobTitleID: String(jobTitile), roleID: String(jobLevel))
            print("roleID",jobLevel)
            //self.GetMinimumBillrate(region:region, jobTitle:jobTitile, jobLevel:jobLevel, GP:Int(GBvalue), estimatedHours: Int(estimatedHours))
            self.removeActivity()
           }
        
        estimateTableView.reloadData()
        let indexPath = NSIndexPath(row: selectedIndexValue, section: 0)
        self.estimateTableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
    }
    
    // MARK: - TxtField delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        print("textFieldDidBeginEditing")
        //        self.userNameLabel.isHidden = false
     
        /*
        if textField.tag == 1 //== estimateTableView.cellForRow(at: indexValue)
        {
            // let aString = OTPTextField.text
            //  OTPTextField.text = aString!.replacingOccurrences(of: ",", with: "")
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector( self.didTapDone))
            let items = [flexSpace, done]
            let keyboardToolbar = UIToolbar()
            keyboardToolbar.sizeToFit()
            keyboardToolbar.items = items
            textField.inputAccessoryView = keyboardToolbar
        
        }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0, delay: 0, options: [.curveEaseOut],
                           animations: {
                            
                            //self.userNameLabel.frame.origin.y = self.userNameLabel.frame.origin.y - 10
                            self.view.layoutIfNeeded()
            }, completion: nil)
        }
        return
        */
        /*UIView.animate(withDuration: 1, delay: 0.5, options: [.curveEaseOut],
         animations: {
         self.userNameLabel.center.y = self.userNameLabel.center.y-15
         self.view.layoutIfNeeded()
         }, completion: nil)*/
        
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        print("textFieldDidEndEditing")

        /*
         if textField == userNameTextField && (userNameTextField.text?.count)!<0
         {
         self.userNameLabel.isHidden = true
         UIView.animate(withDuration: 1, delay: 0.5, options: [.curveEaseOut],
         animations: {
         self.userNameLabel.center.y  = -self.userNameLabel.center.y
         self.view.layoutIfNeeded()
         }, completion: nil)
         
         }*/
        
        
        
        let indexPath = NSIndexPath(row:textField.tag, section:0)
        let cell : EstimateTableViewCell? = self.estimateTableView.cellForRow(at: indexPath as IndexPath) as! EstimateTableViewCell?
        //cell?.GPValueTextField.resignFirstResponder()
        if textField == cell?.GPValueTextField || textField == cell?.extimatedHoursTextField
        {
            if (textField == cell?.GPValueTextField) {
            let gdpValude :Double? = Double(textField.text!) ?? 0
            if gdpValude! > 100.00
            {
                textField.text = "100.00"
            }
            }
        print("TextField",textField.tag,textField.text ?? "")
        //let gpValue = Int(textField.text as! String)
        self.calculationUpdate(selectedValue: textField.tag)
        self.selectedIndexValue = textField.tag
//        let GBvalue = Int(estimateArray[textField.tag].estimateGB)
//        let estimatedHours = estimateArray[textField.tag].estimateHours
        let region : Int = estimateArray[selectedIndexValue].regionId
        let jobTitile : Int = estimateArray[selectedIndexValue].jobTitleId
        let jobLevel : Int = estimateArray[selectedIndexValue].jobLevelId
           /* if region>0 && jobTitile>0 && jobLevel>0
            {
                self.GetMinimumBillrate(region:region, jobTitle:jobTitile, jobLevel:jobLevel, GP:Int(GBvalue), estimatedHours: Int(estimatedHours))
            }*/
            
            if region>0 && jobTitile>0 && jobLevel>0 //if estimateArray[selectedIndexValue].maximumSalary > 0
            {
                //self.calculateEstimatedRevenue()
                   let GBvalue = estimateArray[selectedIndexValue].estimateGB
                   let estimatedHours = estimateArray[selectedIndexValue].estimateHours
                   let maximumSalary : Float = estimateArray[selectedIndexValue].maximumSalary
                   let fixedCost : String = (UserDefaults.standard.string(forKey: "fixedPercentage") ?? "0.4236")
                   let fixedAnnualHours : String = (UserDefaults.standard.string(forKey: "fixedAnnualBillableHours")) ?? "2080"
                   self.GetRevenueBillRate(salary: Int(maximumSalary), estimatedHours: Int(estimatedHours), fixedPercentage: Float(fixedCost)!, GP: GBvalue, fixedAnnualHour: Int(Float(fixedAnnualHours)!))

            }
            
            
           //self.GetMinimumBillrate(region: regionID, jobTitle: jobTitleID, jobLevel: jobLevelID, GP: Int(estimateArray[textField.tag].estimateGB), estimatedHours: Int(estimateArray[textField.tag].estimateHours))
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        print("textFieldShouldReturn")
        let indexPath = IndexPath(row:textField.tag, section:0)
        let cell : EstimateTableViewCell? = self.estimateTableView.cellForRow(at: indexPath as IndexPath) as! EstimateTableViewCell?
        //cell?.GPValueTextField.resignFirstResponder()
        if textField == cell?.GPValueTextField
        {
            let gdpValude :Double? = Double(textField.text!) ?? 0
            if gdpValude! > 100.00
            {
                let alert = UIAlertController(title: "", message: "GP value can’t be greater than 99.99%", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                let defaultfixedGP : String = (UserDefaults.standard.string(forKey: "fixedGP")) ?? "fixedGP"
                textField.text = defaultfixedGP
                cell?.GPValueTextField.text = defaultfixedGP
            }
//            if gdpValude! <= 0
//            {
//                textField.text = "35.00"
//                cell?.GPValueTextField.text = "35.00"
//            }
            estimateArray[textField.tag].estimateGB = Float((cell?.GPValueTextField.text ?? "0").isEmpty ? "0" :  (cell?.GPValueTextField.text ?? "0"))!
            estimateTableView.reloadRows(at: [indexPath], with: .fade)
        }
        if textField == cell?.extimatedHoursTextField
        {
            let estimatedHours :Double? = Double(textField.text!) ?? 0
                        if estimatedHours! <= 0
                        {
                            let alert = UIAlertController(title: "", message: "Estimated Hours should be greater than ZERO", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                            let defaultEstimateHours : String = (UserDefaults.standard.string(forKey: "fixedEstimatedHours")) ?? "2000"
                            textField.text = defaultEstimateHours
                            cell?.GPValueTextField.text = defaultEstimateHours
                        }
            
            estimateArray[textField.tag].estimateHours = Float((cell?.extimatedHoursTextField.text ?? "0").isEmpty ? "0" :  (cell?.extimatedHoursTextField.text ?? "0"))!
            estimateTableView.reloadRows(at: [indexPath], with: .fade)
        }
        
        self.loadBlendedValue()
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool
    {
        
        if string.isEmpty { return true }
        let indexPath = NSIndexPath(row:textField.tag, section:0)
        let cell : EstimateTableViewCell? = self.estimateTableView.cellForRow(at: indexPath as IndexPath) as! EstimateTableViewCell?
        
        if textField == cell?.GPValueTextField || textField == cell?.extimatedHoursTextField  || textField == cell?.minimumBillRateTextField{
            let currentText = textField.text ?? ""
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
            if textField == cell?.extimatedHoursTextField {
                if (textField.text?.count ?? 0) == 4 {
                    return false
                }
                if string == "." {
                    return false
                }
            }
            return replacementText.isValidDouble(maxDecimalPlaces: 2)
        }
        else{
            return true
        }
    }
    func loadBlendedValue()  {
//        let maxGP  = estimateArray.map{$0.estimateGB} // 8
//        print("maxGP",maxGP.max() as Any)
//        let maxGPVal = maxGP.max()
//        self.blendedGB.text = String((maxGPVal?.description ?? "0") + "%")
        var totalGB :Float = 0.0
        var blendedGB: Float = 0.0
        var numberOfResouce : Int = 0
        
         for i in (0..<estimateArray.count)
         {
            if (estimateArray[i].jobLevelId > 0) && (estimateArray[i].estimatedTotalRevenueSalary > 0)
            {
                totalGB += estimateArray[i].estimateGB
                numberOfResouce = numberOfResouce + 1
            }
         }
        if (estimateArray.count > 0 && numberOfResouce >= 1)
        {
            DispatchQueue.main.async {
                if totalGB > 0
                {
                    blendedGB = totalGB/Float(numberOfResouce)
                    //self.blendedGB.text = "\(String(blendedGB))%"
                    self.blendedGB.text = "\(String(format: "%.2f", blendedGB))%"
                }
                self.numberOfResource.text = "No. of Resources : \(String(numberOfResouce))"
            }
        }
        else
        {
            self.blendedGB.text = "0%"
            self.numberOfResource.text = "No. of Resources : 0"

        }


    }
    
    @objc func didTapDone(_ sender:UITextField)
    {
        print("Done Button Pressed",sender.tag)
        view.endEditing(true)
        
    }
    
    
    
    // Calculation for estimated revenue by NB
    func calculationUpdate(selectedValue:Int)  {
        /*
        let gpval = String(format: "%.2f", estimateArray[selectedValue].estimateGB)//String(estimateArray[selectedValue].estimateGB)
        self.blendedGB.text = gpval+"%"
        var calculatedRevenue : Float = 0.0
        var minimamBillRateValue :Float = 0.0
        var GPValue :Float = 0.0
        var minimamBillRateValue_calculated :Float = 0.0
        GPValue = estimateArray[selectedValue].estimateGB
        for i in (0..<estimateArray.count)
        {
            minimamBillRateValue = (Float(estimateArray[i].miimumBillRate) + (Float(estimateArray[i].miimumBillRate) * (0.299))) // minimum bill rate 29.9%
            minimamBillRateValue_calculated = minimamBillRateValue + (minimamBillRateValue * Float(estimateArray[i].estimateGB/100.0) )
            calculatedRevenue += (Float(estimateArray[i].estimateHours) * minimamBillRateValue_calculated)
            let minimumBillRateHour = String(format: "%.2f", minimamBillRateValue_calculated)
            estimateArray[i].estimateBillRate = Float(minimumBillRateHour) ?? 0
            estimateTableView.reloadData()
        }
        let calculatedRevenueValue = (Float(estimateArray[selectedValue].estimateHours) * GPValue)
        let revenue = String(calculatedRevenueValue)
        self.estimatedRevenue.text = String("$"+revenue)
 */
    }
    
    
    // MARK - PopOverPresentation controller delegate methods
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return false
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


extension UITableView {
    func scrollToBottom(animated: Bool = true) {
        let sections = self.numberOfSections
        let rows = self.numberOfRows(inSection: sections - 1)
        if (rows > 0){
            self.scrollToRow(at: NSIndexPath(row: rows - 1, section: sections - 1) as IndexPath, at: .bottom, animated: true)
        }
    }
}

extension Double {
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0 //maximum digits in Double after dot (maximum precision) --16
        return String(formatter.string(from: number) ?? "")
    }
}
extension Date {
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}
