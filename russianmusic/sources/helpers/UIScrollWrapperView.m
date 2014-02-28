//
//  UIScrollWrapperView.m
//  Tvigle Music
//
//  Created by Elena Yakhina on 14/02/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import "UIScrollWrapperView.h"

@implementation UIScrollWrapperView

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView *child = nil;
    
    if ((child = [super hitTest:point withEvent:event]) == self)
    {
        UIScrollView *scrollView;
        
        for (UIView *view in self.subviews)
        {
            if ([view isKindOfClass:[UIScrollView class]])
            {
                scrollView = (UIScrollView *)view;
                break;
            }
        }
        return scrollView;
    }
    return child;
}


@end
