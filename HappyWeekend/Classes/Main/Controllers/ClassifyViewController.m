//
//  ClassifyViewController.m
//  HappyWeekend
//  分类列表
//  Created by 张茫原 on 16/1/6.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "ClassifyViewController.h"
#import "PullingRefreshTableView.h"
#import "GoodActivityTableViewCell.h"
#import "GoodActivityModel.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "VOSegmentedControl.h"
#import "ProgressHUD.h"
#import "ActivityDetailViewController.h"

@interface ClassifyViewController ()<PullingRefreshTableViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _pageCount;
}
@property (nonatomic, strong) PullingRefreshTableView *tableView;
//用来负责展示数据的数组
@property (nonatomic, strong) NSMutableArray *showDataArray;
@property (nonatomic, strong) NSMutableArray *showArray;
@property (nonatomic, strong) NSMutableArray *touristArray;
@property (nonatomic, strong) NSMutableArray *studyArray;
@property (nonatomic, strong) NSMutableArray *familyArray;
@property (nonatomic, assign) BOOL refreshing;
@property (nonatomic, strong) VOSegmentedControl *segementControl;

@end

@implementation ClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分类列表";
    [self showBackButtonWithImage:@"back"];
    [self.view addSubview:self.segementControl];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    _pageCount = 1;
    [self chooseRequest];
}

//在页面将要消失的时候去掉所有的progress
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
}

#pragma mark ------------  UITabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodActivityTableViewCell *goodCell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    GoodActivityModel *model = self.showDataArray[indexPath.row];
    goodCell.goodModel = model;
    
    return goodCell;
}

#pragma mark ------------  UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActivityDetailViewController *activityVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ActivityDetailVC"];
    //活动id
    GoodActivityModel *model = self.showDataArray[indexPath.row];
    activityVC.activityId = model.activityId;
    activityVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:activityVC animated:YES];
}


#pragma mark ------------  PullingRefreshTableViewDelegate
//tableView下拉刷新开始的时候调用
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView {
    _pageCount = 1;
    self.refreshing = YES;
    [self performSelector:@selector(chooseRequest) withObject:nil afterDelay:1.0];
}

//tableView上拉刷新开始的时候调用
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView {
    _pageCount += 1;
    self.refreshing = NO;
    [self performSelector:@selector(chooseRequest) withObject:nil afterDelay:1.0];
}

//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTools getSystemNowDate];
}

//手指开始拖动方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tableView tableViewDidScroll:scrollView];
}

//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.tableView tableViewDidEndDragging:scrollView];
}

#pragma mark ------------  VOSegmentedControl
- (void)segmentCtrlValuechange: (VOSegmentedControl *)segmentCtrl{
    self.classifyListType = segmentCtrl.selectedSegmentIndex + 1;
    [self chooseRequest];
}

#pragma mark ------------  Custom Method

- (void)getShowRequest {
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //typeid = 6 演出剧目
    [ProgressHUD show:@"拼命加载中..."];
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@",kClassifyList,_pageCount,@(6)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"大爷，数据已为您加载完毕."];
    
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            NSArray *acDataArray = successDic[@"acData"];
            //下拉刷新删除原来数据
            if (self.refreshing) {
                if (self.showArray.count > 0) {
                    [self.showArray removeAllObjects];
                }
            }
            for (NSDictionary *dict in acDataArray) {
                GoodActivityModel *model = [[GoodActivityModel alloc] initWithDictionary:dict];
                [self.showArray addObject:model];
            }
        } else {
            
        }
        //根据上一页选择的按钮，确定显示第几页数据
        [self showPreviousSelectButton];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:[NSString stringWithFormat:@"%@", error]];
    }];
}

- (void)getTouristRequest {
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //typeid = 23  景点场馆
    [ProgressHUD show:@"拼命加载中..."];
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@",kClassifyList,_pageCount,@(23)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"大爷，数据已为您加载完毕."];
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            NSArray *acDataArray = successDic[@"acData"];
            //下拉刷新删除原来数据
            if (self.refreshing) {
                if (self.touristArray.count > 0) {
                    [self.touristArray removeAllObjects];
                }
            }
            for (NSDictionary *dict in acDataArray) {
                GoodActivityModel *model = [[GoodActivityModel alloc] initWithDictionary:dict];
                [self.touristArray addObject:model];
            }
        } else {
            
        }
        //根据上一页选择的按钮，确定显示第几页数据
        [self showPreviousSelectButton];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:[NSString stringWithFormat:@"%@", error]];
    }];
}

