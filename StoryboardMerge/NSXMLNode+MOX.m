//
//  NSXMLNode+MOX.m
//  StoryboardMerge
//
//  Created by Marcin Olawski on 13.02.2013.
//  Copyright (c) 2013 Marcin Olawski. All rights reserved.
//

#import "NSXMLNode+MOX.h"


@implementation NSXMLNode (MOX)

- (BOOL)isElement{
    return NO;
}

- (id)nodeForXPath:(NSString *)xpath error:(NSError **)error
{
    NSArray *array = [self nodesForXPath:xpath error:error];
    if (array.count==0)
        return nil;
    
    if (array.count==1)
        return array[0];
    
    if (error){
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:@"Single node xpath returns more than one node" forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"XMLDomain" code:100 userInfo:errorDetail];
    }
    return nil;
}


-(NSArray*)family{
    NSMutableArray *family = [NSMutableArray new];
    NSXMLNode *element = self;
    while (element.level>0) {
        [family insertObject:element atIndex:0];
        element = element.parent;
    }
    return family;
}

@end
