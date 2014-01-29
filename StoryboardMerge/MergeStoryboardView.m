//
//  MergeStoryboardView.m
//  StoryboardMerge
//
//  Created by Marcin Olawski on 10.02.2013.
//  Copyright (c) 2013 Marcin Olawski. All rights reserved.
//

#import "MergeStoryboardView.h"
#import "ACEView+MO.h"
#import "DocumentsWinCtrl.h"
#import "MOTools.h"

MergeStoryboardView* ParentStoryboardView(NSView *view){
    NSView *superview = view.superview;
    while (superview) {
        if ([superview isKindOfClass:[MergeStoryboardView class]])
            return (id)superview;
        superview=superview.superview;
    }
    return nil;
}

@implementation MergeStoryboardView

@synthesize storyboard=_storyboard;

#pragma mark - Init

+ (id)viewWithOwner:(id)owner{
    static NSNib *nib = nil;
    if (!nib)
        nib = [[NSNib alloc] initWithNibNamed:@"MergeStoryboardView" bundle:nil];
    NSArray *nibObjects;
    BOOL loaded = [nib instantiateWithOwner:owner topLevelObjects:&nibObjects];
    if ( loaded ){
        for (id object in nibObjects)
            if ([object isKindOfClass:[MergeStoryboardView class]]){
                [object viewAwakeFromNib];
                return object;
            }
    }
    return nil;//!!zaloguj
}

- (void)viewAwakeFromNib{
    //Setup tab bar
    NSImage *img = [NSImage imageNamed:@"NSListViewTemplate"];
    DMTabBarItem *item1 = [DMTabBarItem tabBarItemWithIcon:img tag:0];
    item1.toolTip = @"Attributes";
    
    img = [NSImage imageNamed:@"NSQuickLookTemplate"];
    DMTabBarItem *item2 = [DMTabBarItem tabBarItemWithIcon:img tag:1];
    item2.toolTip = @"XML";
    
    img = [NSImage imageNamed:@"WarningsTemplate"];
    DMTabBarItem *item3 = [DMTabBarItem tabBarItemWithIcon:img tag:2];
    item3.toolTip = @"Warnings";
    
    _tabBar.tabBarItems = @[item1,item2,item3];
    
    // Handle selection events
    [_tabBar handleTabBarItemSelection:^(DMTabBarItemSelectionType selectionType, DMTabBarItem *targetTabBarItem, NSUInteger targetTabBarItemIndex) {
        if(selectionType==1)
            [self tabBarItemSelection:targetTabBarItemIndex];
    }];
    
    //Setup ACEView
    [_xmlView setMode:ACEModeXML]; //!!!niekloruje
    [_xmlView setTheme:ACEThemeXcode];
    [_xmlView setShowInvisibles:NO];
    [_xmlView setFontSize:12];
    [_xmlView setReadOnly:YES];
    [_xmlView setPrintMarginColumn:NO];
    [_xmlView setShowGutter:NO];
    [_xmlView setHighlightActiveLine:NO];
    
    //Setup warings web view
    _warningsView.preferences.defaultFontSize=13;
    _warningsView.preferences.standardFontFamily = [NSFont systemFontOfSize:13].fontName;
    _warningsView.policyDelegate=self;
    
    //Storyoutview
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(outlineViewSelectionDidChange:)
                   name:@"NSOutlineViewSelectionDidChangeNotification"
                 object:_storyOutView];
}

#pragma mark - Web Policy Delegate

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id < WebPolicyDecisionListener >)listener
{
    NSString *url = [[request.URL description] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    if ([url isEqualToString:@"about:blank"])
        url = nil;
    if (url){
        NSXMLNode *missingNode = [[_mainWindowController.storyboards[0] rootElement] nodeForXPath:url error:nil];
        NSOutlineView *storyOutView = [_mainWindowController.storyViews[0] storyOutView];
        [storyOutView selectNode:missingNode];
        [self.window makeFirstResponder:storyOutView];
        [listener ignore];
    }
    else
        [listener use];
}

#pragma mark - Outline View

-(void)outlineViewSelectionDidChange:(NSNotification *)notification{
    if (_tabBar.selectedIndex>0)
        [self tabBarItemSelection:_tabBar.selectedIndex];
}

#pragma mark - Setters

- (void)setStoryboard:(MOXStoryboard*)story{
    _storyboard = story;
    NSString *filename;
    
    filename = story.url.resourceSpecifier.lastPathComponent;
    filename = [filename stringByDeletingPathExtension];
    if (![story.url.scheme isEqualTo:@"file"])
        filename = MOStrFormat(@"%@:%@",story.url.scheme,filename);
    
    if (story.modificationDate){
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        NSString *date;
        date = [formatter stringFromDate:story.modificationDate];
        filename = [NSString stringWithFormat:@"%@ (%@)",filename, date];
    }
    _filenameTextField.stringValue = filename;
}

#pragma mark - Others

- (void)reloadData{
    [self.storyOutView reloadData];
    [self.attributesTabView reloadData];
}

- (void)tabBarItemSelection:(NSUInteger)itemIndex{
    if (itemIndex==1){
        NSXMLElement *element = [_storyOutView selectedItem];
        element = [element copy];
        if (element){
            MOXStoryboard *doc =[[MOXStoryboard alloc] initWithRootElement:element];
            NSString *storyStr = [[NSString alloc] initWithData:[doc XMLData] encoding:NSUTF8StringEncoding];
            _xmlView.string = storyStr;
        }
    }
    
    if (itemIndex==2){
        MOXElement *element = [_storyOutView selectedItem];
        if (element){
            [[_warningsView mainFrame] loadHTMLString:[element warningsString] baseURL:nil];
        }
    }
    
    [_tabView selectTabViewItemAtIndex:itemIndex];
}

@end


#pragma mark - NSOutlineView category

@implementation NSOutlineView (Storyboard)

- (void)selectNode:(NSXMLNode*)node{
    if (!node) return;
    NSArray *family = node.family;
    for (int i=0;i<family.count-1;i++){
        [self expandItem:family[i]];
    }
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[self rowForItem:node]];
    [self selectRowIndexes:indexSet byExtendingSelection:NO];
}

- (id)selectedItem{
    return [self itemAtRow:[self selectedRow]];
}

- (void)nextElement:(NSInteger)type direction:(NSInteger)direction{
    MOXElement *elem = [self selectedItem];
    if (!elem)
        elem = [self itemAtRow:0];
    while( true ){
        elem = (MOXElement*)(direction>0 ? elem.nextNode:elem.previousNode);
        if (!elem)
            return;
        if (!elem.isElement)
            continue;
        if (type==0){
            if (elem.diff==MOXDiffNodesUnequal || elem.diff==MOXDiffExtraNode)
                break;
        }else{
            if(elem.warningsCount>0)
                break;
        }
    }
    [self selectNode:elem];
}

@end
