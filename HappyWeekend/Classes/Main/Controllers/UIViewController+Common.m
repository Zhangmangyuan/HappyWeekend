//
//  UIViewController+Common.m
//  HappyWeekend
//
//  Created by 张茫原 on 16/1/6.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "UIViewController+Common.h"

@implementation UIViewController (Common)

//导航栏添加返回按钮
- (void)showBarkButton {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
}

- (void)backButtonAction:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showRightButtonWithTitle:(NSString *)title {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 44, 44);
    [rightBtn setTitle:title forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
}

@end
