//
//  RMSearchViewController.h
//  russianmusic
//
//  Created by Elena Yakhina on 11/02/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMSearchViewController : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UITableView *resultsTable;
@property (nonatomic, strong) IBOutlet UILabel *emptyMessage;

@end
