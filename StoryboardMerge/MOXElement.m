//
//  MOXElement.m
//  StoryboardMerge
//
//  Created by Marcin Olawski on 16.01.2013.
//  Copyright (c) 2013 Marcin Olawski. All rights reserved.
//

#import "MOXElement.h"
#import "MOXStoryboard.h"
#import "NSXMLNode+MOX.h"
#import "MOTools.h"

#define elementsIconsDict MOXElement_elementsIconsDict
#define ICONS_DIR @"/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/Xcode/PrivatePlugIns/IDEInterfaceBuilderCocoaTouchIntegration.ideplugin/Contents/Resources/"

NSMutableDictionary* elementsIconsDict = nil;


NSString* NSStringFromDiff(MOXDiff diff){
    if (diff & MOXDiffInherited)
        diff ^= MOXDiffInherited; //czyść inherited
    switch (diff) {
        case MOXDiffNodesEqual:
            return @"";
        case MOXDiffNodesUnequal:
            return @"≠";
        case MOXDiffExtraNode:
            return @"+";
        default:
            return @"?";
    }
}

#pragma mark - MOXElement

@implementation MOXElement

@synthesize warnings=_warnings;

#pragma mark - NSObject methods

- (NSString*)description{

    if ([self.name isEqualToString:@"scene"]){
        NSXMLNode *preceding = [self nodeForXPath:@"preceding-sibling::node()[1]" error:nil];
        if (preceding.kind==NSXMLCommentKind)
            return [NSString stringWithFormat:@"Scene - %@", preceding.stringValue];
    }
    
    if ([self.name isEqualToString:@"viewController"]){
        MOXElement *scene = (MOXElement*)self.parent.parent;
        MOXElement *scenes = (MOXElement*)scene.parent;
        NSUInteger idx = [scenes.children indexOfObject:scene];
        if (idx>0 && [scenes.children[idx-1] kind]==NSXMLCommentKind)
            return [scenes.children[idx-1] stringValue];
    }
    
    NSXMLNode *attribute;
    
    if ([self.name isEqualToString:@"class"]){
        attribute = [self attributeForName:@"className"];
        if (attribute)
            return [NSString stringWithFormat:@"Class - %@", attribute.stringValue];
    }
    
    if ([self.name isEqualToString:@"source"]){
        NSString *key = [self attributeForName:@"key"].stringValue;
        NSString *path = [self attributeForName:@"relativePath"].stringValue;
        if (key && path){
            path = [path lastPathComponent];
            return [NSString stringWithFormat:@"%@ - %@",PrettyName(key), path];
        }
    }
    
    attribute = [self attributeForName:@"userLabel"];
    if (attribute)
        return attribute.stringValue;
    
    NSString* title = nil;
    attribute = [self attributeForName:@"title"];
    if (attribute)
        title = PrettyName(attribute.stringValue);
    
    NSString* key = nil;
    attribute = [self attributeForName:@"key"];
    if (attribute)
        key = PrettyName(attribute.stringValue);
    
    if (key && title)
        return [NSString stringWithFormat:@"%@ - %@",key, title];
    if (key)
        return key;
    
    attribute = [self attributeForName:@"name"];
    if (attribute)
        return [NSString stringWithFormat:@"%@ - %@",PrettyName(self.name), attribute.stringValue];
    
    return PrettyName(self.name);
}

- (void)removeChildAtIndex:(NSUInteger)idx{
    MOXElement *elem = (MOXElement*)[self childAtIndex:idx];
    if ( [elem isKindOfClass:[MOXElement class]] )
        [elem elementWillBeRemoved];
    [super removeChildAtIndex:idx];
}

#pragma mark - Storyboards Children

- (NSUInteger)storyboardChildCount{
    if ([self.name isEqualToString:@"scenes"])
        return [[self nodesForXPath:(NSString *)@"*" error:nil] count];
    else
        return self.childCount;
}

- (NSArray*)storyboardChildren{
    if ([self.name isEqualToString:@"scenes"])
        return [self nodesForXPath:(NSString *)@"*" error:nil];
    else
        return self.children;
}

- (NSXMLNode *)storyboardChildAtIndex:(NSUInteger)index{
    if ([self.name isEqualToString:@"scenes"])
        return [self nodesForXPath:(NSString *)@"*" error:nil][index];
    else
        return [self childAtIndex:index];
}


