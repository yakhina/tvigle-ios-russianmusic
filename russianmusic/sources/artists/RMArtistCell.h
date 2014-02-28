//
//  RMArtistCell.h
//  Русская Музыка
//
//  Created by Elena Yakhina on 11/02/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMArtistCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *artistName;
@property (nonatomic, strong) IBOutlet UIImageView *artistPhoto;
@property (nonatomic, strong) IBOutlet UILabel *countLabel;

@end
