//
//  TPlayerToolbar.m
//  TviglePlayer
//
//  Created by Elena Yakhina on 04/02/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import "TPlayerToolbar.h"

@implementation TPlayerToolbar


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    return self;
}
    
- (void) setup
{
    CGRect frame = self.frame;
    frame.origin = CGRectZero.origin;
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:frame];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [toolbar setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    [toolbar setTranslucent:YES];
    [toolbar setBarStyle:UIBarStyleDefault];
    [toolbar setTintColor:[UIColor clearColor]];
    [toolbar setBackgroundColor:[UIColor clearColor]];
    
    [self insertSubview:toolbar atIndex:0];
    
    
}

@end
