//
//  DocumentsWinCtrl.m
//  StoryboardMerge
//
//  Created by Marcin Olawski on 11.01.2013.
//  Copyright (c) 2013 Marcin Olawski. All rights reserved.
//

#import "DocumentsWinCtrl.h"
#import "MOTools.h"
#import "MOXStoryboard.h"
#import "MOXElement.h"

@interface DocumentsWinCtrl ()

@end

@implementation DocumentsWinCtrl


#pragma mark - Private methods

- (void)_loadStorybords{
    [_storyboards[1] compareStoryboards:_storyboards[0]];
    
    for(int i=0;i<2;i++){
        [_storyViews[i] setStoryboard:_storyboards[i]];
        [[_storyViews[i] storyOutView] reloadData];
    }
}


#pragma mark - Init

- (id)initWithStorybords:(NSArray *)storybords
{
    self = [super initWithWindowNibName:@"DocumentsWinCtrl"];
    if (self) {
        NSAssert(storybords.count==2,@"storybords.count!=2");
        _storyboards = [storybords copy];
    }
    return self;
}

- (void)awakeFromNib{
    if (!nibLoaded){ //<- bo MergeStoryboardView tez wola awakeFromNib
        nibLoaded = YES;
        _storyViews = @[[MergeStoryboardView viewWithOwner:self],[MergeStoryboardView viewWithOwner:self]];
        
        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
        int i = 0;
        for(MergeStoryboardView *storyView in _storyViews){
            storyView.storyOutView.tag = i;
            NSView *splitSubviews = _splitView.subviews[i++];
            storyView.frame = splitSubviews.bounds;
            [splitSubviews addSubview:storyView];
            storyView.storyOutView.target=self;
            storyView.storyOutView.doubleAction=@selector(outlineViewDoubleClicked:);
            storyView.mainWindowController = self;
            [center addObserver:self
                       selector:@selector(outlineViewSelectionDidChange:)
                           name:@"NSOutlineViewSelectionDidChangeNotification"
                         object:storyView.storyOutView];
            
            //Set Window title
            NSString *story0 = [[[_storyboards[0] url] resourceSpecifier] lastPathComponent];
            story0 = [story0 stringByDeletingPathExtension];
            NSString *story1 = [[[_storyboards[1] url] resourceSpecifier] lastPathComponent];
            story1 = [story1 stringByDeletingPathExtension];
            if ([story0 isEqualToString:story1])
                self.window.title = story0;
            else
                self.window.title = MOStrFormat(@"%@ vs. %@",story0, story1);
        }
    }
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [self _loadStorybords];
}

#pragma mark - Window Delegate

- (void)windowDidBecomeMain:(NSNotification *)notification{
    [NSApp setMenu:self.window.menu];
}

#pragma mark - Actions

- (IBAction)reloadAction:(id)sender {
    NSError *error;
    
    MOXStoryboard *story0 = [[MOXStoryboard alloc] initWithContentsOfURL:[_storyboards[0] url] error:&error];
    MOIfErrorShowAlertSheetAndReturn(story0,error,self.window,);
    MOXStoryboard *story1 = [[MOXStoryboard alloc] initWithContentsOfURL:[_storyboards[1] url] error:&error];
    MOIfErrorShowAlertSheetAndReturn(story1,error,self.window,);
    _storyboards = @[story0,story1];
    
    [self _loadStorybords];
}

- (IBAction)mergeAction:(id)sender {
    MOXStoryboard *storyboard0 = _storyboards[0];
    MOXStoryboard *storyboard1 = _storyboards[1];
    
    [storyboard1 merge:storyboard0];
    [storyboard1 compareStoryboards:storyboard0];
    NSUInteger warnings = [storyboard1 validate];
    [_storyViews[0] reloadData];
    [_storyViews[1] reloadData];
    _saveButton.enabled = YES;
    
    if (warnings){
        [_navigateToButton selectItemWithTag:1];
        NSString *msg = MOStrFormat(@"Merge with %ld warning%@.",warnings,(warnings>1?@"s":@""));
        MOShowCriticalAlert(self.window, msg, @"To view all errors use navigation buttons.");
    }
}

- (IBAction)saveAction:(id)sender {
    NSSavePanel* saveDlg = [NSSavePanel savePanel];
    saveDlg.allowedFileTypes = @[@"storyboard"];
    saveDlg.directoryURL = [_storyboards[1] url];
    if ( [saveDlg runModal] == NSOKButton ){
        NSLog(@"%@",[saveDlg URL]);
        NSData *data = [_storyboards[1] XMLData];
        NSError *error; BOOL r;
        r = [data writeToURL:[saveDlg URL] options:NSDataWritingAtomic error:&error];
        MOIfErrorShowAlertSheetAndReturn(r,error,self.window,)
    }
}

- (IBAction)navigationAction:(NSSegmentedControl *)sender {
    MergeStoryboardView *mergeView=nil;
    if (_navigateTo==0){
    if ([self.window.firstResponder isKindOfClass:[NSView class]])
        mergeView = ParentStoryboardView((id)self.window.firstResponder);
    }else{
        mergeView = _storyViews[1];
        [self.window makeFirstResponder:mergeView.storyOutView];
    }
    if (!mergeView)
        return;
    switch (sender.selectedSegment) {
        case 0:
            [mergeView.storyOutView nextElement:_navigateTo direction:-1];
            break;
        case 1:
            [mergeView.storyOutView nextElement:_navigateTo direction:1];
            break;
    }
}

