//
//  MergeStoryboardView.h
//  StoryboardMerge
//
//  Created by Marcin Olawski on 10.02.2013.
//  Copyright (c) 2013 Marcin Olawski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ACEView/ACEView.h>
#import "MOXStoryboard.h"
#import "DMTabBar.h"

@class DocumentsWinCtrl;

@interface MergeStoryboardView : NSSplitView{
    __weak DocumentsWinCtrl *_mainWindowController;
    __weak MOXStoryboard* _storyboard;
    __weak NSTextField *_filenameTextField;
    __weak NSOutlineView *_storyOutView;
    __weak DMTabBar *_tabBar;
    __weak NSTabView *_tabView;
    __weak ACEView *_xmlView;
    __weak WebView *_warningsView;
}

@property (nonatomic,weak) MOXStoryboard* storyboard;

+ (id)viewWithOwner:(id)owner;

@property (weak) DocumentsWinCtrl *mainWindowController;
@property (weak) IBOutlet NSOutlineView *storyOutView;
@property (weak) IBOutlet NSTableView *attributesTabView;
@property (weak) IBOutlet NSTextField *filenameTextField;
@property (weak) IBOutlet DMTabBar *tabBar;
@property (weak) IBOutlet NSTabView *tabView;
@property (weak) IBOutlet ACEView *xmlView;
@property (weak) IBOutlet WebView *warningsView;
@end

#pragma mark - NSOutlineView category

@interface NSOutlineView (Storyboard)

- (void)selectNode:(NSXMLNode*)node;
- (id)selectedItem;
- (void)nextElement:(NSInteger)type direction:(NSInteger)direction;

@end

#pragma mark - Functions

MergeStoryboardView* ParentStoryboardView(NSView *view);