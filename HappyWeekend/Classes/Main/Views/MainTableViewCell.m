//
//  MainTableViewCell.m
//  HappyWeekend
//
//  Created by 张茫原 on 16/1/4.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "MainTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MainTableViewCell ()

//活动图片
@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;
//活动名字
@property (weak, nonatomic) IBOutlet UILabel *activityNameLabel;
//活动价格
@property (weak, nonatomic) IBOutlet UILabel *activityPriceLabel;
//活动距离
@property (weak, nonatomic) IBOutlet UIButton *activityDistanceBtn;
@end

@implementation MainTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}
//在model的set方法中赋值
- (void)setMainModel:(MainModel *)mainModel {
    [self.activityImageView sd_setImageWithURL:[NSURL URLWithString:mainModel.image_big]  placeholderImage:nil];
    self.activityNameLabel.text = mainModel.title;
    self.activityPriceLabel.text = mainModel.price;
    
    if ([mainModel.type integerValue] != RecommendTypeActivity) {
        self.activityDistanceBtn.hidden = YES;
    } else {
        self.activityDistanceBtn.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
