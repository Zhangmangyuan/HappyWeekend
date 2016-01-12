//
//  HotActivityModel.h
//  HappyWeekend
//
//  Created by 张茫原 on 16/1/11.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotActivityModel : NSObject

@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *activityId;

- (instancetype)initWithDictionary:(NSDictionary *)dict;


@end
