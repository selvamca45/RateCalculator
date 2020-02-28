//
//  DropDownModel.h
//  TTDNow
//
//  Created by Shyamchandar on 24/03/16.
//  Copyright © 2016 HTC Global Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DropDownModel : NSObject
{
    
}
//@property (nonatomic) int modelIdString;
@property (nonatomic, strong) NSString *modelCostIdString;
@property (nonatomic, strong) NSString *modelDataString;
@property (nonatomic, strong) NSString *modelCategoryString;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *type;
@property (nonatomic) BOOL isSelected;
@property (nonatomic) int modelIdString;
@property (nonatomic) NSString  *modelIdStringNew;
@property (nonatomic) NSMutableArray *sampleArray;


@end
