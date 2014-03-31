//
//  RMCurrentPlaylistViewController.m
//  Tvigle Music
//
//  Created by Elena Yakhina on 20/03/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import "RMCurrentPlaylistViewController.h"
#import "RMPlaylistItemCell.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "RMVideoViewController.h"
#import "RMFeaturedViewController.h"

@interface RMCurrentPlaylistViewController ()
{
    int startX;
}
@end

@implementation RMCurrentPlaylistViewController


#pragma mark - Data

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"videos" ofType:@"plist"];
    
    self.videosData = [[[NSArray alloc] initWithContentsOfFile:filePath] mutableCopy];
    
    [self reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifierPlaylist = @"playlistListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierPlaylist];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierPlaylist];
    }
    
    for (UIView *v in [cell subviews])
    {
        if ([[v class] isSubclassOfClass:[UICollectionView class]])
        {
            [(UICollectionView *)v reloadData];
            [(UICollectionView *)v setTag:indexPath.section];
            
        }
    }
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.videosData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RMPlaylistItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlaylistItemCell" forIndexPath:indexPath];
    
    NSDictionary *video = [self.videosData objectAtIndex:indexPath.row];
    
    if (!cell)
    {
        cell = [[RMPlaylistItemCell alloc] init];
    }
    
    cell.videoName.text = [video objectForKey:@"name"];
    cell.artistName.text = [[video objectForKey:@"artist"] capitalizedString];
    [cell.screenshot setImageWithURL:[NSURL URLWithString:[video objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"empty_artist"]];
    
    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RMVideoViewController *parentPlayer = (RMVideoViewController *)self.parentViewController;
    
    NSDictionary *video = [self.videosData objectAtIndex:indexPath.row];
    [parentPlayer.videoScreenshot setImageWithURL:[NSURL URLWithString:[video objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"empty_artist"]];
    [parentPlayer.artistName setText:[[video objectForKey:@"artist"] capitalizedString]];
    [parentPlayer.videoTitle setText:[video objectForKey:@"name"]];
}


#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    startX = scrollView.contentOffset.x;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    /*
    float width = scrollView.contentSize.width;
    float pageWidth = 315;
    float currentX = scrollView.contentOffset.x;
    
    //Endless scroll fake
    if (width > pageWidth && currentX > (width - pageWidth))
    {
        [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    else if (currentX < startX && startX < pageWidth)
    {
        [scrollView setContentOffset:CGPointMake(width - pageWidth, 0) animated:NO];
    }*/
}

@end
