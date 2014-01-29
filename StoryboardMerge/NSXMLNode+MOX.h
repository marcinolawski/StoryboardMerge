//
//  NSXMLNode+MOX.h
//  StoryboardMerge
//
//  Created by Marcin Olawski on 13.02.2013.
//  Copyright (c) 2013 Marcin Olawski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSXMLNode (MOX)

- (id)nodeForXPath:(NSString *)xpath error:(NSError **)error;

@property (nonatomic,readonly) BOOL isElement;
@property (nonatomic,readonly) NSArray* family;

@end
