//
//  RMChartItemCell.m
//  Tvigle Music
//
//  Created by Elena Yakhina on 26/03/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import "RMChartItemCell.h"

@implementation RMChartItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
