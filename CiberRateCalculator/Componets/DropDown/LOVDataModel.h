//
//  LOVDataModel.h
//  Travel
//
//  Created by Shyamchandar on 30/06/16.
//  Copyright © 2016 HTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LOVDataModel : NSObject<NSCoding>

@property (nonatomic, strong) NSNumber *lovId;
@property (nonatomic, strong) NSNumber *costCenterId;
@property (nonatomic, strong) NSNumber *categoryId;
@property (nonatomic, strong) NSString *lovValue;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *type;

@end
