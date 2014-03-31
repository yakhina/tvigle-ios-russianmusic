//
//  RMSecondViewController.m
//  russianmusic
//
//  Created by Elena Yakhina on 11/02/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import "RMFeaturedViewController.h"
#import "UIImageView+WebCache.h"
#import "RMCollectionCell.h"
#import "RMPlaylistsListsViewController.h"
#import "RMVideoViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface RMFeaturedViewController ()
{
    float startX;
    float endX;
}

@property (nonatomic, strong) NSArray *baseHeaders;
@property (nonatomic, strong) SINavigationMenuView *filterMenu;
@property (nonatomic, assign) int filterIndex;
@property (strong, nonatomic) UINib *moodNib;
@property (nonatomic, strong) NSArray *genresData;
@property (nonatomic, strong) NSMutableArray *slidersData;

@end

@implementation RMFeaturedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"genres" ofType:@"plist"];
    self.genresData = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    
    self.filterIndex = 0;
    
    [self prepareSlidersData];
    
    float width = self.scrollView.frame.size.width;
    
    CGRect frame = self.collectionView.frame;
    
    frame.size.width = width * [self.slidersData[self.filterIndex] count];
    
    startX = width;
    
    frame = self.pageControl.frame;
    
    frame.size.height = 50;
    
    self.pageControl.frame = frame;
    
    [self configureFilter];
    
    [self.collectionView reloadData];
    
    [self didSelectItemAtIndex:0];
    
    [self.collectionView layoutSubviews];
    
}


#pragma mark - Data

- (void)prepareSlidersData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sliders" ofType:@"plist"];
    self.slidersData = [[[NSArray alloc] initWithContentsOfFile:filePath] mutableCopy];
    
    for (int i = 0; i < self.slidersData.count; i++)
    {
        NSArray *playlists = self.slidersData[i];
        NSMutableArray *playlistsMutable = [playlists mutableCopy];
        [playlistsMutable insertObject:playlistsMutable.lastObject atIndex:0];
        [playlistsMutable addObject:playlistsMutable[1]];
        [self.slidersData replaceObjectAtIndex:i withObject:playlistsMutable];
    }
    
}

#pragma mark - Filter

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
    
    [self.collectionView reloadData];
    
    self.pageControl.numberOfPages = [self.slidersData[self.filterIndex] count] - 2;
    
    [self.pageControl setCurrentPage:0];
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:NO];
    
    if (!self.baseHeaders)
    {
        self.baseHeaders = [self.playlistLists.headers copy];
    }

    if (self.filterIndex)
    {
        NSMutableArray *headers = [NSMutableArray array];
        
        for (NSString *header in self.baseHeaders)
        {
            [headers addObject:[NSString stringWithFormat:@"%@: %@", self.filterMenu.items[self.filterIndex], header]];
        }
        [self.playlistLists setHeaders:headers];
    }
    else
    {
        [self.playlistLists setHeaders:self.baseHeaders];
    }
    
    [self.playlistLists shuffleData];
    [self.playlistLists reloadData];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showTitle"]) {
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] lastObject];
        RMPlaylistsListsViewController *playlistVC = segue.destinationViewController;
        playlistVC.navigationItem.title = [[self.slidersData[self.filterIndex] objectAtIndex:indexPath.row] objectForKey:@"name"];
    }
    if ([segue.identifier isEqualToString:@"loadPlaylists"])
    {
        self.playlistLists = segue.destinationViewController;
    }
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
    
    //Count current page
    if (currentX >= (width - pageWidth) || (currentX < pageWidth * 2 && currentX >= pageWidth))
    {
        [self.pageControl setCurrentPage:0];
    }
    else if (startX >= (width - pageWidth) || currentX < pageWidth)
    {
        int page = (int)self.pageControl.numberOfPages - 1;
        [self.pageControl setCurrentPage:page];
    }
    else
    {
        int page = currentX / pageWidth - 1;
        [self.pageControl setCurrentPage:(page <= 0 ? self.pageControl.currentPage : page)];
    }
    
    //Endless scroll fake
    if (currentX > startX && startX >= (width - pageWidth * 2))
    {
        [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    else if (currentX < 0 && startX <= pageWidth)
    {
        [scrollView setContentOffset:CGPointMake(width - pageWidth * 2, 0) animated:NO];
    }
}

- (IBAction)pageControlDidChangedPage
{
    [self.scrollView setContentOffset:CGPointMake(self.pageControl.currentPage * self.scrollView.frame.size.width, 0) animated:YES];
}

#pragma mark - UICollectionView DataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.slidersData[self.filterIndex] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RMCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
    NSDictionary *playlist = [self.slidersData[self.filterIndex] objectAtIndex:indexPath.row];
    
    if (!cell)
    {
        cell = [[RMCollectionCell alloc] init];
    }
    
    [cell setBackgroundColor:[UIColor whiteColor]];
    cell.cardTitle.text = [playlist objectForKey:@"name"];
    cell.cardSubtitle.text = [NSString stringWithFormat:@"%@ сборников и %@ видео", [playlist objectForKey:@"playlists"], [playlist objectForKey:@"videos"]];
    [cell.cardPoster setImageWithURL:[NSURL URLWithString:[playlist objectForKey:@"image"]] placeholderImage:nil];
    
    cell.cardTitle.layer.shadowRadius = 2;
    cell.cardSubtitle.layer.shadowRadius = 1;
    cell.cardTitle.layer.shadowOpacity = 1;
    cell.cardSubtitle.layer.shadowOpacity = 1;
    cell.cardTitle.layer.shadowOffset = CGSizeMake(0, 0);
    cell.cardSubtitle.layer.shadowOffset = CGSizeMake(0, 0);
    
    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    RMVideoViewController *videoVC = [sb instantiateViewControllerWithIdentifier:@"RMVideoViewController"];
    
    videoVC.navigationItem.title = [[self.slidersData[self.filterIndex] objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    [self.navigationController pushViewController:videoVC animated:YES];
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
