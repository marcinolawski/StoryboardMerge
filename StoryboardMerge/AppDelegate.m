//
//  AppDelegate.m
//  StoryboardMerge
//
//  Created by Marcin Olawski on 10.01.2013.
//  Copyright (c) 2013 Marcin Olawski. All rights reserved.
//

#import <CrashReporter/CrashReporter.h>

#import "AppDelegate.h"
#import "DocumentsWinCtrl.h"
#import "MOXStoryboard.h"
#import "MOTools.h"
#import "SVN.h"
#import "Git.h"


//TODO: Aktywnosc butt. Open. Wykrywaj czy dokument XML.

@implementation AppDelegate


#pragma mark - Private methods

-(void)_windowWillCloseNotification:(NSNotification *)notification{
    NSWindowController * wc = [notification.object windowController];
    if ([wc isKindOfClass:[DocumentsWinCtrl class]]){
        dispatch_queue_t queue = dispatch_get_main_queue();
        dispatch_async(queue, ^{
            [windowControllers removeObject:wc];
        });
        [NSApp setMenu:_window.menu];
    }
}

- (void)_revisionControlCheck{
    NSString *path = [_path0TextField stringValue];
    _revisionCtrl = [RevisionControl revisionControlForFile:path];
    if (_revisionCtrl){
        _revisionCtrlButton.title = [_revisionCtrl description];
        _revisionCtrlButton.hidden = NO;
    }else
        _revisionCtrlButton.hidden = YES;
    
    //Jesli path1TextField zaczyna sie od svn lub git to dla bezpieczenstwa czyscimy go
    NSString *path1 = _path1TextField.stringValue;
    if([path1 hasPrefix:@"svn:"] || [path1 hasPrefix:@"git:"])
        _path1TextField.stringValue = @"";
    
}

#pragma mark - Application Delegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _window.delegate = self;
    isClosed = YES;
    [_window registerForDraggedTypes:@[NSFilenamesPboardType]];
    windowControllers = [NSMutableArray new];
    _path0TextField.delegate = (id)self;
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(_windowWillCloseNotification:) name:NSWindowWillCloseNotification object:nil];
    //[center addObserver:self selector:@selector(controlTextDidChange:) name:NSControlTextDidChangeNotification object:_path0TextField];
}

#pragma mark - Crash reporting

- (void)enableCrashReporter
{
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    NSError *error;
    
    /* Check if we previously crashed */
    if ([crashReporter hasPendingCrashReport])
        [self saveCrashReport];
    
    /* Enable the Crash Reporter */
    BOOL crashEnabled = [crashReporter enableCrashReporterAndReturnError: &error];
    MOIfErrorShowAlertSheetAndReturn(crashEnabled,error,self.window,);
    
}

