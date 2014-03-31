//
//  RMSecondViewController.m
//  russianmusic
//
//  Created by Elena Yakhina on 11/02/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import "RMMoodViewController.h"
#import "UIImageView+WebCache.h"
#import "RMCollectionCell.h"
#import "RMPlaylistsViewController.h"


@interface RMMoodViewController ()
{
    float startX;
    float endX;
}
@property (strong, nonatomic) UINib *moodNib;
@property (nonatomic, strong) NSMutableArray *moodData;

@end

@implementation RMMoodViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareMoodData];
    
    float width = self.scrollView.frame.size.width;
    CGRect frame = self.collectionView.frame;
    frame.size.width = width * self.moodData.count;
    
    self.collectionView.frame = frame;
    
    [self.scrollView setContentSize:CGSizeMake(width * self.moodData.count, self.scrollView.bounds.size.height - 200)];
    [self.scrollView setContentOffset:CGPointMake(width, 0)];
    startX = width;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showTitle"]) {
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] lastObject];
        RMPlaylistsViewController *playlistVC = segue.destinationViewController;
        playlistVC.navigationItem.title = [[self.moodData objectAtIndex:indexPath.row] objectForKey:@"name"];
    }
}

#pragma mark - Data

- (void)prepareMoodData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mood" ofType:@"plist"];
    self.moodData = [[[NSArray alloc] initWithContentsOfFile:filePath] mutableCopy];
    
    [self.moodData insertObject:self.moodData.lastObject atIndex:0];
    [self.moodData addObject:self.moodData[1]];
    
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
    return self.moodData.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RMCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
    NSDictionary *mood = [self.moodData objectAtIndex:indexPath.row];
    
    if (!cell)
    {
        cell = [[RMCollectionCell alloc] init];
    }
    
    [cell setBackgroundColor:[UIColor whiteColor]];
    cell.cardSubtitle.text = [NSString stringWithFormat:@"%@ сборников и %@ видео", [mood objectForKey:@"playlists"], [mood objectForKey:@"videos"]];
    [cell.cardPoster setImageWithURL:[NSURL URLWithString:[mood objectForKey:@"image"]] placeholderImage:nil];
    return cell;
}

#pragma mark - Custom getters & setters

- (UINib *)moodNib
{
    if (!_moodNib)
    {
        _moodNib = [UINib nibWithNibName:@"RMCollectionCell" bundle:nil];
    }
    return _moodNib;
}


@end
