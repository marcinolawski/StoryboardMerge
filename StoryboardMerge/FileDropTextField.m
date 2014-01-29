//
//  FilesDropTextField.m
//  StoryboardMerge
//
//  Created by Marcin Olawski on 11.01.2013.
//  Copyright (c) 2013 Marcin Olawski. All rights reserved.
//

#import "FileDropTextField.h"

@implementation FileDropTextField

-(id)initWithFrame:(NSRect)frameRect{
    self = [super initWithFrame:frameRect];
    self.editable = NO;
    [self registerForDraggedTypes:@[NSFilenamesPboardType]];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    self.editable = NO;
    [self registerForDraggedTypes:@[NSFilenamesPboardType]];
    return self;
}

#pragma mark - Dragging Destination

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    NSPasteboard *pboard = [sender draggingPasteboard];
    if ([sender numberOfValidItemsForDrop]==1){
        NSDragOperation sourceDragMask = [sender draggingSourceOperationMask];
        
        if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
            if (sourceDragMask & NSDragOperationCopy) {
                return NSDragOperationCopy;
            }
        }
        return NSDragOperationNone;
    }
    return NSDragOperationNone;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSPasteboard *pboard = [sender draggingPasteboard];
    
    if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
        self.stringValue = files[0];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NSControlTextDidChangeNotification" object:self];
    }
    return YES;
}

@end
