////
////  NetwrokManager.h
////  Travel
////
////  Created by Shyamchandar on 20/06/16.
////  Copyright © 2016 HTC. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//#import <CoreLocation/CoreLocation.h>
//
//#define WEBSERVICEURL @"http://10.1.29.124:8069/crm/api/"
//
//typedef NS_ENUM(NSUInteger, ServiceRequestType) {
//    ServiceRequestTypeLogin,
//    ServiceRequestTypeLogout,
//    ServiceRequestTypeAllNotifications,
//    ServiceRequestTypeExamSchedule,
//    ServiceRequestTypeAllAppointments,
//    ServiceRequestTypeTeachersList,
//    ServiceRequestTypeNewAppointment,
//    ServiceRequestTypeModifyAppointment,
//    ServiceRequestTypeApproveAppointment,
//    ServiceRequestTypeGetAppointment,
//    ServiceRequestTypeNotificationFlagChange
//    
//};
//
//#define LOGINSERVICEKEY = @"login"
//
//
//
//@protocol NetworkManagerDelegate <NSObject>
//
//@optional
//- (void)responseForRequestType:(ServiceRequestType)requestType isSuccess:(BOOL)isSuccess responseData:(id)Data withStatusCode:(NSInteger)statusCode errorMessage:(id)message;
//-(void)sessionExpired:(id)Data errorMessage:(id)message;
//@end
//
//@interface RequestModel : NSObject
//
//@property (nonatomic) ServiceRequestType requestType;
//@property (nonatomic, strong)NSDictionary *dataDictionary;
//@property (nonatomic, weak)id<NetworkManagerDelegate> delegate;
//
//@end
//
//@interface NetworkRequestModel:NSObject
//{
//    
//}
//@property (nonatomic)ServiceRequestType networkRequestType;
//@property (nonatomic, weak)id<NetworkManagerDelegate> backgroundDelegate;
//@end
//
//@interface NetwrokManager : NSObject<NSURLSessionDataDelegate,CLLocationManagerDelegate>
//{
//    NSURLSession *cryptKeyFetchingSession;
//    NSURLSession *customUrlSession;
//    CLLocationManager *currentLocationManager;
//    BOOL isBackgroundTaskRunning;
//}
//
//@property (nonatomic) NSTimeInterval cryptTokenExpiryInterval;
//@property (nonatomic, strong) NSDate *crypTokenExpiryDate;
//@property (nonatomic) BOOL isCryptRequesting;
//@property (nonatomic, weak)id<NetworkManagerDelegate> currentDelegate;
//@property (nonatomic, strong) NSMutableArray *waitingRequestsArray;
//@property (nonatomic) ServiceRequestType currentRequestType;
//@property (nonatomic, strong)NSString *serverUTCTime;
//@property (nonatomic, strong)NSMutableArray *backgroundTaskArray;
//@property (nonatomic, strong)NetworkRequestModel *currentRequestModel;
//
//+ (NetwrokManager *)sharedInstance;
//- (void)startAutomaticCryptTokenGenerator;
//- (void)stopAutomaticCryptTokenGenerator;
//- (void)makeRequestForRequestType:(ServiceRequestType)requestType requestData:(NSDictionary *)dataDictionary delegate:(id)sessionDelegate;
//- (void)makeStringRequestForRequestType:(ServiceRequestType)requestType requestData:(NSString *)dataString delegate:(id)sessionDelegate;
//- (void)reachabilityChanged:(NSNotification *)notification;
//- (BOOL)isReachable;
//- (void)initiateLocationIdentifier;
//- (void)initiateModels;
//- (NSData *)createBodyWithBoundary:(NSString *)boundary image:(NSData *)image fieldName:(NSString *)fieldName;
//- (NSMutableDictionary *)formMetaDataDictionary;
//- (NSMutableDictionary *)formheaderDataDictionary;
//- (NSString *)linkforCurrentRequestType:(ServiceRequestType)requestType;
//- (void)getHeadersAndMethodsForRequestType:(ServiceRequestType)requestType forRequest:(NSMutableURLRequest *)urlRequest;
//- (void)makeRequestInSharedSessionForRequestType:(ServiceRequestType)requestType delegate:(id)sessionDelegate;
//- (void)invalidedateSession;
//- (void)makeRequestForRequestType:(ServiceRequestType)requestType delegate:(id)sessionDelegate;
//- (void)addBackgroundTaskWithRequestType:(ServiceRequestType)requestType delegate:(id)sessionDelegate;
//- (void)removeTopTask;
//- (void)startNextTask;
//@end

