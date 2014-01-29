//
//  ACEView+MO.m
//  StoryboardMerge
//
//  Created by Marcin Olawski on 04.03.2013.
//  Copyright (c) 2013 Marcin Olawski. All rights reserved.
//

#import "ACEView+MO.h"

#pragma mark - ACEView private API

NSString *ACEStringFromBool(BOOL flag);

@interface ACEView (Private)

- (void) executeScriptWhenLoaded:(NSString *)script;

@end

#pragma mark -

@implementation ACEView (MO)

- (void)setReadOnly:(BOOL)readonly {
    [self executeScriptWhenLoaded:[NSString stringWithFormat:@"editor.setReadOnly(%@);", ACEStringFromBool(readonly)]];
}

- (void)setShowGutter:(BOOL)show{
    [self executeScriptWhenLoaded:[NSString stringWithFormat:@"editor.renderer.setShowGutter(%@);", ACEStringFromBool(show)]];
}

@end
