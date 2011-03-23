//
//  DesktopShelf_AppDelegate+Additions.m
//  DesktopShelf
//
//  Created by Grayson Hansard on 2/28/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import "DesktopShelf_AppDelegate+Additions.h"
#import <ApplicationServices/ApplicationServices.h>

@implementation DesktopShelf_AppDelegate (Additions)

- (NSString *)guaranteedApplicationSupportDirectory {
	NSFileManager *fm = [NSFileManager defaultManager];
	NSError *err = nil;
	if (![fm createDirectoryAtPath:[self applicationSupportDirectory] withIntermediateDirectories:YES attributes:nil error:&err] || err) {
		[NSException raise:@"Error creating application support folder" format:@"Error response was: ", err];
	}
	return [self applicationSupportDirectory];
}

- (NSString *)guaranteedShelfItemsFolder {
	NSFileManager *fm = [NSFileManager defaultManager];
	NSError *err = nil;
	NSString *path = [[self applicationSupportDirectory] stringByAppendingPathComponent:@"Shelf Items"];
	if (![fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err] || err) {
		[NSException raise:@"Error creating Shelf Items folder" format:@"Error response was: ", err];
	}
	return path;
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
		if ([NSApp keyWindow]) [err beginSheetModalForWindow:[NSApp keyWindow] modalDelegate:nil didEndSelector:nil contextInfo:nil];
		else [err runModal];
		return;
	}
	[NSTask launchedTaskWithLaunchPath:@"/usr/bin/touch" arguments:[NSArray arrayWithObject:infoPlistPath]];
	
	NSAlert *alert = [NSAlert alertWithMessageText: NSLocalizedString(@"DesktopShelf needs to be relaunched", @"alert title")
                                     defaultButton: NSLocalizedString(@"Relaunch", @"alert button title")
                                   alternateButton: NSLocalizedString(@"Cancel", @"alert button title")
                                       otherButton: nil
                         informativeTextWithFormat: NSLocalizedString(@"DesktopShelf needs to be relaunched in order to hide the Dock icon.  Would you like to relaunch DesktopShelf now?", @"alert message")];
	[alert setAlertStyle:NSInformationalAlertStyle];
	if ([NSApp keyWindow]) [alert beginSheetModalForWindow:[NSApp keyWindow] modalDelegate:self didEndSelector:@selector(relaunchAlertDidEnd:returnCode:contextInfo:) contextInfo:nil];
	else {
		NSInteger result = [alert runModal];
		[self relaunchAlertDidEnd:alert returnCode:result contextInfo:nil];
	}
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
		if ([NSApp keyWindow]) [err beginSheetModalForWindow:[NSApp keyWindow] modalDelegate:nil didEndSelector:nil contextInfo:nil];
		else [err runModal];
	}
}

@end