//
//  DataToImageTransformer.m
//  DesktopShelf
//
//  Created by Grayson Hansard on 2/24/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import "DataToImageTransformer.h"


@implementation DataToImageTransformer

+(void)load {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	[NSValueTransformer setValueTransformer:[[[self class] new] autorelease] forName:NSStringFromClass([self class])];
	[pool drain];
}

+ (Class)transformedValueClass { return [NSImage class]; }
+ (BOOL)allowsReverseTransformation { return NO; }
- (id)transformedValue:(id)value {
	return (value == nil) ? nil : [[[NSImage alloc] initWithData:value] autorelease];
}

@end
