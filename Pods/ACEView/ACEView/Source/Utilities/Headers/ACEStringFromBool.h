//
//  ACEStringFromBool.h
//  ACEView
//
//  Created by Michael Robinson on 8/12/12.
//  Copyright (c) 2012 Code of Interest. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *ACEStringFromBool(BOOL flag) {
    return flag ? @"true" : @"false";
}