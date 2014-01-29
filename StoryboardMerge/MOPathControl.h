//
//  MOPathControl.h
//  MacTest3
//
//  Created by Marcin Olawski on 15.01.2013.
//  Copyright (c) 2013 Marcin Olawski. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MOPathControl : NSPathControl{
    NSGradient *_gradient;
    CGFloat _gradientAngle;
    NSColor *_gradientStartingColor;
    NSColor *_gradientEndingColor;
}

@property (nonatomic) NSGradient *gradient;
@property (nonatomic) CGFloat gradientAngle;
@property (nonatomic) NSColor *gradientStartingColor;
@property (nonatomic) NSColor *gradientEndingColor;

@property (nonatomic) NSString* test;

@end
