//
//  DesktopShelfController.m
//  DesktopShelf
//
//  Created by Grayson Hansard on 2/24/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import "DesktopShelfController.h"

#import "ShelfRule.h"


@implementation DesktopShelfController
@synthesize tableWindowController = _tableWindowController;
@synthesize preferencesController = _preferencesController;
@synthesize menuItemController = _menuItemController;
@synthesize syncController = _syncController;
@synthesize periodicTimer = _periodicTimer;

- (id)init
{
	self = [super init];
	if (!self) return nil;
	
	// Register standard user defaults
	[[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
		[NSArray arrayWithObject:[NSSearchPathForDirectoriesInDomains (NSDesktopDirectory, NSUserDomainMask, YES) objectAtIndex:0]], UD_SEARCH_PATHS_KEY,
		[NSNumber numberWithBool:NO], UD_SHOULD_LOG_KEY,
		[[ShelfRule defaultRules] valueForKeyPath:@"dictionaryRepresentation"], UD_SHELF_RULES_KEY,
		[NSNumber numberWithInteger:30], UD_MENU_ITEM_MAX_LENGTH,
		nil]];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecameActive:) name:NSApplicationDidBecomeActiveNotification object:NSApp];
	self.periodicTimer = [NSTimer scheduledTimerWithTimeInterval:(60.) target:self selector:@selector(runRules) userInfo:nil repeats:YES];
	
	// Run once now to set up the menu item if necessary.
	[self observeValueForKeyPath:UD_SHOW_MENU_BAR_ITEM_KEY ofObject:[NSUserDefaults standardUserDefaults] change:nil context:nil];
	
	[[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:UD_SHOW_MENU_BAR_ITEM_KEY options:0 context:nil];
	if (![[NSApp delegate] dockItemIsDisabled]) [self showShelfWindow:nil];
	
	self.syncController = [[SyncController new] autorelease];
	self.syncController.delegate = self;
	[self.syncController sync];
	
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self.periodicTimer invalidate];
	
	self.tableWindowController = nil;
	self.preferencesController = nil;
	self.periodicTimer = nil;
	self.menuItemController = nil;
	self.syncController = nil;
	
	[super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqualToString:UD_SHOW_MENU_BAR_ITEM_KEY]) {
		BOOL shouldShowMenu = [object boolForKey:keyPath];
		if (!self.menuItemController) {
			self.menuItemController = [[MenuItemController new] autorelease];
			self.menuItemController.delegate = self;
		}
		if (shouldShowMenu) [self.menuItemController showMenuItem];
		else [self.menuItemController hideMenuItem];
	}
}


- (void)applicationBecameActive:(NSNotification *)aNotification
{
	[self runRules];
	[[ShelfItem everyItem] makeObjectsPerformSelector:@selector(fetchMetadata)];
}

- (void)runRules {
	NSArray *rulesPlistArray = [[NSUserDefaults standardUserDefaults] objectForKey:UD_SHELF_RULES_KEY];
	for (NSDictionary *rulesPlist in rulesPlistArray) {
		ShelfRule *rule = [ShelfRule ruleWithDictionaryRepresentation:rulesPlist];
		NSArray *matchedFiles = [rule matchedFiles];
		for (NSString *path in matchedFiles) [rule performActionOnFile:path];
	}
}

- (IBAction)showPreferences:(id)sender {
	if (!self.preferencesController) self.preferencesController = [[PreferencesController new] autorelease];
	[self.preferencesController showWindow];
}

- (IBAction)showShelfWindow:(id)sender {
	if (!self.tableWindowController) {
		TableWindowController *twc = [[TableWindowController new] autorelease];
		self.tableWindowController = twc;
	}
	[self.tableWindowController showWindow];
}

#pragma mark -
#pragma mark Delegate methods

- (void)syncController:(SyncController *)controller encounteredError:(NSError *)error {
	NSLog(@"%s %@", _cmd, error);
}

@end
