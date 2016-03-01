//
//  LoginViewController.m
//  HappyWeekend
//
//  Created by 张茫原 on 16/1/15.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "LoginViewController.h"
#import <BmobSDK/Bmob.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBarkButton];
    self.navigationController.navigationBar.barTintColor = MainColor;
}

- (void)backButtonAction:(UIButton *)button {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)addOneData:(id)sender {
    //往User表添加一条数据
    BmobObject *user = [BmobObject objectWithClassName:@"MemberUser"];
    [user setObject:@"王雪娟" forKey:@"user_Name"];
    [user setObject:@18 forKey:@"user_Age"];
    [user setObject:@"女" forKey:@"user_Gender"];
    [user setObject:@"18612349876" forKey:@"user_cellPhone"];
    [user saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        //进行操作
        ZMYLog(@"恭喜注册成功！");
    }];
    
}
- (IBAction)queryData:(id)sender {
    
    //查找MemberUser表
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"MemberUser"];
    //查找GameScore表里面id为0c6db13c的数据
    [bquery getObjectInBackgroundWithId:@"17970a33c9" block:^(BmobObject *object,NSError *error){
        if (error){
            //进行错误处理
        }else{
            //表里有id为17970a33c9的数据
            if (object) {
                NSString *userName = [object objectForKey:@"user_Name"];
                NSString *cellPhone = [object objectForKey:@"user_cellPhone"];
                NSLog(@"%@%@", userName, cellPhone);
            }
        }
    }];
}
- (IBAction)modeifyData:(id)sender {
    //查找MemberUser表
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"MemberUser"];
    //查找MemberUser表里面id为0c6db13c的数据
    [bquery getObjectInBackgroundWithId:@"17970a33c9" block:^(BmobObject *object,NSError *error){
        //没有返回错误
        if (!error) {
            //对象存在
            if (object) {
                BmobObject *obj1 = [BmobObject objectWithoutDatatWithClassName:object.className objectId:object.objectId];
                //设置cheatMode为YES
                [obj1 setObject:@"王大白" forKey:@"user_Name"];
                //异步更新数据
                [obj1 updateInBackground];
            }
        }else{
            //进行错误处理
        }
    }];
}
- (IBAction)deleteData:(id)sender {
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"MemberUser"];
    [bquery getObjectInBackgroundWithId:@"4fd295d2fe	" block:^(BmobObject *object, NSError *error){
        if (error) {
            //进行错误处理
        }
        else{
            if (object) {
                //异步删除object
                [object deleteInBackground];
            }
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
