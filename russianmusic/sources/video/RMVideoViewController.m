//
//  RMVideoViewController.m
//  Tvigle Music
//
//  Created by Elena Yakhina on 20/02/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import "RMVideoViewController.h"
#import "RMAppDelegate.h"
#import "RMPlaylistItemCell.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

@interface RMVideoViewController ()
{
    int startX;
}
@property (nonatomic, strong) NSMutableArray *videosData;
@property (nonatomic, assign) CGRect videoScreenshotFrame;
@property (nonatomic, assign) CGRect currentPlaylistFrame;
@property (nonatomic, assign) CGRect currentPlaylistCollapsedFrame;
@property (nonatomic, assign) CGRect currentPlaylistClosedFrame;
@property (nonatomic, assign) CGRect currentPlaylistOpenedFrame;
@property (nonatomic, assign) CGRect otherVideosCollapsedFrame;
@property (nonatomic, assign) CGRect otherVideosExpandedFrame;
@property (nonatomic, assign) CGRect playerFrame;
@property (nonatomic, assign) CGRect playerCollapsedFrame;
@property (nonatomic, assign) CGRect fullscreenBtnFrame;

@property (nonatomic, assign) CGRect windowFrame;
@property (nonatomic, assign) CGRect viewFrame;
@property (nonatomic, assign) CGRect playerWrapperFrame;
@property (nonatomic, assign) CGRect toolbarFrame;
@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, assign) UIDeviceOrientation currentOrientation;
@property (nonatomic, strong) UIActionSheet *shareActionSheet;

@end

@implementation RMVideoViewController

- (void)viewDidLoad
{
    [self.navigationController.navigationBar setHidden:NO];
    
    [super viewDidLoad];
    
    if ([(RMAppDelegate *)[[UIApplication sharedApplication].delegate window].rootViewController isKindOfClass:[UITabBarController class]])
    {
        self.tabBarController = (UITabBarController *)(RMAppDelegate *)[[UIApplication sharedApplication].delegate window].rootViewController;
    }
    
    [self.fullscreenBtn setImage:[UIImage imageNamed:@"windowed_icon"] forState:UIControlStateSelected];
    [self.togglePlaylistButton setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateSelected];
    
    //Other videos
    CGRect frame = self.otherVideos.frame;
    frame.origin.y = 344;
    self.otherVideosCollapsedFrame = frame;
    frame.origin.y = self.currentPlaylist.frame.origin.y;
    self.otherVideosExpandedFrame = frame;
    
    //Current videos
    self.currentPlaylistFrame = self.currentPlaylist.frame;
    frame = self.currentPlaylistFrame;
    frame.size.height = 0;
    self.currentPlaylistCollapsedFrame = frame;
    
    self.fullscreenBtnFrame = self.fullscreenBtn.frame;
    
    self.windowFrame = [(RMAppDelegate *)[UIApplication sharedApplication].delegate window].bounds;
    self.viewFrame = self.view.frame;
    
    self.playerView.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:1].CGColor;
    self.playerView.layer.shadowOpacity = 0.25;
    self.playerView.layer.shadowRadius = 4.0;
    self.playerView.layer.shadowOffset = CGSizeMake(0, 0);
    
    frame = self.playerView.frame;
    frame.size.height = 224;
    
    self.playerCollapsedFrame = frame;
    
    frame.size.height = 344;
    self.playerFrame = frame;
    
    self.playerWrapperFrame = self.playerWrapper.frame;
    self.toolbarFrame = self.toolbar.frame;
    
    self.videoScreenshotFrame = self.videoScreenshot.frame;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:@"UIDeviceOrientationDidChangeNotification"
                                               object:nil];
    
    [self prepareData];
    
    self.playlistOpened = YES;
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.playlistCollection selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    [self collectionView:self.playlistCollection didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

#pragma mark - Current Playlist

- (IBAction)togglePlaylist:(id)sender
{
    if (self.fullscreen)
    {
        if (self.playlistOpened)
        {
            self.togglePlaylistButton.selected = NO;
            
            [UIView animateWithDuration:0.25 animations:^(void)
             {
                 [self.currentPlaylist setFrame:self.currentPlaylistClosedFrame];
             } completion: ^(BOOL finished)
             {
                 self.playlistOpened = NO;
             }];
        }
        else
        {
            self.togglePlaylistButton.selected = YES;
            
            [UIView animateWithDuration:0.25 animations:^(void)
             {
                 [self.currentPlaylist setFrame:self.currentPlaylistOpenedFrame];
             } completion: ^(BOOL finished)
             {
                 self.playlistOpened = YES;
             }];
        }
    }
    else
    {
        if (self.playlistOpened)
        {
            self.togglePlaylistButton.selected = YES;
            
            [UIView animateWithDuration:0.25 animations:^(void)
             {
                 [self.currentPlaylist setFrame:self.currentPlaylistCollapsedFrame];
                 [self.otherVideos setFrame:self.otherVideosExpandedFrame];
                 [self.playerView setFrame:self.playerCollapsedFrame];
                 
             } completion: ^(BOOL finished)
             {
                 self.playlistOpened = NO;
             }];
        }
        else
        {
            self.togglePlaylistButton.selected = NO;
            
            [UIView animateWithDuration:0.25 animations:^(void)
             {
                 [self.currentPlaylist setFrame:self.currentPlaylistFrame];
                 [self.otherVideos setFrame:self.otherVideosCollapsedFrame];
                 [self.playerView setFrame:self.playerFrame];
                 
             } completion: ^(BOOL finished)
             {
                 self.playlistOpened = YES;
             }];
        }
    }
}

#pragma mark - Fullscreen & Rotatation

-(IBAction)toggleFullscreen:(id)sender
{
    self.fullscreen = !self.fullscreen;
}

-(BOOL)canRotate
{
    return YES;
}

- (void)orientationChanged:(NSNotification *)notification
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if (orientation == self.currentOrientation)
    {
        return;
    }
    
    self.currentOrientation = orientation;
    
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        self.fullscreen = YES;
    }
    else if (orientation == UIInterfaceOrientationPortrait)
    {
        self.fullscreen = NO;
    }
}

