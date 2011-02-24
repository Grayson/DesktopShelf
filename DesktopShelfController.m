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
	
	NSString *desktopPath = [NSSearchPathForDirectoriesInDomains (NSDesktopDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	if (!desktopPath) NSLog(@"%s MAJOR ERROR: Can't find Desktop.", _cmd);
	
	NSLog(@"%s %@", _cmd, desktopPath);
	
	[[FileWatcher sharedWatcher] watchFileAtPath:desktopPath delegate:self action:@selector(folderUpdatedAtPath:userInfo:) userInfo:nil];
	
	return self;
}

- (void)folderUpdatedAtPath:(NSString *)path userInfo:(NSDictionary *)userInfo
{
	NSLog(@"%s Changes at %@", _cmd, path);
}

@end
