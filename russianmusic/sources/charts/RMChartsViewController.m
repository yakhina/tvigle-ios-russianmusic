//
//  RMChartsViewController.m
//  Tvigle Music
//
//  Created by Elena Yakhina on 26/03/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import "RMChartsViewController.h"
#import "RMChartItemCell.h"
#import "UIImageView+WebCache.h"
#import "RMVideoViewController.h"

@interface RMChartsViewController ()

@property (nonatomic, strong) NSMutableArray *videosData;
@property (nonatomic, strong) SINavigationMenuView *filterMenu;
@property (nonatomic, assign) int filterIndex;

@end

@implementation RMChartsViewController

#pragma mark - Filter

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"videos" ofType:@"plist"];
    
    self.videosData = [[[NSArray alloc] initWithContentsOfFile:filePath] mutableCopy];
    
    [self configureFilter];
    
    [self.tableView reloadData];
}

- (void)configureFilter
{
    CGRect frame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);
    
    self.filterMenu = [[SINavigationMenuView alloc] initWithFrame:frame title:@"Все жанры"];
    
    [self.filterMenu displayMenuInView:self.parentViewController.view];
    
    self.filterMenu.items = @[@"Все жанры", @"Поп", @"Хип-хоп", @"Рок", @"Шансон"];
    
    self.filterMenu.delegate = self;
    
    self.navigationItem.titleView = self.filterMenu;
    
}

- (void)didSelectItemAtIndex:(NSUInteger)index
{
    self.filterIndex = (int)index;
    
    NSString *title;
    
    if (self.filterIndex)
    {
        title = [NSString stringWithFormat:@"%@: Топ-50", self.filterMenu.items[self.filterIndex]];
    }
    else
    {
        title = @"Русская Музыка: Топ 50";
    }
    
    [self.wholePlaylistButton setTitle:title forState:UIControlStateNormal];
    
    [self shuffleData];
    
    [self.tableView reloadData];
}

- (void)shuffleData
{
    NSUInteger count = self.videosData.count;
    
    for (int i = 0; i < self.videosData.count; i++)
    {
        long nElements = count - i;
        long n = (random() % nElements) + i;
        [self.videosData exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
}

#pragma mark - TableView delegate & datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RMChartItemCell *cell;
    
    static NSString *CellIdentifier = @"ChartCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *video = self.videosData[indexPath.row];
    
    if (cell == nil)
    {
        cell = [[RMChartItemCell alloc] init];
    }
    
    cell.videoName.text = [video objectForKey:@"name"];
    cell.artistName.text = [(NSString *)[video objectForKey:@"artist"] capitalizedString];
    [cell.screenshot setImageWithURL:[NSURL URLWithString:[video objectForKey:@"image"]] placeholderImage:nil];
    cell.position.text = [NSString stringWithFormat:@"%lu", indexPath.row + 1];
    
    UIColor *zebraColor = indexPath.row % 2 ? [UIColor whiteColor] : [UIColor colorWithWhite:245.0/255.0 alpha:1.0];
    [cell setBackgroundColor:zebraColor];
    
    
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showPlaylistTitle"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        RMVideoViewController *videoVC = segue.destinationViewController;
        NSDictionary *video = self.videosData[indexPath.row];
        [videoVC.videoScreenshot setImageWithURL:[NSURL URLWithString:[video objectForKey:@"image"]]];
        videoVC.navigationItem.title = [[video objectForKey:@"artist"] capitalizedString];
        videoVC.isArtistVideo = YES;
    }
    else if ([segue.identifier isEqualToString:@"showWholeChartPlaylistTitle"])
    {
        RMVideoViewController *videoVC = segue.destinationViewController;

        NSString *title;
        
        if (self.filterIndex)
        {
            title = [NSString stringWithFormat:@"%@ Чарт", self.filterMenu.items[self.filterIndex]];
        }
        else
        {
            title = @"Сводный чарт";
        }
        
        videoVC.navigationItem.title = title;
    }
}

@end
