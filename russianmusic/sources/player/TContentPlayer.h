//
//  TContentPlayer.h
//  TviglePlayer
//
//  Created by Elena Yakhina on 23/01/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "TVideo.h"

@interface TContentPlayer : AVPlayer

@property (nonatomic, assign) float currentVolume;
@property (nonatomic, strong) TVideo *video;
@property (nonatomic, weak) AVPlayerLayer *playerLayer;
@property (nonatomic, assign) CMTime startTime;

- (id)initWithVideo:(TVideo *)video;

@end


@protocol TPlayerDelegate <NSObject>

@optional

/*
 * Playback delegate methods
 */
- (void)player:(TContentPlayer *)player didEncounteredError: (NSError *) error;
- (BOOL)playerShouldStartPlaying: (TContentPlayer *)player;
- (void)playerIsReadyToPlay: (TContentPlayer *)player;
- (void)player:(TContentPlayer *)player presentURL:(NSURL *)url;
- (void)playerContentIsReadyForPlayback:(TContentPlayer *)player;
- (void)player:(TContentPlayer *)player changeLayerTo:(AVPlayerLayer*)toLayer;


@end