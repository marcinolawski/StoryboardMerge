//
//  NSError+MO.h
//  StoryboardMerge
//
//  Created by Marcin Olawski on 24.03.2013.
//  Copyright (c) 2013 Marcin Olawski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (MO)

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description;

@end
