//
//  DataModel.h
//  TTDNow
//
//  Created by Vishnu Priya on 06/04/16.
//  Copyright © 2016 HTC Global Services. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "NetwrokManager.h"
#import "LOVDataModel.h"

//#import "TMBaseSynchronization.h"
@protocol dataModelDelegate <NSObject>
@optional
-(void)loadDataForArray:(id)array;
@end

@interface DataModel : NSObject
{
    
}
@property(nonatomic,retain)id<dataModelDelegate>delegate;
+(id)shareManager;
-(NSMutableArray*)getDefaultFieldForScreenName:(NSString*)screenName;
-(void)setPatientDetails:(id)patientData;
-(id)getPatientData;
-(NSDictionary*)getImageArray;
-(NSArray*)getLovListforPlaceHolder:(NSString*)stringType;
-(NSString*)getLovWebserviceName:(NSString*)screenName;
-(void)getLovDataforPlaceHolder:(NSString*)stringType withDelegate:(id)delegate;
@end
