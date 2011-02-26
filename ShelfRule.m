//
//  ShelfRule.m
//  DesktopShelf
//
//  Created by Grayson Hansard on 2/25/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import "ShelfRule.h"


@implementation ShelfRule
@synthesize verb = _verb;
@synthesize value = _value;
@synthesize folder = _folder;
@synthesize action = _action;
@synthesize actionData = _actionData;

+ (id)rule {
	return [[[self class] new] autorelease];
}

+ (NSArray *)defaultRules {
	ShelfRule *weblocRule = [ShelfRule rule];
	ShelfRule *urlRule = [ShelfRule rule];
	NSString *desktopFolder = [NSSearchPathForDirectoriesInDomains (NSDesktopDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	weblocRule.verb = 0;
	weblocRule.value = @".webloc";
	weblocRule.folder = desktopFolder;
	weblocRule.action = 0;
	
	urlRule.verb = 0;
	urlRule.value = @".url";
	urlRule.folder = desktopFolder;
	urlRule.action = 0;
	
	return [NSArray arrayWithObjects:weblocRule, urlRule, nil];
}

- (void)dealloc
{
	self.value = nil;
	self.folder = nil;
	self.actionData = nil;
	
	[super dealloc];
}

- (NSArray *)verbs {
	return [NSArray arrayWithObjects:
		NSLocalizedString(@"ends with", @"rule verb"),
		NSLocalizedString(@"begins with", @"rule verb"),
		NSLocalizedString(@"contains", @"rule verb"),
		nil];
}

- (NSArray *)actions {
	return [NSArray arrayWithObjects:
		NSLocalizedString(@"add to shelf", @"rule action"),
		NSLocalizedString(@"move to", @"rule action"),
		NSLocalizedString(@"run shell script", @"rule action"),
		nil];
}

- (NSString *)description {
	NSString *locformat = NSLocalizedString(@"<ShelfRule: If a file in %@ %@ %@, perform action %@ (%@)>", @"localized rule description");
	return [NSString stringWithFormat:locformat, self.folder, [[self verbs] objectAtIndex:self.verb], self.value, [[self actions] objectAtIndex:self.action], self.actionData, nil];
}

@end
