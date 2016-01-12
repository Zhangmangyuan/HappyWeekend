//
//  HotActivityViewController.m
//  HappyWeekend
//
//  Created by 张茫原 on 16/1/6.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "HotActivityViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "PullingRefreshTableView.h"
#import "HotActivityTableViewCell.h"
#import "HotActivityModel.h"
#import "ThemeViewController.h"

@interface HotActivityViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;
}

@property (nonatomic, retain) PullingRefreshTableView *tableView;
@property (nonatomic, assign) BOOL refreshing;
@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation HotActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBarkButton];
    self.title = @"热门专题";
    [self.view addSubview:self.tableView];
    [self.tableView launchRefreshing];
}

#pragma mark --------- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    HotActivityTableViewCell *hotCell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (hotCell == nil) {
        hotCell = [[HotActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    HotActivityModel *hotModel = self.listArray[indexPath.row];
    hotCell.hotModel = hotModel;
    
    return hotCell;
}


#pragma mark --------- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ThemeViewController *themeVC = [[ThemeViewController alloc] init];
    HotActivityModel *model = self.listArray[indexPath.row];
    themeVC.themeid = model.activityId;
    
    [self.navigationController pushViewController:themeVC animated:YES];
}

#pragma mark ---------  PullingRefreshTableViewDelegate

//tableView下拉刷新开始的时候调用
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView {
    _pageCount = 1;
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
}

//tableView上拉刷新开始的时候调用
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView {
    _pageCount += 1;
    self.refreshing = NO;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
}

//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTools getSystemNowDate];
}


//加载数据
- (void)loadData {
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%ld",kHotActivity,_pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            NSArray *rcDataArray = successDic[@"rcData"];
            if (self.refreshing) {
                //下拉刷新的时候需要移除数组中的元素
                if (self.listArray.count > 0) {
                    [self.listArray removeAllObjects];
                }
            }
            for (NSDictionary *dic in rcDataArray) {
                HotActivityModel *model = [[HotActivityModel alloc] initWithDictionary:dic];
                [self.listArray addObject:model];
            }
            
            //完成加载
            [self.tableView tableViewDidFinishedLoading];
            self.tableView.reachedTheEnd = NO;
            //刷新tableView，他会重新执行tableView的所有代理方法
            [self.tableView reloadData];
        } else {
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZMYLog(@"%@",error);
    }];
    
    
}

//手指开始拖动方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tableView tableViewDidScroll:scrollView];
}

//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.tableView tableViewDidEndDragging:scrollView];
}


#pragma mark ---------  Custom Method


#pragma mark ---------  LazyLoading

- (PullingRefreshTableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 180;
    }
    return _tableView;
}

- (NSMutableArray *)listArray {
    if (_listArray == nil) {
        self.listArray = [NSMutableArray new];
    }
    return _listArray;
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
