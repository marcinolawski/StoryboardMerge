//
//  ACEView.m
//  ACEView
//
//  Created by Michael Robinson on 26/08/12.
//  Copyright (c) 2012 Code of Interest. All rights reserved.
//

#import <ACEView/ACEView.h>
#import <ACEView/ACEModeNames.h>
#import <ACEView/ACEThemeNames.h>
#import <ACEView/ACERange.h>
#import <ACEView/ACEStringFromBool.h>

#import <ACEView/NSString+EscapeForJavaScript.h>
#import <ACEView/NSInvocation+MainThread.h>

#define ACE_JAVASCRIPT_DIRECTORY @"___ACE_VIEW_JAVASCRIPT_DIRECTORY___"

#pragma mark - ACEViewDelegate
NSString *const ACETextDidEndEditingNotification = @"ACETextDidEndEditingNotification";

#pragma mark - ACEView private
static NSArray *allowedSelectorNamesForJavaScript;

@interface ACEView()

- (NSString *) stringByEvaluatingJavaScriptOnMainThreadFromString:(NSString *)script;
- (void) executeScriptsWhenLoaded:(NSArray *)scripts;
- (void) executeScriptWhenLoaded:(NSString *)script;

- (void) showFindInterface;
- (void) showReplaceInterface;

+ (NSArray *) allowedSelectorNamesForJavaScript;

- (void) aceTextDidChange;

@end

#pragma mark - ACEView implementation
@implementation ACEView

@synthesize firstSelectedRange, delegate;

#pragma mark - Internal
- (id) initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self == nil) {
        return nil;
    }
    
    webView = [[WebView alloc] init];
    [webView setFrameLoadDelegate:self];

    return self;
}

- (void) awakeFromNib {
    [self addSubview:webView];
    [self setBorderType:NSBezelBorder];
    
    textFinder = [[NSTextFinder alloc] init];
    [textFinder setClient:self];
    [textFinder setFindBarContainer:self];
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];

    // Unable to use pretty resource paths with CocoaPods
	//	NSString *javascriptDirectory = [[bundle pathForResource:@"ace" ofType:@"js" inDirectory:@"ace/javascript"] stringByDeletingLastPathComponent];
    NSString *javascriptDirectory = [[bundle pathForResource:@"ace" ofType:@"js"] stringByDeletingLastPathComponent];
    
	// Unable to use pretty resource paths with CocoaPods    
	//	NSString *htmlPath = [bundle pathForResource:@"index" ofType:@"html" inDirectory:@"ace"];
    NSString *htmlPath = [bundle pathForResource:@"index" ofType:@"html"];    
    NSString *html = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
	html = [html stringByReplacingOccurrencesOfString:ACE_JAVASCRIPT_DIRECTORY withString:javascriptDirectory];
    
    [[webView mainFrame] loadHTMLString:html baseURL:[bundle bundleURL]];
}
+ (BOOL) isSelectorExcludedFromWebScript:(SEL)aSelector {
    return ![[ACEView allowedSelectorNamesForJavaScript] containsObject:NSStringFromSelector(aSelector)];
}

#pragma mark - NSView overrides
- (void) resizeSubviewsWithOldSize:(NSSize)oldBoundsSize {
    NSRect bounds = [self bounds];

    id<NSTextFinderBarContainer> findBarContainer = [textFinder findBarContainer];
    if ([findBarContainer isFindBarVisible]) {
        CGFloat findBarHeight = [[findBarContainer findBarView] frame].size.height;
        bounds.origin.y += findBarHeight;
        bounds.size.height -= findBarHeight;
    }
    
    [webView setFrame:NSMakeRect(bounds.origin.x + 1, bounds.origin.y + 1,
                                 bounds.size.width - 2, bounds.size.height - 2)];
}

#pragma mark - WebView delegate methods
- (void) webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {    
    [[webView windowScriptObject] setValue:self forKey:@"ACEView"];
}

#pragma mark - NSTextFinderClient methods
- (void) performTextFinderAction:(id)sender {
    [textFinder performAction:[sender tag]];
}
- (void) scrollRangeToVisible:(NSRange)range {
    firstSelectedRange = range;
    [self executeScriptWhenLoaded:[NSString stringWithFormat:
                                   @"editor.session.selection.clearSelection();"
                                   @"editor.session.selection.setRange(new Range(%@));"
                                   @"editor.centerSelection()",
                                   ACEStringFromRangeAndString(range, [self string])]];
}
- (void) replaceCharactersInRange:(NSRange)range withString:(NSString *)string {
    [self executeScriptWhenLoaded:[NSString stringWithFormat:@"editor.session.replace(new Range(%@), \"%@\");",
                                    ACEStringFromRangeAndString(range, [self string]), [string stringByEscapingForJavaScript]]];
}
- (BOOL) isEditable {
    return YES;
}

#pragma mark - Private
- (NSString *) stringByEvaluatingJavaScriptOnMainThreadFromString:(NSString *)script {
    SEL stringByEvaluatingJavascriptFromString = @selector(stringByEvaluatingJavaScriptFromString:);
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                [[webView class] instanceMethodSignatureForSelector:stringByEvaluatingJavascriptFromString]];
    [invocation setSelector:stringByEvaluatingJavascriptFromString];

    [invocation setArgument:&script atIndex:2];
    [invocation setTarget:webView];
    [invocation invokeOnMainThread];
    
    NSString *contentString;
    [invocation getReturnValue:&contentString];
    
    return contentString;
}
- (void) executeScriptsWhenLoaded:(NSArray *)scripts {
    if ([webView isLoading]) {
        [self performSelector:@selector(executeScriptsWhenLoaded:) withObject:scripts afterDelay:0.2];
        return;
    }
    [scripts enumerateObjectsUsingBlock:^(id script, NSUInteger index, BOOL *stop) {
        [webView stringByEvaluatingJavaScriptFromString:script];
    }];
}
- (void) executeScriptWhenLoaded:(NSString *)script {
    [self executeScriptsWhenLoaded:@[script]];
}

