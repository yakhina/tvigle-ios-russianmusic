//
//  RMFeaturedViewController.h
//  Tvigle Music
//
//  Created by Elena Yakhina on 06/03/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMPlaylistsListsViewController.h"
#import "SINavigationMenuView.h"

@interface RMFeaturedViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, SINavigationMenuDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) RMPlaylistsListsViewController *playlistLists;

- (IBAction)pageControlDidChangedPage;

@end
