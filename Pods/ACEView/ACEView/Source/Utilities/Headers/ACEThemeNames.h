//
//  ACEThemeNames.h
//  ACEView
//
//  Created by Michael Robinson on 2/12/12.
//  Copyright (c) 2012 Code of Interest. All rights reserved.
//
#import <ACEView/ACEThemes.h>

@interface ACEThemeNames : NSObject { }

+ (NSArray *) themeNames;
+ (NSArray *) humanThemeNames;

+ (NSString *) nameForTheme:(ACETheme)theme;
+ (NSString *) humanNameForTheme:(ACETheme)theme;

@end