- (void) showFindInterface {
    [textFinder performAction:NSTextFinderActionShowFindInterface];
}
- (void) showReplaceInterface {
    [textFinder performAction:NSTextFinderActionShowReplaceInterface];
}

+ (NSArray *) allowedSelectorNamesForJavaScript {
    if (allowedSelectorNamesForJavaScript == nil) {
        allowedSelectorNamesForJavaScript = @[
            @"showFindInterface",
            @"showReplaceInterface",
            @"aceTextDidChange"
        ];
    }
    return [allowedSelectorNamesForJavaScript retain];
}

- (void) aceTextDidChange {
    NSNotification *textDidChangeNotification = [NSNotification notificationWithName:ACETextDidEndEditingNotification
                                                                              object:self];
    [[NSNotificationCenter defaultCenter] postNotification:textDidChangeNotification];
    if (self.delegate == nil) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(textDidChange:)]) {
        [self.delegate performSelector:@selector(textDidChange:) withObject:textDidChangeNotification];
    }
}

#pragma mark - Public
- (NSString *) string {
    return [self stringByEvaluatingJavaScriptOnMainThreadFromString:@"editor.getValue();"];
}
- (void) setString:(id)string {
    [self executeScriptsWhenLoaded:@[
        @"reportChanges = false;",
        [NSString stringWithFormat:@"editor.setValue(\"%@\");", [string stringByEscapingForJavaScript]],
        @"editor.clearSelection();",
        @"editor.moveCursorTo(0, 0);",
        @"reportChanges = true;",
        @"ACEView.aceTextDidChange();"
    ]];
}

- (void) setMode:(ACEMode)mode {
    [self executeScriptWhenLoaded:[NSString stringWithFormat:@"editor.getSession().setMode(\"ace/mode/%@\");", [ACEModeNames nameForMode:mode]]];
}
- (void) setTheme:(ACETheme)theme {
    [self executeScriptWhenLoaded:[NSString stringWithFormat:@"editor.setTheme(\"ace/theme/%@\");", [ACEThemeNames nameForTheme:theme]]];
}

- (void) setWrappingBehavioursEnabled:(BOOL)wrap {
    [self executeScriptWhenLoaded:[NSString stringWithFormat:@"editor.setWrapBehavioursEnabled(%@);", ACEStringFromBool(wrap)]];
}
- (void) setUseSoftWrap:(BOOL)wrap {
    [self executeScriptWhenLoaded:[NSString stringWithFormat:@"editor.getSession().setUseWrapMode(%@);", ACEStringFromBool(wrap)]];
}
- (void) setWrapLimitRange:(NSRange)range {
    [self setUseSoftWrap:YES];
    [self executeScriptWhenLoaded:[NSString stringWithFormat:@"editor.getSession().setWrapLimitRange(%ld, %ld);", range.location, range.length]];
}
- (void) setShowInvisibles:(BOOL)show {
    [self executeScriptWhenLoaded:[NSString stringWithFormat:@"editor.setShowInvisibles(%@);", ACEStringFromBool(show)]];
}
- (void) setShowFoldWidgets:(BOOL)show {
    [self executeScriptWhenLoaded:[NSString stringWithFormat:@"editor.setShowFoldWidgets(%@);", ACEStringFromBool(show)]];
}
- (void) setHighlightActiveLine:(BOOL)highlight {
    [self executeScriptWhenLoaded:[NSString stringWithFormat:@"editor.setHighlightActiveLine(%@);", ACEStringFromBool(highlight)]];
}
- (void) setHighlightGutterLine:(BOOL)highlight {
    [self executeScriptWhenLoaded:[NSString stringWithFormat:@"editor.setHighlightGutterLine(%@);", ACEStringFromBool(highlight)]];
}
- (void) setHighlightSelectedWord:(BOOL)highlight {
    [self executeScriptWhenLoaded:[NSString stringWithFormat:@"editor.setHighlightSelectedWord(%@);", ACEStringFromBool(highlight)]];
}
- (void) setDisplayIndentGuides:(BOOL)display {
    [self executeScriptWhenLoaded:[NSString stringWithFormat:@"editor.setDisplayIndentGuides(%@);", ACEStringFromBool(display)]];
}
- (void) setFadeFoldWidgets:(BOOL)fade {
    [self executeScriptWhenLoaded:[NSString stringWithFormat:@"editor.setFadeFoldWidgets(%@);", ACEStringFromBool(fade)]];
}
- (void) setAnimatedScroll:(BOOL)animate {
    [self executeScriptWhenLoaded:[NSString stringWithFormat:@"editor.setAnimatedScroll(%@);", ACEStringFromBool(animate)]];
}
- (void) setPrintMarginColumn:(NSUInteger)column {
    [self executeScriptWhenLoaded:[NSString stringWithFormat:@"editor.setPrintMarginColumn(%ld);", column]];
}
- (void) setScrollSpeed:(NSUInteger)speed {
    [self executeScriptWhenLoaded:[NSString stringWithFormat:@"editor.setScrollSpeed(%ld);", speed]];
}
- (void) setFontSize:(NSUInteger)size {
    [self executeScriptWhenLoaded:[NSString stringWithFormat:@"editor.setFontSize('%ldpx');", size]];
}

@end
