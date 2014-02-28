//
//  TPlayerView.h
//  TviglePlayer
//
//  Created by Elena Yakhina on 03/02/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface TPlayerView : UIView

@property (nonatomic, retain) AVPlayer *player;

- (void)setPlayer:(AVPlayer *)player;
- (void)setVideoFillMode:(NSString *)fillMode;

@end
