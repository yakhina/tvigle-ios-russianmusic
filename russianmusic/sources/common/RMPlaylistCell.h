//
//  RMPlaylistCell.h
//  Tvigle Music
//
//  Created by Elena Yakhina on 19/02/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"

@interface RMPlaylistCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *playlistPoster;
@property (nonatomic, strong) IBOutlet FXBlurView *blurringBackground;
@property (nonatomic, strong) IBOutlet UILabel *playlistTitle;
@property (nonatomic, strong) IBOutlet UILabel *videosCount;

@end
