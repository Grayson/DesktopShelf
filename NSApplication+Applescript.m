//
//  NSApplication+Applescript.m
//  DesktopShelf
//
//  Created by Grayson Hansard on 3/31/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import "NSApplication+Applescript.h"
#import "ShelfItem.h"

@implementation NSApplication (NSApplication_Applescript)

- (NSArray *)shelfItems {
	return [ShelfItem everyItem];
}

@end
