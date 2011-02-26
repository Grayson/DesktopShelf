//
//  PreferencesController.m
//  DesktopShelf
//
//  Created by Grayson Hansard on 2/25/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import "PreferencesController.h"


@implementation PreferencesController
@synthesize window = _window;

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
	
	[_window release];
	
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
	NSLog(@"%s %@", _cmd, infoPlist);
	return NO;
}

- (void)setDockItemIsDisabled:(BOOL)newDockItemIsDisabled {
	NSString *infoPlistPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents/Info.plist"];
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:infoPlistPath];
	[dict setObject:[NSString stringWithFormat:@"%d", newDockItemIsDisabled] forKey:@"LSUIElement"];
	// [dict writeToFile:infoPlistPath atomically:YES];
	[NSTask launchedTaskWithLaunchPath:@"/usr/bin/touch" arguments:[NSArray arrayWithObject:infoPlistPath]];
}


@end
