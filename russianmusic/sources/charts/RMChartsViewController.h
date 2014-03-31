//
//  RMChartsViewController.h
//  Tvigle Music
//
//  Created by Elena Yakhina on 26/03/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SINavigationMenuView.h"

@interface RMChartsViewController : UIViewController <SINavigationMenuDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIButton *wholePlaylistButton;

@end
