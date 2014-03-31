//
//  RMPlaylistsListsViewController.m
//  Tvigle Music
//
//  Created by Elena Yakhina on 12/03/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import "RMPlaylistsListsViewController.h"
#import "RMPlaylistItemCell.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "RMVideoViewController.h"
#import "RMFeaturedViewController.h"

@interface RMPlaylistsListsViewController ()
{
    int startX;
}

@end

@implementation RMPlaylistsListsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - Data

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"videos" ofType:@"plist"];
    
    NSArray *videos = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    self.videosData = [[NSMutableArray alloc] init];
    
    int count = ceil(videos.count/6);
    
    for (int i = 0; i < 6; i++)
    {
        [self.videosData addObject:[[NSMutableArray alloc] initWithCapacity:count]];
        
        for (int n = i * ceil(videos.count/6); n < (i+1) * ceil(videos.count/6); n++)
        {
            [self.videosData[i] addObject:videos[n]];
        }
        
        [self.videosData[i] insertObject:self.videosData[i][[self.videosData[i] count]-1] atIndex:0];
        [self.videosData[i] insertObject:self.videosData[i][[self.videosData[i] count]-2] atIndex:0];
        [self.videosData[i] insertObject:self.videosData[i][[self.videosData[i] count]-3] atIndex:0];
        
        [self.videosData[i] addObject:self.videosData[i][3]];
        [self.videosData[i] addObject:self.videosData[i][4]];
        [self.videosData[i] addObject:self.videosData[i][5]];
        
    }
    
    self.headers = @[@"Новинки", @"Популярное", @"Рекомендуем", @"Хиты"];
    
    [self shuffleData];
    [self reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shuffleData
{
    for (int k = 0; k < self.videosData.count; k++)
    {
        NSUInteger count = [self.videosData[k] count];
        
        for (NSUInteger i = 0; i < count; ++i)
        {
            long nElements = count - i;
            long n = (random() % nElements) + i;
            [self.videosData[k] exchangeObjectAtIndex:i withObjectAtIndex:n];
        }
    }
    
}

- (void)reloadData
{
    [self.tableView reloadData];
    [self.tableView layoutSubviews];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierPlaylist = @"playlistListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierPlaylist];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierPlaylist];
    }
    
    for (UIView *v in [cell.contentView subviews])
    {
        v.tag = indexPath.section;
        
        if ([[v class] isSubclassOfClass:[UICollectionView class]])
        {
            [(UICollectionView *)v reloadData];
            [(UICollectionView *)v setTag:indexPath.section];
            [(UICollectionView *)v setContentOffset:CGPointMake(320, 0)];
            
        }
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerWrapper = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];
    
    [headerWrapper setBackgroundColor:[UIColor clearColor]];
    
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];
    
    [headerWrapper addSubview:header];
    
    [header setBackgroundColor: [UIColor whiteColor]];
    
    NSMutableAttributedString *headerText = [[NSMutableAttributedString alloc] initWithString:[self.headers[section] uppercaseString]];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    
    paragraph.firstLineHeadIndent = 6;
    
    [headerText addAttributes:@{ NSParagraphStyleAttributeName : paragraph, NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:13], NSForegroundColorAttributeName : [UIColor blackColor] } range:NSMakeRange(0, [self.headers[section] length])];
    
    [header setAttributedText:headerText];
    
    
    UILabel *count = [[UILabel alloc] initWithFrame:CGRectMake(200, 2, 115, 19)];
    
    NSMutableParagraphStyle *countParagraph = [[NSMutableParagraphStyle alloc] init];
    
    [countParagraph setAlignment:NSTextAlignmentRight];
    
    int c = arc4random() % 100;
    
    NSString *word;
    
    int end = c % 10;
    
    switch (end)
    {
        case (1): word = @"клип"; break;
        case (2): word = @"клипа"; break;
        case (3):
        case (4): word = @"клипов"; break;
        default: word = @"клипов";
    }
    
    NSMutableAttributedString *countText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%u %@", c, word]];
    
    [countText addAttributes:@{ NSParagraphStyleAttributeName : countParagraph, NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:12], NSForegroundColorAttributeName : [UIColor blackColor] } range:NSMakeRange(0, [countText length])];
    
    [count setAttributedText:countText];
    
    [header addSubview:count];
    
    return headerWrapper;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel *footer = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    [footer setBackgroundColor: [UIColor clearColor]];
    
    return footer;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.videosData[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RMPlaylistItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlaylistItemCell" forIndexPath:indexPath];
    
    NSDictionary *video = [self.videosData[collectionView.tag] objectAtIndex:indexPath.row];
    
    if (!cell)
    {
        cell = [[RMPlaylistItemCell alloc] init];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    cell.videoName.text = [video objectForKey:@"name"];
    cell.artistName.text = [[video objectForKey:@"artist"] capitalizedString];
    [cell.screenshot setImageWithURL:[NSURL URLWithString:[video objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"empty_artist"]];
    
    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.parentViewController isKindOfClass:[RMFeaturedViewController class]])
    {
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        
        RMVideoViewController *videoVC = [sb instantiateViewControllerWithIdentifier:@"RMVideoViewController"];
        videoVC.navigationItem.title = self.headers[collectionView.tag];
        [self.navigationController pushViewController:videoVC animated:YES];
        
    }
    
    else if ([self.parentViewController isKindOfClass:[RMVideoViewController class]])
    {
        RMVideoViewController *parentPlayer = (RMVideoViewController *)self.parentViewController;
        
        NSDictionary *video = [self.videosData[collectionView.tag] objectAtIndex:indexPath.row];
        
        [parentPlayer.videoScreenshot setImageWithURL:[NSURL URLWithString:[video objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"empty_artist"]];
        
        [parentPlayer.artistName setText:[[video objectForKey:@"artist"] capitalizedString]];
        
        [parentPlayer.videoTitle setText:[video objectForKey:@"name"]];
    }
}


#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    startX = scrollView.contentOffset.x;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float width = scrollView.contentSize.width;
    float pageWidth = 320;
    float currentX = scrollView.contentOffset.x;
    
     //Endless scroll fake
     if (width > pageWidth && currentX > (width - pageWidth))
     {
         [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
     }
     else if (currentX < startX && startX < pageWidth)
     {
         [scrollView setContentOffset:CGPointMake(width - pageWidth, 0) animated:NO];
     }
}


@end