- (IBAction)navigateToChangeAction:(NSMenuItem*)sender {
    _navigateTo = sender.tag;
}


#pragma mark - Outline View Data Source / Delegate / Notifications

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(MOXElement*)item{
    if (!item)
        return [ParentStoryboardView(outlineView).storyboard rootElement];
    return [item storyboardChildAtIndex:index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(MOXElement*)item{
    if (!item)
        return YES;
    return (item.storyboardChildCount>0);
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(MOXElement*)item{
    if (!item)
        return 1;
    return item.storyboardChildCount;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(MOXElement*)item{
    if (!item)
        item = (MOXElement*)[ParentStoryboardView(outlineView).storyboard rootElement];
    
    if ([@"description" isEqualToString:tableColumn.identifier])
        return [item description];
    
    if ([@"diff" isEqualToString:tableColumn.identifier])
        return NSStringFromDiff(item.diff);
    
    if ([@"merge" isEqualToString:tableColumn.identifier]){
        if (item.actionMask & MOXMergeActionMerge)
            return @1;
        if (item.actionMask & MOXMergeActionNoMerge)
            return @0;
        return nil;
    }
    
    return @"";
}

- (void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(MOXElement*)item{
    if ([@"merge" isEqualToString:tableColumn.identifier]){
        BOOL val = [object boolValue];
        item.actionMask = val ? MOXMergeActionMerge : MOXMergeActionNoMerge;
        if (item.diff==MOXDiffNodesUnequal){
            item.actionMask |= MOXMergeActionAtributesOnly;
            int i = (outlineView.tag+1) % 2;
            MOXStoryboard *story = _storyboards[i];
            MOXElement *cousin = [story.rootElement nodeForXPath:[item absoluteXpathForCousin] error:nil];
            cousin.actionMask = val ? MOXMergeActionNoMerge : MOXMergeActionMerge;
            cousin.actionMask |= MOXMergeActionAtributesOnly;
            [[_storyViews[i] storyOutView] reloadItem:cousin];
        }else if (item.diff==MOXDiffExtraNode){
            [outlineView reloadItem:item reloadChildren:YES];
        }
    }
}

- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(MOXElement*)item{
    if ([@"merge" isEqualToString:tableColumn.identifier]){
        [cell setEnabled:YES];
        if (item.diff==MOXDiffNodesUnequal || item.diff==MOXDiffExtraNode)
            [cell setImagePosition:NSImageOnly];
        else if (item.actionMask & MOXMergeActionInherited){
            [cell setImagePosition:NSImageOnly];
            [cell setEnabled:NO];
        }else
            [cell setImagePosition:NSNoImage];
    }else if ([@"description" isEqualToString:tableColumn.identifier]){
        NSColor *c = item.warningsCount>0 ? [NSColor redColor] : [NSColor blackColor];
        [cell setTextColor:c];
        [cell setImage:item.icon];
    }else if ([@"diff" isEqualToString:tableColumn.identifier]){
        NSColor *c = item.diff & MOXDiffInherited ? [NSColor grayColor] : [NSColor blackColor];
        [cell setTextColor:c];
    }
}

#pragma mark - Outline View Actions

-(void)outlineViewSelectionDidChange:(NSNotification *)notification{
    NSOutlineView *outlineView = notification.object;
    MergeStoryboardView *storyView = ParentStoryboardView(outlineView);
    [storyView.attributesTabView reloadData];
}

- (BOOL)_outlineViewDoubleClicked:(NSOutlineView *)outlineView item:(MOXElement*)item{
    int i = (outlineView.tag+1) % 2;
    
    NSString *xpath = item.absoluteXpathForCousin;
    MOXElement *cousin = (MOXElement*)[(MOXElement*)[_storyboards[i] rootElement] nodeForXPath:xpath error:nil];
    
    if (!cousin)
        return NO;
    
    NSOutlineView *cousinOutlineView = [_storyViews[i] storyOutView];
    [cousinOutlineView selectNode:cousin];
    [self.window makeFirstResponder:cousinOutlineView];
    return YES;
}

- (void)outlineViewDoubleClicked:(NSOutlineView *)outlineView {
    MOXElement* item = [outlineView itemAtRow:[outlineView selectedRow]];
    BOOL r, l;
    do {
        r = [self _outlineViewDoubleClicked:outlineView item:item];
        item = item.parent;
        l = (item.level>0);
    } while (r==NO & l==YES);
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView{
    MergeStoryboardView *storyView = ParentStoryboardView(aTableView);
    NSOutlineView *_storyOutView = storyView.storyOutView;
    MOXElement* selectedElement = [_storyOutView itemAtRow:[_storyOutView selectedRow]];
    return selectedElement.attributes.count;
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex{
    MergeStoryboardView *storyView = ParentStoryboardView(aTableView);
    NSOutlineView *_storyOutView = storyView.storyOutView;
    MOXElement* selectedElement = [_storyOutView itemAtRow:[_storyOutView selectedRow]];
    NSArray *attributes = selectedElement.attributes;
    NSXMLNode *attribute = nil;
    if (attributes.count>rowIndex)
        attribute = attributes[rowIndex];
    
    if ([@"attribute" isEqualToString:aTableColumn.identifier])
        return attribute.name;
    if ([@"value" isEqualToString:aTableColumn.identifier])
        return attribute.stringValue;
    
    return @"";
}



@end

