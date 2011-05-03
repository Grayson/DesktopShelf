//
//  TableWindowController.h
//  DesktopShelf
//
//  Created by Grayson Hansard on 2/24/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ShelfItem.h"
#import "DragAndDropTableView.h"

#import "includes.h"

@interface TableWindowController : NSObject {
	IBOutlet NSWindow *_window;
	IBOutlet DragAndDropTableView *_tableView;
	IBOutlet NSArrayController *_arrayController;
}
@property (retain) NSWindow *window;
@property (retain) DragAndDropTableView *tableView;
@property (retain) NSArrayController *arrayController;

- (void)showWindow;

-(void)setShelfItems:(NSArray *)items;
- (NSArray *)shelfItems;

@end
