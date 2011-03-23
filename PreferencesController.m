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
@synthesize shelfRulesArrayController = _shelfRulesArrayController;

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
	self.shelfRulesArrayController = nil;
	
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
	return [[NSApp delegate] dockItemIsDisabled];
}

- (void)setDockItemIsDisabled:(BOOL)newDockItemIsDisabled {
	[[NSApp delegate] setDockItemIsDisabled:newDockItemIsDisabled];
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
	// NSLog(@"%s", _cmd);
}

- (IBAction)addShelfRule:(id)sender {
	if (!self.newShelfRuleController) {
		self.newShelfRuleController = [[NewShelfRuleController new] autorelease];
		self.newShelfRuleController.delegate = self;
	}
	[self.newShelfRuleController showWindow:self];
}

- (IBAction)removeShelfRule:(id)sender {
	NSDictionary *ruleToRemove = [[self.shelfRulesArrayController.selectedObjects lastObject] dictionaryRepresentation];
	NSMutableArray *rulesPlist = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:UD_SHELF_RULES_KEY]];
	NSDictionary *deleteThisOne = nil;
	for (NSDictionary *ruleDict in rulesPlist) {
		if ([ruleDict isEqualToDictionary:ruleToRemove]) {
			deleteThisOne = ruleDict;
			break;
		}
	}
	if (deleteThisOne) [rulesPlist removeObject:deleteThisOne];
	[[NSUserDefaults standardUserDefaults] setObject:rulesPlist forKey:UD_SHELF_RULES_KEY];
	[self setShelfRules:nil];
}

- (void)newRuleWasCreated:(ShelfRule *)rule {
	if (!rule) return;
	NSMutableArray *rulesPlist = [NSMutableArray arrayWithArray: [[NSUserDefaults standardUserDefaults] objectForKey:UD_SHELF_RULES_KEY]];
	[rulesPlist addObject:[rule dictionaryRepresentation]];
	[[NSUserDefaults standardUserDefaults] setObject:rulesPlist forKey:UD_SHELF_RULES_KEY];
	[self setShelfRules:nil];
}

@end