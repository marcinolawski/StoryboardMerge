//
//  MOXStoryboard.h
//  StoryboardMerge
//
//  Created by Marcin Olawski on 13.01.2013.
//  Copyright (c) 2013 Marcin Olawski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOXElement.h"

NSString* PrettyName(NSString* name);

@interface MOXStoryboard : NSXMLDocument{
   
}

- (id)initWithContentsOfFile:(NSString *)path error:(NSError **)errorPtr;
- (id)initWithContentsOfURL:(NSURL *)url error:(NSError **)error;

- (MOXElement *)rootElement;

- (void)compareStoryboards:(MOXStoryboard *)storyboard;
- (void)merge:(MOXStoryboard*)storyboard;
- (NSUInteger)validate;

@property (nonatomic,copy) NSURL *url;
@property (nonatomic,copy) NSDate *modificationDate;

@end
