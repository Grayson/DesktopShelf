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
@synthesize tableView = _tableView;
@synthesize arrayController = _arrayController;

- (id)init
{
	self = [super init];
	if (!self) return nil;
	
	[NSBundle loadNibNamed:@"TableWindow" owner:self];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshShelf:) name:NC_REFRESH_SHELF_KEY object:nil];
	
	return self;
}

- (void)awakeFromNib
{
	// Set up open handler when table view is double-clicked
	[self.tableView setTarget:self];
	[self.tableView setDoubleAction:@selector(tableViewWasDoubleClicked:)];
}

- (void)dealloc
{
	self.window = nil;
	self.tableView = nil;
	
	[_window release];
	[_tableView release];
	
	[super dealloc];
}

- (void)showWindow {
	[self.window makeKeyAndOrderFront:self];
}

- (void)refreshShelf:(NSNotification *)aNotification
{
	[self setShelfItems:nil];
}

-(void)setShelfItems:(NSArray *)items { } // Shell method to update the array controller

- (NSArray *)shelfItems {
	return [ShelfItem everyItem];
}

- (IBAction)tableViewWasDoubleClicked:(id)sender {
	[[self.tableView selectedRowIndexes] enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop){
		[[self.arrayController.arrangedObjects objectAtIndex:idx] open];
	}];
}

@end
