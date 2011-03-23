//
//  DesktopShelf_AppDelegate+Additions.h
//  DesktopShelf
//
//  Created by Grayson Hansard on 2/28/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "DesktopShelf_AppDelegate.h"

@interface DesktopShelf_AppDelegate (Additions)

- (NSString *)guaranteedApplicationSupportDirectory;
- (NSString *)guaranteedShelfItemsFolder;
- (BOOL)dockItemIsDisabled;
- (void)setDockItemIsDisabled:(BOOL)newDockItemIsDisabled;


@end
