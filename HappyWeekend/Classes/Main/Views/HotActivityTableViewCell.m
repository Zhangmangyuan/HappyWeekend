//
//  HotActivityTableViewCell.m
//  HappyWeekend
//
//  Created by 张茫原 on 16/1/11.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "HotActivityTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HotActivityTableViewCell ()

@property (nonatomic, retain) UIImageView *headImageView;

@end

@implementation HotActivityTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, 170);
        [self addSubview:self.headImageView];
    }
    return self;
}


- (void)setHotModel:(HotActivityModel *)hotModel {
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:hotModel.img] placeholderImage:nil];
}

- (UIImageView *)headImageView {
    if (_headImageView == nil) {
        self.headImageView = [[UIImageView alloc] initWithFrame:self.frame];
        
    }
    return _headImageView;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
