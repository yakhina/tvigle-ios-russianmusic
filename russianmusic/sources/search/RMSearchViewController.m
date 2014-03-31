//
//  RMSearchViewController.m
//  russianmusic
//
//  Created by Elena Yakhina on 11/02/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import "RMSearchViewController.h"
#import "RMVideoViewController.h"
#import "UIImageView+WebCache.h"
#import "RMVideoCell.h"

@interface RMSearchViewController ()

@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, strong) NSArray *videosData;

@end

@implementation RMSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"videos" ofType:@"plist"];
    
    self.videosData = [[NSArray alloc] initWithContentsOfFile:filePath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showPlaylistTitle"])
    {
        NSIndexPath *indexPath = [self.resultsTable indexPathForSelectedRow];
        RMVideoViewController *videoVC = segue.destinationViewController;
        NSMutableDictionary *artist = [self.searchResults objectAtIndex:indexPath.row];
        videoVC.navigationItem.title = [[artist objectForKey:@"artist"] capitalizedString];
        videoVC.isArtistVideo = YES;
    }
}

#pragma mark - TableView delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RMVideoCell *cell;
    
    static NSString *CellIdentifier = @"VideoCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *video = self.searchResults[indexPath.row];
    
    if (cell == nil)
    {
        cell = [[RMVideoCell alloc] init];
    }
    
    cell.videoName.text = [video objectForKey:@"name"];
    cell.artistName.text = [(NSString *)[video objectForKey:@"artist"] capitalizedString];
    [cell.screenshot setImageWithURL:[NSURL URLWithString:[video objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"empty_artist"]];
    
    return cell;
}


#pragma mark - Searching

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.emptyMessage setHidden:YES];
    self.searchBar.text = @"";
    self.searchResults = @[];
    [self.resultsTable reloadData];
    [searchBar resignFirstResponder];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if (!self.searchResults.count)
    {
        [searchBar resignFirstResponder];
    }
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if (text.length != 0)
    {
        [self filterContentForSearchText:text];
    }
    else
    {
        [self.emptyMessage setHidden:YES];
        self.searchResults = @[];
        [self.resultsTable reloadData];
        [searchBar resignFirstResponder];
    }
}


- (void)filterContentForSearchText:(NSString*)searchText
{
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"(self.name contains[c] %@) || (self.artist contains[c] %@)", searchText, searchText];
    
    self.searchResults = [self.videosData filteredArrayUsingPredicate:searchPredicate];
    
    if (!self.searchResults.count)
    {
        [self.emptyMessage setHidden:NO];
    }
    else
    {
        [self.emptyMessage setHidden:YES];
    }
    
    [self.resultsTable reloadData];
    
}

@end
