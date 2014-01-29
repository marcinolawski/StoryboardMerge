//
//  ACELog.h
//
//  Created by Koenraad Van Nieuwenhove on 26/08/08.
//  Copyright 2008 CoCoa Crumbs. All rights reserved.
//

// idea from http://www.borkware.com/rants/agentm/mlog/

#define ACELog(s,...)                    \
[ACELogger log:__FILE__                  \
lineNumber:__LINE__                      \
format:(s), ##__VA_ARGS__]

@interface ACELogger : NSObject { }

+ (void) log:(char*)file
    lineNumber:(int)lineNumber
        format:(NSString*)format, ...;

@end
