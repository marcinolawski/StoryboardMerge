//
//  Git.h
//  StoryboardMerge
//
//  Created by Marcin Olawski on 22.03.2013.
//  Copyright (c) 2013 Marcin Olawski. All rights reserved.
//

#define PRIVATE_SVN

#import <Foundation/Foundation.h>
#import "SVN.h"


@interface Git : SVN

+(NSString*)findRoot:(NSString*)path;

+ (BOOL)isFileInRepository:(NSString*)path;

@end
