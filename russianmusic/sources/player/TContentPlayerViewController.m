//
//  TContentPlayerViewController.m
//  TviglePlayer
//
//  Created by Elena Yakhina on 23/01/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import "TContentPlayerViewController.h"

@interface TContentPlayerViewController ()

@end

@implementation TContentPlayerViewController

#pragma mark - Initializers

- (id)initWithPlaylist:(TPlaylist *)playlist
{
    self = [super initWithNibName:@"TContentPlayerView" bundle:nil];
    
    if (self)
    {
        self.playlist = playlist;
        
        [self hideStatusBar];
    }
    return self;
}



#pragma mark - ViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)hideStatusBar
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
}

@end
