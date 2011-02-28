//
//  ShellScriptLauncher.m
//  Countdown
//
//  Created by Grayson Hansard on 11/6/07.
//  Copyright 2007 From Concentrate Software. All rights reserved.
//

#import "ShellScriptLauncher.h"

@implementation ShellScriptLauncher

+(NSDictionary *)extensionsToLaunchPathsDict
{
	return [NSDictionary dictionaryWithObjectsAndKeys:
		@"/bin/sh", @"sh",
		@"/usr/bin/ruby", @"rb",
		@"/usr/bin/python", @"py",
		@"/usr/local/bin/nush", @"nu",
		@"/usr/bin/perl", @"pl",
		@"/usr/bin/osascript", @"scpt",
		@"/usr/bin/php", @"php",
		nil];
}

+(BOOL)canLaunchScriptAtPath:(NSString *)path
{
	NSDictionary *d = [self extensionsToLaunchPathsDict];
	return [[d allKeys] containsObject:[path pathExtension]];
}

+(NSString *)launchScriptAtPath:(NSString *)path
{
	return [self launchScriptAtPath:path withArguments:nil];
}

+(NSString *)launchScriptAtPath:(NSString *)path withArguments:(NSArray *)arguments
{
	NSDictionary *d = [self extensionsToLaunchPathsDict];
	if (![[d allKeys] containsObject:[path pathExtension]]) return nil;
	
	NSTask *t = [NSTask new];
	NSPipe *p = [NSPipe pipe];
	NSFileHandle *fh = [p fileHandleForReading];
	NSArray *args = [NSArray arrayWithObject:path];
	if (arguments) args = [args arrayByAddingObjectsFromArray:arguments];
	
	[t setStandardOutput:p];
	[t setLaunchPath:[d valueForKey:[path pathExtension]]];
	[t setCurrentDirectoryPath:[path stringByDeletingLastPathComponent]];	
	[t setArguments:args];
	[t launch];
	
	NSData *data = [fh readDataToEndOfFile];
	[t release];
	return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}

@end
