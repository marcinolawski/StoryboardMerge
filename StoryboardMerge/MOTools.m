//
//  MOTools.m
//  StoryboardMerge
//
//  Created by Marcin Olawski on 14.01.2013.
//  Copyright (c) 2013 Marcin Olawski. All rights reserved.
//

#import "MOTools.h"

#pragma mark - String

NSString* MOStrFormat(NSString *format,...)
{
    va_list arguments;
    va_start(arguments,format);
    NSString *result = [[NSString alloc] initWithFormat:format arguments:arguments];
    va_end(arguments);
    return result;
}

#pragma mark - Alerts

void MOShowCriticalAlert(NSWindow *window, NSString *messageText, NSString *format,...)
{
    va_list arguments;
    va_start(arguments,format);
    format = [[NSString alloc] initWithFormat:format arguments:arguments];
    va_end(arguments);
    NSAlert *alert = [NSAlert alertWithMessageText:messageText
                                     defaultButton:nil
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"%@",format];
    alert.alertStyle = NSCriticalAlertStyle;
    [alert beginSheetModalForWindow:window modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

