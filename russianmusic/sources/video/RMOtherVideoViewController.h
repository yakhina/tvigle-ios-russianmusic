//
//  RMOtherVideoViewController.h
//  Tvigle Music
//
//  Created by Elena Yakhina on 27/02/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMOtherVideoViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *videosData;

@end
