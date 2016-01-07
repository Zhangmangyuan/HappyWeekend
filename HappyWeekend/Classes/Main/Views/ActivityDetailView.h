//
//  ActivityDetailView.h
//  HappyWeekend
//
//  Created by 张茫原 on 16/1/7.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityDetailView : UIView

@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UIButton *makeCallButton;
@property (nonatomic, strong) NSDictionary *dataDic;

@end
