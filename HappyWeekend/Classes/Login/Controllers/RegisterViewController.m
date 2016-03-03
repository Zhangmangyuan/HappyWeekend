//
//  RegisterViewController.m
//  HappyWeekend
//
//  Created by 张茫原 on 16/3/2.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "RegisterViewController.h"
#import <BmobSDK/BmobUser.h>
#import "ProgressHUD.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmTF;
@property (weak, nonatomic) IBOutlet UISwitch *passWordSwitch;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackButtonWithImage:@"back"];
    self.title = @"注册";
    
    //密码密文显示
    self.passWordTF.secureTextEntry = YES;
    self.confirmTF.secureTextEntry = YES;
    //默认switch关闭,密码不显示
    self.passWordSwitch.on = NO;
}

#pragma mark ----  UITextFieldDelegate

//点击右下角回收键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//点击页面空白处回收键盘
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //第一种方式空白处回收键盘
    [self.view endEditing:YES];
    /*第二种方式空白处回收键盘
    [self.userNameTF resignFirstResponder];
    [self.passWordTF resignFirstResponder];
    [self.confirmTF resignFirstResponder];
     */
}

- (IBAction)pressSwitchAction:(id)sender {
    UISwitch *passWordSwitch = sender;
    if (passWordSwitch.on) {
        self.passWordTF.secureTextEntry = NO;
        self.confirmTF.secureTextEntry = NO;
    } else {
        self.passWordTF.secureTextEntry = YES;
        self.confirmTF.secureTextEntry = YES;
    }
}

//注册
- (IBAction)registerAction:(id)sender {
    if (![self checkout]) {
        return;
    }
    [ProgressHUD show:@"正在为您注册..."];
    BmobUser *bUser = [[BmobUser alloc] init];
    [bUser setUsername:self.userNameTF.text];
    [bUser setPassword:self.passWordTF.text];
    [bUser signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [ProgressHUD showSuccess:@"注册成功"];
            ZMYLog(@"注册成功");
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"恭喜你" message:@"注册成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                ZMYLog(@"确定");
            }];
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                ZMYLog(@"取消");
            }];
            [alert addAction:action];
            [alert addAction:cancleAction];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            [ProgressHUD showError:@"注册失败"];
            ZMYLog(@"注册失败");
        }
    }];
}

//注册之前需要判断
- (BOOL)checkout {
    //用户名不能为空且不能为空格
    if (self.userNameTF.text.length <= 0 || [self.userNameTF.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
        //alert提示框
        
        return NO;
    }
    
    //两次输入密码一直
    if (![self.passWordTF.text isEqualToString:self.confirmTF.text]) {
        //alert提示框
        
        return NO;
    }
    
    //输入的密码不能为空
    if (self.passWordTF.text.length <= 0 || [self.passWordTF.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
        //alert输入密码不能为空
        return NO;
    }
    
    //正则表达式
    
    //判断输入是否是有效的手机号
    
    //判断输入邮箱是否正确
    
    
    return YES;
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
