//
//  GoodActivityTableViewCell.m
//  HappyWeekend
//
//  Created by 张茫原 on 16/1/8.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "GoodActivityTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface GoodActivityTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *loveCountButton;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;


@end


@implementation GoodActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.frame = CGRectMake(0, 0, kScreenWidth, 90);
}

- (void)setGoodModel:(GoodActivityModel *)goodModel {
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:goodModel.image] placeholderImage:nil];
    self.headImageView.layer.cornerRadius = 20;
    self.headImageView.clipsToBounds = YES;
    
    self.activityTitleLabel.text = goodModel.title;
    self.activityPriceLabel.text = goodModel.price;
    self.activityDistanceLabel.text = @"688.88km";
    self.ageLabel.text = goodModel.age;
    [self.loveCountButton setTitle:[NSString stringWithFormat:@"%ld",[goodModel.counts integerValue]] forState:UIControlStateNormal];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
