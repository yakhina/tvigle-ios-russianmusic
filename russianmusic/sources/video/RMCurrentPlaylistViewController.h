//
//  RMCurrentPlaylistViewController.h
//  Tvigle Music
//
//  Created by Elena Yakhina on 20/03/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMCurrentPlaylistViewController : UITableViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *videosData;


@end
