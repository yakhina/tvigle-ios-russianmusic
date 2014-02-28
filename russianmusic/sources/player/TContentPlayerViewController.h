//
//  TContentPlayerViewController.h
//  TviglePlayer
//
//  Created by Elena Yakhina on 23/01/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPlayerToolbar.h"
#import "TContentPlayer.h"
#import "TPlaylist.h"
#import "TVideo.h"

typedef enum {
    TContentPlayerStateLoading,
    TContentPlayerStatePlay,
    TContentPlayerStatePause,
    TContentPlayerStateDisable,
} TContentPlayerState;


@interface TContentPlayerViewController : UIViewController

@property (nonatomic, retain) TVideo *currentVideo;
@property (nonatomic, retain) TPlaylist *playlist;
@property (nonatomic, assign) TContentPlayerState state;
@property (nonatomic, assign) int currentPlaybackProgress;

//Outlets
@property (nonatomic, weak) IBOutlet TPlayerToolbar *playerToolbar;

- (id)initWithPlaylist:(TPlaylist *)playlist;
- (void)setState:(TContentPlayerState)state;




@end


@protocol TContentPlayerViewControllerDelegate <NSObject>

//Content playback cycle
- (BOOL)playerShouldAutoplay:(TContentPlayerViewController *)player;
- (void)playerIsReadyToPlay:(TContentPlayerViewController *)player;
- (BOOL)playerShouldPlay:(TContentPlayerViewController *)player;

- (void)playerWillPlay:(TContentPlayerViewController *)player;
- (void)playerDidPlay:(TContentPlayerViewController *)player;

- (void)playerWillPause:(TContentPlayerViewController *)player;
- (void)playerDidPause:(TContentPlayerViewController *)player;

- (void)playerWillReachEnd:(TContentPlayerViewController *)player;
- (void)playerDidReachEnd:(TContentPlayerViewController *)player;

- (void)playerWillClose:(TContentPlayerViewController *)player;
- (void)playerDidClose:(TContentPlayerViewController *)player;

- (void)player:(TContentPlayerViewController *)player playbackProgressChangedWithSeconds:(int)secondsPassed;


//Playlist
- (void)playerWillBeginPlayNextItem:(TContentPlayerViewController *)player;
- (void)playerDidBeginPlayNextItem:(TContentPlayerViewController *)player;

- (void)playerWillBeginPlayPrevItem:(TContentPlayerViewController *)player;
- (void)playerDidBeginPlayPrevItem:(TContentPlayerViewController *)player;

- (void)playerPlaylistWillReachEnd:(TContentPlayerViewController *)player;
- (void)playerPlaylistDidReachEnd:(TContentPlayerViewController *)player;



@end