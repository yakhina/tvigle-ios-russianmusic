//
//  TContentPlayerView.m
//  TviglePlayer
//
//  Created by Elena Yakhina on 03/02/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import "TContentPlayerView.h"

@implementation TContentPlayerView


#pragma mark - Initializers

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.blurringView.blurEnabled = YES;
    }
    return self;
}


@end
