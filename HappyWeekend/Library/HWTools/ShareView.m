//
//  ShareView.m
//  HappyWeekend
//
//  Created by 张茫原 on 16/1/14.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "ShareView.h"
#import "WeiboSDK.h"

@interface ShareView ()

@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UIView *shareView;

@end

@implementation ShareView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configShareView];
    }
    return self;
}

- (void)configShareView {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    //黑色背景
    self.blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.blackView.backgroundColor = [UIColor blackColor];
    self.blackView.alpha = 0.0;
    [window addSubview:self.blackView];
    
    //灰色底部
    self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 200)];
    self.shareView.backgroundColor = RGB(232, 233, 232);
    [window addSubview:self.shareView];
    
    //取消按钮
    UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    removeBtn.frame = CGRectMake(30, 140, kScreenWidth - 60, 40);
    [removeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [removeBtn setBackgroundColor:[UIColor redColor]];
    [removeBtn addTarget:self action:@selector(removeAllShare) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:removeBtn];
    
    //weibo
    //图片
    UIImageView *weiboImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 30, 50, 50)];
    weiboImageView.image = [UIImage imageNamed:@"share_weibo"];
    [self.shareView addSubview:weiboImageView];
    //label
    UILabel *weiboLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 90, 68, 21)];
    weiboLabel.text = @"新浪微博";
    weiboLabel.textAlignment = NSTextAlignmentCenter;
    weiboLabel.textColor = [UIColor darkGrayColor];
    [self.shareView addSubview:weiboLabel];
    //按钮
    UIButton *weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weiboBtn.frame = CGRectMake(32, 26, 85, 85);
    [weiboBtn addTarget:self action:@selector(shareWeibo) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:weiboBtn];
    
    //friend
    //图片
    UIImageView *friendImageView = [[UIImageView alloc] initWithFrame:CGRectMake(165, 30, 50, 50)];
    friendImageView.image = [UIImage imageNamed:@"share_friend"];
    [self.shareView addSubview:friendImageView];
    //label
    UILabel *friendLabel = [[UILabel alloc] initWithFrame:CGRectMake(154, 90, 68, 21)];
    friendLabel.text = @"微信好友";
    friendLabel.textAlignment = NSTextAlignmentCenter;
    friendLabel.textColor = [UIColor darkGrayColor];
    [self.shareView addSubview:friendLabel];
    //按钮
    UIButton *friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    friendBtn.frame = CGRectMake(148, 26, 85, 85);
    [friendBtn addTarget:self action:@selector(shareWeiXinFriend) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:friendBtn];
    
    //Circle
    //图片
    UIImageView *circleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(280, 30, 50, 50)];
    circleImageView.image = [UIImage imageNamed:@"share_pengyouquan"];
    [self.shareView addSubview:circleImageView];
    //label
    UILabel *circleLabel = [[UILabel alloc] initWithFrame:CGRectMake(262, 90, 85, 21)];
    circleLabel.text = @"微信朋友圈";
    circleLabel.textAlignment = NSTextAlignmentCenter;
    circleLabel.textColor = [UIColor darkGrayColor];
    [self.shareView addSubview:circleLabel];
    //按钮
    UIButton *circleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    circleBtn.frame = CGRectMake(263, 26, 85, 85);
    [circleBtn addTarget:self action:@selector(shareWeiXinCircle) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:circleBtn];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.blackView.alpha = 0.8;
        self.shareView.frame = CGRectMake(0, kScreenHeight - 200, kScreenWidth, 200);
    }];
}

- (void)removeAllShare {
    //    objc_setAssociatedObject(pickAction, nil, complete, OBJC_ASSOCIATION_RETAIN);
    
    [UIView animateWithDuration:0.4 animations:^{
        self.blackView.alpha = 0.0;
        self.shareView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 200);
    } completion:^(BOOL finished) {
        [self.blackView removeFromSuperview];
        [self.shareView removeFromSuperview];
    }];
}

- (void)removeAllChildrenViews {
    [self.blackView removeFromSuperview];
    [self.shareView removeFromSuperview];
}

- (void)shareWeibo {
    //微博sso授权
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURL;
    request.scope = @"all";
    request.userInfo = @{@"userName" : @"Mango-iOS"};
    [WeiboSDK sendRequest:request];
}

- (void)shareWeiXinFriend {
    ZMYLog(@"微信好友");
}

- (void)shareWeiXinCircle {
    ZMYLog(@"微信朋友圈");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
