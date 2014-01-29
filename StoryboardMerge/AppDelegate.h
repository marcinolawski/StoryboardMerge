//
//  AppDelegate.h
//  StoryboardMerge
//
//  Created by Marcin Olawski on 10.01.2013.
//  Copyright (c) 2013 Marcin Olawski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RevisionControl.h"

@interface AppDelegate : NSObject <NSApplicationDelegate,NSWindowDelegate>{
    NSMutableArray *windowControllers;
    BOOL isClosed;
    RevisionControl *_revisionCtrl;
    
    __weak NSTextField *_path0TextField;
    __weak NSTextField *_path1TextField;
    __weak NSButton *_revisionCtrlButton;
}

@property (assign) IBOutlet NSWindow *window;


- (IBAction)openButtonPressed:(id)sender;
- (IBAction)revisionControlPressed:(id)sender;
- (IBAction)openPanelAction:(id)sender;
- (IBAction)openDocument:(id)sender;
- (IBAction)detectRevisionControl:(id)sender;


@property (weak) IBOutlet NSTextField *path0TextField;
@property (weak) IBOutlet NSTextField *path1TextField;
@property (weak) IBOutlet NSButton *revisionCtrlButton;
@end
