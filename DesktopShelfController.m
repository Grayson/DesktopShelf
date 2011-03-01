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
		nil]];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecameActive:) name:NSApplicationDidBecomeActiveNotification object:NSApp];
	self.periodicTimer = [NSTimer scheduledTimerWithTimeInterval:(60. * 60. * 5.) target:self selector:@selector(runRules) userInfo:nil repeats:YES];
	
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self.periodicTimer invalidate];
	
	self.tableWindowController = nil;
	self.preferencesController = nil;
	self.periodicTimer = nil;
	
	[super dealloc];
}

- (void)applicationBecameActive:(NSNotification *)aNotification
{
	if (!self.tableWindowController) {
		TableWindowController *twc = [[TableWindowController new] autorelease];
		self.tableWindowController = twc;
	}
	[self.tableWindowController showWindow];
	[self runRules];
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

@end
