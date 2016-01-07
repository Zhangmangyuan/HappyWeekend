//
//  MainViewController.m
//  
//
//  Created by 张茫原 on 16/1/4.
//
//

#import "MainViewController.h"
#import "MainTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "MainModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SelectCityViewController.h"
#import "SearchViewController.h"
#import "ActivityDetailViewController.h"
#import "ThemeViewController.h"
#import "ClassifyViewController.h"
#import "GoodActivityViewController.h"
#import "HotActivityViewController.h"

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//全部列表数组
@property (nonatomic, strong) NSMutableArray *listArray;
//推荐活动数组
@property (nonatomic, strong) NSMutableArray *activityArray;
//推荐专题数组
@property (nonatomic, strong) NSMutableArray *themeArray;
//广告
@property (nonatomic, strong) NSMutableArray *adArray;
//轮播图
@property (nonatomic, strong) UIScrollView *carouselView;
//小圆点
@property (nonatomic, strong) UIPageControl *pageControl;
//定时器用于图片滚动播放
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIButton *activityBtn;

@property (nonatomic, strong) UIButton *themeBtn;


@end


@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //left
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"北京" style:UIBarButtonItemStylePlain target:self action:@selector(selectCityAction:)];
    leftBarBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    //right
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 14, 14);
    [rightBtn setImage:[UIImage imageNamed:@"btn_search"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(searchActivityAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self configTableViewHeaderView];
    //请求网络数据
    [self requestModel];
    //启动定时器
    [self startTimer];
}

#pragma mark ------- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.activityArray.count;
    }
    return self.themeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell *mainCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSMutableArray *array = self.listArray[indexPath.section];
    mainCell.mainModel = array[indexPath.row];
    
    return mainCell;
}


#pragma mark ------- UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 203;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 26;
}

//自定义分区头部
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    
    UIImageView *sectionView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2 - 160, 5, 320, 16)];
    if (section == 0) {
        sectionView.image = [UIImage imageNamed:@"home_recommed_ac"];
    } else {
        sectionView.image = [UIImage imageNamed:@"home_recommd_rc"];
    }
    [view addSubview:sectionView];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ActivityDetailViewController *activityVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ActivityDetailVC"];
        //活动id
        MainModel *mainModel = self.listArray[indexPath.section][indexPath.row];
        activityVC.activityId = mainModel.activityId;
        [self.navigationController pushViewController:activityVC animated:YES];
    } else {
        ThemeViewController *themeVC = [[ThemeViewController alloc] init];
        [self.navigationController pushViewController:themeVC animated:YES];
    }
}

#pragma mark -------- Custom Method

//选择城市
- (void)selectCityAction:(UIBarButtonItem *)barButton {
    SelectCityViewController *selectCityVC = [[SelectCityViewController alloc] init];
    [self.navigationController presentViewController:selectCityVC animated:YES completion:nil];
}

//搜索关键字
- (void)searchActivityAction:(UIButton *)btn {
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

//自定义tableView头部
- (void)configTableViewHeaderView {
    UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 343)];
    [tableViewHeaderView addSubview:self.carouselView];
    self.pageControl.numberOfPages = self.adArray.count;
    [tableViewHeaderView addSubview:self.pageControl];

    for (int i = 0; i < self.adArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, 186)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.adArray[i][@"url"]] placeholderImage:nil];
        imageView.userInteractionEnabled = YES;
        [self.carouselView addSubview:imageView];
        
        UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        touchBtn.frame = imageView.frame;
        touchBtn.tag = 100 + i;
        [touchBtn addTarget:self action:@selector(touchAdvertisement:) forControlEvents:UIControlEventTouchUpInside];
        [self.carouselView addSubview:touchBtn];
    }
 
    //按钮
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * kScreenWidth / 4, 186, kScreenWidth / 4, kScreenWidth / 4);
        NSString *imageStr = [NSString stringWithFormat:@"home_icon_%02d",i + 1];
        [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(mainActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [tableViewHeaderView addSubview:btn];
    }
    
    //精选活动&热门专题
    [tableViewHeaderView addSubview:self.activityBtn];
    [tableViewHeaderView addSubview:self.themeBtn];
    
    self.tableView.tableHeaderView = tableViewHeaderView;
}

- (void)requestModel {
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:kMainDataList parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resultDic = responseObject;
        NSString *status = resultDic[@"status"];
        NSInteger code = [resultDic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dic = resultDic[@"success"];
            //推荐活动
            NSArray *acDataArray = dic[@"acData"];
            for (NSDictionary *dict in acDataArray) {
                MainModel *model = [[MainModel alloc] initWithDictionary:dict];
                [self.activityArray addObject:model];
            }
            [self.listArray addObject:self.activityArray];
            //推荐专题
            NSArray *rcDataArray = dic[@"rcData"];
            for (NSDictionary *dict in rcDataArray) {
                MainModel *model = [[MainModel alloc] initWithDictionary:dict];
                [self.themeArray addObject:model];
            }
            [self.listArray addObject:self.themeArray];
            //刷新tableView数据
            [self.tableView reloadData];
            //广告
            NSArray *adDataArray = dic[@"adData"];
            for (NSDictionary *dic in adDataArray) {
                NSDictionary *dict = @{@"url" : dic[@"url"], @"type" : dic[@"type"], @"id" : dic[@"id"]};
                [self.adArray addObject:dict];
            }
            //拿到数据之后重新刷新headview
            [self configTableViewHeaderView];
            
            
            //以请求回来的城市作为导航栏按钮标题
            NSString *cityName = dic[@"cityname"];
            self.navigationItem.leftBarButtonItem.title = cityName;
        } else {
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZMYLog(@"%@",error);
    }];
}

