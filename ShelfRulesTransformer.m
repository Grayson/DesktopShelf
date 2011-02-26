//
//  ShelfRulesTransformer.m
//  DesktopShelf
//
//  Created by Grayson Hansard on 2/25/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import "ShelfRulesTransformer.h"


@implementation ShelfRulesTransformer

+(void)load {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	[NSValueTransformer setValueTransformer:[[[self class] new] autorelease] forName:NSStringFromClass([self class])];
	[pool drain];
}

+ (Class)transformedValueClass { return [NSString class]; }
+ (BOOL)allowsReverseTransformation { return NO; }
- (id)transformedValue:(id)value {
	return (value == nil) ? nil : [[NSImage alloc] initWithData:value];
}

@end