- (void)_elementsWithParameter:(void*)parameter value:(NSUInteger)value array:(NSMutableArray*)array{
    if (parameter==@"diff"){
        if (self.diff==value)
            [array addObject:self];
    }else if(parameter==@"actionMask"){
        if (self.actionMask==value)
            [array addObject:self];
    }else
        [NSException raise:@"InternalException" format:@"Invalid parameter: %@", parameter];
    
    for (id child in self.children){
        if ([child isKindOfClass:[MOXElement class]])
            [child _elementsWithParameter:parameter value:value array:array];
    }
    
}

- (NSArray*)elementsWithDiffs:(MOXDiff)diff{
    NSMutableArray *array = [NSMutableArray new];
    [self _elementsWithParameter:@"diff" value:diff array:array];
    return array;
}

- (NSArray*)elementsWithMergeAction:(MOXMergeAction)mergeAction{
    NSMutableArray *array = [NSMutableArray new];
    [self _elementsWithParameter:@"actionMask" value:mergeAction array:array];
    return array;
}

- (void)copyChild:(NSXMLNode *)child{
    NSXMLNode *copiedChild = [child copy];
    [self addChild:copiedChild];
    if ([child isKindOfClass:[MOXElement class]])
        [(MOXElement*)copiedChild elementDidCopiedFrom:(MOXElement*)child];
}

- (void)removeChild:(NSXMLNode *)child{
    if (!child) return;
    NSUInteger i = child.index;
    if ([self childAtIndex:i]==child)
        [self removeChildAtIndex:i];
}

#pragma mark - Comparsion

- (NSString*)_xpathFromNameAndAttributesForNames:(NSArray*)attributes{
    NSXMLNode *atrr;
    int i=0;
    NSMutableString *attrStr = [NSMutableString new];
    for (NSString *attribute in attributes){
        if (i++>0)
            [attrStr appendString:@" and "];
        atrr = [self attributeForName:attribute];//!!co jak nie ma atrybutu
        [attrStr appendFormat:@"@%@='%@'",atrr.name,atrr.stringValue];
    }
    
    return [NSString stringWithFormat:@"%@[%@]",self.name,attrStr];
}

- (BOOL)_haveName:(NSString*)name andAtributesNames:(NSArray*)atributes{
    if (![self.name isEqualToString:name])
        return FALSE;
    for (NSString* atribute in atributes)
        if (![self attributeForName:atribute])
            return FALSE;
    return TRUE;
}

- (NSString*)xpathForCousin{
    NSString *idAtrr;
    
    if ([self.name isEqualToString:@"scenes"]){
        return @"scenes";
    }
    
    if ([self.name isEqualToString:@"document"]){
        return @"document";
    }
    
    if ([self.name isEqualToString:@"scene"]){
        idAtrr = [[self attributeForName:@"sceneID"] stringValue];
        return [NSString stringWithFormat:@"scene[@sceneID='%@']",idAtrr];
    }
    

    if ( [self _haveName:@"class" andAtributesNames:@[@"className"]] )
        return [self _xpathFromNameAndAttributesForNames:@[@"className"]];

    if ([self _haveName:@"relationship" andAtributesNames:@[@"kind",@"name"]])
         return [self _xpathFromNameAndAttributesForNames:@[@"kind",@"name"]];
    
    if ([self _haveName:@"plugIn" andAtributesNames:@[@"identifier"]])
        return [self _xpathFromNameAndAttributesForNames:@[@"identifier"]];
    
    idAtrr = [[self attributeForName:@"key"] stringValue];
    if (idAtrr)
        return [NSString stringWithFormat:@"%@[@key='%@']",self.name,idAtrr];
    
    idAtrr = [[self attributeForName:@"id"] stringValue];
    if (idAtrr)
        return [NSString stringWithFormat:@"%@[@id='%@']",self.name,idAtrr];
    
    if (self.attributes.count>0)
        NSLog(@"XpathForCousin: suspicious element %@",self.XPath);
    return [NSString stringWithFormat:@"%@",self.name];
}

- (NSString*)absoluteXpathForCousin{
    NSString *xpath = @"";
    MOXElement *parent = self;
    @autoreleasepool {
        while (parent.level>0) {
            xpath = [NSString stringWithFormat:@"/%@%@",parent.xpathForCousin,xpath];
            parent = parent.parent;
        }
    }
    return xpath;
}

