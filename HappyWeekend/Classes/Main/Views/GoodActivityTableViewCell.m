//
//  GoodActivityTableViewCell.m
//  HappyWeekend
//
//  Created by 张茫原 on 16/1/8.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "GoodActivityTableViewCell.h"

@interface GoodActivityTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *loveCountButton;
@property (weak, nonatomic) IBOutlet UIImageView *ageBgImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;


@end


@implementation GoodActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.frame = CGRectMake(0, 0, kScreenWidth, 90);
}

- (void)setGoodModel:(GoodActivityModel *)goodModel {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