- (BOOL)saveCrashReport
{
    NSSavePanel* saveDlg = [NSSavePanel savePanel];
    saveDlg.allowedFileTypes = @[@"crep"];
    if ( [saveDlg runModal] == NSOKButton ){
        PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
        NSError *error;
        NSData *data = [crashReporter loadPendingCrashReportDataAndReturnError:&error];
        MOIfErrorShowAlertSheetAndReturn(data,error,self.window,NO);
        BOOL wroteOk = [data writeToURL:[saveDlg URL] options:NSDataWritingAtomic error:&error];
        MOIfErrorShowAlertSheetAndReturn(wroteOk,error,self.window,NO);
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - Window Delegate

- (void)windowDidBecomeMain:(NSNotification *)notification{
    [NSApp setMenu:_window.menu];
    if (isClosed){
        NSArray *args = [[NSProcessInfo processInfo] arguments];
      
        //Be aware that when debugging Xcode will add 2 extra arguments into the app at the end of the arguments passed through the current Scheme.
        if ([args count] >= 5) {
            NSString *leftPath = [self resolvedPathFromWorkingDirectory:args[1] forFile:args[2]];
            NSString *rightPath = [self resolvedPathFromWorkingDirectory:args[1] forFile:args[3]];
            NSString *destinationPath = [self resolvedPathFromWorkingDirectory:args[1] forFile:args[4]];
            
            self.saveURL = [NSURL fileURLWithPath:destinationPath];
            
            _path0TextField.stringValue = leftPath;
            _path1TextField.stringValue = rightPath;
        } else {
            _path0TextField.stringValue = @"";
            _path1TextField.stringValue = @"";
        }
    }
    isClosed = NO;
}

- (NSString *)resolvedPathFromWorkingDirectory:(NSString *)workingDirectory forFile:(NSString *)filePath
{
    NSString *returnedPath;
    if ([filePath hasPrefix:@"."]) {
        
        returnedPath = [NSString stringWithFormat:@"%@%@",workingDirectory,[filePath substringFromIndex:1]];
        
    } else if(![filePath hasPrefix:@"/"]) {
        
        returnedPath = [NSString stringWithFormat:@"%@/%@",workingDirectory,filePath];
        
    } else {
        returnedPath = filePath;
    }
    return returnedPath;
}

- (void)windowWillClose:(NSNotification *)notification{
    isClosed = YES;
}

#pragma mark - NSControl (NSTextField) Delegate

- (void)controlTextDidChange:(NSNotification *)notification {
    if (notification.object==_path0TextField){
        [self _revisionControlCheck];
    }
}

#pragma mark - Actions

- (IBAction)openButtonPressed:(id)sender {
    NSError *error;
    MOXStoryboard *story0 = [[MOXStoryboard alloc] initWithContentsOfFile:_path0TextField.stringValue error:&error];
    MOIfErrorShowAlertSheetAndReturn(story0,error,_window,);
    MOXStoryboard *story1;
    story1 = [[MOXStoryboard alloc] initWithContentsOfFile:_path1TextField.stringValue error:&error];
    MOIfErrorShowAlertSheetAndReturn(story1,error,_window,);
  
    
    NSWindowController *ctrl = [[DocumentsWinCtrl alloc]initWithStorybords:@[story0,story1]];
    
    [windowControllers addObject:ctrl];
    [_window close];
    [ctrl showWindow:self];
}

- (IBAction)revisionControlPressed:(id)sender {
    NSString *address;
    if (_revisionCtrl){
        address = [_path0TextField.stringValue substringFromIndex:_revisionCtrl.root.length+1];
    }
    
    if ([_revisionCtrl isKindOfClass:[SVN class]])
        _path1TextField.stringValue = MOStrFormat(@"svn:%@",address);
    if ([_revisionCtrl isKindOfClass:[Git class]])
        _path1TextField.stringValue = MOStrFormat(@"git:%@",address);
}

- (IBAction)openPanelAction:(NSButton*)sender {
    NSTextField *textField;
    textField = sender.tag ?  _path1TextField : _path0TextField;
    
    NSOpenPanel *openDlg = [NSOpenPanel openPanel];
    openDlg.allowedFileTypes = @[@"storyboard"];
    if ( [openDlg runModal] == NSOKButton ){
        textField.stringValue = [[openDlg URL] path];
        if (sender.tag==0)
            [self _revisionControlCheck];
    }
}

- (IBAction)openDocument:(id)sender{
    [self.window makeKeyAndOrderFront:sender];
}

- (IBAction)detectRevisionControl:(id)sender {
    NSString *path = _path0TextField.stringValue;
    RevisionControl *rc;
    rc=[RevisionControl revisionControlForFile:path];
    if (!rc)
    {
        path = [path stringByDeletingLastPathComponent];
        NSAlert* alert=[NSAlert alertWithMessageText:@"Not a svn/git repository."
                                      defaultButton:nil
                                    alternateButton:nil
                                        otherButton:nil
                          informativeTextWithFormat:@"Cannot find .svn or .git directory in %@ or in any of the parent directories.",path];
        [alert beginSheetModalForWindow:_window modalDelegate:nil didEndSelector:nil contextInfo:nil];
    }
}


@end
