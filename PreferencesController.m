//
//  PreferencesController.m
//  DesktopShelf
//
//  Created by Grayson Hansard on 2/25/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import "PreferencesController.h"
#import "ShelfRule.h"
#import <ApplicationServices/ApplicationServices.h>

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
	NSBundle *b = [NSBundle mainBundle];
	NSDictionary *infoPlist = [b infoDictionary];
	NSString *LSUIElement = [infoPlist objectForKey:@"LSUIElement"];
	if (!LSUIElement) return NO;
	
	return [LSUIElement integerValue] == 1;
}

- (void)setDockItemIsDisabled:(BOOL)newDockItemIsDisabled {
	NSString *infoPlistPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents/Info.plist"];
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:infoPlistPath];
	
	[dict setObject:[NSString stringWithFormat:@"%d", newDockItemIsDisabled] forKey:@"LSUIElement"];

	if (![dict writeToFile:infoPlistPath atomically:YES]) {
		NSAlert *err = [NSAlert alertWithMessageText: NSLocalizedString(@"Error changing application", @"error title")
                                       defaultButton: nil
                                     alternateButton: nil
                                         otherButton: nil
                           informativeTextWithFormat: NSLocalizedString(@"DesktopShelf could not alter its own Info.plist file.  This is likely a problem with ownership permissions.  See that you are the owner of DesktopShelf and that you have write permissions.", @"error text")];
		[err beginSheetModalForWindow:[NSApp keyWindow] modalDelegate:nil didEndSelector:nil contextInfo:nil];
		return;
	}
	[NSTask launchedTaskWithLaunchPath:@"/usr/bin/touch" arguments:[NSArray arrayWithObject:infoPlistPath]];
	
	NSAlert *alert = [NSAlert alertWithMessageText: NSLocalizedString(@"DesktopShelf needs to be relaunched", @"alert title")
                                     defaultButton: NSLocalizedString(@"Relaunch", @"alert button title")
                                   alternateButton: NSLocalizedString(@"Cancel", @"alert button title")
                                       otherButton: nil
                         informativeTextWithFormat: NSLocalizedString(@"DesktopShelf needs to be relaunched in order to hide the Dock icon.  Would you like to relaunch DesktopShelf now?", @"alert message")];
	[alert setAlertStyle:NSInformationalAlertStyle];
	[alert beginSheetModalForWindow:[NSApp keyWindow] modalDelegate:self didEndSelector:@selector(relaunchAlertDidEnd:returnCode:contextInfo:) contextInfo:nil];
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

- (void)relaunchAlertDidEnd:(NSAlert *)anAlert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
	if (returnCode != NSAlertDefaultReturn) return;
	
	NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
	LSLaunchURLSpec launchSpec;
	launchSpec.appURL = (CFURLRef)url;
	launchSpec.itemURLs = NULL;
	launchSpec.passThruParams = NULL;
	launchSpec.launchFlags = kLSLaunchDefaults | kLSLaunchNewInstance;
	launchSpec.asyncRefCon = NULL;
	
	OSErr err = LSOpenFromURLSpec(&launchSpec, NULL);
	if (err == noErr) [NSApp terminate:nil];
	else {
		// Handle relaunch failure
		NSAlert *err = [NSAlert alertWithMessageText: NSLocalizedString(@"Error relaunching DesktopShelf", @"error title")
                                       defaultButton: nil
                                     alternateButton: nil
                                         otherButton: nil
                           informativeTextWithFormat: NSLocalizedString(@"There was a problem relaunching DesktopShelf.  Please quit it and relaunch it yourself.", @"error message")];
		[err beginSheetModalForWindow:[NSApp keyWindow] modalDelegate:nil didEndSelector:nil contextInfo:nil];
	}
}

@end