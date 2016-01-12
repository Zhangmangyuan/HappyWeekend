//
//  HotActivityModel.m
//  HappyWeekend
//
//  Created by 张茫原 on 16/1/11.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "HotActivityModel.h"

@implementation HotActivityModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.img = dict[@"img"];
        self.activityId = dict[@"id"];
    }
    return self;
}

@end
