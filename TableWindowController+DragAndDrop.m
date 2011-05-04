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

// - (BOOL)performDragOperation:(id < NSDraggingInfo >)sender {
// 	NSPasteboard *dragPasteboard = [sender draggingPasteboard];
// 	
// 	NSArray *files = [dragPasteboard propertyListForType:NSFilenamesPboardType];
// 	if (files) {
// 		NSFileManager *fm = [NSFileManager defaultManager];
// 		for (NSString *file in files) {
// 			NSError *err = nil;
// 			NSString *uuid = [[NSProcessInfo processInfo] globallyUniqueString];
// 			NSString *movePath = [[[[NSApp delegate] guaranteedShelfItemsFolder] stringByAppendingPathComponent:uuid] stringByAppendingPathExtension:[file pathExtension]];
// 			BOOL moved = [fm moveItemAtPath:file toPath:movePath error:&err];
// 			if ((!moved || err) && SHOULDLOG) {
// 				NSLog(@"performDragOperation Error moving item %@ to shelf.  Error message: %@", file, err);
// 				return NO;
// 			}
// 			ShelfItem *item = [ShelfItem item];
// 			item.path = movePath;
// 			item.desc = [[file lastPathComponent] stringByDeletingPathExtension];
// 			[item fetchMetadata];
// 			if (SHOULDLOG) NSLog(@"[TableWindowController+DragAndDrop performDragOperation] Adding item: %@", item);
// 			[fm removeItemAtPath:file error:nil];
// 		}
// 		[[NSNotificationCenter defaultCenter] postNotificationName:NC_REFRESH_SHELF_KEY object:nil];
// 		return YES;
// 	}
// 	return NO;
// }

- (BOOL)prepareForDragOperation:(id < NSDraggingInfo >)sender {
	NSPasteboard *dragPasteboard = [sender draggingPasteboard];
	if ([dragPasteboard propertyListForType:NSFilenamesPboardType]) return YES;
	return NO;
}

- (NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)isLocal {
	return NSDragOperationCopy;
}

- (BOOL)tableView:(NSTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
	NSMutableArray *items = [NSMutableArray array];
	__block NSString *tmp = NSTemporaryDirectory();
	__block NSFileManager *fm = [NSFileManager defaultManager];
	
	[rowIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop){
		NSError *err = nil;
		ShelfItem *item = [self.arrayController.arrangedObjects objectAtIndex:idx];
		NSString *tmpPath = [[tmp stringByAppendingPathComponent:item.desc] stringByAppendingFormat:@".%@", [item.path pathExtension]];
		if ([fm fileExistsAtPath:tmpPath]) [fm removeItemAtPath:tmpPath error:&err];
		if (err) return;
		[fm copyItemAtPath:item.path toPath:tmpPath error:&err];
		if (err) return;
		[items addObject:tmpPath];
	}];
	
	
	// for (ShelfItem *item in self.arrayController.selectedObjects) {
	// 	NSString *tmpPath = [[tmp stringByAppendingPathComponent:item.desc] stringByAppendingFormat:@".%@", [item.path pathExtension]];
	// 	if ([fm fileExistsAtPath:tmpPath]) [fm removeItemAtPath:tmpPath error:&err];
	// 	if (err) continue;
	// 	[fm copyItemAtPath:item.path toPath:tmpPath error:&err];
	// 	if (err) continue;
	// 	[items addObject:tmpPath];
	// }
	// [pboard clearContents];
	// [pboard writeObjects:items];
	// [pboard declareTypes:[NSArray arrayWithObject:NSFilenamesPboardType] owner:nil];
	// [pboard setPropertyList:items forType:NSFilenamesPboardType];
	
	NSPasteboard *dboard = [NSPasteboard pasteboardWithName:NSDragPboard];
	[dboard clearContents];
	[dboard declareTypes:[NSArray arrayWithObject:NSFilenamesPboardType] owner:self];
	[dboard setPropertyList:items forType:NSFilenamesPboardType];
	
	return YES;
}

- (void)dragStartedForTableView:(NSTableView *)aTableView {
	return;
	NSPasteboard *pboard = [NSPasteboard pasteboardWithName:NSDragPboard];
	NSArray *selection = [self.arrayController selectedObjects];
	float size = 32. + ((selection.count-1) * 10.);
	NSImage *img = [[[NSImage alloc] initWithSize:NSMakeSize(size, size)] autorelease];
	NSUInteger idx = 0;
	
	[img lockFocus];
	for (ShelfItem *item in selection) {
		NSImage *tmp = [[[NSImage alloc] initWithData:item.icon] autorelease];
		[tmp setScalesWhenResized:YES];
		tmp.size = NSMakeSize(32., 32.);
		[tmp dissolveToPoint:NSMakePoint(idx * 10., idx * 10.) fraction:1.];
		[[tmp TIFFRepresentation] writeToFile:@"/Users/ghansard/Desktop/asf.tiff" atomically:YES];
		idx++;
	}
	[img unlockFocus];
	[[img TIFFRepresentation] writeToFile:@"/Users/ghansard/Desktop/test.tiff" atomically:YES];
	
	NSEvent *currentEvent = [NSApp currentEvent];
	NSPoint p = [aTableView convertPoint:[currentEvent locationInWindow] fromView:nil];
	p.x -= size / 2.;
	p.y += size / 2.;
	[aTableView dragImage:img
                       at:p
                   offset:NSMakeSize(0., 0.)
                    event:currentEvent
               pasteboard:pboard
                   source:self
                slideBack:YES];
}

@end
