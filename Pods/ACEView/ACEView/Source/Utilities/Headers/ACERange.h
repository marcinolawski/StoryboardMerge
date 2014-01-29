//
//  ACERange.h
//  ACEView
//
//  Created by Michael Robinson on 5/12/12.
//  Copyright (c) 2012 Code of Interest. All rights reserved.
//

typedef struct _ACERangeComponent {
    NSUInteger start;
    NSUInteger end;
} ACERangeComponent;


typedef struct _ACERange {
    ACERangeComponent row;
    ACERangeComponent column;
} ACERange;

NS_INLINE ACERange ACEMakeRange(NSRange range, NSString *string);
NS_INLINE NSString *ACEStringFromACERange(ACERange range);
NS_INLINE NSString *ACEStringFromRangeAndString(NSRange range, NSString *string);

NS_INLINE ACERange ACEMakeRange(NSRange range, NSString *string) {
    ACERange aceRange = { { 0, 0 }, { 0, 0 } };
    NSUInteger characterCountIncludingCurrentLine = 0;
    NSUInteger characterCountForCurrentLine = 0;
    BOOL rangeLocationFound = NO;

    NSUInteger numberOfLines, index, stringLength = [string length];
    NSRange lineRange;
    for (index = 0, numberOfLines = 0; index < stringLength; numberOfLines++) {
        lineRange = [string lineRangeForRange:NSMakeRange(index, 0)];
        index = NSMaxRange(lineRange);

        characterCountForCurrentLine = lineRange.length;
        characterCountIncludingCurrentLine += characterCountForCurrentLine;
        
        if (!rangeLocationFound && characterCountIncludingCurrentLine >= range.location) {
            aceRange.row.start = numberOfLines;
            aceRange.column.start = characterCountForCurrentLine - (characterCountIncludingCurrentLine - range.location);
            rangeLocationFound = YES;
        }

        NSUInteger rangeEndLocation = range.location + range.length;
        if (rangeLocationFound && characterCountIncludingCurrentLine >= rangeEndLocation) {
            aceRange.row.end = numberOfLines;
            aceRange.column.end = characterCountForCurrentLine - (characterCountIncludingCurrentLine - rangeEndLocation);
            break;
        }

    }
    return aceRange;
}

NS_INLINE NSString *ACEStringFromACERange(ACERange range) {
    NSString *string = [NSString stringWithFormat:@"{ %lu, %lu }, { %lu, %lu }",
                        range.row.start, range.row.end, range.column.start, range.column.end];
    return [string autorelease];
}

NS_INLINE NSString *ACEStringFromRangeAndString(NSRange range, NSString *string) {
    ACERange aceRange = ACEMakeRange(range, string);
    NSString *rangeString = [NSString stringWithFormat:@"%lu, %lu, %lu, %lu",
                             aceRange.row.start, aceRange.column.start, aceRange.row.end, aceRange.column.end];
    return rangeString;
}
