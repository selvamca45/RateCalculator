//
//  AlertView.h
//  Instant
//
//  Created by Harish Kishenchand on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlertView : NSObject
{
    
}
+(void) showAlertMessage:(NSString *)message;
+(void) showProgress;
+(void) hideAlert;
+(void) showAlertMessageOption:(NSString *)message;
+(void) setNilMessage;
+(void)clearMessages;
@end
