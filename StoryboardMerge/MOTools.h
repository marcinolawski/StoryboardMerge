//
//  MOTools.h
//  StoryboardMerge
//
//  Created by Marcin Olawski on 14.01.2013.
//  Copyright (c) 2013 Marcin Olawski. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Macros

#define MOIfErrorShowAlertSheetAndReturn(condition, error, window, ret) \
if (!(condition)) { [[NSAlert alertWithError:error] beginSheetModalForWindow:window modalDelegate:nil didEndSelector:nil contextInfo:nil]; return ret; }

#define MORaiseThisShouldNeverHappen() [NSException raise:@"InternalException" format:@"Internal error: %s,%d", __FILE__, __LINE__]; 

#pragma mark - Text

NSString* MOStrFormat(NSString *format,...) NS_FORMAT_FUNCTION(1,2);

#pragma mark - Alerts

void MOShowCriticalAlert(NSWindow *window, NSString *messageText, NSString *informativeTextFormat,...) NS_FORMAT_FUNCTION(3,4);