//
//  TableWindowController.m
//  DesktopShelf
//
//  Created by Grayson Hansard on 2/24/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import "TableWindowController.h"


@implementation TableWindowController
@synthesize window = _window;

- (id)init
{
	self = [super init];
	if (!self) return nil;
	
	[NSBundle loadNibNamed:@"TableWindow" owner:self];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshShelf:) name:NC_REFRESH_SHELF_KEY object:nil];
	
	return self;
}

- (void)dealloc
{
	[_window release];
	[super dealloc];
}

- (void)showWindow {
	[self.window makeKeyAndOrderFront:self];
}

- (void)refreshShelf:(NSNotification *)aNotification
{
	NSLog(@"%s", _cmd);
	NSLog(@"%s %@", _cmd, [ShelfItem everyItem]);
}

- (NSArray *)shelfItems {
	return [ShelfItem everyItem];
}

@end
