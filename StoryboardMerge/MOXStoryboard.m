//
//  MOXStoryboard.m
//  StoryboardMerge
//
//  Created by Marcin Olawski on 13.01.2013.
//  Copyright (c) 2013 Marcin Olawski. All rights reserved.
//

#import "MOXStoryboard.h"
#import "MOXElement.h"

@implementation MOXStoryboard

#pragma mark - Functions

NSString* PrettyName(NSString* name){
    if (!name)
        return nil;
    
    static NSMutableDictionary* cache = nil;
    if (!cache)
        cache = [NSMutableDictionary new];
    NSString *cachedPrettyName = cache[name];
    if (cachedPrettyName)
        return cachedPrettyName;
    
    NSUInteger len = name.length;
    unichar ch = [[name uppercaseString] characterAtIndex:0];
    NSMutableString* prettyName = [[NSMutableString alloc] initWithCharacters:&ch length:1];
    for(NSUInteger i=1;i<len;i++){
        unichar ch = [name characterAtIndex:i];
        if ([[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:ch])
            [prettyName appendFormat:@" %c",ch];
        else
            [prettyName appendFormat:@"%c",ch];
    }
    [cache setObject:[prettyName copy] forKey:name];
    return [prettyName copy];
}

#pragma mark - Init

- (id)initWithContentsOfFile:(NSString *)path error:(NSError **)errorPtr{
    path = [path stringByExpandingTildeInPath];
    NSData *data = [NSData dataWithContentsOfFile:path options:0 error:errorPtr];
    if (!data)
        return nil; 
    self = [super initWithData:data options:0 error:errorPtr];
    if (self){
        self.url = [NSURL fileURLWithPath:path];
        NSFileManager *man = [NSFileManager defaultManager];
        self.modificationDate = [man attributesOfItemAtPath:path error:nil][NSFileModificationDate];
    }
    return self;
}

- (id)initWithContentsOfURL:(NSURL *)url error:(NSError **)error{
    self = [super initWithContentsOfURL:url options:0 error:error];
    if (self){
        self.url = url;
        NSFileManager *man = [NSFileManager defaultManager];
        self.modificationDate = [man attributesOfItemAtPath:url.path error:nil][NSFileModificationDate];
    }
    return self;
}



#pragma mark - NSXMLDocument

+ (Class)replacementClassForClass:(Class)class{
    if (class==[NSXMLElement class] )
        return [MOXElement class];
    if (class==[NSXMLDocument class])
        return [MOXStoryboard class];
    
    return class;
}

- (MOXElement *)rootElement{
    return (MOXElement*)super.rootElement;
}

- (NSData *)XMLData{
    return [super XMLDataWithOptions:NSXMLNodePrettyPrint|NSXMLNodeCompactEmptyElement];
}

#pragma mark - Merging / Comparing

- (void)_setAutomaticMergeActions:(MOXStoryboard*)storyboard{
    MOXElement *element;
    for (element in [self.rootElement elementsWithDiffs:MOXDiffExtraNode])
        element.actionMask = MOXMergeActionMerge;
    
    for (element in [storyboard.rootElement elementsWithDiffs:MOXDiffExtraNode])
        element.actionMask = MOXMergeActionMerge;
    
    for (element in [self.rootElement elementsWithDiffs:MOXDiffNodesUnequal])
        element.actionMask = MOXMergeActionNoMerge|MOXMergeActionAtributesOnly;
    
    for (element in [storyboard.rootElement elementsWithDiffs:MOXDiffNodesUnequal])
        element.actionMask = MOXMergeActionMerge|MOXMergeActionAtributesOnly;
}

- (void)compareStoryboards:(MOXStoryboard *)storyboard{
    BOOL recompare = NO; //porownywany ponownie
    
    if (self.rootElement.diff!=MOXDiffNodesEqual){
        recompare = YES;
        [self.rootElement clearDiff];
        [storyboard.rootElement clearDiff];
    }
    
    [self.rootElement findCousinAndCompare:storyboard.rootElement];
    [storyboard.rootElement findCousinAndCompare:self.rootElement];
    
    if (!recompare)
        [self _setAutomaticMergeActions:storyboard];
}

- (void)merge:(MOXStoryboard*)storyboard{
    NSString *xpath;
    MOXElement *parent, *cousin;
    
    NSArray *elements = [storyboard.rootElement elementsWithMergeAction:MOXMergeActionMerge];
    for (MOXElement* element in elements){
        xpath = [element.parent absoluteXpathForCousin];
        parent = [self.rootElement nodeForXPath:xpath error:nil];//!! zalogowac
        if (parent){
            [parent copyChild:element];
            element.actionMask = MOXMergeActionNone;
        }
    }
    
    elements = [storyboard.rootElement elementsWithMergeAction:MOXMergeActionMerge|MOXMergeActionAtributesOnly];
    for (MOXElement* element in elements){
        xpath = [element absoluteXpathForCousin];
        cousin = [self.rootElement nodeForXPath:xpath error:nil];
        if (cousin){
            NSArray *attributes = [[NSArray alloc] initWithArray:element.attributes copyItems:YES];
            [cousin setAttributes:attributes];
            element.actionMask = MOXMergeActionNone;
            cousin.actionMask = MOXMergeActionNone;
        }
    }
    
    elements = [self.rootElement elementsWithMergeAction:MOXMergeActionNoMerge];
    for (MOXElement* element in elements)
        [element.parent removeChild:element];
}

#pragma mark -

- (NSUInteger)validate{
    NSUInteger warnings;
    warnings = [self.rootElement validate:self];
    return warnings;
}

@end
