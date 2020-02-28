//
//  LOVDataModel.m
//  Travel
//
//  Created by Shyamchandar on 30/06/16.
//  Copyright © 2016 HTC. All rights reserved.
//

#import "LOVDataModel.h"

@implementation LOVDataModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:self.lovId forKey:@"lovId"];
    [aCoder encodeObject:self.lovValue forKey:@"lovValue"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.categoryId forKey:@"categoryId"];
    [aCoder encodeObject:self.costCenterId forKey:@"costCenterId"];
    [aCoder encodeObject:self.type forKey:@"type"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self.lovId = [aDecoder decodeObjectForKey:@"lovId"];
    self.lovValue = [aDecoder decodeObjectForKey:@"lovValue"];
    self.status = [aDecoder decodeObjectForKey:@"status"];
    self.categoryId = [aDecoder decodeObjectForKey:@"categoryId"];
    self.costCenterId = [aDecoder decodeObjectForKey:@"costCenterId"];
    self.type = [aDecoder decodeObjectForKey:@"type"];
    return self;
}

@end
