//
//  RevisionControl.m
//  StoryboardMerge
//
//  Created by Marcin Olawski on 22.03.2013.
//  Copyright (c) 2013 Marcin Olawski. All rights reserved.
//

#import "RevisionControl.h"
#import "NSError+MO.h"
#import "SVN.h"
#import "Git.h"

#pragma mark - Constans

NSString * const RevisionControlErrorDomain = @"Revision Control Error";

@implementation RevisionControl

+ (id)revisionControlForFile:(NSString*)path{
    path = [path stringByExpandingTildeInPath];
    if ([SVN isFileInRepository:path])
        return [[SVN alloc] initWithRoot:[SVN findRoot:path]];
    if ([Git isFileInRepository:path])
        return [[Git alloc] initWithRoot:[Git findRoot:path]];

    return nil;
}

- (NSData*)catFile:(NSString*)path error:(NSError**)error{
    return nil;
}

@end
