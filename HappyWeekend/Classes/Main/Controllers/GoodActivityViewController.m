//
//  GoodActivityViewController.m
//  HappyWeekend
//  精选活动
//  Created by 张茫原 on 16/1/6.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "GoodActivityViewController.h"
#import "PullingRefreshTableView.h"
#import "GoodActivityTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "GoodActivityModel.h"
#import "ActivityDetailViewController.h"

@interface GoodActivityViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;   //定义请求的页码
}
@property (nonatomic, assign) BOOL refreshing;
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation GoodActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"精选活动";
    [self showBarkButton];
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView launchRefreshing];
}

#pragma mark -----  UITableViewDataSource 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodActivityTableViewCell *goodCell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    GoodActivityModel *model = self.dataArray[indexPath.row];
    goodCell.goodModel = model;
    
    return goodCell;
}

#pragma mark ------ UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodActivityModel *model = self.dataArray[indexPath.row];
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActivityDetailViewController *activityVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ActivityDetailVC"];
    activityVC.activityId = model.activityId;
    [self.navigationController pushViewController:activityVC animated:YES];
}

#pragma mark ------- PullingRefreshDelegate
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
    AFHTTPSessionManager *sessionManager =[AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%ld",kGoodActivity,_pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            NSArray *acDataArray = successDic[@"acData"];
            if (self.refreshing) {
                //下拉刷新的时候需要移除数组中的元素
                if (self.dataArray.count > 0) {
                    [self.dataArray removeAllObjects];
                }
            }
            for (NSDictionary *dic in acDataArray) {
                GoodActivityModel *model = [[GoodActivityModel alloc] initWithDictionary:dic];
                [self.dataArray addObject:model];
            }
        } else {
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZMYLog(@"%@",error);
    }];
    
    //完成加载
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;
    //刷新tableView，他会重新执行tableView的所有代理方法
    [self.tableView reloadData];
}

//手指开始拖动方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tableView tableViewDidScroll:scrollView];
}

//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.tableView tableViewDidEndDragging:scrollView];
}

#pragma mark ------- LazyLoading

- (PullingRefreshTableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 90;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
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
