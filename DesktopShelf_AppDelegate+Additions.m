//
//  DesktopShelf_AppDelegate+Additions.m
//  DesktopShelf
//
//  Created by Grayson Hansard on 2/28/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import "DesktopShelf_AppDelegate+Additions.h"

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

@end
