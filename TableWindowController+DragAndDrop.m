//
//  TableWindowController+DragAndDrop.m
//  DesktopShelf
//
//  Created by Grayson Hansard on 5/3/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import "TableWindowController+DragAndDrop.h"
#import "DesktopShelf_AppDelegate+Additions.h"

@implementation TableWindowController (DragAndDrop)

- (NSDragOperation)draggingEntered:(id < NSDraggingInfo >)sender {
	return NSDragOperationCopy;
}

- (BOOL)performDragOperation:(id < NSDraggingInfo >)sender {
	NSPasteboard *dragPasteboard = [sender draggingPasteboard];
	
	NSArray *files = [dragPasteboard propertyListForType:NSFilenamesPboardType];
	if (files) {
		NSFileManager *fm = [NSFileManager defaultManager];
		for (NSString *file in files) {
			NSError *err = nil;
			NSString *uuid = [[NSProcessInfo processInfo] globallyUniqueString];
			NSString *movePath = [[[[NSApp delegate] guaranteedShelfItemsFolder] stringByAppendingPathComponent:uuid] stringByAppendingPathExtension:[file pathExtension]];
			BOOL moved = [fm moveItemAtPath:file toPath:movePath error:&err];
			if ((!moved || err) && SHOULDLOG) {
				NSLog(@"performDragOperation Error moving item %@ to shelf.  Error message: %@", file, err);
				return NO;
			}
			ShelfItem *item = [ShelfItem item];
			item.path = movePath;
			item.desc = [[file lastPathComponent] stringByDeletingPathExtension];
			[item fetchMetadata];
			if (SHOULDLOG) NSLog(@"[TableWindowController+DragAndDrop performDragOperation] Adding item: %@", item);
			[fm removeItemAtPath:file error:nil];
		}
		[[NSNotificationCenter defaultCenter] postNotificationName:NC_REFRESH_SHELF_KEY object:nil];
		return YES;
	}
	return NO;
}

- (BOOL)prepareForDragOperation:(id < NSDraggingInfo >)sender {
	NSPasteboard *dragPasteboard = [sender draggingPasteboard];
	if ([dragPasteboard propertyListForType:NSFilenamesPboardType]) return YES;
	return NO;
}

@end
