//
//  ShelfRulesTransformer.m
//  DesktopShelf
//
//  Created by Grayson Hansard on 2/25/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import "ShelfRulesTransformer.h"


@implementation ShelfRulesTransformer

NSAttributedString *toas (NSString *str) {
	return [[[NSAttributedString alloc] initWithString:str] autorelease];
}

NSAttributedString *aswithimage (NSImage *img) {
	NSFileWrapper *fw = [[[NSFileWrapper alloc] initWithSerializedRepresentation:[img TIFFRepresentation]] autorelease];
	NSTextAttachment *ta = [[[NSTextAttachment alloc] initWithFileWrapper:fw] autorelease];
	NSLog(@"%@", ta);
	return [NSAttributedString attributedStringWithAttachment:ta];
}

+(void)load {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	[NSValueTransformer setValueTransformer:[[[self class] new] autorelease] forName:NSStringFromClass([self class])];
	[pool drain];
}

+ (Class)transformedValueClass { return [NSAttributedString class]; }
+ (BOOL)allowsReverseTransformation { return NO; }
- (id)transformedValue:(id)value {
	if (!value) return nil;
	
	ShelfRule *rule = (ShelfRule *)value;
	
	NSString *verb = [[rule verbs] objectAtIndex:rule.verb];
	NSString *match = rule.value;
	NSString *folder = rule.folder;
	NSString *action = [[rule actions] objectAtIndex:rule.action];
	NSString *actionData = rule.actionData;
	
	NSMutableAttributedString *as = [[NSMutableAttributedString new] autorelease];
	NSString *protasis = [NSString stringWithFormat:NSLocalizedString(@"For every file that %@ %@ ", @"rules transformer message format"), verb, match];
	NSString *folderMessage = NSLocalizedString(@"in ", @"rules transformer message format");
	
	[as appendAttributedString:toas(protasis)];
	[as appendAttributedString:toas(folderMessage)];
	// [as appendAttributedString:aswithimage([[NSWorkspace sharedWorkspace] iconForFile:folder])];
	[as appendAttributedString:toas([folder lastPathComponent])];
	[as appendAttributedString:toas(@", ")];
	
	if (rule.action == kAddToShelfAction) [as appendAttributedString:toas(action)];
	else {
		NSImage *img = [[NSWorkspace sharedWorkspace] iconForFile:actionData];
		[as appendAttributedString:toas([NSString stringWithFormat:@"%@", action])];
		// [as appendAttributedString:aswithimage(img)];
		[as appendAttributedString:toas(action)];
		[as appendAttributedString:toas(actionData)];
	}
	[as appendAttributedString:toas(@".")];
	
	return as;
}

@end
