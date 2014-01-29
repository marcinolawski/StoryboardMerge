//
//  DocumentsWinCtrl.h
//  StoryboardMerge
//
//  Created by Marcin Olawski on 11.01.2013.
//  Copyright (c) 2013 Marcin Olawski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MergeStoryboardView.h"
#import "MOPathControl.h"

@interface DocumentsWinCtrl : NSWindowController<NSTableViewDataSource>{
    NSArray *_storyboards;
    NSArray *_storyViews;
    BOOL nibLoaded;
    NSInteger _navigateTo;
    
    __weak NSSplitView *_splitView;
    __weak NSButton *_saveButton;
    __weak NSPopUpButton *_navigateToButton;
}

- (id)initWithStorybords:(NSArray *)storybords;

#pragma mark - Properties

@property (nonatomic) NSArray *storyViews;
@property (nonatomic) NSArray *storyboards;

#pragma mark - Outlets

@property (weak) IBOutlet NSSplitView *splitView;
@property (weak) IBOutlet NSButton *saveButton;
@property (weak) IBOutlet NSPopUpButton *navigateToButton;

#pragma mark - Actions

- (IBAction)reloadAction:(id)sender;
- (IBAction)mergeAction:(id)sender;
- (IBAction)saveAction:(id)sender;
- (IBAction)navigationAction:(NSSegmentedControl *)sender;
- (IBAction)navigateToChangeAction:(id)sender;


@end



