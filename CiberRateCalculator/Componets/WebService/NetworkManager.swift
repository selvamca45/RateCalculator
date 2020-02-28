//
//  NetworkManager.swift
//  Sample
//
//  Created by selvakumar on 16/05/17.
//  Copyright © 2017 chandramouli. All rights reserved.
//

import UIKit
import CoreTelephony
import MapKit
// Base url for the web service

//**** Local URL

//var webserviceURL:String = SharedOjectModel.sharedInstance.webServiceURL!

///////"http://10.1.29.124:8069/crm/api/"


// Create protocol for NetworkManager class

protocol NetworkManagerDelegate {
    
    func webServiceResponse(for requestType: ServiceRequestType, isSuccess: Bool, responseData Data: Any!, withStatusCode statusCode: Int, errorMessage message: Any!)
    
    
}

//Service request type.
enum ServiceRequestType {
    
    case ServiceTypeLogin
    case ServiceTypeListOfOpportunitites
    case ServiceTypeOpportunityCreation
    case ServiceTypeOpportunityDetail
    case ServiceTypeFetchLovs
    case ServiceTypeFetchDependsLovs
    case ServiceTypeCreateTaskInOpportunity
    case ServiceTypeCreateCallLogInOpportunity
    case ServiceTypeCreateAppointmentInOpportunity
    
    case ServiceTypeFetchListTask
    case ServiceTypeFetchListCallLog
    case ServiceTypeFetchListAppointment
    case ServiceTypeFetchListAttachment



    case ServiceTypeFetchAllLovs

    case ServiceTypeAddNotes
    case ServiceTypeListOfNotes


    case ServiceTypeListOfAccount
    case ServiceTypeAccountCreation
    case ServiceTypeAccountDetail
    
    case ServiceTypeListOfContact
    case ServiceTypeListTaskDashboard

    
    case ServiceTypeContactCreation
    case ServiceTypeContactDetail
    case ServiceTypeContactLovs
    
    case ServiceTypeListOfLeads
    case ServiceTypeLeadDetail
    case ServiceTypeContractDetail
    case ServiceTypeClientRequest

    case ServiceTypeLeadCreation

    case ServiceTypeApprovalLeadAndOpportunity
    case ServiceTypeApprovalEdit

    case ServiceTypeNotification
    case ServiceTypeUpdateNotification




    case ServiceTypeVerifyMobileNo
    case ServiceTypeRegistration
    case ServiceTypeChangePassword
    case ServiceTypeFetchProductList
    case ServiceTypeProfile
    case ServiceTypeOfferList
    case ServiceTypeCouponApply
    case ServiceTypeSendingProductsToDb
    case ServiceTypegetAllUserOrders
    case ServiceTypeParticularOrderDetail
    case ServiceTypeAddPaypalTransactionDetails
    case ServiceTypeGetAllNotifications
    case ServiceTypeGetNotificationCount
    case ServiceTypeQRScanning
    case ServiceTypeApplicableOffers
    case ServiceTypePieChartData
    case ServiceTypePieChartSelected
    case ServiceTypeLineChart
    case ServiceTypeGetProductDetail
    case ServiceTypeListNewProductList
    case ServiceTypeForgotProducts
    case ServiceTypeLogout

}


//Module type.
enum MouduleType {
    
    case MouduleTypeOpportunity
    case MouduleTypeContacts
    case MouduleTypeAccounts
    case MouduleTypeTask
    case MouduleTypeLeads
}
// Create network model for background request processing
class NetworkRequestModel: NSObject {
    
    var networkRequestType: ServiceRequestType?
    var backgroundDelegate: NetworkManagerDelegate?
    var backgroundUrlString : String?
    var jsonData:NSDictionary?
    
}

class NetworkManager: NSObject,CLLocationManagerDelegate {
    
    //Device details
    var deviceId : String?
    var deviceName : String?
    var deviceModel : String?
    var osVersion : String?
    var deviceUTCTime : String?
    var appBuildVersion : String?
    var networkIpAddress : String?
    var reachability = Reachability()
    var latLongValue : CLLocationCoordinate2D?
    var currentLocationState : String?
    var networkStatusResult : String?
    
    // To Check network types
    var isReachableViaWiFi : Bool!
    var isReachableViaCellular : Bool!
    var isNotReachable : Bool!
    
    var sessionDelegate:NetworkManagerDelegate? // Current session delegate
    var currentRequestType : ServiceRequestType? // Current service type request
    
    var currentUrlSession :URLSession!
    var currentUrlSharedSession :URLSession!
    var backgroundSessionArray = NSMutableArray()
    
