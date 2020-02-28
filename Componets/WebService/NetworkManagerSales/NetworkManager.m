////
////  NetwrokManager.m
////  Travel
////
////  Created by Shyamchandar on 20/06/16.
////  Copyright © 2016 HTC. All rights reserved.
////
//
//#import "NetworkManager.h"
//#import "Reachability.h"
//#import "AlertView.h"
////#import "ResponseManager.h"
////#import "RequestManager.h"
//
//
//@interface NetwrokManager()
//
//@property (nonatomic, strong)Reachability *reachability;
//
//@end
//
//@implementation RequestModel
//
//@end
//
//@implementation NetworkRequestModel
//
//
//
//@end
//
//@implementation NetwrokManager
//
//
//@synthesize reachability = _reachability;
//
//+ (NetwrokManager *)sharedInstance
//{
//    static NetwrokManager *networkManager;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        networkManager = [[NetwrokManager alloc] init];
//        [[NSNotificationCenter defaultCenter] addObserver:networkManager
//                                                 selector:@selector(reachabilityChanged:)
//                                                     name:kReachabilityChangedNotification
//                                                   object:nil];
//        [networkManager setReachability:[Reachability reachabilityForInternetConnection]];
//        
//        [networkManager.reachability startNotifier];
//        [networkManager initiateModels];
//        
//        
//        if(![networkManager isReachable])
//            [AlertView showAlertMessage:@"No network connection. Please check your connection and try again."];
//    });
//    return networkManager;
//}
//
//- (void)reachabilityChanged:(NSNotification *)notification{
//    self.reachability = [notification object];
//    if(![self isReachable]){
//        [AlertView showAlertMessageOption:@"No network connection. Please check your connection and try again."];
//        if (cryptKeyFetchingSession) {
//            [cryptKeyFetchingSession invalidateAndCancel];
//        }
//        if (customUrlSession) {
//            [customUrlSession invalidateAndCancel];
//            //[self.currentDelegate responseForRequestType: isSuccess:<#(BOOL)#> responseData:<#(id)#> errorMessage:<#(id)#>]
//        }
//    }
//    if(!self.reachability.connectionRequired){
//        
//    }
//}
//
//- (BOOL)isReachable{
//    return ([self.reachability currentReachabilityStatus] != NotReachable);
//}
//
//- (void)initiateModels
//{
//    isBackgroundTaskRunning = false;
//    self.backgroundTaskArray = [NSMutableArray new];
//    [self initiateLocationIdentifier];
//    NetworkStatus currentStatus = [self.reachability currentReachabilityStatus];
//    switch (currentStatus) {
//            //        case ReachableViaWiFi:
//            //            self.currentDeviceDetailModel.networkType = @"wi-fi";
//            //            break;
//            //        case ReachableViaWWAN:
//            //            self.currentDeviceDetailModel.networkType = @"MobileData";
//            //            break;
//            //        case NotReachable:
//            //            break;
//            //        default:
//            //            self.currentDeviceDetailModel.networkType = @"MobileData";
//            //            break;
//    }
//    
//    //    self.customMetaDataModel = [[MetaDataModel alloc] init];
//    //    self.customMetaDataModel.currency = @"$";
//}
//
//- (void)initiateLocationIdentifier
//{
//    // self.currentDeviceDetailModel.isLocationAvailable = false;
//    if (currentLocationManager == nil) {
//        currentLocationManager = [[CLLocationManager alloc] init];
//        currentLocationManager.delegate = self;
//    }
//    
//    if ([CLLocationManager authorizationStatus] <= 2) {
//        [currentLocationManager requestWhenInUseAuthorization];
//    }
//    if ([CLLocationManager locationServicesEnabled]) {
//        [currentLocationManager startUpdatingLocation];
//    }
//}
//
//- (void)locationManager:(CLLocationManager *)manager
//     didUpdateLocations:(NSArray<CLLocation *> *)locations
//{
//    if (locations.count) {
//        CLLocation *currentLocation = [locations lastObject];
//        //        self.currentDeviceDetailModel.latlongData = currentLocation.coordinate;
//        //        self.currentDeviceDetailModel.isLocationAvailable = true;
//    }
//    else
//    {
//        //self.currentDeviceDetailModel.isLocationAvailable = false;
//    }
//    [manager stopUpdatingLocation];
//}
//
//- (void)startAutomaticCryptTokenGenerator
//{
//    
//}
//- (void)stopAutomaticCryptTokenGenerator
//{
//    
//}
//
//- (NSMutableDictionary *)formMetaDataDictionary
//{
//    NSMutableDictionary *metaDataDictionary = [[NSMutableDictionary alloc] init];
//    return metaDataDictionary;
//}
//- (NSMutableDictionary *)formheaderDataDictionary
//{
//    NSMutableDictionary *headerDictionary = [NSMutableDictionary dictionary];
//    
//    return headerDictionary;
//}
//
//- (NSString *)linkforCurrentRequestType:(ServiceRequestType)requestType
//{
//    NSString *serviceName;
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    NSString *currentDatestring = [formatter stringFromDate:[NSDate date]];
//    
//    switch (requestType) {
//        case ServiceRequestTypeLogin:
//            serviceName = @"authenticate/login";
//            break;
//        case ServiceRequestTypeLogout:
//            serviceName = @"LOGOUT";
//            break;
//        case ServiceRequestTypeAllNotifications:
//            serviceName = @"AllNOTIFICATIONS";
//            break;
//        case ServiceRequestTypeExamSchedule:
//            serviceName = @"VIEWEXAMSCHEDULE";
//            break;
//        case ServiceRequestTypeAllAppointments:
//            serviceName = @"APPOINTMENTSLIST";
//            break;
//        case ServiceRequestTypeTeachersList:
//            serviceName = @"TEACHERSLIST";
//            break;
//        case ServiceRequestTypeNewAppointment:
//            serviceName = @"CREATENEWAPPOINTMENT";
//            break;
//        case ServiceRequestTypeModifyAppointment:
//            serviceName = @"APPOINTMENTRESCHEDULE";
//            break;
//        case ServiceRequestTypeApproveAppointment:
//            serviceName = @"APPOINTMENTRESCHEDULE";
//            break;
//        case ServiceRequestTypeGetAppointment:
//            serviceName = @"GETAPPOINTMENT";
//            break;
//        case ServiceRequestTypeNotificationFlagChange:
//            serviceName = @"NOTIFICATIONFLAGCHANGE";
//            break;
//            
////        case ServiceRequestTypeGetCostConsultation:
////            serviceName = [NSString stringWithFormat:@"patients/%@/providers/eligible-providers-walkin?clientTime=%@&stateId=%@&specialtyId=%@",userID,currentDatestring,selectedStateId,selectedSpecialityId];
////            serviceName = [serviceName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
////            break;
////        case ServiceRequestTypeGetNotificationCount:
////            serviceName = [NSString stringWithFormat:@"users/%@/notifications/alerts-count",userID];
////            break;
////        case ServiceRequestTypeGetTopNotifications:
////            serviceName = [NSString stringWithFormat:@"users/%@/notifications/CIC?messageTypes=4&Top=2",userID];
////            break;
//
//        
//        default:
//            serviceName = @"addApprovalQuery";
//            break;
//    }
//    NSLog(@"%@%@",WEBSERVICEURL,serviceName);
//    return [NSString stringWithFormat:@"%@%@",WEBSERVICEURL,serviceName];
//}
//
//
//- (void)getHeadersAndMethodsForRequestType:(ServiceRequestType)requestType forRequest:(NSMutableURLRequest *)urlRequest
//{
//    NSString *value;
//    NSString *bearerValue;
//    NSString *pharmacyIdValue;
//    switch (requestType) {
//        case ServiceRequestTypeLogin:
//            [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//            [urlRequest setHTTPMethod:@"POST"];
//            break;
//        case ServiceRequestTypeAllAppointments:
//            [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//            [urlRequest setHTTPMethod:@"POST"];
//            break;
//        case ServiceRequestTypeAllNotifications:
//            [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//            [urlRequest setHTTPMethod:@"POST"];
//            break;
//        case ServiceRequestTypeTeachersList:
//            [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//            [urlRequest setHTTPMethod:@"POST"];
//            break;
//        case ServiceRequestTypeExamSchedule:
//            [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//            [urlRequest setHTTPMethod:@"POST"];
//            break;
//        case ServiceRequestTypeLogout:
//            [urlRequest setHTTPMethod:@"POST"];
//            break;
//        case ServiceRequestTypeNewAppointment:
//            [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//            [urlRequest setHTTPMethod:@"POST"];
//            break;
//        case ServiceRequestTypeModifyAppointment:
//            [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//            [urlRequest setHTTPMethod:@"POST"];
//            break;
//        case ServiceRequestTypeApproveAppointment:
//            [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//            [urlRequest setHTTPMethod:@"POST"];
//            break;
//        case ServiceRequestTypeGetAppointment:
//            [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//            [urlRequest setHTTPMethod:@"POST"];
//            break;
//        case ServiceRequestTypeNotificationFlagChange:
//            [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//            [urlRequest setHTTPMethod:@"POST"];
//            break;
////        case ServiceRequestTypeGetCostConsultation:
////            value = [SharedObjectModel sharedInstance].loginUserData.accessToken ;
////            bearerValue = [NSString stringWithFormat:@"Bearer %@",value];
////            [urlRequest addValue:bearerValue forHTTPHeaderField:@"Authorization"];
////            [urlRequest setHTTPMethod:@"GET"];
////            break;
////        case ServiceRequestTypeUpdateConsultationStatus:
////            value = [SharedObjectModel sharedInstance].loginUserData.accessToken ;
////            bearerValue = [NSString stringWithFormat:@"Bearer %@",value];
////            [urlRequest addValue:bearerValue forHTTPHeaderField:@"Authorization"];
////            [urlRequest setHTTPMethod:@"GET"];
////            break;
////        case ServiceRequestTypeGetPreviousProviders:
////            value = [SharedObjectModel sharedInstance].loginUserData.accessToken ;
////            bearerValue = [NSString stringWithFormat:@"Bearer %@",value];
////            [urlRequest addValue:bearerValue forHTTPHeaderField:@"Authorization"];
////            [urlRequest setHTTPMethod:@"GET"];
////            break;
////        case ServiceRequestTypeGetNotificationCount:
////            value = [SharedObjectModel sharedInstance].loginUserData.accessToken ;
////            bearerValue = [NSString stringWithFormat:@"Bearer %@",value];
////            NSLog(@"%@",bearerValue);
////            [urlRequest addValue:bearerValue forHTTPHeaderField:@"Authorization"];
////            [urlRequest setHTTPMethod:@"GET"];
////            break;
////        case ServiceRequestTypeGetTopNotifications:
////        case ServiceRequestTypeGetNotifications:
////            value = [SharedObjectModel sharedInstance].loginUserData.accessToken ;
////            bearerValue = [NSString stringWithFormat:@"Bearer %@",value];
////            [urlRequest addValue:bearerValue forHTTPHeaderField:@"Authorization"];
////            [urlRequest setHTTPMethod:@"GET"];
////            break;
////        case ServiceRequestTypeGetOnlineProviders:
////            value = [SharedObjectModel sharedInstance].loginUserData.accessToken ;
////            bearerValue = [NSString stringWithFormat:@"Bearer %@",value];
////            [urlRequest addValue:bearerValue forHTTPHeaderField:@"Authorization"];
////            [urlRequest setHTTPMethod:@"GET"];
////            break;
////        case ServiceRequestTypeGetActiveState:
////        case ServiceRequestTypeGetLanguages:
////        case ServiceRequestTypeGetGender:
////        case ServiceRequestTypeGetPharmacy:
////        case ServiceRequestTypeGetCards:
////        case ServiceRequestTypeGetSpeciality:
////        case ServiceRequestTypeGetPatientInfo:
////        case ServiceRequestTypeVerifyState:
////        case ServiceRequestTypeGetProvider:
////        case ServiceRequestTypeGetDiseases:
////        case ServiceRequestTypeGetMedications:
////        case ServiceRequestTypeGetAllergies:
////        case ServiceRequestTypeGetTreatments:
////        case ServiceRequestTypeGetMedicalConditions:
////        case ServiceRequestTypeGetVaccinations:
////        case ServiceRequestTypeGetPatientsMedications:
////        case ServiceRequestTypeGetPatientMedicalConditions:
////        case ServiceRequestTypeGetPatientsAllergies:
////        case ServiceRequestTypeGetPatientsTreatments:
////        case ServiceRequestTypeGetPatientsVaccinations:
////        case ServiceRequestTypeGetLifestyles:
////            value = [SharedObjectModel sharedInstance].loginUserData.accessToken ;
////            bearerValue = [NSString stringWithFormat:@"Bearer %@",value];
////            [urlRequest addValue:bearerValue forHTTPHeaderField:@"Authorization"];
////            [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
////            [urlRequest setHTTPMethod:@"GET"];
////            break;
////        case ServiceRequestTypeDeletePharmacy:
////        case ServiceRequestTypeDeleteMedicalCondition:
////            value = [SharedObjectModel sharedInstance].loginUserData.accessToken ;
////            bearerValue = [NSString stringWithFormat:@"Bearer %@",value];
////            [urlRequest addValue:bearerValue forHTTPHeaderField:@"Authorization"];
////            [urlRequest setHTTPMethod:@"DELETE"];
////            break;
////        case ServiceRequestTypeDeleteCards:
////            value = [SharedObjectModel sharedInstance].loginUserData.accessToken ;
////            bearerValue = [NSString stringWithFormat:@"Bearer %@",value];
////            [urlRequest addValue:bearerValue forHTTPHeaderField:@"Authorization"];
////            [urlRequest setHTTPMethod:@"DELETE"];
////            break;
////        case ServiceRequestTypeCreateConsultation:
////        case ServiceRequestTypeLogout:
////        case ServiceRequestTypeSubmitConsultation:
////        case ServiceRequestTypeAddMedicalCondition:
////        case ServiceRequestTypeConsultationStart:
////        case ServiceRequestTypeAddAllergies:
////        case ServiceRequestTypeAddTreatments:
////        case ServiceRequestTypeAddVaccinations:
////        case ServiceRequestTypeAddMedications:
////        case ServiceRequestTypeAddConditions:
////            value = [SharedObjectModel sharedInstance].loginUserData.accessToken ;
////            bearerValue = [NSString stringWithFormat:@"Bearer %@",value];
////            [urlRequest addValue:bearerValue forHTTPHeaderField:@"Authorization"];
////            [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
////            [urlRequest setHTTPMethod:@"POST"];
////            break;
////        case ServiceRequestTypeSetWaitTime:
////            value = [SharedObjectModel sharedInstance].loginUserData.accessToken ;
////            bearerValue = [NSString stringWithFormat:@"Bearer %@",value];
////            [urlRequest addValue:bearerValue forHTTPHeaderField:@"Authorization"];
////            [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
////            [urlRequest setHTTPMethod:@"PUT"];
////            break;
////        case ServiceRequestTypeStartConsultation:
////            value = [SharedObjectModel sharedInstance].loginUserData.accessToken ;
////            bearerValue = [NSString stringWithFormat:@"Bearer %@",value];
////            [urlRequest addValue:bearerValue forHTTPHeaderField:@"Authorization"];
////            [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
////            [urlRequest setHTTPMethod:@"POST"];
////            break;
////        case ServiceRequestTypeConfirmHelathInfo:
////            value = [SharedObjectModel sharedInstance].loginUserData.accessToken ;
////            bearerValue = [NSString stringWithFormat:@"Bearer %@",value];
////            [urlRequest addValue:bearerValue forHTTPHeaderField:@"Authorization"];
////            [urlRequest setHTTPMethod:@"PUT"];
////            break;
////        case ServiceRequestTypeCancelConsultation:
////            value = [SharedObjectModel sharedInstance].loginUserData.accessToken ;
////            bearerValue = [NSString stringWithFormat:@"Bearer %@",value];
////            [urlRequest addValue:bearerValue forHTTPHeaderField:@"Authorization"];
////            [urlRequest setHTTPMethod:@"PUT"];
////            break;
////        case ServiceRequestTypeEndConsultation:
////            value = [SharedObjectModel sharedInstance].loginUserData.accessToken ;
////            bearerValue = [NSString stringWithFormat:@"Bearer %@",value];
////            [urlRequest addValue:bearerValue forHTTPHeaderField:@"Authorization"];
////            [urlRequest setHTTPMethod:@"PUT"];
////            break;
//        default:
//            break;
//    }
//}
//
//- (void)invalidedateSession
//{
//    if (customUrlSession) {
//        [customUrlSession invalidateAndCancel];
//    }
//}
//
//- (void)makeStringRequestForRequestType:(ServiceRequestType)requestType requestData:(NSString *)dataString delegate:(id)sessionDelegate
//{
//    
//    if(![self isReachable]){
//        [AlertView showAlertMessageOption:@"No network connection. Please check your connection and try again."];
//        if (cryptKeyFetchingSession) {
//            [cryptKeyFetchingSession invalidateAndCancel];
//        }
//        if (customUrlSession) {
//            [customUrlSession invalidateAndCancel];
//            //[self.currentDelegate responseForRequestType: isSuccess:<#(BOOL)#> responseData:<#(id)#> errorMessage:<#(id)#>]
//        }
//    }
//    else{
//    
//    self.currentDelegate = sessionDelegate;
//    self.currentRequestType = requestType;
//    
//    customUrlSession = nil;
//    customUrlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
//    //[dataRequestDictionary setObject:[self formheaderDataDictionary] forKey:@"header"];
//    
//    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self linkforCurrentRequestType:self.currentRequestType]]];
//    [self getHeadersAndMethodsForRequestType:requestType forRequest:urlRequest];
//    
//    NSLog(@"%@",urlRequest);
//    if (requestType == ServiceRequestTypeLogin) {
//        
//        //        NSString *value = [[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"];
//        //        NSString *bearerValue = [NSString stringWithFormat:@"Bearer %@",value];
//        //        [urlRequest addValue:bearerValue forHTTPHeaderField:@"Authorization"];
//        NSData* requestData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
//        [urlRequest setHTTPBody:requestData];
//    }
//    else if (requestType == ServiceRequestTypeLogout)
//    {
//        
////        NSString *value = [SharedObjectModel sharedInstance].loginUserData.accessToken;
////        NSString *bearerValue = [NSString stringWithFormat:@"Bearer %@",value];
////        [urlRequest addValue:bearerValue forHTTPHeaderField:@"Authorization"];
//    }
//    else
//    {
//        
//        NSData* requestData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
//        [urlRequest setHTTPBody:requestData];
//        
//    }
//    
//    NSURLSessionDataTask *dataTask = [customUrlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
//        if (error == nil) {
//            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//            if(responseDictionary == nil)
//            {
//                NSString *jsonString =[[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
//                NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//                responseDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
//                
//                if (responseDictionary == nil) {
//                    if (requestType == ServiceRequestTypeLogout/* && [(NSHTTPURLResponse *)response statusCode] == 200*/) {
//                        [self.currentDelegate responseForRequestType:self.currentRequestType isSuccess:YES responseData:nil withStatusCode:[httpResponse statusCode] errorMessage:@""];
//                    }
//                    else
//                    {
//                        //[AlertView showAlertMessageOption:@"Cannot connect to server"];
//                    }
//                    return;
//                }
//            }
//            NSLog(@"%@",responseDictionary);
//            [self.currentDelegate responseForRequestType:self.currentRequestType isSuccess:YES responseData:responseDictionary withStatusCode:[httpResponse statusCode] errorMessage:@""];
//        }
//        else
//        {
//            
//            [self.currentDelegate responseForRequestType:self.currentRequestType isSuccess:NO responseData:nil withStatusCode:[httpResponse statusCode] errorMessage:@"Error"];
//            // NSLog(@"Eroor...%@",error);
//        }
//    }];
//    [dataTask resume];
//    }
//   
//        
//}
//
//- (void)makeRequestForRequestType:(ServiceRequestType)requestType requestData:(NSDictionary *)dataDictionary delegate:(id)sessionDelegate
//{
//    
//    self.currentDelegate = sessionDelegate;
//    self.currentRequestType = requestType;
//    
//    customUrlSession = nil;
//    customUrlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
//    NSMutableDictionary *dataRequestDictionary = [[NSMutableDictionary alloc] init];
//    
//    [dataRequestDictionary addEntriesFromDictionary:dataDictionary];
//    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self linkforCurrentRequestType:self.currentRequestType]]];
//    NSError *error;
//    
//    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dataRequestDictionary options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *requestJson = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
//    [urlRequest setHTTPBody:[requestJson dataUsingEncoding:NSUTF8StringEncoding]];
//    NSLog(@"Request Json..%@",requestJson);
//    [urlRequest setHTTPMethod:@"POST"];
//    
//    NSLog(@"%@",urlRequest);
//    NSURLSessionDataTask *dataTask = [customUrlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
//        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//        
//        if(responseDictionary == nil)
//        {
//            NSString *jsonString =[[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
//            NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//            responseDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
//        }
//        NSLog(@"%@",responseDictionary);
//        if ([[responseDictionary allKeys] containsObject:@"status"]) {
//            if ([[responseDictionary objectForKey:@"status"] isEqualToString:@"SUCCESS"]) {
//                [self.currentDelegate responseForRequestType:self.currentRequestType isSuccess:YES responseData:responseDictionary withStatusCode:[httpResponse statusCode] errorMessage:@""];
//                
//            }
//            else if([[responseDictionary objectForKey:@"status"] isEqualToString:@"ERROR"]){
//                
//                if (self.currentRequestType == ServiceRequestTypeLogin) {
//                    
//                    [self.currentDelegate responseForRequestType:self.currentRequestType isSuccess:NO responseData:responseDictionary withStatusCode:[httpResponse statusCode] errorMessage:@"Invalid Credentials"];
//                }
//                else
//                {
//                    [self.currentDelegate responseForRequestType:self.currentRequestType isSuccess:NO responseData:responseDictionary withStatusCode:[httpResponse statusCode] errorMessage:@""];
//                }
//                
//            }
//            else if([[responseDictionary objectForKey:@"status"] isEqualToString:@"FAILURE"]){
//                [self.currentDelegate responseForRequestType:self.currentRequestType isSuccess:NO responseData:responseDictionary withStatusCode:[httpResponse statusCode] errorMessage:@""];
//            }
//        }
//        
////        if (error == nil && [httpResponse statusCode] == 200) {
////
////        }
////        else
////        {
////            NSLog(@"Error in response");
////            [self.currentDelegate responseForRequestType:self.currentRequestType isSuccess:NO responseData:nil withStatusCode:[httpResponse statusCode] errorMessage:@"Error"];
////            // NSLog(@"Eroor...%@",error);
////        }
//    }];
//    [dataTask resume];
//}
//
//- (void)makeRequestForRequestType:(ServiceRequestType)requestType delegate:(id)sessionDelegate
//{
//    self.currentDelegate = sessionDelegate;
//    self.currentRequestType = requestType;
//    
//    customUrlSession = nil;
//    customUrlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
//    
//    
//    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self linkforCurrentRequestType:self.currentRequestType]]];
//    [self getHeadersAndMethodsForRequestType:requestType forRequest:urlRequest];
//    
//    NSLog(@"%@",urlRequest);
//    
//    NSURLSessionDataTask *dataTask = [customUrlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
//        if (error == nil) {
//            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//            if(responseDictionary == nil)
//            {
//                NSString *jsonString =[[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
//                NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//                responseDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
//            }
//            NSLog(@"%@",responseDictionary);
//            [self.currentDelegate responseForRequestType:self.currentRequestType isSuccess:YES responseData:responseDictionary withStatusCode:[httpResponse statusCode] errorMessage:@""];
//        }
//        else
//        {
//            [self.currentDelegate responseForRequestType:self.currentRequestType isSuccess:NO responseData:nil withStatusCode:[httpResponse statusCode] errorMessage:@"Error"];
//            // NSLog(@"Eroor...%@",error);
//        }
//    }];
//    [dataTask resume];
//}
//
//#pragma mark - FormData
//
//- (NSString *)httpBodyForParamsDictionary:(NSDictionary *)paramDictionary
//{
//    NSMutableArray *parameterArray = [NSMutableArray array];
//    
//    [paramDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        NSString *value;
//        if ([obj isKindOfClass:[NSDictionary class]]) {
//            // NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
//            NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
//            
//            value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        }
//        else
//        {
//            value = obj;
//        }
//        NSString *param = [NSString stringWithFormat:@"%@=%@", key, value];
//        [parameterArray addObject:param];
//    }];
//    
//    NSString *string = [parameterArray componentsJoinedByString:@"&"];
//    
//    return string;
//}
//
//- (NSData *)createBodyWithBoundary:(NSString *)boundary image:(NSData *)image fieldName:(NSString *)fieldName
//{
//    NSMutableData *httpBody = [NSMutableData data];
//    
//    // add params (all params are strings)
//    
//    boundary = @"124445";
//    NSData   *data      = [[NSData alloc] initWithData:image];
//    NSString *mimetype  = @"image/png";
//    
//    [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, fieldName] dataUsingEncoding:NSUTF8StringEncoding]];
//    [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
//    [httpBody appendData:data];
//    [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    
//    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    return httpBody;
//}
//
//- (void)makeRequestInSharedSessionForRequestType:(ServiceRequestType)requestType delegate:(id)sessionDelegate
//{
//    //self.currentDelegate = sessionDelegate;
//    //self.currentRequestType = requestType;
//    self.currentRequestModel = [self.backgroundTaskArray firstObject];
//    isBackgroundTaskRunning = true;
//    NSURLSession *customUrlSharedSession = [NSURLSession sharedSession];
//    //customUrlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
//    
//    
//    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self linkforCurrentRequestType:self.currentRequestModel.networkRequestType]]];
//    [self getHeadersAndMethodsForRequestType:requestType forRequest:urlRequest];
//    
//    NSLog(@"%@",urlRequest);
//    
//    NSURLSessionDataTask *dataTask = [customUrlSharedSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        isBackgroundTaskRunning = false;
//        
//        
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
//        if (error == nil) {
//            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//            if(responseDictionary == nil)
//            {
//                NSString *jsonString =[[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
//                NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//                responseDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
//            }
//            NSLog(@"%@",responseDictionary);
//            [self.currentRequestModel.backgroundDelegate responseForRequestType:self.currentRequestModel.networkRequestType isSuccess:YES responseData:responseDictionary withStatusCode:[httpResponse statusCode] errorMessage:@""];
//        }
//        else
//        {
//            [self.currentRequestModel.backgroundDelegate responseForRequestType:self.currentRequestModel.networkRequestType isSuccess:NO responseData:nil withStatusCode:[httpResponse statusCode] errorMessage:@"Error"];
//            // NSLog(@"Eroor...%@",error);
//        }
//        [self performSelectorOnMainThread:@selector(removeTopTask) withObject:nil waitUntilDone:NO];
//    }];
//    [dataTask resume];
//}
//
//- (void)addBackgroundTaskWithRequestType:(ServiceRequestType)requestType delegate:(id)sessionDelegate
//{
//    NetworkRequestModel *newRequest = [NetworkRequestModel new];
//    newRequest.networkRequestType = requestType;
//    newRequest.backgroundDelegate = sessionDelegate;
//    [self.backgroundTaskArray addObject:newRequest];
//    [self startNextTask];
//}
//- (void)removeTopTask
//{
//    if (self.backgroundTaskArray.count) {
//        [self.backgroundTaskArray removeObjectAtIndex:0];
//        [self startNextTask];
//    }
//}
//- (void)startNextTask
//{
//    if (self.backgroundTaskArray.count) {
//        if (!isBackgroundTaskRunning) {
//            NetworkRequestModel *topRequest = (NetworkRequestModel *)[self.backgroundTaskArray firstObject];
//            [self makeRequestInSharedSessionForRequestType:topRequest.networkRequestType delegate:topRequest.backgroundDelegate];
//        }
//    }
//}
//
//@end

