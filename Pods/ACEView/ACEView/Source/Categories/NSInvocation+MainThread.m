//
//  NSInvocation+MainThread.m
//  ACEView
//
//  Created by Michael Robinson on 8/12/12.
//  Copyright (c) 2012 Code of Interest. All rights reserved.
//

#import "NSInvocation+MainThread.h"

@implementation NSInvocation (MainThread)

- (void) invokeOnMainThread {
    [self performSelectorOnMainThread:@selector(invokeWithTarget:)
                           withObject:[self target]
                        waitUntilDone:YES];
}

@end
