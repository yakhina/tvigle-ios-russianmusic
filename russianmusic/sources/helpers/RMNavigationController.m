//
//  RMNavigationController.m
//  Tvigle Music
//
//  Created by Elena Yakhina on 27/02/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import "RMNavigationController.h"
#import "RMVideoViewController.h"

@interface RMNavigationController ()

@end

@implementation RMNavigationController

+ (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

-(BOOL)shouldAutorotate
{
    return [self.topViewController isKindOfClass:[RMVideoViewController class]];
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([self.topViewController isKindOfClass:[RMVideoViewController class]])
    {
        return UIInterfaceOrientationPortrait | UIInterfaceOrientationMaskLandscape;
    }
    else
    {
        return UIInterfaceOrientationPortrait;
    }
}

@end
