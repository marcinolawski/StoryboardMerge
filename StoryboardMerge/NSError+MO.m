//
//  NSError+MO.m
//  StoryboardMerge
//
//  Created by Marcin Olawski on 24.03.2013.
//  Copyright (c) 2013 Marcin Olawski. All rights reserved.
//

#import "NSError+MO.h"

@implementation NSError (MO)

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description{
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: description};
    return [NSError errorWithDomain:domain code:code userInfo:userInfo];
}

@end
