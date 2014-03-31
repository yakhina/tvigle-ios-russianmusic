//
//  SAMenuCell.m
//  NavigationMenu
//
//  Created by Ivan Sapozhnik on 2/19/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import "SIMenuCell.h"
#import "SIMenuConfiguration.h"
#import "UIColor+Extension.h"
#import "SICellSelection.h"
#import <QuartzCore/QuartzCore.h>

@interface SIMenuCell ()
@end

@implementation SIMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.contentView.backgroundColor = [UIColor color:[SIMenuConfiguration itemsColor] withAlpha:[SIMenuConfiguration menuAlpha]];
        //[self.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:self.textLabel.font.pointSize]];
        self.textLabel.textColor = [SIMenuConfiguration itemTextColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 2.0f);
    
    CGContextSetRGBStrokeColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
    CGContextMoveToPoint(ctx, 0, self.contentView.bounds.size.height);
    CGContextAddLineToPoint(ctx, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    CGContextStrokePath(ctx);
    
    CGContextSetRGBStrokeColor(ctx, 1.0f, 1.0f, 1.0f, 0.7f);
        
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, self.contentView.bounds.size.width, 0);
    CGContextStrokePath(ctx);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setSelected:(BOOL)selected withCompletionBlock:(void (^)())completion
{
    [super setSelected:selected animated:YES];
    
    float alpha = 0.0;
    
    if (selected)
    {
        alpha = 1.0;
    }
    else
    {
        alpha = 0.0;
    }
}


@end
