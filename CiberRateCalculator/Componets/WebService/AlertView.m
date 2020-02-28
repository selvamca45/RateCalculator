//
//  AlertView.m
//  Instant
//
//  Created by Harish Kishenchand on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView
#define APP_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]
#define ACTIVITY_TAG 100
UIAlertView *alertview;
NSMutableString *alertMessage;

+(void)showAlertMessage:(NSString *)message
{
    if (!alertMessage) {
        alertMessage = [[NSMutableString alloc] initWithString:message];
    }
    else
    {
        if ([alertMessage isEqualToString:message]) {
            return;
        }
        [alertMessage setString:message];
    }
    
//    APP_NAME
    
    UIAlertView *aAlertview = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    @try {
        [aAlertview show];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

+(void) setNilMessage
{
    if (alertMessage) {
        [alertMessage setString:@""];
    }
}

+(void)showAlertMessageOption:(NSString *)message
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

+(void)showProgress
{
    if(alertview)
    {
        [alertview dismissWithClickedButtonIndex:0 animated:YES];
    }
	alertview = [[UIAlertView alloc] initWithTitle:@"Loading..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	UIActivityIndicatorView *indicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[indicator setFrame:CGRectMake(120.0, 50.0, 30.0, 30.0)];
	indicator.tag=ACTIVITY_TAG;
	[alertview addSubview:indicator];
	[indicator startAnimating];
	[alertview show];
    //[indicator release];
}

+ (void) hideAlert
{
	if(alertview != nil && [alertview isKindOfClass:[UIAlertView class]] ){
		if([alertview viewWithTag:ACTIVITY_TAG])
        {
			UIActivityIndicatorView *indicator=(UIActivityIndicatorView *)[alertview viewWithTag:500];
			[indicator stopAnimating];
		}
		[alertview dismissWithClickedButtonIndex:0 animated:YES];
		//alertview=nil;
	}
}
+(void)clearMessages
{
    alertMessage = nil;
}

@end
