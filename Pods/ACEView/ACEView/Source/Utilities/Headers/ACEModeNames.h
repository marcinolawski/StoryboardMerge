//
//  ACEModeNames.h
//  ACEView
//
//  Created by Michael Robinson on 2/12/12.
//  Copyright (c) 2012 Code of Interest. All rights reserved.
//
#import <ACEView/ACEModes.h>

@interface ACEModeNames : NSObject { }

+ (NSArray *) modeNames;
+ (NSArray *) humanModeNames;

+ (NSString *) nameForMode:(ACEMode)mode;
+ (NSString *) humanNameForMode:(ACEMode)mode;

@end