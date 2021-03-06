//
//  RMChartItemCell.h
//  Tvigle Music
//
//  Created by Elena Yakhina on 26/03/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMChartItemCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *position;
@property (nonatomic, strong) IBOutlet UIImageView *screenshot;
@property (nonatomic, strong) IBOutlet UILabel *artistName;
@property (nonatomic, strong) IBOutlet UILabel *videoName;

@end
