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
@property (nonatomic, assign) int filterIndex;
@property (nonatomic, strong) SINavigationMenuView *filterMenu;
@property (nonatomic, strong) NSMutableArray *firstLetters;
@property (nonatomic, strong) NSMutableArray *firstGenresLetters;
@property (nonatomic, strong) NSArray *rawArtistsData;
@property (nonatomic, strong) NSMutableArray *artistsData;
@property (nonatomic, strong) NSMutableArray *filteredData;
@property (nonatomic, strong) NSMutableArray *genresData;

@end

@implementation RMArtistsListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.filterIndex = -1;
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
    
    [self configureFilter];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showPlaylistTitle"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        RMVideoViewController *videoVC = segue.destinationViewController;
        NSMutableDictionary *artist = self.isSearching ? [self.filteredData objectAtIndex:indexPath.row] : [[self.artistsData[indexPath.section] objectForKey:@"artists"] objectAtIndex:indexPath.row];
        videoVC.navigationItem.title = [artist objectForKey:@"name"];
        videoVC.isArtistVideo = YES;
    }
}

#pragma mark - Filter


- (void)configureFilter
{
    CGRect frame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);
    
    self.filterMenu = [[SINavigationMenuView alloc] initWithFrame:frame title:@"Все исполнители"];
    
    [self.filterMenu displayMenuInView:self.parentViewController.view];
    
    self.filterMenu.items = @[@"Все исполнители", @"Поп", @"Хип-хоп", @"Рок", @"Шансон"];
    
    self.filterMenu.delegate = self;
    
    self.navigationItem.titleView = self.filterMenu;
}

- (void)didSelectItemAtIndex:(NSUInteger)index
{
    self.filterIndex = (int)index - 1;
    
    [self.tableView reloadData];
}

#pragma mark - UITableView DataSource & Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.isSearching)
    {
        return @[];
    }
    else if (self.filterIndex >= 0)
    {
        return self.firstGenresLetters[self.filterIndex];
    }
    else
    {
        return self.firstLetters;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isSearching)
    {
        return 1;
    }
    else if (self.filterIndex >= 0)
    {
        
        return [self.genresData[self.filterIndex] count];
    }
    else
    {
        return self.firstLetters.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.isSearching)
    {
        return @"";
    }
    else if (self.filterIndex >= 0)
    {
        return [self.genresData[self.filterIndex][section] objectForKey:@"key"];
    }
    else
    {
        return [self.artistsData[section] objectForKey: @"key"];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isSearching)
    {
        return self.filteredData.count;
    }
    else if (self.filterIndex >= 0)
    {
        return [[self.genresData[self.filterIndex][section] objectForKey:@"artists"] count];
    }
    
    return [[self.artistsData[section] objectForKey:@"artists"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RMArtistCell *cell;
    
    NSMutableDictionary *artist;
    
    static NSString *CellIdentifier = @"Cell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (self.isSearching)
    {
        artist = self.filteredData[indexPath.row];
    }
    else if (self.filterIndex >= 0)
    {
        artist = [self.genresData[self.filterIndex][indexPath.section] objectForKey:@"artists"][indexPath.row];
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
    self.genresData = [[NSMutableArray alloc] initWithCapacity:4];
    self.firstGenresLetters = [[NSMutableArray alloc] initWithCapacity:4];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"artists" ofType:@"plist"];
    self.rawArtistsData = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    
    for (int i = 0; i < 4; i++)
    {
        [self.genresData addObject:[NSMutableArray array]];
        [self.firstGenresLetters addObject:[NSMutableArray array]];
    }
    
    for (int i = 0; i < self.rawArtistsData.count; i++)
    {
        NSDictionary *artist = self.rawArtistsData[i];
        
        NSString *first = [[artist objectForKey:@"name"] substringToIndex:1];
        
        BOOL inArray = [self.firstLetters containsObject:first];
        
        
        NSMutableDictionary *newArtist = [@{
                                            @"name" : [artist objectForKey:@"name"],
                                            @"image" : [artist objectForKey:@"image"],
                                           } mutableCopy];
        
        
        NSMutableDictionary *letterData = [@{
                                             @"key" : first,
                                             @"artists" : [@[newArtist] mutableCopy],
                                             } mutableCopy];
        
        
        
        NSUInteger genreIndex = arc4random_uniform(4);
        
        BOOL inGenreArray = [self.firstGenresLetters[genreIndex] containsObject:first];
        
        if (inGenreArray)
        {
            NSUInteger index = [self.firstGenresLetters[genreIndex] indexOfObject:first];
            NSMutableDictionary *foundLetterData = [self.genresData[genreIndex] objectAtIndex:index];
            NSMutableArray *foundLetterArtists = [foundLetterData objectForKey:@"artists"];
            [foundLetterArtists addObject:newArtist];
        }
        else
        {
            [self.firstGenresLetters[genreIndex] addObject:first];
            [(NSMutableArray *)self.genresData[genreIndex] addObject:letterData];
        }
        
        if (inArray)
        {
            NSUInteger index = [self.firstLetters indexOfObject:first];
            NSMutableDictionary *foundLetterData = [self.artistsData objectAtIndex:index];
            NSMutableArray *foundLetterArtists = [foundLetterData objectForKey:@"artists"];
            [foundLetterArtists addObject:newArtist];
        }
        else
        {
            
            [self.firstLetters addObject:first];
            [self.artistsData addObject:letterData];
        }
    }
    
}


#pragma mark - Searching

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:NO animated:YES];
    
    return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.isSearching = NO;
    [searchBar resignFirstResponder];
    [self.searchDisplayController setActive:NO];
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if (text.length != 0)
    {
        self.isSearching = YES;
        [self filterContentForSearchText:text];
        [self.filterMenu reset];
    }
    else
    {
        self.isSearching = NO;
    }
    
    [self.tableView reloadData];
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


@end
