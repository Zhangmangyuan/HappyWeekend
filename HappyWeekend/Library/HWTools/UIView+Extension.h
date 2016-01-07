//
//  UIView+Extension.h
//  HappyWeekend
//
//  Created by 张茫原 on 16/1/7.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

/**
 *	@brief	获取左上角横坐标
 *
 *	@return	坐标值
 */
- (CGFloat)left;

/**
 *	@brief	获取左上角纵坐标
 *
 *	@return	坐标值
 */
- (CGFloat)top;

/**
 *	@brief	获取视图右下角横坐标
 *
 *	@return	坐标值
 */
- (CGFloat)right;

/**
 *	@brief	获取视图右下角纵坐标
 *
 *	@return	坐标值
 */
- (CGFloat)bottom;

/**
 *	@brief	获取视图宽度
 *
 *	@return	宽度值（像素）
 */
- (CGFloat)width;

/**
 *	@brief	获取视图高度
 *
 *	@return	高度值（像素）
 */
- (CGFloat)height;

/**
 *	@brief	删除所有子对象
 */
- (void)removeAllSubviews;


@end