- (void)setFullscreen:(BOOL)fullscreen
{
    if (fullscreen == _fullscreen)
    {
        return;
    }
    
    _fullscreen = fullscreen;
    
    if (fullscreen)
    {
        [self setFullscreenMode];
    }
    else
    {
        [self setWindowedMode];
    }
}

- (void)setFullscreenMode
{
    [self.view setClipsToBounds:YES];
    
    [self.fullscreenBtn setSelected:YES];
    
    [self.playerView setFrame:self.playerCollapsedFrame];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.view setNeedsLayout];
    
    CGRect newFrame;
    newFrame.size.width = self.windowFrame.size.width;
    newFrame.size.height = self.windowFrame.size.height;
    newFrame.origin.y = 0;
    newFrame.origin.x = 0;
    
    CGRect newScreenshotFrame;
    newScreenshotFrame.size.width = self.windowFrame.size.height;
    newScreenshotFrame.size.height = self.windowFrame.size.width;
    newScreenshotFrame.origin.y = 0;
    newScreenshotFrame.origin.x = 0;
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    CGRect frame = self.currentPlaylist.frame;
    frame.size.height = 120;
    frame.origin.y = self.windowFrame.size.width - frame.size.height - 44;
    frame.size.width = self.windowFrame.size.height;
    self.currentPlaylistOpenedFrame = frame;
    
    frame.origin.y = self.windowFrame.size.width;
    self.currentPlaylistClosedFrame = frame;
    [self.currentPlaylist setFrame:self.currentPlaylistClosedFrame];
    
    self.togglePlaylistButton.selected = NO;
    self.playlistOpened = NO;
    
    CGRect newToolbarFrame;
    newToolbarFrame.origin = CGPointMake(0, self.windowFrame.size.width - 44);
    newToolbarFrame.size = CGSizeMake(self.windowFrame.size.height, 44);
    
    
    CGRect newFullscreenBtnFrame = self.fullscreenBtn.frame;
    newFullscreenBtnFrame.origin.y -= 44;
    [self.fullscreenBtn setFrame:newFullscreenBtnFrame];
    
    [UIView animateWithDuration:0.3 animations:^(void)
     {
         [self.view setFrame:self.windowFrame];
         
         if (self.currentOrientation == UIDeviceOrientationLandscapeLeft)
         {
             self.playerView.transform = CGAffineTransformMakeRotation(M_PI_2);
         }
         else
         {
             self.playerView.transform = CGAffineTransformMakeRotation(-M_PI_2);
         }
         
         [self.playerView setFrame:newFrame];
         
         [self.playerWrapper setFrame:newScreenshotFrame];
         
         [self.toolbar setFrame:newToolbarFrame];
         
         self.otherVideos.alpha = 0;
         
     } completion:^(BOOL finished)
     {
         [self.playerView setNeedsLayout];
     }];
    
}


- (void)setWindowedMode
{
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    
    [UIView animateWithDuration:0.3 animations:^(void)
     {
         [self.view setFrame:self.viewFrame];
         
         self.playerView.transform = CGAffineTransformMakeRotation(0);
         
         
         [self.otherVideos setFrame:self.otherVideosCollapsedFrame];
         
         [self.currentPlaylist setFrame:self.currentPlaylistFrame];
         
         [self.playerView setFrame:self.playerFrame];
         
         self.otherVideos.alpha = 1;
         
         [self.toolbar setFrame:self.toolbarFrame];
         
         [self.playerWrapper setFrame:self.playerWrapperFrame];
         
         [self.fullscreenBtn setFrame:self.fullscreenBtnFrame];
         
         [self.playerView setNeedsLayout];
         
         [self.playerView layoutSubviews];

         
     } completion:^(BOOL finished)
     {
         self.playlistOpened = NO;
         
         [self.playerView setNeedsLayout];
         
         [self videoPlaylistsDidScrollDown:nil];
     }];
    
    
    [self.fullscreenBtn setSelected:NO];
    
    self.tabBarController.tabBar.hidden = NO;
    
    self.navigationController.navigationBar.hidden = NO;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"loadPlaylists"])
    {
        self.playlistLists = segue.destinationViewController;
        self.playlistLists.delegate = self;
    }
}


