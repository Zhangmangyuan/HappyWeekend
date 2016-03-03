//
//  CityCollectionViewCell.m
//  HappyWeekend
//
//  Created by 张茫原 on 16/3/1.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "CityCollectionViewCell.h"

@implementation CityCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        ZMYLog(@"$234");
        [self configView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)configView {

    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/3 - 5, kScreenWidth/9)];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.textLabel];
}


@end
