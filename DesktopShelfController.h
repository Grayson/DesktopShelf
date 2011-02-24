//
//  DesktopShelfController.h
//  DesktopShelf
//
//  Created by Grayson Hansard on 2/24/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "includes.h"

#import "FileWatcher.h"
#import "URLFile.h"
#import "WeblocFile.h"
#import "ShelfItem.h"

#import "TableWindowController.h"

@interface DesktopShelfController : NSObject {
	TableWindowController *_tableWindowController;
}
@property (retain) TableWindowController *tableWindowController;

- (void)folderUpdatedAtPath:(NSString *)updatedPath userInfo:(NSDictionary *)userInfo;

@end
