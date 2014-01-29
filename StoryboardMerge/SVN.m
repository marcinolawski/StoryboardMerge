//
//  SVN.m
//  StoryboardMerge
//
//  Created by Marcin Olawski on 22.03.2013.
//  Copyright (c) 2013 Marcin Olawski. All rights reserved.
//

#import "SVN.h"
#import "NSError+MO.h"
#import "MOTools.h"

#pragma mark - Functions

TaskResult* LaunchTask(NSString *launchPath, NSString* currentDir, NSArray *arguments){
    NSTask *task = [NSTask new];
    task.launchPath = launchPath;
    task.arguments = arguments;
    if (currentDir)
        task.currentDirectoryPath = currentDir;
    task.standardOutput = [NSPipe pipe];
    task.standardError = [NSPipe pipe];
    [task launch];
    [task waitUntilExit];
    TaskResult *result = [TaskResult new];
    result.terminationStatus = task.terminationStatus;
    NSData *errorData = [[task.standardError fileHandleForReading] readDataToEndOfFile];
    if (errorData.length>4)
        result.errorString = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
    result.outputData = [[task.standardOutput fileHandleForReading] readDataToEndOfFile];
    return result;
}

#pragma mark - TaskResult

@implementation TaskResult

- (NSString*)outputString{
    return [[NSString alloc] initWithData:self.outputData encoding:NSUTF8StringEncoding];
}

@end

#pragma mark - SVN

@implementation SVN

#pragma mark - Private methods

+ (TaskResult*)_launchTaskWithArguments:(NSArray*)arguments currentDirectory:(NSString*)dir{
    return LaunchTask(@"/Applications/Xcode.app/Contents/Developer/usr/bin/svn", dir, arguments);//!!
}

#pragma mark - Init

- (id)initWithRoot:(NSString *)path{
    self = [super init];
    if (self){
        _root = [path copy];
    }
    return self;
}

#pragma mark - Static methods

+ (NSString*)findRoot:(NSString*)path{
    NSString *dir = nil;
    NSFileManager *fileMen = [NSFileManager defaultManager];
    NSString *rootDir;
    while (path.length>1) {
        rootDir = [path stringByAppendingPathComponent:@".svn"];
        if ([fileMen fileExistsAtPath:rootDir])
            dir = path;
        path = [path stringByDeletingLastPathComponent];
    }
    
    //if (![dir hasSuffix:@"/"]) return MOStrFormat(@"%@/",dir);
    if (dir)
        return dir;
    
    return nil;
}


+ (BOOL)isFileInRepository:(NSString*)_path{
    TaskResult *res;
    NSArray* args = @[@"info",_path];
    res = [SVN _launchTaskWithArguments:args currentDirectory:nil];
    return (res.terminationStatus==0);
}

#pragma mark -

- (NSString*)root{
    return _root;
}


- (NSData*)catFile:(NSString*)address error:(NSError**)error{
    if ([address hasPrefix:@"svn:"])
        address = [address substringFromIndex:4];
    NSArray* args = @[@"cat",address];
    TaskResult *res;
    res = [SVN _launchTaskWithArguments:args currentDirectory:_root];
    int status = res.terminationStatus;
    if (status==0){
        return res.outputData;
    }else{
        if (error)
            *error = [NSError errorWithDomain:RevisionControlErrorDomain code:status description:res.errorString];
        return nil;
    }
}

#pragma mark - NSObject

- (NSString*)description{
    return  @"SVN";
}


@end
