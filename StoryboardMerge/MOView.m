//
//  MOView.m
//  StoryboardMerge
//
//  Created by Marcin Olawski on 21.01.2013.
//  Copyright (c) 2013 Marcin Olawski. All rights reserved.
//

#import "MOView.h"

@implementation MOView

#pragma mark - NSView

- (void)drawRect:(NSRect)dirtyRect
{
    [_gradient drawInRect:[self bounds] angle:_gradientAngle];
    
    [super drawRect:dirtyRect];
}

#pragma mark - Setters

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    //Dziwny blad...
    if ([@"keyPath" isEqualToString:key])
        return;
}

- (void)setGradient:(NSGradient *)gradient{
    _gradient = gradient;
    //self.backgroundColor = [NSColor clearColor];
    if (!self.needsDisplay)
        [self setNeedsDisplay:YES];
}

- (void)setGradientAngle:(CGFloat)angle{
    _gradientAngle = angle;
    if (!self.needsDisplay)
        [self setNeedsDisplay:YES];
}

- (void) setGradientStartingColor:(NSColor *)color{
    _gradientStartingColor = color;
    if (_gradientEndingColor)
        self.gradient = [[NSGradient alloc] initWithStartingColor:_gradientStartingColor endingColor:_gradientEndingColor];
}

- (void) setGradientEndingColor:(NSColor *)color{
    _gradientEndingColor = color;
    if (_gradientStartingColor)
        self.gradient = [[NSGradient alloc] initWithStartingColor:_gradientStartingColor endingColor:_gradientEndingColor];
}

@end
