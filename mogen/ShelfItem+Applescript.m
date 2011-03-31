//
//  ShelfItem+Applescript.m
//  DesktopShelf
//
//  Created by Grayson Hansard on 3/31/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import "ShelfItem+Applescript.h"


@implementation ShelfItem (ShelfItem_Applescript)

-(id)objectSpecifier
{
	NSArray *items = [ShelfItem everyItem];
	unsigned idx = [items indexOfObjectIdenticalTo:self];
	NSScriptClassDescription *containerRef = (NSScriptClassDescription *)[NSApp classDescription];
	NSScriptObjectSpecifier *spec = nil;
	if (idx != NSNotFound)
	{
		spec = [[[NSIndexSpecifier allocWithZone:[self zone]] initWithContainerClassDescription:containerRef
																			 containerSpecifier:[NSApp objectSpecifier]
																							key:@"shelf items"
																						  index:idx] autorelease];
	}
	
	return spec;
}

@end
