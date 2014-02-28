//
//  TVideo.m
//  TviglePlayer
//
//  Created by Elena Yakhina on 23/01/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import "TVideo.h"
#import "objc/runtime.h"

@implementation TVideo

#pragma mark - Initializers

+ (id)videoWithDictionary:(NSDictionary *)dictionary
{
    return [[self alloc] initWithDictionary:dictionary];
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self)
    {
        for (NSString *key in dictionary)
        {
            if ([self respondsToSelector:NSSelectorFromString(key)])
            {
                [self setValue:dictionary[key] forKey:key];
            }
        }
    }
    
    return self;
}

@end
