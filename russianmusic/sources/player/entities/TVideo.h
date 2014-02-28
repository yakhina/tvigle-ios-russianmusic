//
//  TVideo.h
//  TviglePlayer
//
//  Created by Elena Yakhina on 23/01/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TVideo : NSObject

@property (nonatomic, assign) NSNumber *id;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *fullDescription;
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, assign) NSNumber *length;
@property (nonatomic, retain) NSString *siteURL;
@property (nonatomic, retain) NSArray *imagefiles;
@property (nonatomic, retain) NSArray *videofiles;
@property (nonatomic, retain) NSString *distributionType;
@property (nonatomic, retain) NSArray *collections;
@property (nonatomic, retain) NSDictionary *advData;

+ (id)videoWithDictionary:(NSDictionary *)dictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
