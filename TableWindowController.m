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

- (IBAction)delete:(id)sender {	
	// Ask before we delete something.  If we can't delete, then return.
	if (![[NSUserDefaults standardUserDefaults] boolForKey:UD_WARN_SHELF_DELETE_KEY]) {
		NSString *title = NSLocalizedString(@"Delete this item?", @"alert title");
		NSString *deleteButton = NSLocalizedString(@"Delete", @"button title");
		NSString *cancelButton = NSLocalizedString(@"Cancel", @"button title");
		NSString *msg = NSLocalizedString(@"Are you sure that you want to delete this item?", @"alert message");
	
		NSAlert *alert = [NSAlert alertWithMessageText:title defaultButton:deleteButton alternateButton:cancelButton otherButton:nil informativeTextWithFormat:msg];
		alert.alertStyle = NSInformationalAlertStyle;
		[alert setShowsSuppressionButton:YES];
		alert.suppressionButton.title = NSLocalizedString(@"Do not show this message again", @"alert suppression message");

		NSInteger result = [alert runModal];
		[[NSUserDefaults standardUserDefaults] setBool:alert.suppressionButton.state forKey:UD_WARN_SHELF_DELETE_KEY];

		if (result != NSAlertDefaultReturn) return;
	}	
	
	NSManagedObjectContext *context = [[NSApp delegate] managedObjectContext];
	[[self.tableView selectedRowIndexes] enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
		ShelfItem *item = [self.arrayController.arrangedObjects objectAtIndex:idx];
		[context deleteObject:item];
	}];
	self.shelfItems = nil;
}

@end
