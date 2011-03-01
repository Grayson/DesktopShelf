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

@interface DesktopShelfController : NSObject {
	TableWindowController *_tableWindowController;
	PreferencesController *_preferencesController;
	NSTimer *_periodicTimer;
}
@property (retain) TableWindowController *tableWindowController;
@property (retain) PreferencesController *preferencesController;
@property (retain) NSTimer *periodicTimer;

- (IBAction)showPreferences:(id)sender;
- (void)runRules;

@end
