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
#import "ShelfRule.h"

#import "TableWindowController.h"
#import "PreferencesController.h"

@interface DesktopShelfController : NSObject {
	TableWindowController *_tableWindowController;
	PreferencesController *_preferencesController;
}
@property (retain) TableWindowController *tableWindowController;
@property (retain) PreferencesController *preferencesController;

- (void)folderUpdatedAtPath:(NSString *)updatedPath userInfo:(NSDictionary *)userInfo;
- (IBAction)showPreferences:(id)sender;

@end
