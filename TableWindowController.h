//
//  TableWindowController.h
//  DesktopShelf
//
//  Created by Grayson Hansard on 2/24/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ShelfItem.h"

#import "includes.h"

@interface TableWindowController : NSObject {
	IBOutlet NSWindow *_window;
}
@property (retain) NSWindow *window;

- (void)showWindow;
- (NSArray *)shelfItems;

@end
