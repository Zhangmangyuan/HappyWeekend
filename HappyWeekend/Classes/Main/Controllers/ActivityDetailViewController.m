//
//  ActivityDetailViewController.m
//  HappyWeekend
//  活动详情
//  Created by 张茫原 on 16/1/6.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "AFHTTPSessionManager.h"
#import "ActivityDetailView.h"
@interface ActivityDetailViewController ()
{
    NSString *_phoneNumber;
}

@property (strong, nonatomic) IBOutlet ActivityDetailView *activityDetailView;

@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动详情";
    [self showBackButtonWithImage:@"back"];
//    //隐藏tabbar
//    self.tabBarController.tabBar.hidden = YES;
    //去地图页面
    [self.activityDetailView.mapButton addTarget:self action:@selector(mapButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    //打电话
    [self.activityDetailView.makeCallButton addTarget:self action:@selector(makeCallButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self getModel];
}

#pragma mark -------  Custom Method

- (void)getModel {
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:[NSString stringWithFormat:@"%@&id=%@",kActivityDetail,self.activityId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            self.activityDetailView.dataDic = successDic;
            _phoneNumber = successDic[@"tel"];
        } else {
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZMYLog(@"%@",error);
    }];
}

//去地图页
- (void)mapButtonAction:(UIButton *)button {
    
}

//打电话
- (void)makeCallButtonAction:(UIButton *)button {
    //程序外打电话，打完电话之后不返回当前应用程序
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_phoneNumber]]];
    //程序内打电话，打完电话之后还返回当前应用程序
    UIWebView *cellPhoneWebView = [[UIWebView alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_phoneNumber]]];
    [cellPhoneWebView loadRequest:request];
    [self.view addSubview:cellPhoneWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
