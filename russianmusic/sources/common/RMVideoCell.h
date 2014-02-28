//
//  RMVideoCell.h
//  Tvigle Music
//
//  Created by Elena Yakhina on 25/02/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMVideoCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *screenshot;
@property (nonatomic, strong) IBOutlet UILabel *artistName;
@property (nonatomic, strong) IBOutlet UILabel *videoName;

@end
