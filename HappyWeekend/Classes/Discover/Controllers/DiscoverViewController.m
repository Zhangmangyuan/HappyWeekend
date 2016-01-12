//
//  DiscoverViewController.m
//  HappyWeekend
//
//  Created by 张茫原 on 16/1/4.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoverTableViewCell.h"
#import "PullingRefreshTableView.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ProgressHUD.h"
#import "DiscoverModel.h"
#import "ActivityDetailViewController.h"

@interface DiscoverViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>

@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *likeArray;
@property (nonatomic, assign) BOOL refreshing;

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscoverTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView launchRefreshing];
}

#pragma mark ------------  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.likeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.model = self.likeArray[indexPath.row];
    
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"大家都喜欢";
}
#pragma mark ------------  UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActivityDetailViewController *activityVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ActivityDetailVC"];
    //活动id
    DiscoverModel *model = self.likeArray[indexPath.row];
    activityVC.activityId = model.activityId;
    activityVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:activityVC animated:YES];
}

#pragma mrak ------------ PullingRefreshTableViewDelegate

//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView {
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
}

- (NSDate *)pullingTableViewRefreshingFinishedDate {
    return [HWTools getSystemNowDate];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.tableView tableViewDidEndDragging:scrollView];
}

- (void)loadData {
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"拼命加载中..."];
    [sessionManager GET:kDiscover parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"大爷，数据已为您加载完毕."];
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            NSArray *likeArr = successDic[@"like"];
            //下拉刷新删除原来数据
            if (self.refreshing) {
                if (self.likeArray.count > 0) {
                    [self.likeArray removeAllObjects];
                }
            }
            for (NSDictionary *dict in likeArr) {
                DiscoverModel *model = [[DiscoverModel alloc] initWithDictionary:dict];
                [self.likeArray addObject:model];
            }
        } else {
            
        }
        //完成加载
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
        //刷新tableView，他会重新执行tableView的所有代理方法
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:[NSString stringWithFormat:@"%@", error]];
        [ProgressHUD dismiss];
    }];
}

#pragma mark ------------  Lazy Loading

- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 44) pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        //只有上边的下拉刷新
        [self.tableView setHeaderOnly:YES];
        self.tableView.rowHeight = 60;
    }
    return _tableView;
}

- (NSMutableArray *)likeArray {
    if (_likeArray == nil) {
        self.likeArray = [NSMutableArray new];
    }
    return _likeArray;
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