//分类列表
- (void)mainActivityButtonAction:(UIButton *)activityButton {
    ClassifyViewController *classifyVC = [[ClassifyViewController alloc] init];
    [self.navigationController pushViewController:classifyVC animated:YES];
}

//精选活动
- (void)goodActivityButton {
    GoodActivityViewController *goodVC = [[GoodActivityViewController alloc] init];
    [self.navigationController pushViewController:goodVC animated:YES];
}

//热门专题
- (void)hotActivityButton {
    HotActivityViewController *hotVC = [[HotActivityViewController alloc] init];
    [self.navigationController pushViewController:hotVC animated:YES];
}

//点击广告
- (void)touchAdvertisement:(UIButton *)adButton {
    //从数组中的字典里取出type类型
    NSString *type = self.adArray[adButton.tag - 100][@"type"];
    if ([type integerValue] == 1) {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ActivityDetailViewController *activityVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ActivityDetailVC"];
        //活动id
        activityVC.activityId = self.adArray[adButton.tag - 100][@"id"];
        [self.navigationController pushViewController:activityVC animated:YES];
    } else {
        HotActivityViewController *hotVC = [[HotActivityViewController alloc] init];
        [self.navigationController pushViewController:hotVC animated:YES];
    }
}

#pragma mark -------  轮播图
- (void)startTimer {
    //防止定时器重复创建
    if (self.timer != nil) {
        return;
    }
    self.timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(rollAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

//每2秒执行一次，图片自动轮播
- (void)rollAnimation {
    //把page当前页加1
    NSInteger rollPage = (self.pageControl.currentPage + 1) % self.adArray.count;
    self.pageControl.currentPage = rollPage;
    //计算出scrollView应该滚动的x轴坐标
    CGFloat offsetX = self.pageControl.currentPage * kScreenWidth;
    [self.carouselView setContentOffset:CGPointMake(offsetX, 0)animated:YES];
}

//当手动去滑动scrollView的时候，定时器依然在计算时间，可能我们刚刚滑动到下一页，定时器时间有刚好触发，导致在当前页停留的时间不够2秒。
//解决方案在scrollView开始移动的时候结束定时器
//在scrollView移动完毕的时候在启动定时器

/*
 scrollView将要开始拖拽
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //停止定时器
    [self.timer invalidate];
    self.timer = nil; // 停止定时器后并置为nil，再次启动定时器才能保证正常执行。
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

#pragma mark --------- LazyLoading
//懒加载
- (NSMutableArray *)listArray {
    if (_listArray == nil) {
        self.listArray = [NSMutableArray new];
    }
    return _listArray;
}

- (NSMutableArray *)activityArray {
    if (_activityArray == nil) {
        self.activityArray = [NSMutableArray new];
    }
    return _activityArray;
}

- (NSMutableArray *)themeArray {
    if (_themeArray == nil) {
        self.themeArray = [NSMutableArray new];
    }
    return _themeArray;
}

- (NSMutableArray *)adArray {
    if (_adArray == nil) {
        self.adArray = [NSMutableArray new];
    }
    return _adArray;
}

- (UIScrollView *)carouselView {
    if (_carouselView == nil) {
        //添加轮播图
        self.carouselView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 186)];
        self.carouselView.contentSize = CGSizeMake(self.adArray.count* kScreenWidth, 186);
        //整屏滑动
        self.carouselView.pagingEnabled = YES;
        //不显示水平方向滚动条
        self.carouselView.showsHorizontalScrollIndicator = NO;
        self.carouselView.delegate = self;
    }
    return _carouselView;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        //创建小圆点
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 156, kScreenWidth, 30)];
        self.pageControl.currentPageIndicatorTintColor = [UIColor cyanColor];
        [self.pageControl addTarget:self action:@selector(pageSelectAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

- (UIButton *)activityBtn {
    if (_activityBtn == nil) {
        self.activityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.activityBtn.frame = CGRectMake(0, 186 + kScreenWidth / 4, kScreenWidth / 2, 343 - 186 - kScreenWidth / 4);
        [self.activityBtn setImage:[UIImage imageNamed:@"home_huodong"] forState:UIControlStateNormal];
        [self.activityBtn addTarget:self action:@selector(goodActivityButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _activityBtn;
}

- (UIButton *)themeBtn {
    if (_themeBtn == nil) {
        self.themeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.themeBtn.frame = CGRectMake(kScreenWidth / 2, 186 + kScreenWidth / 4, kScreenWidth / 2, 343 - 186 - kScreenWidth / 4);
        [self.themeBtn setImage:[UIImage imageNamed:@"home_zhuanti"] forState:UIControlStateNormal];
        [self.themeBtn addTarget:self action:@selector(hotActivityButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _themeBtn;
}

#pragma mark -------  首页轮播图

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //第一步：获取scrollView页面的宽度
    CGFloat pageWidth = self.carouselView.frame.size.width;
    //第二步：获取scrollView停止时候的偏移量
    //contentOffset是当前scrollView距离原点偏移的位置
    CGPoint offset = self.carouselView.contentOffset;
    //第三步：通过偏移量和页面宽度计算出当前页数
    NSInteger pageNumber = offset.x / pageWidth;
    self.pageControl.currentPage = pageNumber;
}

- (void)pageSelectAction:(UIPageControl *)pageControl {
    //第一步：获取pageControl点击的页面在第几页
    NSInteger pageNumber = pageControl.currentPage;
    //第二步：获取页面的宽度
    CGFloat pageWidth = self.carouselView.frame.size.width;
    //让scrollView滚动到第几页
    self.carouselView.contentOffset = CGPointMake(pageNumber * pageWidth, 0);
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
























