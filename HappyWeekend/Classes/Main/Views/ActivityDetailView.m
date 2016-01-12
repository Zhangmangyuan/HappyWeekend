//
//  ActivityDetailView.m
//  HappyWeekend
//
//  Created by 张茫原 on 16/1/7.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "ActivityDetailView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ActivityDetailView ()
{
    //保存上一次图片底部的高度
    CGFloat _previousImageBottom;
    //最后一个label底部高度
    CGFloat _lastLabelBottom;
}

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *favouriteLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityPriceLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UILabel *activityAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityPhoneNumLabel;

@end

@implementation ActivityDetailView

- (void)awakeFromNib {
    self.mainScrollView.contentSize = CGSizeMake(kScreenWidth, 10000);
    
}


//在set方法中赋值
- (void)setDataDic:(NSDictionary *)dataDic {
//活动图片
    NSArray *urls = dataDic[@"urls"];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:urls[0]] placeholderImage:nil];
//活动标题
    self.activityTitleLabel.text = [NSString stringWithFormat:@"  %@",dataDic[@"title"]];
//活动起止时间
    NSString *startTime = [HWTools getDateFromString:dataDic[@"new_start_date"]];
    NSString *endTime = [HWTools getDateFromString:dataDic[@"new_end_date"]];
    self.activityTimeLabel.text = [NSString stringWithFormat:@"  正在进行：%@-%@",startTime,endTime];
//已经有多少人喜欢
    self.favouriteLabel.text = [NSString stringWithFormat:@"%@人已喜欢",dataDic[@"fav"]];
//活动价格
    self.activityPriceLabel.text = dataDic[@"pricedesc"];
//活动地址
    self.activityAddressLabel.text = dataDic[@"address"];
//活动联系电话
    self.activityPhoneNumLabel.text = dataDic[@"tel"];
//活动详情
    [self drawContentWithArray:dataDic[@"content"]];
    //当拿到数据后重新设置scrollView的高度
    self.mainScrollView.contentSize = CGSizeMake(kScreenWidth, _lastLabelBottom);
}

- (void)drawContentWithArray:(NSArray *)contentArray {
    for (NSDictionary *dic in contentArray) {
        //每一段活动信息
        CGFloat height = [HWTools getTextHeightWithText:dic[@"description"] bigestSize:CGSizeMake(kScreenWidth, 1000) textFont:15.0];
        CGFloat y;
        if (_previousImageBottom > 500) { //如果图片底部的高度没有值（也就是小于500）,也就说明是加载第一个lable，那么y的值不应该减去500
            y = 500 + _previousImageBottom - 500;
        } else {
            y = 500 + _previousImageBottom;
        }
        NSString *title = dic[@"title"];
        if (title != nil) {
            //如果标题存在,标题的高度应该是上次图片的底部高度
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, y, kScreenWidth - 20, 30)];
            titleLabel.text = title;
            [self.mainScrollView addSubview:titleLabel];
            //下边详细信息label显示的时候，高度的坐标应该再加30，也就是标题的高度。
            y += 30;
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, y, kScreenWidth - 20, height)];
        label.text = dic[@"description"];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:15.0];
        [self.mainScrollView addSubview:label];
        
        NSArray *urlsArray = dic[@"urls"];
        if (urlsArray == nil) { //当某一个段落中没有图片的时候，上次图片的高度用上次label的底部高度+10
            _previousImageBottom = label.bottom + 10;
        } else {
            CGFloat lastImgbottom = 0.0;
            for (NSDictionary *urlDic in urlsArray) {
                CGFloat imgY;
                if (urlsArray.count > 1) {
                    //图片不止一张的情况
                    if (lastImgbottom == 0.0) {
                        if (title != nil) { //有title的算上title的30像素
                            imgY = _previousImageBottom + label.height + 30 + 5;
                        } else {
                            imgY = _previousImageBottom + label.height + 5;
                        }
                    } else {
                        imgY = lastImgbottom + 10;
                    }

                } else {
                    //单张图片的情况
                    imgY = label.bottom;
                }
                CGFloat width = [urlDic[@"width"] integerValue];
                CGFloat imageHeight = [urlDic[@"height"] integerValue];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, imgY, kScreenWidth - 20, (kScreenWidth - 20)/width * imageHeight)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:urlDic[@"url"]] placeholderImage:nil];
                [self.mainScrollView addSubview:imageView];
                //每次都保留最新的图片底部高度
                _previousImageBottom = imageView.bottom + 5;
                if (urlsArray.count > 1) {
                    lastImgbottom = imageView.bottom;
                }
            }
        }
        //保留最后一个label的高度,就是scrollView的高度
        _lastLabelBottom = label.bottom > _previousImageBottom ? label.bottom + 70 : _previousImageBottom + 70;
    }
}

@end







