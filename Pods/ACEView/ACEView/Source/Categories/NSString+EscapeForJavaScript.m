//
//  NSString+EscapeForJavaScript.m
//  ACEView
//
//  Created by Michael Robinson on 5/12/12.
//  Copyright (c) 2012 Code of Interest. All rights reserved.
//

#import "NSString+EscapeForJavaScript.h"

@implementation NSString (EscapeForJavaScript)

- (NSString *) stringByEscapingForJavaScript {
    NSString *jsonString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:@[self]
                                                                                          options:0
                                                                                            error:nil] encoding:NSUTF8StringEncoding];
    [jsonString autorelease];
    return [jsonString substringWithRange:NSMakeRange(2, jsonString.length - 4)];
}

@end