- (void)videoPlaylistsDidScrollUp: (RMVideoPlaylistsViewController *)videoPlaylists
{
    if (!self.fullscreen && self.playlistOpened)
    {
        [self togglePlaylist:nil];
    }
}

- (void)videoPlaylistsDidScrollDown:(RMVideoPlaylistsViewController *)videoPlaylists
{
    if (!self.fullscreen && !self.playlistOpened)
    {
        [self togglePlaylist:nil];
    }
}
#pragma mark - Collection View
//TODO: remove


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
    
    cell.videoName.text = [video objectForKey:@"name"];
    cell.artistName.text = [[video objectForKey:@"artist"] capitalizedString];
    [cell.screenshot setImageWithURL:[NSURL URLWithString:[video objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"empty_artist"]];
  
    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *video = [self.videosData[collectionView.tag] objectAtIndex:indexPath.row];

    [self.videoScreenshot setImageWithURL:[NSURL URLWithString:[video objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"empty_artist"]];
    
    [self.artistName setText:[[video objectForKey:@"artist"] capitalizedString]];
    
    [self.videoTitle setText:[video objectForKey:@"name"]];
    
    [[(RMPlaylistItemCell *)[collectionView cellForItemAtIndexPath:indexPath] screenshot] layer].borderColor =  [UIColor colorWithRed:53.0/255.0 green:123.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor;

    [[(RMPlaylistItemCell *)[collectionView cellForItemAtIndexPath:indexPath] screenshot] layer].borderWidth = 3.0;
    
    if (self.fullscreen)
    {
        [self togglePlaylist:nil];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[(RMPlaylistItemCell *)[collectionView cellForItemAtIndexPath:indexPath] screenshot] layer].borderWidth = 0.0;
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

- (void)prepareData
{
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
}


#pragma mark - Share & ActionSheet Delegate

- (IBAction)blacklistButtonTapped:(id)sender
{
    
    if (!self.shareActionSheet)
    {
        self.shareActionSheet = [[UIActionSheet alloc] initWithTitle:@"Добавить в Черный спиок" delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:@"Только это видео", @"Все видео исполнителя", nil];
        
        self.shareActionSheet.tag = 1;
        
    }
    [self showActionSheet];
}
- (IBAction)favoriteButtonTapped:(id)sender
{
    
    if (!self.shareActionSheet)
    {
        self.shareActionSheet = [[UIActionSheet alloc] initWithTitle:@"Добавить в Избранное" delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:@"Только это видео", @"Весь плейлист", nil];
        
        self.shareActionSheet.tag = 2;
        
    }
    [self showActionSheet];
}

- (IBAction)shareButtonTapped:(id)sender
{
    if (!self.shareActionSheet)
    {
        self.shareActionSheet = [[UIActionSheet alloc] initWithTitle:@"Поделиться" delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:@"Facebook", @"Vkontakte", @"Twitter", @"Google+", @"Odnoklassniki", nil];
        
        self.shareActionSheet.tag = 3;
        
    }
    
    [self showActionSheet];
}

- (void)showActionSheet
{
    if (self.fullscreen)
    {
        [self.shareActionSheet showInView:self.playerView];
        [self.shareActionSheet.superview setTransform:self.playerView.transform];
        [self.shareActionSheet.superview setFrame:CGRectMake(-240, 120, self.windowFrame.size.height, self.windowFrame.size.width)];
    }
    else
    {
        [self.shareActionSheet showFromTabBar:self.tabBarController.tabBar];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        NSString *title;
        NSString *message;
        
        
        switch (actionSheet.tag) {
            case 1:
                title = @"Добавлено в Черный список!";
                message = @"Вы можете отредактировать Черный список в своем Личном кабинете";
                break;
            case 2:
                title = @"Добавлено в Избранное!";
                message = @"Вы можете отредактировать список Избранного в своем Личном кабинете";
                break;
            case 3:
                title = @"Ура!";
                message = @"Вы успешно поделились этим видео с друзьями!";
                break;
                
            default:
                break;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Закрыть" otherButtonTitles:nil];
        
        if (!self.fullscreen)
        {
            [alert show];
        }
    }
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.shareActionSheet = nil;
}

@end
