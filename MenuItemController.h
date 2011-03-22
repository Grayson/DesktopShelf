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
}
@property (retain) NSStatusItem *statusItem;

- (void)showMenuItem;
- (void)hideMenuItem;

- (void)update;

@end
