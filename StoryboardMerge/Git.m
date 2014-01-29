//
//  Git.m
//  StoryboardMerge
//
//  Created by Marcin Olawski on 22.03.2013.
//  Copyright (c) 2013 Marcin Olawski. All rights reserved.
//

#import "Git.h"
#import "SVN.h"
#import "NSError+MO.h"
#import "MOTools.h"

@implementation Git

#pragma mark - Private methods

+ (TaskResult*)_launchTaskWithArguments:(NSArray*)arguments currentDirectory:(NSString*)dir{
    return LaunchTask(@"/Applications/Xcode.app/Contents/Developer/usr/bin/git", dir, arguments);//!!
}

#pragma mark - Static methods

+ (NSString*)findRoot:(NSString*)path{
    NSFileManager *fileMen = [NSFileManager defaultManager];
    NSString *gitDir;
    while (path.length>1) {
        gitDir = [path stringByAppendingPathComponent:@".git"];
        if ([fileMen fileExistsAtPath:gitDir])
            return path;
        path = [path stringByDeletingLastPathComponent];
    }
    return nil;
}

+ (BOOL)isFileInRepository:(NSString*)path{
    NSString *gitDir = [Git findRoot:path];
    if (!gitDir)
        return NO;
    NSString* currentDir = gitDir;
    path = [path substringFromIndex:gitDir.length+1];
    NSArray *args = @[@"show",path];
    TaskResult *tr;
    tr = [Git _launchTaskWithArguments:args currentDirectory:currentDir];
    return (tr.terminationStatus==0);
}

#pragma mark - Inherited methods

- (NSString*)description{
    return @"Git";
}

#pragma mark -

- (NSData*)catFile:(NSString*)address error:(NSError**)error{
    if ([address hasPrefix:@"git:"])
        address = [address substringFromIndex:4];
    NSArray* args = @[@"cat-file", @"-p", MOStrFormat(@"master:%@",address)];
    TaskResult *res;
    res = [Git _launchTaskWithArguments:args currentDirectory:_root];
    int status = res.terminationStatus;
    if (status==0){
        return res.outputData;
    }else{
        if (error)
            *error = [NSError errorWithDomain:RevisionControlErrorDomain code:status description:res.errorString];
        return nil;
    }
}

@end
