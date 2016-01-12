//
//  DiscoverModel.m
//  HappyWeekend
//
//  Created by 张茫原 on 16/1/12.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "DiscoverModel.h"

@implementation DiscoverModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.activityId = dict[@"id"];
        self.image = dict[@"image"];
        self.title = dict[@"title"];
        self.type = dict[@"type"];
    }
    return self;
}

@end
