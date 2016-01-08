//
//  GoodActivityModel.m
//  HappyWeekend
//
//  Created by 张茫原 on 16/1/8.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "GoodActivityModel.h"

@implementation GoodActivityModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.title = dict[@"title"];
        self.image = dict[@"image"];
        self.age = dict[@"age"];
        self.counts = dict[@"counts"];
        self.price = dict[@"price"];
        self.activityId = dict[@"id"];
        self.address = dict[@"address"];
        self.type = dict[@"type"];
    }
    return self;
}


@end
