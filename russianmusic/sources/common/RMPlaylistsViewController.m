//
//  RMPlaylistsViewController.m
//  Tvigle Music
//
//  Created by Elena Yakhina on 19/02/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import "RMPlaylistsViewController.h"
#import "RMPlaylistCell.h"
#import "UIImageView+WebCache.h"
#import "FXBlurView.h"
#import "RMVideoViewController.h"

@interface RMPlaylistsViewController ()

@end

@implementation RMPlaylistsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showPlaylistTitle"]) {
        NSIndexPath *indexPath = [[self.tableView indexPathsForSelectedRows] lastObject];
        RMVideoViewController *videoVC = segue.destinationViewController;
        videoVC.navigationItem.title = [[self.playlistData objectAtIndex:indexPath.row] objectForKey:@"name"];
        videoVC.navigationItem.backBarButtonItem.title = @"Назад";
    }
}

#pragma mark - Data

- (NSArray *)playlistData
{
    if (_playlistData)
    {
        return _playlistData;
    }
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"playlists" ofType:@"plist"];
    _playlistData = [[[NSArray alloc] initWithContentsOfFile:filePath] mutableCopy];
    
    [self.tableView reloadData];
    
    return _playlistData;
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RMPlaylistCell *cell;
    
    NSDictionary *playlist;
    
    static NSString *CellIdentifier = @"PlaylistCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    playlist = self.playlistData[indexPath.row];
    
    if (cell == nil)
    {
        cell = [[RMPlaylistCell alloc] init];
    }
    
    cell.playlistTitle.text = [playlist objectForKey:@"name"];
    
    cell.videosCount.text = [NSString stringWithFormat:@"%@ клипов", [playlist objectForKey:@"count"]];
    
    [cell.playlistPoster setImageWithURL:[NSURL URLWithString:[playlist objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"blend"]];
    
    [cell.blurringBackground setBlurEnabled:YES];
    
    return cell;
}

@end
