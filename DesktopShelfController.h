//
//  DesktopShelfController.h
//  DesktopShelf
//
//  Created by Grayson Hansard on 2/24/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "includes.h"

#import "TableWindowController.h"
#import "PreferencesController.h"
#import "MenuItemController.h"
#import "SyncController.h"

@interface DesktopShelfController : NSObject {
	TableWindowController *_tableWindowController;
	PreferencesController *_preferencesController;
	MenuItemController *_menuItemController;
	SyncController *_syncController;
	NSTimer *_periodicTimer;
}
@property (retain) TableWindowController *tableWindowController;
@property (retain) PreferencesController *preferencesController;
@property (retain) MenuItemController *menuItemController;
@property (retain) SyncController *syncController;
@property (retain) NSTimer *periodicTimer;

- (IBAction)showPreferences:(id)sender;
- (IBAction)showShelfWindow:(id)sender;
- (void)runRules;

@end
