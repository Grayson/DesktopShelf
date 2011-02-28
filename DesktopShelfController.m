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

- (void)folderUpdatedAtPath:(NSString *)updatedPath userInfo:(NSDictionary *)userInfo
{
	if (SHOULDLOG) NSLog(@"[DesktopShelfController %s] Changes at %@", _cmd, updatedPath);
	
	// NSEnumerator *e = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:updatedPath error:nil] objectEnumerator];
	// NSString *filePath = nil;
	// NSFileManager *fm = [NSFileManager defaultManager];
	// while (filePath = [e nextObject])
	// {
	// 	NSString *path = [updatedPath stringByAppendingPathComponent:filePath];
	// 	id f = nil;
	// 	if ([[filePath pathExtension] isEqualToString:@"webloc"]) 
	// 		f = [WeblocFile weblocFileWithFile:path];
	// 	else if ([[filePath pathExtension] isEqualToString:@"url"])
	// 		f = [URLFile URLFileWithContentsOfFile:path];
	// 	
	// 	if (f)
	// 	{
	// 		ShelfItem *item = [ShelfItem item];
	// 		item.desc = [f name];
	// 		item.url = [[f url] absoluteString];
	// 		item.type = @"bookmark";
	// 		[item fetchIcon];
	// 		if (SHOULDLOG) NSLog(@"[DesktopShelfController %s] Adding item: %@", _cmd, item);
	// 		[fm removeItemAtPath:path error:nil];
	// 	}
	// 	
	// 	// Do something with file types...
	// }
	// [[NSNotificationCenter defaultCenter] postNotificationName:NC_REFRESH_SHELF_KEY object:nil];
}

- (IBAction)showPreferences:(id)sender {
	if (!self.preferencesController) self.preferencesController = [[PreferencesController new] autorelease];
	[self.preferencesController showWindow];
}

@end
