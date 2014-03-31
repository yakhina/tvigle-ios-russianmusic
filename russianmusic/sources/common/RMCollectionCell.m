//
//  RMCollectionCell.m
//  Tvigle Music
//
//  Created by Elena Yakhina on 12/02/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import "RMCollectionCell.h"
#import <QuartzCore/QuartzCore.h>

@interface RMCollectionCell()

@property (nonatomic, assign) BOOL isCustomized;

@end

@implementation RMCollectionCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    if (self.isCustomized)
    {
        return;
    }
    
    self.backgroundView.layer.borderWidth = 0.5;
    self.backgroundView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
    
    self.isCustomized = YES;
}

@end
