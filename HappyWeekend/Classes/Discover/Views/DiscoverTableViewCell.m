//
//  DiscoverTableViewCell.m
//  HappyWeekend
//
//  Created by 张茫原 on 16/1/12.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "DiscoverTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DiscoverTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation DiscoverTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(DiscoverModel *)model {
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
    self.headImageView.layer.cornerRadius = 40;
    self.headImageView.clipsToBounds = YES;
    
    self.titleLabel.text = model.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
