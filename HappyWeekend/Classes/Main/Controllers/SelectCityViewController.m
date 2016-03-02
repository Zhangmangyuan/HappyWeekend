//
//  SelectCityViewController.m
//  HappyWeekend
//
//  Created by 张茫原 on 16/1/6.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "SelectCityViewController.h"
#import "HeadrCollectionView.h"
#import "FooterCollectionView.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ProgressHUD.h"
#import "CityCollectionViewCell.h"

static NSString *itemIdentifier = @"itemIdentifier";
static NSString *headIdentifier = @"headIdentifier";
static NSString *footIdentifier = @"footIdentifier";

@interface SelectCityViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *cityListArray;
@end

@implementation SelectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"切换城市";
    [self showBackButtonWithImage:@"camera_cancel_up"];
    self.navigationController.navigationBar.barTintColor = MainColor;
    
    [self.view addSubview:self.collectionView];
    [self loadData];
}

#pragma mark -----  UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cityListArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"itemIdentifier" forIndexPath:indexPath];
    cell.textLabel.text = self.cityListArray[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        HeadrCollectionView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headIdentifier forIndexPath:indexPath];
        return headView;
    }
    FooterCollectionView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footIdentifier forIndexPath:indexPath];
    footView.backgroundColor = [UIColor greenColor];
    return footView;
}




#pragma mark -----  Custom Method

- (void)backButtonAction:(UIButton *)button {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadData {
    [ProgressHUD show:@"拼命加载中..."];
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:KSelectCity parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载成功"];
        NSDictionary *dic = responseObject;
        NSInteger code = [dic[@"code"] integerValue];
        NSString *status = dic[@"status"];
        if (code == 0 && [status isEqualToString:@"success"]) {
            NSDictionary *successDic = dic[@"success"];
            NSArray *listArray = successDic[@"list"];
            for (NSDictionary *dict in listArray) {
                [self.cityListArray addObject:dict[@"cat_name"]];
            }
            [self.collectionView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:@"请求失败"];
        NSLog(@"%@",error);
    }];
}

#pragma mark ------  Lazy Loading

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        //创建一个layout布局类
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置布局方向(默认垂直方向)
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //设置每一行的间距
        layout.minimumLineSpacing = 1;
        //设置item的间距
        layout.minimumInteritemSpacing = 0;
        //section的边距
        layout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
        //设置collectionView区头区尾的大小
        layout.headerReferenceSize = CGSizeMake(kScreenWidth, 137);
//        layout.footerReferenceSize = CGSizeMake(kScreenWidth, 50);
        //设置每个item的大小
        layout.itemSize = CGSizeMake(kScreenWidth/3 - 5, kScreenWidth/9);
        //通过一个layout布局来创建一个collectionView
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor clearColor];
        //设置代理
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        //注册item类型
        [self.collectionView registerClass:[CityCollectionViewCell class] forCellWithReuseIdentifier:itemIdentifier];
        //注册头部
        [self.collectionView registerNib:[UINib nibWithNibName:@"HeadrCollectionView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headIdentifier];
        //注册尾部
        [self.collectionView registerClass:[FooterCollectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footIdentifier];
    }
    return _collectionView;
}

-(NSMutableArray *)cityListArray {
    if (_cityListArray == nil) {
        self.cityListArray = [NSMutableArray new];
    }
    return _cityListArray;
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
