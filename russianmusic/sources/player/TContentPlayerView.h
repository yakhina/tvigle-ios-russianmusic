//
//  TContentPlayerView.h
//  TviglePlayer
//
//  Created by Elena Yakhina on 03/02/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPlayerView.h"
#import "FXBlurView.h"

typedef enum {
    TPlayerViewStateLoading,
    TPlayerViewStateReadyToPlay,
    TPlayerViewStatePlaying,
    TPlayerViewStatePause,
    TPlayerViewStateError,
    TPlayerViewStateUnload,
} TPlayerViewState;

@class TPlayerView;

@protocol TPlayerViewDelegate <NSObject>

@optional

- (void)playerViewDoneAction:(TPlayerView*)playerView;

/*
 * Playback controls
 */
- (void)playerViewPlayAction:(TPlayerView*)playerView;
- (void)playerViewPauseAction:(TPlayerView*)playerView;
- (void)playerViewPrevAction:(TPlayerView*)playerView;
- (void)playerViewNextAction:(TPlayerView*)playerView;

/*
 * Min/max view controls
 */
- (void)playerViewMaximizeAction:(TPlayerView*)playerView;
- (void)playerViewMinimizeAction:(TPlayerView*)playerView;

/*
 * Scrubber control
 */
- (void)playerViewDidStartScrubbing:(TPlayerView*)playerView;
- (void)playerViewDidEndScrubbing:(TPlayerView*)playerView;
- (void)playerView:(TPlayerView*)playerView isScrubbingWithSlider: (UISlider *) slider;

@end


@interface TContentPlayerView : TPlayerView <UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet FXBlurView *blurringView;

@property (nonatomic, assign) id<TPlayerViewDelegate> delegate;
@property (nonatomic, assign) TPlayerViewState state;

@property (nonatomic, assign) float progressValue;
@property (nonatomic, assign) float progressPercent;
@property (nonatomic, assign) NSTimeInterval passedTimeInterval;
@property (nonatomic, assign) NSTimeInterval leftTimeInterval;

@end