    // Creating singleton object for NetworkManager class and initial
    static let sharedInstance : NetworkManager = {
        var networkManagerObj = NetworkManager()
        networkManagerObj.initiateNetworkModels()
        
        if !networkManagerObj.isReachable()
        {
//            print("Network not available")
        }
        return networkManagerObj
        
    }()
    var locationManager:CLLocationManager? = CLLocationManager()   // To get the current location
    var networkRequestModelObj : NetworkRequestModel?
    var backgroundRequestDictionary:NSMutableDictionary = NSMutableDictionary()
    var deviceDetailsDictionary:NSMutableDictionary = NSMutableDictionary()
    
    //MARK: - Initiate Required Models
    func initiateNetworkModels()  {
        
        self.backgroundRequestDictionary = NSMutableDictionary()
        self.findCurrentLocationIdentifier()
    }
    
    //MARK: - Check internet connection
    func checkTypeOfNetwork() -> String {
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(notificationObj:)), name:ReachabilityChangedNotification, object: nil) // Notify if there is any change in the network
        
        do {
            try reachability?.startNotifier()
            
            let networkStatus:Reachability.NetworkStatus = reachability!.currentReachabilityStatus // Get the current network status
            
            //Check which type of network is available
            switch networkStatus{
            case .notReachable:
                networkStatusResult = "Not Reachable"
//                print("Network Status..\(networkStatusResult)")
                self.isReachableViaWiFi = false
                self.isReachableViaCellular = false
                self.isNotReachable = true
                break
            case .reachableViaWiFi:
                networkStatusResult = "Wi-Fi"
//                print("Network Status..\(networkStatusResult)")
                self.isReachableViaWiFi = true
                self.isReachableViaCellular = false
                self.isNotReachable = false
                break
            case .reachableViaWWAN:
                networkStatusResult = "Cellular"
//                print("Network Status..\(networkStatusResult)")
                self.isReachableViaCellular = true
                self.isReachableViaWiFi = false
                self.isNotReachable = false
                break
            default:
//                print("Network Status.")
                networkStatusResult = "Not Reachable"
                break
            }
            
        } catch  {
            
//            print("Error in network")
        }
        
        return networkStatusResult!
    }
    
    //MARK: - Check the reachability of the network connection
    func isReachable() -> Bool {
        
        return self.reachability?.currentReachabilityStatus != .notReachable
    }
    
    //MARK: - Reachability Change Notification Method
    @objc func reachabilityChanged(notificationObj: NSNotification) {
        let reachabilityStatus = notificationObj.object as! Reachability     // Reachability status from notification object
        if reachabilityStatus.isReachable {
            if reachabilityStatus.isReachableViaWiFi {
//                print("Reachable via WiFi")
            } else {
//                print("Reachable via Cellular")
            }
        } else {
//            print("Network not reachable")
        }
    }
    
    //MARK: - Find the current location
    func findCurrentLocationIdentifier()  {
        
        if CLLocationManager.locationServicesEnabled()
        {
            if locationManager == nil
            {
                locationManager = CLLocationManager()
            }
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager?.requestWhenInUseAuthorization()
            locationManager!.startUpdatingLocation()
            switch(CLLocationManager.authorizationStatus()) {
                
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager!.startUpdatingLocation()
                break
            default:
                break
            }
            
        }
        
    }
    
    //MARK: - Get IP Address
    func getNetworkIPAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var addr = interface.ifa_addr.pointee
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        networkIpAddress = address
        return address
    }
    
    //MARK: - Get webservice link with the parameters available for the request
    func getLinkForRequestType(_ requestType : ServiceRequestType) -> String {
        var serviceName :String?
        switch requestType {
        case .ServiceTypeLogin:
            serviceName = "authenticate/login"
            break
            //Opportunities
        case .ServiceTypeListOfOpportunitites:
            serviceName = "list/opportunities"
            break
        case .ServiceTypeOpportunityCreation:
            serviceName = "create/opportunities"
            break
        case .ServiceTypeOpportunityDetail:
            serviceName = "fetch/opportunities"
            break
            
        case .ServiceTypeFetchLovs:
            serviceName = "fetch/fetchlovs"
            break
        case .ServiceTypeFetchDependsLovs:
            serviceName = "fetch/fetchdependantvalues"
            break
            
        case .ServiceTypeFetchAllLovs:
            serviceName = "fetch/fetchlovs"
            break
        case .ServiceTypeCreateTaskInOpportunity:
            serviceName = "create/task"
            break
        case .ServiceTypeCreateAppointmentInOpportunity:
            serviceName = "create/appointment"
            break
            
        case .ServiceTypeCreateCallLogInOpportunity:
            serviceName = "create/calllog"
            break
        case .ServiceTypeFetchListTask:
            serviceName = "fetch/task"
            break
            
        case .ServiceTypeFetchListCallLog:
            serviceName = "fetch/callLog"
            break
        case .ServiceTypeFetchListAppointment:
            serviceName = "fetch/appointment"
            break
            
        case .ServiceTypeFetchListAttachment:
            serviceName = "list/attachments"
            break
            
            
        case .ServiceTypeAddNotes:
            serviceName = "add/notes"
            break
        case .ServiceTypeListOfNotes:
            serviceName = "list/notes"
            break
            
            //Contacts
            
        case .ServiceTypeListOfContact:
            serviceName = "list/contact"
            break
        case .ServiceTypeListTaskDashboard:
            serviceName = "list/taskDashboard"
            break
            
        case .ServiceTypeListOfAccount:
            serviceName = "list/account"
            break
            
        case .ServiceTypeListOfLeads:
            serviceName = "list/lead"
            break
        case .ServiceTypeContactCreation:
            serviceName = "create/contact"
            break
        case .ServiceTypeAccountCreation:
            serviceName = "create/account"
            break

        case .ServiceTypeLeadCreation:
            serviceName = "create/lead"
            break
        case .ServiceTypeLeadDetail:
            serviceName = "fetch/lead"
            break
        case .ServiceTypeContractDetail:
            serviceName = "fetch/contracts"
            break
        case .ServiceTypeClientRequest:
            serviceName = "fetch/clientcontractrequest"
            break
            
        case .ServiceTypeContactDetail:
            serviceName = "fetch/contact"
            break
        case .ServiceTypeAccountDetail:
            serviceName = "fetch/account"
            break
        case .ServiceTypeContactLovs:
            serviceName = "fetch/fetchlovs"
            break
            
        case .ServiceTypeApprovalLeadAndOpportunity:
            serviceName = "list/approval"
            break
        case .ServiceTypeApprovalEdit:
            serviceName = "edit/approval"
            break
            
        case .ServiceTypeNotification:
            serviceName = "list/notification"
            break
        case .ServiceTypeUpdateNotification:
            serviceName = "update/notification"
            break
            
        case .ServiceTypeRegistration:
            serviceName = "user/register"
            break
        case .ServiceTypeChangePassword:
            serviceName = "user/changePassword"
            break
        case .ServiceTypeFetchProductList:
            serviceName = "product/newList"
            break
        case .ServiceTypeProfile:
            serviceName = "user/profile"
            break
        case .ServiceTypeOfferList:
//            serviceName = "coupons/all"
            let userID: Int = UserDefaults.standard.object(forKey: "userId") as! Int
            let aString = String(userID)
            serviceName = "coupons/apllicable/"+(aString.trimmingCharacters(in: .whitespaces))
            
            break
        case .ServiceTypeCouponApply:
            serviceName = "coupons/apply"
            break
        case .ServiceTypeSendingProductsToDb:
            serviceName = "order/add"
            break
        case .ServiceTypeAddPaypalTransactionDetails:
            serviceName = "payment/add"
            break
        case .ServiceTypegetAllUserOrders:
            serviceName = "order/getAllUserOrders"
            break
        case .ServiceTypeParticularOrderDetail:
            serviceName = "order/findByOrderCode"
            break
        case .ServiceTypeGetAllNotifications:
            serviceName = "notification/all"
            break
        case .ServiceTypeGetNotificationCount:
            serviceName = "notification/findNotificationsCount"
            break
        case .ServiceTypeQRScanning:
            
            let QRResponse: String = UserDefaults.standard.object(forKey: "QRRequest") as! String
            serviceName = QRResponse.trimmingCharacters(in: .whitespaces)
            break
        case .ServiceTypeApplicableOffers:
            serviceName = "coupons/applicableCoupons"
            break
        case .ServiceTypePieChartData:
//            serviceName = "graph/month"
            serviceName = "reports/month"
            break
        case .ServiceTypePieChartSelected:
//            serviceName = "graph/categoryProducts"
            serviceName = "reports/categoryProducts"
            break
//        case .ServiceTypeBanner:
//            let userId : Int = UserDefaults.standard.object(forKey: "userId") as! Int
//            serviceName = "product/splOfferProducts/" + String(userId)
//            break
        case .ServiceTypeLineChart:
            let lineRequest: String = UserDefaults.standard.object(forKey: "LineRequest") as! String
            serviceName = lineRequest.trimmingCharacters(in: .whitespaces)
            break
        case .ServiceTypeLogout:
            let logOutRequest: String = UserDefaults.standard.object(forKey: "LogOutRequest") as! String
            serviceName = logOutRequest.trimmingCharacters(in: .whitespaces)
            break
        case .ServiceTypeGetProductDetail:
            let productDetailRequest: String = UserDefaults.standard.object(forKey: "ProductDetailRequest") as! String
            serviceName = productDetailRequest.trimmingCharacters(in: .whitespaces)
            break
        case .ServiceTypeListNewProductList:
            serviceName = "product/newList"
            break
        case .ServiceTypeForgotProducts:
            serviceName = "product/forgotProducts"
            break
        
        default:
            break
        }
        let userDefaults:UserDefaults = UserDefaults.standard
        var webserviceURL1:String = userDefaults.object(forKey: "weburl") as! String

        var finalURL = webserviceURL1 + "/crm/api/"

        var webserviceURL:String = finalURL //userDefaults.object(forKey: "weburl") as! String
        let finalServiceRequet:String = "\(webserviceURL)\(serviceName!)"
        
        //Full webservice link with parameters
//        let finalServiceRequet:String = "\(SharedOjectModel.sharedInstance.webServiceURL)\(serviceName!)"
        return finalServiceRequet
    }
    
    
    //MARK: - Add additonal values (Headers & Method type)for the request
    func getHeadersAndMethodsForRequestType(_ requestType : ServiceRequestType, _ urlRequest:URLRequest) -> URLRequest{
        
        var serviceUrlRequest = urlRequest
        
        // Adding values to web-service request and type of httpMethod
        switch requestType {
        case .ServiceTypeLogin:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
           // serviceUrlRequest.addValue("mobile", forHTTPHeaderField: "Client-Id")

            //serviceUrlRequest.addValue("6b2d9ac466af3640ecb71d36a2370fee", forHTTPHeaderField: "Client-Secret")

            serviceUrlRequest.httpMethod = "POST"
            break
            //Opportunities
        case .ServiceTypeListOfOpportunitites:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
        case .ServiceTypeOpportunityCreation:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
        case .ServiceTypeOpportunityDetail:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
            
        case .ServiceTypeFetchLovs:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
        case .ServiceTypeFetchDependsLovs:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
            
        case .ServiceTypeFetchAllLovs:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            serviceUrlRequest.httpMethod = "POST"
            break
        case .ServiceTypeCreateTaskInOpportunity:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
        case .ServiceTypeCreateAppointmentInOpportunity:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
            
        case .ServiceTypeCreateCallLogInOpportunity:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
        case .ServiceTypeFetchListCallLog:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
        case .ServiceTypeFetchListAppointment:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
        case .ServiceTypeFetchListAttachment:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
            
        case .ServiceTypeOpportunityDetail:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
            
            //Contacts
        case .ServiceTypeFetchListTask:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
        case .ServiceTypeContactCreation:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
        case .ServiceTypeListOfAccount:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
        case .ServiceTypeListOfContact:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
        case .ServiceTypeListTaskDashboard:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
            
        case .ServiceTypeAccountCreation:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
        case .ServiceTypeAccountDetail:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
            
        case .ServiceTypeContactDetail:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
        case .ServiceTypeContactLovs:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
        case .ServiceTypeLeadDetail:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
        case .ServiceTypeContractDetail:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
        case .ServiceTypeClientRequest:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
            
            
        case .ServiceTypeLeadCreation:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
        case .ServiceTypeListOfLeads:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
        case .ServiceTypeAddNotes:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
        case .ServiceTypeListOfNotes:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
        case .ServiceTypeApprovalLeadAndOpportunity:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
        case .ServiceTypeApprovalEdit:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
        case .ServiceTypeNotification:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
        case .ServiceTypeUpdateNotification:
            serviceUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            serviceUrlRequest.httpMethod = "POST"
            break
            
            
        default: break
            
        }
        
//        if SharedOjectModel.sharedInstance.webServiceURL == "http://10.1.29.124:8069" //|| SharedOjectModel.sharedInstance.webServiceURL == "http://10.1.29.124:8069/crm/api/"
//        {
            serviceUrlRequest.addValue("mobile", forHTTPHeaderField: "Client-Id")
            serviceUrlRequest.addValue("6b2d9ac466af3640ecb71d36a2370fee", forHTTPHeaderField: "Client-Secret")
//        }
//        else if SharedOjectModel.sharedInstance.webServiceURL == "******************"
//        {
//
//        }
        
       // self.addAdditionalHeaders(serviceUrlRequest)
        return serviceUrlRequest
    }
    //MARK : - Adding headers
    
   /* func addAdditionalHeaders(_ servURL : URLRequest)
    {
        if SharedOjectModel.sharedInstance.webServiceURL == "" {
            
        }
        serviceUrlRequest.addValue("mobile", forHTTPHeaderField: "Client-Id")
        serviceUrlRequest.addValue("6b2d9ac466af3640ecb71d36a2370fee", forHTTPHeaderField: "Client-Secret")

        
    }*/
    
    //MARK: -  Create URL Session and process webservice request with the body parameter
    func createConnectionAndProcessWebServiceRequestWithBody(_ requestType:ServiceRequestType, _ requestData:NSDictionary, _ delegate:Any?)
    {
        self.sessionDelegate = delegate as! NetworkManagerDelegate?
        self.currentRequestType = requestType
        
        var config :URLSessionConfiguration!
        
        // Set up session
        config = URLSessionConfiguration.default
        currentUrlSession = URLSession(configuration: config)
        
        //Create url with the parameters
        guard let callURL = URL.init(string: self.getLinkForRequestType(self.currentRequestType!)) else
        {
            return
        }
        #if DEBUG
//        print(callURL)
        #endif
        
        // Set up web-service request
      //  var request = URLRequest.init(url: callURL)
        let fileUrl = NSURL(string: "http://mapp2.htcindia.com:8080/ciber/calculator/getarea")
        var request = URLRequest.init(url: fileUrl as! URL)

        request.timeoutInterval = 60.0 // TimeoutInterval in Seconds 60 to 10
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "POST"
        request = self.getHeadersAndMethodsForRequestType(self.currentRequestType!, request)
        #if DEBUG
        print(request);
        #endif
        //*****************
        
//        var requestData: Data? = try? JSONSerialization.data(withJSONObject: requestData, options: .prettyPrinted)
//        var requestJson: String? = nil
//        if let aData = requestData {
//            requestJson = String(data: aData, encoding: .utf8)
//        }
//        request.setValue("\(UInt(requestData?.count ?? 0))", forHTTPHeaderField: "Content-Length")

        //****************
        
//        self.getHeadersAndMethodsForRequestType(self.currentRequestType!, request) // Get the full webservice link to process the request
        
        do {
            //Add body parameters
            let requestDataObj :NSData = try JSONSerialization.data(withJSONObject: requestData, options: []) as NSData
            let requestStringObj : String = String.init(data: requestDataObj as Data, encoding: String.Encoding.utf8)!
            request.httpBody = requestStringObj.data(using: String.Encoding.utf8)
            
            let dataTask = currentUrlSession.dataTask(with: request) { (data,response,error) in
                
                let httpResponse = response as? HTTPURLResponse
                
                guard error
                    == nil else {
                    //LoadingView.shareInstance.hideLoadingView()

                    DispatchQueue.main.async {
                    let alert = UIAlertView(title: "", message: "Sorry, Something went wrong", delegate: nil, cancelButtonTitle: "Ok" ) // HTTP load failed
                    alert.show()
                    #if DEBUG
                     print("\(error)")
                    #endif
                   
                    
                  
                        AlertView.showAlertMessage("Server is temporarily unavailable. Please try again after sometime")
                    }
                    return
                }
                // Check whether response data is available
                guard let responseData = data else {
                   // print("Error: did not receive data")
                    return
                }
                do {
                    //Parse the response as JSON
                    guard let resultJson = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String:AnyObject] else
                    {
                        return
                    }
                    
                    print("resultJson",resultJson)
                    // Send the data to the respective class from which they made service request
//                    if requestType == ServiceRequestType.ServiceTypeFetchLovs || requestType == ServiceRequestType.ServiceTypeFetchDependsLovs {
//
//                        if requestType == ServiceRequestType.ServiceTypeFetchLovs{
//
//                            ResponseManager.sharedInstance.getLovsResult(responseData: resultJson)
//
//                        }
//                        else{
//                            ResponseManager.sharedInstance.getDependentLOVS(responseData: resultJson)
//
//                        }
//                    }
//                    else{
                        self.sessionDelegate?.webServiceResponse(for: self.currentRequestType!, isSuccess: true, responseData: resultJson, withStatusCode:(httpResponse?.statusCode)! , errorMessage: error)

//                    }

                    
                    //print("Result",resultJson)
                    
                } catch {
                    
                    self.sessionDelegate?.webServiceResponse(for: self.currentRequestType!, isSuccess: false, responseData: "", withStatusCode:(httpResponse?.statusCode)! , errorMessage: error)
                  //  print("Error -> \(error)")
                }
            }
            
            
            dataTask.resume()
            
        } catch  {
            
            
        }
    }
    
    //MARK: - Create URL Session and process webservice request without body parameter
    func createConnectionAndProcessWebServiceRequest(_ requestType:ServiceRequestType, _ delegate:Any?)
    {
        self.sessionDelegate = delegate as! NetworkManagerDelegate?
        self.currentRequestType = requestType
        
        
        var config :URLSessionConfiguration!
        
        // Set up session
        config = URLSessionConfiguration.default
        currentUrlSession = URLSession(configuration: config)
        
        //Create url with the parameters
        guard let callURL = URL.init(string: self.getLinkForRequestType(self.currentRequestType!)) else
        {
            return
        }
        
        // Set up web-service request
        var request = URLRequest.init(url: callURL)
        request.timeoutInterval = 60.0 // TimeoutInterval in Seconds
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request = self.getHeadersAndMethodsForRequestType(self.currentRequestType!, request)

//        self.getHeadersAndMethodsForRequestType(self.currentRequestType!, request) // Get the full webservice link to process the request
        
        let dataTask = currentUrlSession.dataTask(with: request) { (data,response,error) in
            
            let httpResponse = response as? HTTPURLResponse
            
            guard error == nil else {
               // print("\(error)")
                return
            }
            // Check whether response data is available
            guard let responseData = data else {
                //print("Error: did not receive data")
                return
            }
            do {
                //Parse the response as JSON
                guard let resultJson = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String:AnyObject] else
                {
                    return
                }
               // print("1. Request Type...\(self.currentRequestType)")
                // Send the data to the respective class from which they made service request
                self.sessionDelegate?.webServiceResponse(for: self.currentRequestType!, isSuccess: true, responseData: resultJson, withStatusCode:(httpResponse?.statusCode)! , errorMessage: error)
                //print("Result",resultJson)
                
            } catch {
                
                self.sessionDelegate?.webServiceResponse(for: self.currentRequestType!, isSuccess: false, responseData: "", withStatusCode:(httpResponse?.statusCode)! , errorMessage: error)
               // print("Error -> \(error)")
            }
        }
        
        dataTask.resume()
        
    }
    
    //MARK: - Create URL Session and process request to download
    func createConnectionAndProcessWebServiceRequestForDownload(_ requestType:ServiceRequestType, _ delegate:Any?)
    {
        self.sessionDelegate = delegate as! NetworkManagerDelegate?
        self.currentRequestType = requestType
        
        var config :URLSessionConfiguration!
        
        // Set up session
        config = URLSessionConfiguration.default
        currentUrlSession = URLSession(configuration: config)
        
        //Create url with the parameters
        guard let callURL = URL.init(string: self.getLinkForRequestType(self.currentRequestType!)) else
        {
            return
        }
        
        // Set up web-service request
        var request = URLRequest.init(url: callURL)
        request.timeoutInterval = 60.0 // TimeoutInterval in Seconds
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        self.getHeadersAndMethodsForRequestType(self.currentRequestType!, request) // Get the full webservice link to process the request
        #if DEBEG
        print("URL: /",callURL)
        print("Request: /",request)
        #endif 
        let downloadTasks = currentUrlSession.downloadTask(with: request) { (data,response,error) in
            
            let httpResponse = response as? HTTPURLResponse
            
            guard error == nil else {
                print("\(error)")
                
                // Pass the error data
                // Send the data to the respective class from which they made service request
                self.sessionDelegate?.webServiceResponse(for: self.currentRequestType!, isSuccess: false, responseData: "", withStatusCode:(httpResponse?.statusCode)! , errorMessage: error)
                return
            }
            // Check whether response data is available
            guard let responseData = data else {
               // print("Error: did not receive data")
                return
            }
            // Send the data to the respective class from which they made service request
            self.sessionDelegate?.webServiceResponse(for: self.currentRequestType!, isSuccess: true, responseData: responseData, withStatusCode:(httpResponse?.statusCode)! , errorMessage: error)
           // print("Result",responseData)
        }
        
        downloadTasks.resume()
        
    }
    
    //MARK: - Create URL Session and process for multiple request in background
    func createConnectionAndProcessRequestInBackgroundSession(_ requestType:ServiceRequestType,_ requestModel:NetworkRequestModel, _ delegate:Any?) {
        
        DispatchQueue.main.async {
            
        
        
        var config :URLSessionConfiguration!
        
        
        // Set up session
        config = URLSessionConfiguration.default
        
            if self.currentUrlSharedSession == nil {
            
                self.currentUrlSharedSession = URLSession(configuration: config)
            
        }
        requestModel.networkRequestType = requestType
        //Create url with the parameters
        guard let callURL = URL.init(string: self.getLinkForRequestType(requestType)) else
        {
            return
        }
        requestModel.backgroundUrlString = self.getLinkForRequestType(requestType)
        
        // Set up web-service request
        var request = URLRequest.init(url: callURL)
        request.timeoutInterval = 60.0 // TimeoutInterval in Seconds
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request = self.getHeadersAndMethodsForRequestType(requestModel.networkRequestType!, request) // Get the full webservice link to process the request
        
        if requestModel.jsonData != nil
        {
            do
            {
            let requestDataObj :NSData = try JSONSerialization.data(withJSONObject: requestModel.jsonData!, options: []) as NSData
            let requestStringObj : String = String.init(data: requestDataObj as Data, encoding: String.Encoding.utf8)!
            request.httpBody = requestStringObj.data(using: String.Encoding.utf8)
            }
            catch
            {
                //print("Invalid JSON")
            }
        }
        
        
       // print(request)

        
            let dataTask = self.currentUrlSharedSession.dataTask(with: request) { (data,response,error) in
            
            let httpResponse = response as? HTTPURLResponse
            
            
            //let objectKey = response!.url?.absoluteString
            
            /*if (self.backgroundRequestDictionary.object(forKey: objectKey!) != nil)
            {
                newRequestModel = self.backgroundRequestDictionary.object(forKey: response?.url?.absoluteString as Any) as! NetworkRequestModel
            }*/
            
            
            // Get values from Dictionary to process the background operations
            //newRequestModel = self.backgroundRequestDictionary.object(forKey: response?.url?.absoluteString as Any) as! NetworkRequestModel
            guard error == nil else {
               // print("\(error.debugDescription)")
                return
            }
            // Check whether response data is available
            guard let responseData = data else {
                //print("Error: did not receive data")
                return
            }
            do {
                //Parse the response as JSON
                guard let resultJson = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String:AnyObject] else
                {
                    return
                }
                if requestType != ServiceRequestType.ServiceTypeFetchLovs
                {
                   // print("2. Request Type...\(requestModel.networkRequestType!)")
                }
                // Send the data to the respective class from which they made service request
                
               /* if requestType == ServiceRequestType.ServiceTypeFetchLovs || requestType == ServiceRequestType.ServiceTypeFetchDependsLovs {
                    
                    if requestType == ServiceRequestType.ServiceTypeFetchLovs{
                        
                        ResponseManager.sharedInstance.getLovsResult(responseData: resultJson)
                        
                    }
                    else if requestType == ServiceRequestType.ServiceTypeFetchDependsLovs{
                        ResponseManager.sharedInstance.getDependentLOVS(responseData: resultJson)
                        
                    }
                    else {
                        requestModel.backgroundDelegate?.webServiceResponse(for: requestModel.networkRequestType!, isSuccess: true, responseData: resultJson, withStatusCode:(httpResponse?.statusCode)! , errorMessage: error)

                    }

                    
                }*/
                requestModel.backgroundDelegate?.webServiceResponse(for: requestModel.networkRequestType!, isSuccess: true, responseData: resultJson, withStatusCode:(httpResponse?.statusCode)! , errorMessage: error)

               // print("Result",resultJson)
                
            } catch {
                requestModel.backgroundDelegate?.webServiceResponse(for: requestModel.networkRequestType!, isSuccess: false, responseData: "", withStatusCode:(httpResponse?.statusCode)! , errorMessage: error)
               // print("Error -> \(error)")
            }
            
            //self.performSelector(onMainThread: #selector(self.removeTopTask(_:)), with: response?.url?.absoluteString, waitUntilDone: true)
        }
        dataTask.resume()
        }
        
    }
    
    //MARK: - Add background task
    func addBackgroundTaskWithRequestType(_ requestType:ServiceRequestType, jsonData:NSDictionary?,_ delegate:Any?)  {
        
        // Create the new request model for background operations
        let newRequestModel : NetworkRequestModel = NetworkRequestModel()
        newRequestModel.networkRequestType = requestType
        newRequestModel.backgroundUrlString = self.getLinkForRequestType(requestType)
        newRequestModel.backgroundDelegate = delegate as! NetworkManagerDelegate?
        if jsonData != nil
        {
            newRequestModel.jsonData = jsonData
        }
        // Assign the request model in queue
        guard let callURL = URL.init(string: self.getLinkForRequestType(newRequestModel.networkRequestType!)) else
        {
            return
        }
        
        newRequestModel.backgroundUrlString = callURL.absoluteString
        //self.backgroundRequestDictionary.setObject(requestModel, forKey: callURL.absoluteString as NSCopying)
        self.createConnectionAndProcessRequestInBackgroundSession(newRequestModel.networkRequestType!, newRequestModel, newRequestModel.backgroundDelegate)
        self.startNextTaskInQueue(newRequestModel)
    }
    
    //MARK: - Start next task in the queue
    func startNextTaskInQueue(_ requestModel:NetworkRequestModel) {
        
        guard let callURL = URL.init(string: self.getLinkForRequestType(requestModel.networkRequestType!)) else
        {
            return
        }
        
        requestModel.backgroundUrlString = callURL.absoluteString
        self.backgroundRequestDictionary.setObject(requestModel, forKey: callURL.absoluteString as NSCopying)
        self.createConnectionAndProcessRequestInBackgroundSession(requestModel.networkRequestType!, requestModel, requestModel.backgroundDelegate)
        
    }
    
    //MARK: - Remove the Task
    func removeTopTask(_ urlString:String) {
        
        if urlString != "" {
            
            self.backgroundRequestDictionary.removeObject(forKey: urlString)
        }
        
    }
    
    //MARK: -  Get device details
    func getDeviceDetails() -> NSDictionary {
        
        self.deviceId = UIDevice.current.identifierForVendor?.uuidString
        self.deviceName = UIDevice.current.name
        self.deviceModel = UIDevice.current.model
        self.osVersion = UIDevice.current.systemVersion
        self.deviceUTCTime = self.getCurrentUTCDateTime()
        self.appBuildVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String?
        
        let deviceDictionaryDetails:NSDictionary = ["deviceID":self.deviceId as Any,"deviceName":self.deviceName as Any,"deviceModel":self.deviceModel as Any,"osVersion":self.osVersion as Any,"deviceUTCTime":self.deviceUTCTime as Any,"appBuildVersion":self.appBuildVersion as Any]
        
        return deviceDictionaryDetails
        
    }
    
    
    //MARK: - Accessing status code
    func checkStatusCode(_ statusCode:Int) -> Bool {
        
        if statusCode == 200 || statusCode == 201 || statusCode == 400 {
            
            return true
        }
        else
        {
            return false
        }
    }
    
    //MARK: - Get current UTC Time
    func getCurrentUTCDateTime()-> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDateTime = formatter.string(from: date)
        return currentDateTime
    }
    
    //MARK: - Location Manager delegate methods
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch(CLLocationManager.authorizationStatus()) {
            
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager!.startUpdatingLocation()
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let reverseGeoCoder:CLGeocoder = CLGeocoder()
        let locationObj:CLLocation = locations.last!
        self.latLongValue = locationObj.coordinate
        
        print("Lat Value..\(self.latLongValue?.latitude)..Long Value\(self.latLongValue?.longitude)")
        print(self.latLongValue?.latitude)
        if locations.count == 0{
            return;
        }
        reverseGeoCoder.reverseGeocodeLocation(locations[locations.count-1]) { (placeMarks:[CLPlacemark]?, error:Error?) in
            if let _:Error = error
            {
               // print("Can't get location")
                
            }
            else
            {
                if (placeMarks?.count)! > 0
                {
                    self.currentLocationState = placeMarks?[0].administrativeArea
                   // print("Current Location...\(self.currentLocationState!)")
                    
                }
            }
        }
        manager.stopUpdatingLocation()
        if locations.count > 0{
            manager.delegate = nil
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }
    
    //MARK: - Invalidate URL session
    func invalidateURLSession()   {
        
        if (currentUrlSession != nil) {
            currentUrlSession.invalidateAndCancel()
            currentUrlSession = nil
        }
        
        if (currentUrlSharedSession != nil) {
            currentUrlSharedSession.invalidateAndCancel()
            currentUrlSharedSession = nil
        }
        
    }
    
    //MARK: - Handling multipart.
    func createBodyWithBoundary(_ boundary:NSString,_ imageData:NSData,_ fieldName:NSString) -> NSData {
        
        var boundaryValue:NSString = boundary
        let imageDataValue:NSData = imageData
        
        let httpBody:NSMutableData = NSMutableData.init()
        
        boundaryValue = "124445"
        let data:NSData = NSData.init(data: imageDataValue as Data)
        let mimeType = "imgae/png"
        
        httpBody.append("--\(boundaryValue)\r\n".data(using: String.Encoding.utf8)!)
        httpBody.append("Content-Disposition:form-data; name=\"test\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        httpBody.append("Content-Disposition:form-data; name=\"\(fieldName)\"; filename=\"\(fieldName)\"\r\n".data(using: String.Encoding.utf8)!)
        httpBody.append("--\(boundaryValue)\r\n".data(using: String.Encoding.utf8)!)
        httpBody.append("Content-Type: \(mimeType)\r\n\r\n".data(using: String.Encoding.utf8)!)
        httpBody.append(data as Data)
        httpBody.append("\r\n".data(using: String.Encoding.utf8)!)
        httpBody.append("--\(boundaryValue)--\r\n".data(using: String.Encoding.utf8)!)
        
        
        return httpBody
    }
    
    func checkError(receivedData:Any?) -> ErrorModel {
        
        let errorModel = ErrorModel()
        if receivedData != nil
        {
            if let recievedDictionary:NSDictionary = receivedData as? NSDictionary{
                
                if let errorMessage = recievedDictionary["error"] as? String  {
                    errorModel.errorMessage = errorMessage
                }
                else if let errorMessage = recievedDictionary["message"] as? String {
                    errorModel.errorMessage = errorMessage
                }
                else if let errorstatus = recievedDictionary["status"] as? Int {
                    errorModel.errorStatus = errorstatus
                }
            }
        }
        return errorModel
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        reachability?.stopNotifier()
    }
    
    
}