-(MOXElement*)findCousin:(MOXElement*)uncle{
    if ([self.name isEqualToString:uncle.name])
        return uncle;
    
    NSString *xpath = [self xpathForCousin];
    
    NSError *error = nil;
    NSArray *foundNodes = [uncle nodesForXPath:xpath error:&error];
    if (error)
        [NSException raise:@"XPathException" format:@"XPath error:%@", error.localizedDescription];
    if (foundNodes.count==0)
        return nil;
    if (foundNodes.count>1)
        [NSException raise:@"XPathException" format:@"Too many rows"];
    return foundNodes[0];
}

-(BOOL)areAttributesEqual:(NSXMLElement*)element{
    if (self.attributes==nil && element.attributes==nil)
        return YES;
    return [self.attributes isEqualToArray:element.attributes];
 }

-(void)findCousinAndCompare:(MOXElement*)uncle{
    MOXElement* cousin = [self findCousin:uncle];
    if (!cousin){
        self.diff=MOXDiffExtraNode;
        uncle.diff=MOXDiffNodesUnequal|MOXDiffInherited;
        return;
    }
    
    if (![self areAttributesEqual:cousin])
        self.diff=MOXDiffNodesUnequal;
        
        if (self.childCount==0){
            //porownaj atrybuty!!
            return;
        }
    
    for (MOXElement* child in [self nodesForXPath:@"*" error:nil]){
        MOXElement* childsUncle = cousin;
        [child findCousinAndCompare:childsUncle];
    }
}

- (BOOL)hasAttribute:(NSString*)attributeName withValue:(NSString*)value{
    NSXMLNode *attribute = [self attributeForName:attributeName];
    return [attribute.stringValue isEqualToString:value];
}

#pragma mark - Notifications

- (void)elementDidCopiedFrom:(MOXElement*)sourceElement{
    if([self.name isEqualToString:@"scene"]){
        NSXMLNode *comment = [sourceElement nodeForXPath:@"preceding-sibling::node()[1]" error:nil];
        if (comment.kind==NSXMLCommentKind)
            [self.parent insertChild:[comment copy] atIndex:self.index];
    }
    
}

- (void)elementWillBeRemoved{
    
}

#pragma mark - Warnings / Validation

- (NSUInteger)warningsCount{
    return _warnings.count;
}

- (NSString*)warningsString{
    NSMutableString *str = [NSMutableString new];
    for (NSString *warning in _warnings)
        [str appendFormat:@"\n\n%@",warning];
    return [str copy];
}

- (void)addWarning:(NSString *)warning{
    if (!_warnings)
        _warnings = [[NSMutableArray alloc] initWithCapacity:1];
    [_warnings addObject:warning];
}

- (NSUInteger)validate:(MOXStoryboard*)storyboard{
    NSUInteger warnings=0;
    NSString *xpath;
    NSArray *array;
    NSXMLNode *atribute = [self attributeForName:@"destination"];
    if (atribute){
        xpath = [NSString stringWithFormat:@"//viewController[@id='%@']",atribute.stringValue];
        array = [storyboard.rootElement nodesForXPath:xpath error:nil];
        if (array.count==0){
            NSString *w = [NSString stringWithFormat:@"Undeclared identifier <a href=%@>%@</a>",xpath,atribute.stringValue];//!!moze jakos lepszy kom
            [self addWarning:w];
            warnings++;
        }
    }
    
    atribute = [self attributeForName:@"customClass"];
    if (atribute){
        xpath = [NSString stringWithFormat:@"/document/classes/class[@className='%@']",atribute.stringValue];
        array = [storyboard.rootElement nodesForXPath:xpath error:nil];
        if (array.count==0){
            NSString *w = [NSString stringWithFormat:@"Undeclared custom class <a href=%@>%@</a>",xpath,atribute.stringValue];//!!moze jakos lepszy kom
            [self addWarning:w];
            warnings++;
        }
    }
    
    if ([self.name isEqualToString:@"constraint"]){
        atribute = [self attributeForName:@"firstItem"];
        if (atribute){
            xpath = [NSString stringWithFormat:@"//*[@id='%@']",atribute.stringValue];
            array = [storyboard.rootElement nodesForXPath:xpath error:nil];
            if (array.count==0){
                NSString *w = [NSString stringWithFormat:@"Undeclared identifier <a href=%@>%@</a>",xpath,atribute.stringValue];//!!moze jakos lepszy kom
                [self addWarning:w];
                warnings++;
            }
        }
    }
    
    if ([self.name isEqualToString:@"constraint"]){
        atribute = [self attributeForName:@"secondItem"];
        if (atribute){
            xpath = [NSString stringWithFormat:@"//*[@id='%@']",atribute.stringValue];
            array = [storyboard.rootElement nodesForXPath:xpath error:nil];
            if (array.count==0){
                NSString *w = [NSString stringWithFormat:@"Undeclared identifier <a href=%@>%@</a>",xpath,atribute.stringValue];//!!moze jakos lepszy kom
                [self addWarning:w];
                warnings++;
            }
        }
    }
    
    for (MOXElement *e in self.children)
        if (e.isElement)
            warnings+=[e validate:storyboard];
    
    return warnings;
}

