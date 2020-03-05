//
//  WelcomeDashboardViewController.swift
//  CiberRateCalculator
//
//  Created by maranisowjanya on 21/10/19.
//  Copyright © 2019 Selvakumar. All rights reserved.
//

import UIKit
import CoreData


class WelcomeDashboardViewController: UIViewController,UIAlertViewDelegate {

    @IBOutlet weak var noResultsLabel : UILabel!
    @IBOutlet weak var welcomeLabel : UILabel!
    var noOfScreenCount : Int = 1
    var versionArray : Array <HTCDropDownModel> = []
    var verversionDictionary : NSDictionary = NSDictionary()
    var strLabel :UILabel =  UILabel()
    var activityIndicator :UIActivityIndicatorView =  UIActivityIndicatorView()
    let effectView :UIView = UIView()
    var dataModelArr : Array<HTCDropDownModel> = []
    var dataModelArrayJobTitle : Array<HTCDropDownModel> = []
    var dataModelArrarJobLevel : Array<HTCDropDownModel> = []
    var dataModelArrarMinimamBillRate : Array<HTCDropDownModel> = []
    var retriveArray : Array<HTCDropDownModel> = []
    var retriveArrayJobTitile : Array<HTCDropDownModel> = []
    var retriveArrayJobLevel : Array<HTCDropDownModel> = []
    var retriveArraySalary : Array<HTCDropDownModel> = []
    var selectedSalaryArray : Array<HTCDropDownModel> = []
    var userName  : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLabel.text = "Welcome \(userName)!"
        // Do any additional setup after loading the view.
    }
    
    
    func checkDataVersionCheck() {
          let timestamp = (UserDefaults.standard.string(forKey: "lastUpdatedDateTime"))
                let version = UserDefaults.standard.integer(forKey: "versionID")
                //let timestamCurrent = self.generateCurrentTimeStamp()
                print("timestam old from server",timestamp as Any)
                //let serverTimeNewUpdate = self.verversionDictionary["lastUpdatedDateTime"] as! String
                let timeStampCurrent = Date.currentTimeStamp
                print("CurrentTimestamp",timeStampCurrent)
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
                                self.nextViewAction()
        //                        self.retrieveData()
        //                        self.retrieveJobTitle()
                            }
    }
    
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int)
    {
        
            if alertView.tag == 405{
                if buttonIndex == 0
                {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
          noOfScreenCount = 1
          self.noResultsLabel.text = String(noOfScreenCount)
       // self.getVersion()
    }
    // Locading Activity
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
    // Removing activity
    func removeActivity() {
        //strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        

        
    }
    
    func nextViewAction()  {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let createEstimateViewController = storyBoard.instantiateViewController(withIdentifier: "CreateEstimateViewController") as! CreateEstimateViewController
        createEstimateViewController.noOfScreenCount = self.noOfScreenCount
        createEstimateViewController.versionArray = self.versionArray
        createEstimateViewController.modalPresentationStyle = .fullScreen
        self.present(createEstimateViewController, animated:true, completion:nil)
    }
    
    // GetAllData for saving in Coredata
    func GetAllData() {
            
            let networkReachableStatus = NetworkManager.sharedInstance.isReachable()
            if networkReachableStatus == false
            {
                let alert = UIAlertController(title: "No internet connection", message: "Please check your internet connection and try again", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print("No Internet pelase check your internet connection")
            }
             
        else
            {
                self.activityIndicator("Loading")

               // Set up the URL request
                             let todoEndpoint: String = "https://home.htcindia.com/rateestimator/calculator/getalldata"
                             //let todoEndpoint: String = "http://mapp2.htcindia.com:8080/rateestimator/calculator/getalldata"
                            // https://jsonplaceholder.typicode.com/todos/1
                            // http://mapp2.htcindia.com:8080/ciber/calculator/getarea
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
               //                  let jsonEncoder = JSONEncoder()
               //
               //               let appDelegate = UIApplication.shared.delegate as! AppDelegate
               //               let context = appDelegate.persistentContainer.viewContext
               //               let entity = NSEntityDescription.entity(forEntityName: "Area", in: context)
               //               let newArea = NSManagedObject(entity: entity!, insertInto: context)

                              
                                 // parse the result as JSON, since that's what the API provides
                                 do {
                                     guard let todo = try JSONSerialization.jsonObject(with: responseData, options: [])
                                         as? [String: Any] else {
                                             print("error trying to convert data to JSON")
                                             return
                                     }
                                     // now we have the todo
                                     // let's just print it to prove we can access it
                                     //print("The todo is: " + todo.description)
                                  
                                  
                                     
                                     let responseDict = todo as NSDictionary
                                     //let reponseArray = responseDict["value"] as! NSArray
                                     let reponsedataArray = responseDict["area"] as! NSArray
                                     let reponsedataArrayJobTitle = responseDict["jobTitle"] as! NSArray
                                     let reponsedataArrayAlldata = responseDict["jobRole"] as! NSArray
                                     let reponsedataVersionArray = responseDict["version"] as! NSArray
                                     let responseDataSalarArray  =  responseDict["salary"] as! NSArray
                                     let responseDataFixedCostArray  =  responseDict["salaryFixedPercent"] as! NSArray
                                     let responseDataRateFixedPercent = responseDict["salaryFixedPercent"] as! NSArray

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
                                   UserDefaults.standard.set(fixedPercentage["fixedAnnualBillableHours"], forKey: "fixedAnnualBillableHours") //setObject

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
                                       self.removeActivity()
                                       self.nextViewAction()
                                   }

                                  
                                  
                                 } catch  {
                                     print("error trying to convert data to JSON")
                                     return
                                 }
                             }
                             task.resume()
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
    
    
      //  Saving saveJobTitle
            
            func saveJobTitle(_ areas: [HTCDropDownModel]) {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
//                article.setValue(stream["jobTitleID"], forKey: "jobTitleID")
//                articles.append(article)
                
                do {
                        if areas.count > 0
                        {
                                   for  i in 0 ..< areas.count { //for user in areas {
                                        //print("areas.count",areas.count)
                                    let dropDownModelObj = areas[i]
                                        //let newUser = NSEntityDescription.insertNewObject(forEntityName: "JobTitle", into: context)
                                    let entity =  NSEntityDescription.entity(forEntityName: "JobTitle", in: context)
                                    let article = NSManagedObject(entity: entity!, insertInto: context)
                                    article.setValue(dropDownModelObj.modelId, forKey: "jobTitleID")
                                    article.setValue(dropDownModelObj.modelData, forKey: "jobTitleName")
                                        //newUser.setValue(dropDownModelObj.modelId, forKey: "jobTitleID")
                                        //newUser.setValue(dropDownModelObj.modelData, forKey: "jobTitleName")
                                        //print("saveUserData",dropDownModelObj.modelId,dropDownModelObj.modelData,dropDownModelObj.cityString)
                                    }
                            try context.save()
                            print("Success")
                             DispatchQueue.main.async {
                            //self.deleteData()
                            //self.retrieveJobTitle()
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
                         //self.retrieveData()
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
        
    
    
    
    // Get version tile
    func getVersion()
    {
        

            // Set up the URL request
                            //let todoEndpoint: String = "http://mapp2.htcindia.com:8080/rateestimator/calculator/getversion"
                            let todoEndpoint: String = "https://home.htcindia.com/rateestimator/calculator/getversion"
                            // https://jsonplaceholder.typicode.com/todos/1
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
                                      }
                              } catch  {
                                  print("error trying to convert data to JSON")
                                  return
                              }
                          }
                          task.resume()

    }
    
    
    @IBAction func rightButtonPressed()
    {
        noOfScreenCount = noOfScreenCount+1
        self.noResultsLabel.text = String(noOfScreenCount)
    }
    
    @IBAction func leftButtonPressed()
    {
        if noOfScreenCount == 1 {
            return
        }
        noOfScreenCount = noOfScreenCount-1
        self.noResultsLabel.text = String(noOfScreenCount)
    }
    
    @IBAction func nextButtonPressed()
    {
//        let createEstimateViewController = self.storyboard?.instantiateViewController(withIdentifier: "CreateEstimateViewController") as! CreateEstimateViewController
//        self.navigationController?.pushViewController(createEstimateViewController, animated: true)
        let networkReachableStatus = NetworkManager.sharedInstance.isReachable()
        if networkReachableStatus != false
          {
              DispatchQueue.main.async {
                  self.getVersion()
                  //self.checkDataVersionCheck()
              }
          }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { //2.0
             self.checkDataVersionCheck()
            
        }
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            let createEstimateViewController = storyBoard.instantiateViewController(withIdentifier: "CreateEstimateViewController") as! CreateEstimateViewController
//            createEstimateViewController.noOfScreenCount = self.noOfScreenCount
//            createEstimateViewController.versionArray = self.versionArray
//            createEstimateViewController.modalPresentationStyle = .fullScreen
//            self.present(createEstimateViewController, animated:true, completion:nil)
        

        
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
