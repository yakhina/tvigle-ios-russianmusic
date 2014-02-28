//
//  RMVideoViewController.h
//  Tvigle Music
//
//  Created by Elena Yakhina on 20/02/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMVideoViewController : UIViewController

@property (nonatomic, assign) BOOL fullscreen;
@property (nonatomic, strong) IBOutlet UIView *playerView;
@property (nonatomic, strong) IBOutlet UIView *otherVideos;
@property (nonatomic, strong) IBOutlet UIView *toolbarBlur;
@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) IBOutlet UIToolbar *socialToolbar;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *fullscreenBtn;
@property (nonatomic, strong) IBOutlet UISlider *progressView;

-(IBAction)toggleFullscreen:(id)sender;

@end
