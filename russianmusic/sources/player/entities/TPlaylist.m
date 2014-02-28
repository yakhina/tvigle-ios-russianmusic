//
//  TPlaylist.m
//  TviglePlayer
//
//  Created by Elena Yakhina on 23/01/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import "TPlaylist.h"

@implementation TPlaylist

#pragma mark - Initializers

- (id) initWithVideos:(NSArray *)videos currentIndex:(NSInteger)currentIndex
{
    self = [super init];
    
    if (self)
    {
        self.videos = videos;
        self.currentIndex = [self isVideoIndexValid:currentIndex] ? currentIndex : 0;
    }
    
    return self;
}

#pragma mark - Getters

- (TVideo *)currentVideo
{
    return self.videos[self.currentIndex];
}

- (TVideo *)prevVideo
{
    int prevIndex = self.currentIndex - 1;
    
    self.currentIndex = [self isVideoIndexValid:prevIndex] ? prevIndex : self.videos.count - 1;
    
    return self.videos[self.currentIndex];
}

- (TVideo *)nextVideo
{
    int nextIndex = self.currentIndex + 1;
    
    self.currentIndex = [self isVideoIndexValid:nextIndex] ? nextIndex : 0;
    
    return self.videos[self.currentIndex];
}

#pragma mark - Helpers

- (BOOL)isVideoIndexValid:(int)index
{
    return index < self.videos.count && index >= 0;
}

@end
