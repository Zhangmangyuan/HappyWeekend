//
//  DiscoverModel.h
//  HappyWeekend
//
//  Created by 张茫原 on 16/1/12.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscoverModel : NSObject

@property (nonatomic, copy) NSString *activityId;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
