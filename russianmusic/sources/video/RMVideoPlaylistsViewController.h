//
//  RMVideoPlaylistsViewController.h
//  Tvigle Music
//
//  Created by Elena Yakhina on 18/03/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RMVideoPlaylistsViewController;

@protocol VideoPlaylistsDelegate <NSObject>

- (void)videoPlaylistsDidScrollUp: (RMVideoPlaylistsViewController *)videoPlaylists;
- (void)videoPlaylistsDidScrollDown: (RMVideoPlaylistsViewController *)videoPlaylists;

@end

@interface RMVideoPlaylistsViewController : UITableViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *headers;
@property (nonatomic, strong) NSMutableArray *videosData;
@property (nonatomic, assign) id<VideoPlaylistsDelegate> delegate;


- (void)shuffleData;
- (void)reloadData;

@end
