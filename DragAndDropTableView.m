//
//  DragAndDropTableView.m
//  DesktopShelf
//
//  Created by Grayson Hansard on 5/3/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import "DragAndDropTableView.h"


@implementation DragAndDropTableView

- (id)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)isLocal {
	if ([self.delegate respondsToSelector:_cmd]) return [(NSTableView*)self.delegate draggingSourceOperationMaskForLocal:isLocal];
	return NSDragOperationNone;
}

- (NSDragOperation)draggingEntered:(id < NSDraggingInfo >)sender {
	if (sender.draggingSource == self || sender.draggingSource == self.delegate || sender.draggingSource == self.target) return NSDragOperationNone;
	if (![self.delegate respondsToSelector:_cmd]) return NSDragOperationCopy;
	return (int)[self.delegate performSelector:_cmd withObject:sender];
}

- (NSDragOperation)draggingUpdated:(id < NSDraggingInfo >)sender {
	if (sender.draggingSource == self || sender.draggingSource == self.delegate || sender.draggingSource == self.target) return NSDragOperationNone;
	if (![self.delegate respondsToSelector:_cmd]) return NSDragOperationCopy;
	return (int)[self.delegate performSelector:_cmd withObject:sender];
}

- (void)draggingExited:(id < NSDraggingInfo >)sender {
	if (![self.delegate respondsToSelector:_cmd]) return;
	[self.delegate performSelector:_cmd withObject:sender];
}

- (void)concludeDragOperation:(id < NSDraggingInfo >)sender {
	if (![self.delegate respondsToSelector:_cmd]) return;
	[self.delegate performSelector:_cmd withObject:sender];
}

- (void)draggingEnded:(id < NSDraggingInfo >)sender {
	if (![self.delegate respondsToSelector:_cmd]) return;
	[self.delegate performSelector:_cmd withObject:sender];
}

- (BOOL)performDragOperation:(id < NSDraggingInfo >)sender {
	if (sender.draggingSource == self || sender.draggingSource == self.delegate || sender.draggingSource == self.target) return NO;
	if (![self.delegate respondsToSelector:_cmd]) return NO;
	return (BOOL)[(NSTableView*)self.delegate performDragOperation:sender];
}

- (BOOL)prepareForDragOperation:(id < NSDraggingInfo >)sender {
	if (sender.draggingSource == self || sender.draggingSource == self.delegate || sender.draggingSource == self.target) return NO;
	if (![self.delegate respondsToSelector:_cmd]) return NO;
	return (BOOL)[(NSTableView*)self.delegate prepareForDragOperation:sender];
}

- (BOOL)wantsPeriodicDraggingUpdates {
	if (![self.delegate respondsToSelector:_cmd]) return NO;
	return (BOOL)[(NSTableView*)self.delegate wantsPeriodicDraggingUpdates];
}

- (void)mouseDragged:(NSEvent *)theEvent {
	if ([self.delegate respondsToSelector:@selector(dragStartedForTableView:)])
		[self.delegate performSelector:@selector(dragStartedForTableView:) withObject:self];
}

@end
