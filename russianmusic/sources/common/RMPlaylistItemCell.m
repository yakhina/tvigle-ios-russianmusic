//
//  RMPlaylistItemCell.m
//  Tvigle Music
//
//  Created by Elena Yakhina on 12/03/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import "RMPlaylistItemCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation RMPlaylistItemCell


- (IBAction)toggleVideo:(id)sender
{
    _isDisabled = !_isDisabled;
    [self.disabledView setHidden:!_isDisabled];
    [self.enableButton setHidden:!_isDisabled];
    [self.disableButton setHidden:_isDisabled];
    [self.disabledView setBlurEnabled:_isDisabled];
    [self.disabledView setBlurRadius:7.0];
}

@end
