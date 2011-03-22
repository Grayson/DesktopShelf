//
//  PreferencesController.m
//  DesktopShelf
//
//  Created by Grayson Hansard on 2/25/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import "PreferencesController.h"
#import "ShelfRule.h"


@implementation PreferencesController
@synthesize window = _window;
@synthesize newShelfRuleController = _newShelfRuleController;

- (id)init
{
	self = [super init];
	if (!self) return nil;
	
	[NSBundle loadNibNamed:@"Prefs" owner:self];
	
	return self;
}

- (void)dealloc
{
	self.window = nil;
	self.newShelfRuleController = nil;
	
	[_window release];
	[_newShelfRuleController release];
	
	[super dealloc];
}

- (void)showWindow
{
	[self.window makeKeyAndOrderFront:nil];
}

- (IBAction)resetAllWarnings:(id)sender {
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	[ud setBool:YES forKey:UD_WARN_SHELF_DELETE_KEY];
}

- (BOOL)dockItemIsDisabled {
	NSBundle *b = [NSBundle mainBundle];
	NSDictionary *infoPlist = [b infoDictionary];
	// NSLog(@"%s %@", _cmd, infoPlist);
	return NO;
}

- (void)setDockItemIsDisabled:(BOOL)newDockItemIsDisabled {
	// NSLog(@"%s", _cmd);
	NSString *infoPlistPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents/Info.plist"];
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:infoPlistPath];
	[dict setObject:[NSString stringWithFormat:@"%d", newDockItemIsDisabled] forKey:@"LSUIElement"];
	// [dict writeToFile:infoPlistPath atomically:YES];
	[NSTask launchedTaskWithLaunchPath:@"/usr/bin/touch" arguments:[NSArray arrayWithObject:infoPlistPath]];
}

- (NSArray *)shelfRules
{
	NSArray *rulesPlist = [[NSUserDefaults standardUserDefaults] objectForKey:UD_SHELF_RULES_KEY];
	NSMutableArray *rules = [NSMutableArray array];
	for (NSDictionary *rulePlist in rulesPlist) {
		ShelfRule *rule = [ShelfRule ruleWithDictionaryRepresentation:rulePlist];
		[rules addObject:rule];
	}
	return rules;
}

- (void)setShelfRules:(NSArray *)newShelfRules
{
	NSLog(@"%s", _cmd);
}

- (IBAction)addShelfRule:(id)sender {
	if (!self.newShelfRuleController) {
		self.newShelfRuleController = [[NewShelfRuleController new] autorelease];
		self.newShelfRuleController.delegate = self;
	}
	[self.newShelfRuleController showWindow:self];
}

- (void)newRuleWasCreated:(ShelfRule *)rule {
	if (!rule) return;
	NSMutableArray *rulesPlist = [NSMutableArray arrayWithArray: [[NSUserDefaults standardUserDefaults] objectForKey:UD_SHELF_RULES_KEY]];
	[rulesPlist addObject:[rule dictionaryRepresentation]];
	[[NSUserDefaults standardUserDefaults] setObject:rulesPlist forKey:UD_SHELF_RULES_KEY];
	[self setShelfRules:nil];
}

@end
