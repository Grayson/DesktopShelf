//
//  PreferencesController.h
//  DesktopShelf
//
//  Created by Grayson Hansard on 2/25/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "includes.h"

@interface PreferencesController : NSObject {
	IBOutlet NSWindow *_window;
}
@property (retain) NSWindow *window;

- (void)showWindow;
- (IBAction)resetAllWarnings:(id)sender;

- (BOOL)dockItemIsDisabled;
- (void)setDockItemIsDisabled:(BOOL)newDockItemIsDisabled;

- (NSArray *)shelfRules;
- (void)setShelfRules:(NSArray *)newShelfRules;

@end
