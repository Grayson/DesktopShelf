//
//  DesktopShelfController.m
//  DesktopShelf
//
//  Created by Grayson Hansard on 2/24/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import "DesktopShelfController.h"


@implementation DesktopShelfController

- (id)init
{
	self = [super init];
	if (!self) return nil;
	
	// Register standard user defaults
	[[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
		[NSArray arrayWithObject:[NSSearchPathForDirectoriesInDomains (NSDesktopDirectory, NSUserDomainMask, YES) objectAtIndex:0]], UD_SEARCH_PATHS_KEY,
		[NSNumber numberWithBool:NO], UD_SHOULD_LOG_KEY,
		nil]];
	
	// Loop over out search paths, adding a filewatcher and checking if there are already items
	NSArray *searchPaths = [[NSUserDefaults standardUserDefaults] objectForKey:UD_SEARCH_PATHS_KEY];
	for (NSString *path in searchPaths) {
		[[FileWatcher sharedWatcher] watchFileAtPath:path delegate:self action:@selector(folderUpdatedAtPath:userInfo:) userInfo:nil];
		[self folderUpdatedAtPath:path userInfo:nil];
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecameActive:) name:NSApplicationDidBecomeActiveNotification object:NSApp];
	
	return self;
}

- (void)applicationBecameActive:(NSNotification *)aNotification
{
	NSLog(@"%s", _cmd);
}

- (void)folderUpdatedAtPath:(NSString *)updatedPath userInfo:(NSDictionary *)userInfo
{
	NSLog(@"%s Changes at %@", _cmd, updatedPath);
	
	NSEnumerator *e = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:updatedPath error:nil] objectEnumerator];
	NSString *filePath = nil;
	NSMutableArray *newItems = [NSMutableArray array];
	// NSFileManager *fm = [NSFileManager defaultManager];
	while (filePath = [e nextObject])
	{
		NSString *path = [updatedPath stringByAppendingPathComponent:filePath];
		id f = nil;
		if ([[filePath pathExtension] isEqualToString:@"webloc"])
			f = [WeblocFile weblocFileWithFile:path];
		else if ([[filePath pathExtension] isEqualToString:@"url"])
			f = [URLFile URLFileWithContentsOfFile:path];
		
		if (f)
		{
			[newItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:[f name], @"title", [f url], @"URL", nil]];
			// [fm removeFileAtPath:path handler:nil];
		}		
	}
	NSLog(@"%s %@", _cmd, newItems);
	// [newItems addObjectsFromArray:[self URLArray]];
	
}

@end
