//
//  ShareViewController.m
//  HappyWeekend
//
//  Created by 张茫原 on 16/1/14.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "ShareViewController.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"
@interface ShareViewController ()<WBHttpRequestDelegate>
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackButtonWithImage:@"back"];
    [self showRightButtonWithTitle:@"发送"];
    self.navigationController.navigationBar.barTintColor = MainColor;
}

- (void)backButtonAction:(UIButton *)button {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightButtonAction:(UIButton *)button {
//    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
//    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
//    authRequest.redirectURI = kRedirectURL;
//    authRequest.scope = @"all";
//    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare]];
//     authInfo:authRequest access_token:myDelegate.wbtoken
    [WeiboSDK sendRequest:request];
}

- (WBMessageObject *)messageToShare {
    WBMessageObject *message = [WBMessageObject message];
    message.text = self.inputTextView.text;
    WBImageObject *imageObj = [WBImageObject object];
    imageObj.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"mine_share"]);
    message.imageObject = imageObj;
    return message;
}

#pragma mark -
#pragma WBHttpRequestDelegate

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = NSLocalizedString(@"收到网络回调", nil);
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",result]
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"确定", nil)
                             otherButtonTitles:nil];
    [alert show];
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error;
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = NSLocalizedString(@"请求异常", nil);
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",error]
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"确定", nil)
                             otherButtonTitles:nil];
    [alert show];
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
