//
//  RevisionControl.h
//  StoryboardMerge
//
//  Created by Marcin Olawski on 22.03.2013.
//  Copyright (c) 2013 Marcin Olawski. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Constans

NSString * const RevisionControlErrorDomain;

#pragma mark - RevisionControl

@interface RevisionControl : NSObject

+ (id)revisionControlForFile:(NSString*)path;

- (NSData*)catFile:(NSString*)address error:(NSError**)error;

@property (nonatomic,readonly) NSString *root;

@end
