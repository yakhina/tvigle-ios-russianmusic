//
//  RMPlaylistsListsViewController.h
//  Tvigle Music
//
//  Created by Elena Yakhina on 12/03/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMPlaylistsListsViewController : UITableViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *headers;
@property (nonatomic, strong) NSMutableArray *videosData;

- (void)shuffleData;
- (void)reloadData;

@end
