//
//  RMSecondViewController.m
//  russianmusic
//
//  Created by Elena Yakhina on 11/02/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import "RMGenresViewController.h"
#import "UIImageView+WebCache.h"
#import "RMPlaylistsViewController.h"
#import "RMCollectionCell.h"

@interface RMGenresViewController ()
{
    float startX;
    float endX;
}
@property (strong, nonatomic) UINib *genreNib;
@property (nonatomic, strong) NSMutableArray *genresData;

@end

@implementation RMGenresViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareGenresData];
    
    float width = self.scrollView.frame.size.width;
    CGRect frame = self.collectionView.frame;
    frame.size.width = width * self.genresData.count;
    
    self.collectionView.frame = frame;
    
    [self.scrollView setContentSize:CGSizeMake(width * self.genresData.count, self.scrollView.bounds.size.height - 200)];
    [self.scrollView setContentOffset:CGPointMake(width, 0)];
    
    startX = width;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showTitle"]) {
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] lastObject];
        RMPlaylistsViewController *playlistVC = segue.destinationViewController;
        playlistVC.navigationItem.title = [[self.genresData objectAtIndex:indexPath.row] objectForKey:@"name"];
    }
}


#pragma mark - Data

- (void)prepareGenresData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"genres" ofType:@"plist"];
    self.genresData = [[[NSArray alloc] initWithContentsOfFile:filePath] mutableCopy];
    
    [self.genresData insertObject:self.genresData.lastObject atIndex:0];
    [self.genresData addObject:self.genresData[1]];
    
    [self.collectionView reloadData];
}


#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    startX = self.scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float width = self.scrollView.contentSize.width;
    float pageWidth = self.scrollView.frame.size.width;
    float currentX = self.scrollView.contentOffset.x;
    
    if (currentX > startX && startX >= (width - pageWidth * 2))
    {
        [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    else if (currentX < 0 && startX <= pageWidth)
    {
        [scrollView setContentOffset:CGPointMake(width - pageWidth * 2, 0) animated:NO];
    }
}


#pragma mark - UICollectionView DataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.genresData.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RMCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
    NSDictionary *genre = [self.genresData objectAtIndex:indexPath.row];
    
    if (!cell)
    {
        cell = [[RMCollectionCell alloc] init];
    }
    
    [cell setBackgroundColor:[UIColor whiteColor]];
    cell.cardTitle.text = [NSString stringWithFormat:@"%@ сборников и %@ видео", [genre objectForKey:@"playlists"], [genre objectForKey:@"videos"]];
    [cell.cardPoster setImageWithURL:[NSURL URLWithString:[genre objectForKey:@"image"]] placeholderImage:nil];
    return cell;
}

#pragma mark - Custom getters & setters

- (UINib *)genreNib
{
    if (!_genreNib)
    {
        _genreNib = [UINib nibWithNibName:@"RMCollectionCell" bundle:nil];
    }
    return _genreNib;
}


@end
