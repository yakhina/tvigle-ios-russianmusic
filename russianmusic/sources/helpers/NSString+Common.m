//
//  NSString+NSString_Common.m
//  Русская Музыка
//
//  Created by Elena Yakhina on 12/02/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import "NSString+Common.h"

@implementation NSString (Common)

- (NSString *)stringByDecodingURLFormat
{
    NSString *result = [(NSString *)self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

@end