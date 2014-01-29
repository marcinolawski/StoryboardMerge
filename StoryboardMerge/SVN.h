//
//  SVN.h
//  StoryboardMerge
//
//  Created by Marcin Olawski on 22.03.2013.
//  Copyright (c) 2013 Marcin Olawski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RevisionControl.h"

#pragma mark - TaskResult

@interface TaskResult : NSObject

@property (nonatomic) int terminationStatus;
@property (nonatomic,copy) NSString* errorString;
@property (nonatomic,readonly) NSString* outputString;
@property (nonatomic,copy) NSData* outputData;

@end

TaskResult* LaunchTask(NSString *launchPath, NSString* currentDir, NSArray *arguments);

#pragma mark - SVN

@interface SVN : RevisionControl{
    NSString* _root;
}

- (id)initWithRoot:(NSString *)path;

+ (NSString*)findRoot:(NSString*)path;
+ (BOOL)isFileInRepository:(NSString*)path;


@end
