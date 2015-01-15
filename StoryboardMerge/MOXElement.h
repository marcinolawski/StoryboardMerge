//
//  MOXElement.h
//  StoryboardMerge
//
//  Created by Marcin Olawski on 16.01.2013.
//  Copyright (c) 2013 Marcin Olawski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSXMLNode+MOX.h"

@class MOXStoryboard;

#pragma mark - Constans

/*typedef enum {
    MOXDiffNodesEqual=0,
    MOXDiffNodesUnequal,
    MOXDiffNodesUnequalInherited,
    MOXDiffExtraNode,
    MOXDiffExtraNodeInherited
} MOXDiff;*/

typedef NSUInteger MOXDiff;
static const MOXDiff MOXDiffNodesEqual = 0;
static const MOXDiff MOXDiffNodesUnequal = 0x1;
static const MOXDiff MOXDiffExtraNode = 0x2;
static const MOXDiff MOXDiffInherited = 0x80000000;

typedef NSUInteger MOXMergeAction;
static const MOXMergeAction MOXMergeActionNone=0;
static const MOXMergeAction MOXMergeActionNoMerge=0x1;
static const MOXMergeAction MOXMergeActionMerge=0x2;
static const MOXMergeAction MOXMergeActionAtributesOnly=0x4;
static const MOXMergeAction MOXMergeActionInherited = 0x80000000;

typedef enum {
    MOXElementChangeTypeAddition,
    MOXElementChangeTypeRemoval,
    MOXElementChangeTypeAttributes
} MOXElementChangeType;

#pragma mark - Functions

NSString* NSStringFromDiff(MOXDiff diff);

#pragma mark - MOXElement

@interface MOXElement : NSXMLElement{
    MOXDiff _diff;
    NSMutableArray *_warnings;
}

- (NSString*)absoluteXpathForCousin;
- (MOXElement*)findCousin:(MOXElement*)uncle;
- (void)findCousinAndCompare:(MOXElement*)uncle;
- (BOOL)hasAttribute:(NSString*)attributeName withValue:(NSString*)value;
- (void)clearDiff;


#pragma mark - Storyboards Children
- (void)copyChild:(NSXMLNode *)child;

- (NSUInteger)storyboardChildCount;
- (NSArray*)storyboardChildren;
- (NSXMLNode *)storyboardChildAtIndex:(NSUInteger)index;
- (NSArray*)elementsWithDiffs:(MOXDiff)diff;
- (NSArray*)elementsWithMergeAction:(MOXMergeAction)mergeAction;
- (void)removeChild:(NSXMLNode *)child;

#pragma mark - Notifications
- (void)elementDidCopiedFrom:(MOXElement*)sourceElement;
- (void)elementWillBeRemoved;

#pragma mark - Warnings / Validation
- (NSUInteger)validate:(MOXStoryboard*)storyboard;
- (NSUInteger)warningsCount;
- (void)addWarning:(NSString *)warning;
- (NSString*)warningsString;

#pragma mark - Propertys

@property (nonatomic,readonly) NSArray* storyboardChildren;
@property (nonatomic) MOXDiff diff;
@property (nonatomic) MOXMergeAction actionMask;
@property (nonatomic,readonly) NSMutableArray *warnings;
@property (nonatomic,readonly) NSImage *icon;
@property (readonly, copy) MOXElement *parent;

@end
