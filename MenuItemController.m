//
//  MenuItemController.m
//  DesktopShelf
//
//  Created by Grayson Hansard on 3/22/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import "MenuItemController.h"
#import "ShelfItem.h"

@implementation MenuItemController
@synthesize statusItem = _statusItem;
@synthesize delegate = _delegate;

- (void)dealloc
{
	[self hideMenuItem]; // Will kill self.statusItem.
	
	self.delegate = nil;
	
	[super dealloc];
}

- (void)showMenuItem {
	if (!self.statusItem) {
		self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
		NSImage *img = [[[NSImage imageNamed:@"NSApplicationIcon"] copy] autorelease];
		[img setScalesWhenResized:YES];
		[img setSize:NSMakeSize(16., 16.)];
		self.statusItem.image = img;
		self.statusItem.highlightMode = YES;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:NC_REFRESH_SHELF_KEY object:nil];
	}
	[self update];
}

- (void)hideMenuItem {
	[[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
	self.statusItem = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)update {
	if (!self.statusItem) return;
	
	NSMenu *menu = [[[NSMenu alloc] initWithTitle:@"com.fcs.desktopshelf.systemmenuitem"] autorelease];
	
	for (ShelfItem *item in [ShelfItem everyItem]) {
		NSMenuItem *mi = [menu addItemWithTitle:item.desc action:@selector(openShelfItem:) keyEquivalent:@""];
		mi.target = self;
		mi.representedObject = item;
		NSImage *img = [[[NSImage alloc] initWithData:item.icon] autorelease];
		[img setScalesWhenResized:YES];
		[img setSize:NSMakeSize(16., 16.)];
		mi.image = img;
	}
	[menu addItem:[NSMenuItem separatorItem]];
	
	NSMenuItem *prefsItem = [menu addItemWithTitle:NSLocalizedString(@"Open Preferences\\U2026", @"menu item") action:@selector(showPreferences:) keyEquivalent:@""];
	prefsItem.target = self.delegate;
	
	NSMenuItem *quitItem = [menu addItemWithTitle:NSLocalizedString(@"Quit DesktopShelf", @"menu item") action:@selector(terminate:) keyEquivalent:@""];
	quitItem.target = NSApp;
	
	self.statusItem.menu = menu;
}

- (void)openShelfItem:(NSMenuItem *)aMenuItem
{
	[aMenuItem.representedObject open];
}

@end
