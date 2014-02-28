//
//  TPlaylist.h
//  TviglePlayer
//
//  Created by Elena Yakhina on 23/01/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TVideo.h"

@interface TPlaylist : NSObject

@property (nonatomic, retain) NSArray *videos;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign, readonly) BOOL isPrevAvailable;
@property (nonatomic, assign, readonly) BOOL isNextAvailable;
@property (nonatomic, retain, readonly) TVideo *currentVideo;
@property (nonatomic, retain, readonly) TVideo *prevVideo;
@property (nonatomic, retain, readonly) TVideo *nextVideo;

- (id) initWithVideos:(NSArray *)videos currentIndex:(NSInteger)currentIndex;

@end