#pragma mark - Images

+ (void)_initIconsDict{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    //!!blad jesli katalog nie istnieje
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:ICONS_DIR];
    NSString *file;
    NSString *name;
    NSImage *img;
    while (file = [dirEnum nextObject]) {
        if ([file hasSuffix:@"Icon.tiff"] || [file hasSuffix:@"Icon.pdf"] || [file hasSuffix:@"Icon.png"]){
            //zrob z UIViewControllerIcon.tiff viewController
            name = [file substringFromIndex:2];//wywal prefix
            name = [name substringToIndex:[name rangeOfString:@"Icon."].location];//wywal koncowke
            name = [name lowercaseString];
            file = [NSString pathWithComponents:@[ICONS_DIR,file]];
            img = [[NSImage alloc] initByReferencingFile:file];
            [dict setObject:img forKey:name];
        }
    }
    NSString* dir = [[NSBundle mainBundle] pathForResource:@"Elements" ofType:nil];
    dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:dir];
    while (file = [dirEnum nextObject]) {
        name = [file stringByReplacingOccurrencesOfString:@".png" withString:@""];
        name = [name lowercaseString];
        file = [NSString pathWithComponents:@[dir,file]];
        img = [[NSImage alloc] initByReferencingFile:file];
        [dict setObject:img forKey:name];
    }
    elementsIconsDict = dict;
}

- (NSImage*)icon{
    if (!elementsIconsDict)
        [MOXElement _initIconsDict];
    NSImage *icon = [elementsIconsDict objectForKey:[self.name lowercaseString]];
    if (icon)
        return icon;
    
    //jesli ma atrybuty opaque i contentMode to pewnie dziedziczy z UIView
    if ([self attributeForName:@"opaque"] || [self attributeForName:@"contentMode"]){
        icon = [elementsIconsDict objectForKey:@"view"];
        [elementsIconsDict setObject:icon forKey:self.name];
    }
    return icon;
}

#pragma mark - Setters/Getters

-(MOXElement*)parent{
    return (MOXElement*)super.parent;
}


- (BOOL)isElement{
    return YES;
}

- (void)setDiff:(MOXDiff)value{
     if (self.diff==value)
        return;
     _diff = value;
     
     if (value==MOXDiffNodesEqual)
         return;
     
     if (value & MOXDiffExtraNode){
         for (MOXElement *element in self.storyboardChildren)
             element.diff=MOXDiffExtraNode|MOXMergeActionInherited;
     }
        
     if (self.level==1)
        return;
     
    if(self.parent.diff==MOXDiffNodesEqual)
        self.parent.diff=MOXDiffNodesUnequal|MOXDiffInherited;
}

- (void)setActionMask:(MOXMergeAction)mask{
    _actionMask = mask;
    if (_diff & MOXDiffExtraNode){
        MOXMergeAction childsMask = MOXMergeActionNone;
        if (mask & MOXMergeActionMerge)
            childsMask = MOXMergeActionMerge|MOXMergeActionInherited;
        else if (mask & MOXMergeActionNoMerge || mask & MOXMergeActionAtributesOnly)
            childsMask = MOXMergeActionNoMerge|MOXMergeActionInherited;
        
        for (MOXElement *child in self.storyboardChildren)
            child.actionMask = childsMask;
    }
}

- (void)clearDiff{
    _diff = MOXDiffNodesEqual;
    
    for(MOXElement *e in self.children)
        if (e.isElement)
            [e clearDiff];
}


@end
