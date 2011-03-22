//
//  PreferencesController.h
//  DesktopShelf
//
//  Created by Grayson Hansard on 2/25/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "includes.h"
#import "NewShelfRuleController.h"

@interface PreferencesController : NSObject {
	IBOutlet NSWindow *_window;
	NewShelfRuleController *_newShelfRuleController;
}
@property (retain) NSWindow *window;
@property (retain) NewShelfRuleController *newShelfRuleController;

- (void)showWindow;
- (IBAction)resetAllWarnings:(id)sender;

- (BOOL)dockItemIsDisabled;
- (void)setDockItemIsDisabled:(BOOL)newDockItemIsDisabled;

- (NSArray *)shelfRules;
- (void)setShelfRules:(NSArray *)newShelfRules;

- (IBAction)addShelfRule:(id)sender;

@end
