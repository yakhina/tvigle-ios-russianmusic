//
//  TContentPlayer.m
//  TviglePlayer
//
//  Created by Elena Yakhina on 23/01/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import "TContentPlayer.h"
#import <MediaPlayer/MediaPlayer.h>

/**
 * Contexts
 */
static void *playerContentRateContext = &playerContentRateContext;
static void *playerContentStatusContext = &playerContentStatusContext;
static void *inlineAdStatusContext = &inlineAdStatusContext;
static void *adPlayerRateContext = &adPlayerRateContext;
static void *playerBufferContext = &playerBufferContext;

static NSString * const kVolumeSystemNotificationKey = @"AVSystemController_SystemVolumeDidChangeNotification";


@implementation TContentPlayer

#pragma mark - Initializers

-(id)init
{
    if (self = [super init])
    {
        
        //Add listener for video rate changes
        [self addObserver:self
               forKeyPath:@"rate"
                  options:NSKeyValueObservingOptionNew
                  context:playerContentRateContext];
        
        //Get initial device volume
        MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
        self.currentVolume = musicPlayer.volume;
        
        //Add listener for volume changes
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:)
                                                     name:kVolumeSystemNotificationKey
                                                   object:nil];
        
    }
    
    return self;
}


- (id)initWithVideo:(TVideo *)video
{
    if (self = [self init])
    {
        self.video = video;
    }
    return self;
}


#pragma mark - Volume observer

- (void)volumeChanged:(NSNotification *)notification
{
    NSDictionary *notificationInfo = [notification userInfo];
    float volume = [[notificationInfo objectForKey:kVolumeSystemNotificationKey] floatValue];
    
    self.currentVolume = volume;
}


@end
