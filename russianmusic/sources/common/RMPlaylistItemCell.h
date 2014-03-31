//
//  RMPlaylistItemCell.h
//  Tvigle Music
//
//  Created by Elena Yakhina on 12/03/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"

@interface RMPlaylistItemCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *screenshot;
@property (nonatomic, strong) IBOutlet UILabel *artistName;
@property (nonatomic, strong) IBOutlet UILabel *videoName;
@property (nonatomic, strong) IBOutlet UIButton *disableButton;
@property (nonatomic, strong) IBOutlet UIButton *enableButton;
@property (nonatomic, strong) IBOutlet FXBlurView *disabledView;
@property (nonatomic, assign) BOOL isDisabled;

- (IBAction)toggleVideo:(id)sender;

@end
