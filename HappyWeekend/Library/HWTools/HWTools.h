//
//  HWTools.h
//  HappyWeekend
//
//  Created by 张茫原 on 16/1/7.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWTools : NSObject

#pragma mrak ------  时间转换相关的方法
+ (NSString *)getDateFromString:(NSString *)timestamp;

#pragma mrak ------  根据文字最大显示宽高和文字内容返回文字高度
+ (CGFloat)getTextHeightWithText:(NSString *)text bigestSize:(CGSize)bigSize textFont:(CGFloat)font;

@end
