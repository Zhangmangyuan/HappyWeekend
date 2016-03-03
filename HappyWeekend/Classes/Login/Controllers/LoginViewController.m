//
//  LoginViewController.m
//  HappyWeekend
//
//  Created by 张茫原 on 16/1/15.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "LoginViewController.h"
#import <BmobSDK/BmobUser.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackButtonWithImage:@"back"];
    self.navigationController.navigationBar.barTintColor = MainColor;
    
}

- (void)backButtonAction:(UIButton *)button {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginAction:(id)sender {
    [BmobUser loginWithUsernameInBackground:self.userNameTF.text password:self.passWordTF.text block:^(BmobUser *user, NSError *error) {
        if (user) {
            ZMYLog(@"%@", user);
        }
    }];
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
