//
//  RMArtistsViewController.m
//  russianmusic
//
//  Created by Elena Yakhina on 11/02/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "RMArtistsListViewController.h"
#import "RMArtistCell.h"
#import "NSString+Common.h"
#import "RMVideoViewController.h"

@interface RMArtistsListViewController ()

@property (nonatomic, assign) BOOL isSearching;
@property (nonatomic, strong) NSMutableArray *firstLetters;
@property (nonatomic, strong) NSArray *rawArtistsData;
@property (nonatomic, strong) NSMutableArray *artistsData;
@property (nonatomic, strong) NSMutableArray *filteredData;

@end

@implementation RMArtistsListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.filteredData = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    self.searchDisplayController.searchBar.delegate = self;
    
    [self prepareArtistsData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showPlaylistTitle"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        RMVideoViewController *videoVC = segue.destinationViewController;
        NSMutableDictionary *artist = self.isSearching ? [self.filteredData objectAtIndex:indexPath.row] : [[self.artistsData[indexPath.section] objectForKey:@"artists"] objectAtIndex:indexPath.row];
        videoVC.navigationItem.title = [artist objectForKey:@"name"];
    }
}

#pragma mark - UITableView DataSource & Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    self.isSearching = tableView != self.tableView;
    return self.isSearching ? @[] : self.firstLetters;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.isSearching = tableView != self.tableView;
    return self.isSearching ? 1 : self.artistsData.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    self.isSearching = tableView != self.tableView;
    return self.isSearching ? @"" : [self.artistsData[section] objectForKey: @"key"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.isSearching = tableView != self.tableView;
    return self.isSearching ? self.filteredData.count : [[self.artistsData[section] objectForKey:@"artists"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.isSearching = tableView != self.tableView;
    
    RMArtistCell *cell;
    
    NSMutableDictionary *artist;
    
    static NSString *CellIdentifier = @"Cell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (self.isSearching)
    {
        artist = self.filteredData[indexPath.row];
    }
    else
    {
        artist = [self.artistsData[indexPath.section] objectForKey:@"artists"][indexPath.row];
    }
    
    if (cell == nil)
    {
        cell = [[RMArtistCell alloc] init];
    }
    
    cell.artistPhoto.layer.cornerRadius = 25.0;
    
    cell.artistPhoto.layer.masksToBounds = YES;
    
    cell.artistName.text = [artist objectForKey:@"name"];
    
    cell.countLabel.text = [NSString stringWithFormat:@"%d видео", arc4random() % 100];
    
    [cell.artistPhoto setImageWithURL:[NSURL URLWithString:[artist objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"empty_artist"]];
    
    return cell;
}

#pragma mark - Data

- (void)prepareArtistsData
{
    self.firstLetters = [[NSMutableArray alloc] init];
    self.artistsData = [[NSMutableArray alloc] init];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"artists" ofType:@"plist"];
    self.rawArtistsData = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    for (NSDictionary *artist in self.rawArtistsData)
    {
        NSString *first = [[artist objectForKey:@"name"] substringToIndex:1];
        
        BOOL inArray = [self.firstLetters containsObject:first];
        
        NSMutableDictionary *newArtist = [@{
                                            @"name" : [artist objectForKey:@"name"],
                                            @"image" : [artist objectForKey:@"image"],
                                           } mutableCopy];
        
        if (inArray)
        {
            NSUInteger index = [self.firstLetters indexOfObject:first];
            NSMutableDictionary *foundLetterData = [self.artistsData objectAtIndex:index];
            NSMutableArray *foundLetterArtists = [foundLetterData objectForKey:@"artists"];
            [foundLetterArtists addObject:newArtist];
        }
        else
        {
            NSMutableDictionary *letterData = [@{
                                                 @"key" : first,
                                                 @"artists" : [@[newArtist] mutableCopy],
                                                 } mutableCopy];
            
            [self.firstLetters addObject:first];
            [self.artistsData addObject:letterData];
        }
    }
}


#pragma mark - Searching

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length != 0)
    {
        [self filterContentForSearchText:text];
    }
}

- (void)filterContentForSearchText:(NSString*)searchText
{
    [self.filteredData removeAllObjects];
    
    for (NSMutableDictionary *sectionData in self.artistsData)
    {
        NSMutableArray *artists = [sectionData objectForKey:@"artists"];
        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"(self.name contains[c] %@)", searchText];
        NSArray *filteredArray = [artists filteredArrayUsingPredicate:searchPredicate];
        [self.filteredData addObjectsFromArray:filteredArray];
    }
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    controller.searchResultsTableView.dataSource = self;
    controller.searchResultsTableView.delegate = self;
    [self filterContentForSearchText:searchString];
    
    return YES;
}


@end
