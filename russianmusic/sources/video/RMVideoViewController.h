//
//  RMVideoViewController.h
//  Tvigle Music
//
//  Created by Elena Yakhina on 20/02/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"
#import "RMVideoPlaylistsViewController.h"

@interface RMVideoViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate, VideoPlaylistsDelegate>

@property (nonatomic, assign) BOOL playlistOpened;
@property (nonatomic, assign) BOOL fullscreen;
@property (nonatomic, assign) BOOL isArtistVideo;

@property (nonatomic, strong) IBOutlet UICollectionView *playlistCollection;

@property (nonatomic, strong) IBOutlet UIView *playerWrapper;
@property (nonatomic, strong) IBOutlet UIView *toolbar;

@property (nonatomic, strong) IBOutlet UILabel *artistName;
@property (nonatomic, strong) IBOutlet UILabel *videoTitle;
@property (nonatomic, strong) IBOutlet UIImageView *videoScreenshot;
@property (nonatomic, strong) IBOutlet UIProgressView *progressView;
@property (nonatomic, strong) IBOutlet UIButton *togglePlaylistButton;
@property (nonatomic, strong) IBOutlet UIView *playerView;
@property (nonatomic, strong) IBOutlet UIView *otherVideos;
@property (nonatomic, strong) IBOutlet UIButton *fullscreenBtn;

@property (nonatomic, strong) IBOutlet FXBlurView *currentPlaylist;
@property (nonatomic, strong) RMVideoPlaylistsViewController *playlistLists;

- (IBAction)toggleFullscreen:(id)sender;
- (IBAction)togglePlaylist:(id)sender;
- (IBAction)shareButtonTapped:(id)sender;
- (IBAction)blacklistButtonTapped:(id)sender;
- (IBAction)favoriteButtonTapped:(id)sender;

@end
