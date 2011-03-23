//
//  MenuItemController.m
//  DesktopShelf
//
//  Created by Grayson Hansard on 3/22/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import "MenuItemController.h"
#import "ShelfItem.h"

NSMenuItem *toastitleitem (NSString *str) {
	NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
		[NSFont systemFontOfSize:10.], NSFontAttributeName,
		nil];
 	NSAttributedString *as = [[[NSAttributedString alloc] initWithString:str attributes:attrs] autorelease];
	NSMenuItem *mi = [[NSMenuItem alloc] initWithTitle:str action:nil keyEquivalent:@""];
	mi.attributedTitle = as;
	return mi;
}

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
	
	NSInteger truncationLength = [[NSUserDefaults standardUserDefaults] integerForKey:UD_MENU_ITEM_MAX_LENGTH];
	
	NSMenu *menu = [[[NSMenu alloc] initWithTitle:@"com.fcs.desktopshelf.systemmenuitem"] autorelease];
	
	[menu addItem:toastitleitem(NSLocalizedString(@"Shelf", @"menu item"))];
	
	for (ShelfItem *item in [ShelfItem everyItem]) {
		NSString *title = item.desc;
		if (truncationLength != 0 && title.length > truncationLength) {
			title = [[title substringToIndex:truncationLength] stringByAppendingFormat:@"%C", 0x2026];
		}
		NSMenuItem *mi = [menu addItemWithTitle:title action:@selector(openShelfItem:) keyEquivalent:@""];
		mi.target = self;
		mi.representedObject = item;
		NSImage *img = nil;
		if (item.icon) img = [[[NSImage alloc] initWithData:item.icon] autorelease];
		else img = [[NSWorkspace sharedWorkspace] iconForFileType:item.path.pathExtension];
		[img setScalesWhenResized:YES];
		[img setSize:NSMakeSize(16., 16.)];
		mi.image = img;
		mi.indentationLevel = 1;
	}
	[menu addItemWithTitle:@"" action:nil keyEquivalent:@""];
	[menu addItem:toastitleitem(NSLocalizedString(@"Application", @"menu item"))];
	
	NSMenuItem *showShelfItem = [menu addItemWithTitle:NSLocalizedString(@"Show Shelf window\\U2026", @"menu item") action:@selector(showShelfWindow:) keyEquivalent:@""];
	showShelfItem.target = self;
	showShelfItem.indentationLevel = 1;
	
	NSMenuItem *prefsItem = [menu addItemWithTitle:NSLocalizedString(@"Open Preferences\\U2026", @"menu item") action:@selector(showPreferences:) keyEquivalent:@""];
	prefsItem.target = self;
	prefsItem.indentationLevel = 1;
	
	NSMenuItem *quitItem = [menu addItemWithTitle:NSLocalizedString(@"Quit DesktopShelf", @"menu item") action:@selector(terminate:) keyEquivalent:@""];
	quitItem.target = NSApp;
	quitItem.indentationLevel = 1;
	
	self.statusItem.menu = menu;
}

- (void)openShelfItem:(NSMenuItem *)aMenuItem
{
	[aMenuItem.representedObject open];
}

- (IBAction)showPreferences:(id)sender {
	[NSApp activateIgnoringOtherApps:YES];
	if ([self.delegate respondsToSelector:@selector(showPreferences:)]) [self.delegate showPreferences:sender];
}

- (IBAction)showShelfWindow:(id)sender {
	[NSApp activateIgnoringOtherApps:YES];
	if ([self.delegate respondsToSelector:@selector(showShelfWindow:)]) [self.delegate showShelfWindow:sender];
}

@end