- (void)getStudyRequest {
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //typeid = 22  学习益智
    [ProgressHUD show:@"拼命加载中..."];

    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@",kClassifyList,_pageCount,@(22)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"大爷，数据已为您加载完毕."];

        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            NSArray *acDataArray = successDic[@"acData"];
            //下拉刷新删除原来数据
            if (self.refreshing) {
                if (self.studyArray.count > 0) {
                    [self.studyArray removeAllObjects];
                }
            }
            for (NSDictionary *dict in acDataArray) {
                GoodActivityModel *model = [[GoodActivityModel alloc] initWithDictionary:dict];
                [self.studyArray addObject:model];
            }
        } else {
            
        }
        //根据上一页选择的按钮，确定显示第几页数据
        [self showPreviousSelectButton];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:[NSString stringWithFormat:@"%@", error]];
    }];

}

- (void)getFamilyRequest {
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //typeid = 21  亲子旅游
    [ProgressHUD show:@"拼命加载中..."];
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@",kClassifyList,_pageCount,@(21)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"大爷，数据已为您加载完毕."];

        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            NSArray *acDataArray = successDic[@"acData"];
            //下拉刷新删除原来数据
            if (self.refreshing) {
                if (self.familyArray.count > 0) {
                    [self.familyArray removeAllObjects];
                }
            }
            for (NSDictionary *dict in acDataArray) {
                GoodActivityModel *model = [[GoodActivityModel alloc] initWithDictionary:dict];
                [self.familyArray addObject:model];
            }
        } else {
            
        }
        //根据上一页选择的按钮，确定显示第几页数据
        [self showPreviousSelectButton];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:[NSString stringWithFormat:@"%@", error]];
    }];

}


- (void)showPreviousSelectButton {
    if (self.refreshing) { //下拉删除原来的数据
        if (self.showDataArray.count > 0) {
            [self.showDataArray removeAllObjects];
        }
    }
    switch (self.classifyListType) {
        case ClassifyListTypeShowRepertoire:
        {
            self.showDataArray = self.showArray;
        }
            break;
        case ClassifyListTypeTouristPlace:
        {
            self.showDataArray = self.touristArray;
        }
            break;
        case ClassifyListTypeStudyPUZ:
        {
            self.showDataArray = self.studyArray;
        }
            break;
        case ClassifyListTypeFamilyTravel:
        {
            self.showDataArray = self.familyArray;
        }
            break;
        default:
            break;
    }
    //完成加载
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;
    //刷新tableView，他会重新执行tableView的所有代理方法
    [self.tableView reloadData];
}

- (void)chooseRequest {
    switch (self.classifyListType) {
        case ClassifyListTypeShowRepertoire:
            [self getShowRequest];
            break;
        case ClassifyListTypeTouristPlace:
            [self getTouristRequest];
            break;
        case ClassifyListTypeStudyPUZ:
            [self getStudyRequest];
            break;
        case ClassifyListTypeFamilyTravel:
            [self getFamilyRequest];
            break;
        default:
            break;
    }
}

#pragma mark ------------  Lazy Loading

- (PullingRefreshTableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight - 64 - 40) pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 90;
    }
    return _tableView;
}

- (NSMutableArray *)showDataArray {
    if (_showDataArray == nil) {
        self.showDataArray = [NSMutableArray new];
    }
    return _showDataArray;
}

- (NSMutableArray *)showArray {
    if (_showArray == nil) {
        self.showArray = [NSMutableArray new];
    }
    return _showArray;
}

- (NSMutableArray *)touristArray {
    if (_touristArray == nil) {
        self.touristArray = [NSMutableArray new];
    }
    return _touristArray;
}

- (NSMutableArray *)studyArray {
    if (_studyArray == nil) {
        self.studyArray = [NSMutableArray new];
    }
    return _studyArray;
}

- (NSMutableArray *)familyArray {
    if (_familyArray == nil) {
        self.familyArray = [NSMutableArray new];
    }
    return _familyArray;
}

- (VOSegmentedControl *)segementControl {
    if (_segementControl == nil) {
        self.segementControl = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText : @"演出剧目"},@{VOSegmentText : @"景点场馆"},@{VOSegmentText : @"学习益智"},@{VOSegmentText : @"亲子旅游"},]];
        self.segementControl.contentStyle = VOContentStyleTextAlone;
        self.segementControl.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.segementControl.backgroundColor = [UIColor whiteColor];
        self.segementControl.selectedBackgroundColor = [UIColor whiteColor];
        self.segementControl.allowNoSelection = NO;
        self.segementControl.frame = CGRectMake(0, 0, kScreenWidth, 40);
        self.segementControl.indicatorThickness = 4;
        self.segementControl.selectedSegmentIndex = self.classifyListType - 1;
        //返回点击的是哪个按钮
        [self.segementControl setIndexChangeBlock:^(NSInteger index) {
        }];

        [self.segementControl addTarget:self action:@selector(segmentCtrlValuechange:) forControlEvents:UIControlEventValueChanged];
    }
    return _segementControl;
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
