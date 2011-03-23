//
//  MenuItemController.h
//  DesktopShelf
//
//  Created by Grayson Hansard on 3/22/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MenuItemController : NSObject {
	NSStatusItem *_statusItem;
	id _delegate;
}
@property (retain) NSStatusItem *statusItem;
@property (retain) id delegate;

- (void)showMenuItem;
- (void)hideMenuItem;

- (void)update;

- (IBAction)showPreferences:(id)sender;

@end
