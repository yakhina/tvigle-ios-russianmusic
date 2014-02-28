//
//  RMVideoViewController.m
//  Tvigle Music
//
//  Created by Elena Yakhina on 20/02/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import "RMVideoViewController.h"
#import "RMAppDelegate.h"

@interface RMVideoViewController ()

@property (nonatomic, assign) CGRect windowFrame;
@property (nonatomic, assign) CGRect viewFrame;
@property (nonatomic, assign) CGRect playerFrame;
@property (nonatomic, assign) CGRect toolbarFrame;
@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, assign) UIDeviceOrientation currentOrientation;

@end

@implementation RMVideoViewController

- (void)viewDidLoad
{
    [self.navigationController.navigationBar setHidden:NO];
    
    [super viewDidLoad];
    
    [self.progressView setThumbImage:[UIImage imageNamed:@"progress_thumb"] forState:UIControlStateNormal];
    
    self.playerView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    self.playerView.layer.shadowOpacity = 0.5;
    self.playerView.layer.shadowOffset = CGSizeMake(0, 3);
    
    self.socialToolbar.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    self.socialToolbar.layer.shadowOpacity = 0.5;
    self.socialToolbar.layer.shadowOffset = CGSizeMake(0, 3);
    
    if ([(RMAppDelegate *)[[UIApplication sharedApplication].delegate window].rootViewController isKindOfClass:[UITabBarController class]])
    {
        self.tabBarController = (UITabBarController *)(RMAppDelegate *)[[UIApplication sharedApplication].delegate window].rootViewController;
    }
    
    self.windowFrame = [(RMAppDelegate *)[UIApplication sharedApplication].delegate window].bounds;
    self.viewFrame = self.view.frame;
    self.playerFrame = self.playerView.frame;
    self.toolbarFrame = self.toolbar.frame;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:@"UIDeviceOrientationDidChangeNotification"
                                               object:nil];
}


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
    
    [self.fullscreenBtn setImage:[UIImage imageNamed:@"windowed_icon"]];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.view setNeedsLayout];
    
    CGRect newFrame;
    newFrame.size.width = self.windowFrame.size.width;
    newFrame.size.height = self.windowFrame.size.height;
    newFrame.origin.y = 0;
    newFrame.origin.x = 0;
    
    CGRect newToolbarFrame = self.toolbar.frame;
    newToolbarFrame.size.width = newFrame.size.height;
    newToolbarFrame.origin.y = newFrame.size.width - newToolbarFrame.size.height;
    
    [UIView animateWithDuration:0.3 animations:^(void)
     {
         [self.view setFrame:newFrame];
         
         if (self.currentOrientation == UIDeviceOrientationLandscapeLeft)
         {
             self.playerView.transform = CGAffineTransformMakeRotation(M_PI_2);
         }
         else
         {
             self.playerView.transform = CGAffineTransformMakeRotation(-M_PI_2);
         }
         [self.playerView setFrame:newFrame];
         [self.toolbarBlur setFrame:newToolbarFrame];
         [self.toolbar setFrame:newToolbarFrame];
         self.otherVideos.alpha = 0;
         self.socialToolbar.alpha = 0;
         [self.view setNeedsLayout];
     }];
    
}


- (void)setWindowedMode
{
    
    [UIView animateWithDuration:0.3 animations:^(void)
     {
         [self.view setFrame:self.viewFrame];
         self.playerView.transform = CGAffineTransformMakeRotation(0);
         [self.playerView setNeedsLayout];
         [self.playerView setFrame:self.playerFrame];
         [self.toolbarBlur setFrame:self.toolbarFrame];
         [self.toolbar setFrame:self.toolbarFrame];
         self.otherVideos.alpha = 1;
         self.socialToolbar.alpha = 1;
         [self.playerView setNeedsLayout];
         [self.view setNeedsLayout];
     }];
    
    [self.fullscreenBtn setImage:[UIImage imageNamed:@"fullscreen_icon"]];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.view setNeedsLayout];
}


@end
