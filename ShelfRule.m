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

+ (id)ruleWithDictionaryRepresentation:(NSDictionary *)representation {
	if (!representation) return nil;
	NSNumber *verb = [representation objectForKey:@"verb"];
	NSString *value = [representation objectForKey:@"value"];
	NSString *folder = [representation objectForKey:@"folder"];
	NSNumber *action = [representation objectForKey:@"action"];
	NSString *actionData = [representation objectForKey:@"actionData"];
	
	if (!verb || !action || ![verb isKindOfClass:[NSNumber class]] || ![action isKindOfClass:[NSNumber class]]) return nil;
	ShelfRule *rule = [ShelfRule rule];
	rule.verb = [verb unsignedIntValue];
	rule.value = value;
	rule.folder = [folder isEqualToString:@"<null>"] ? nil : folder;
	rule.action = [action unsignedIntValue];
	rule.actionData = [actionData isEqualToString:@"<null>"] ? nil : actionData;
	
	return rule;
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

- (NSArray *)matchedFiles {
	NSMutableArray *matchedFiles = [NSMutableArray array];
	for (NSString *fileName in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.folder error:nil])
	{
		NSString *path = [self.folder stringByAppendingPathComponent:fileName];
		if ([self matchesFile:path]) [matchedFiles addObject:path];
	}
	return matchedFiles;
}

- (BOOL)matchesFile:(NSString *)filePath {
	NSString *fileName = [filePath lastPathComponent];
	return 	(self.verb == kEndsWithVerb && [fileName hasSuffix:self.value]) 	||
			(self.verb == kBeginsWithVerb && [fileName hasPrefix:self.value]) 	||
			(self.verb == kContainsVerb && [fileName rangeOfString:self.value].location != NSNotFound);
}

- (void)performActionOnFile:(NSString *)filePath {
	// Adding something to the shelf involves moving it to the Shelf Items folder, adding a record
	// to the CoreData store (ShelfItem), and then deleting the original file, if necessary.
	if (self.action == kAddToShelfAction) {
		NSFileManager *fm = [NSFileManager defaultManager];
		NSError *err = nil;
		NSString *uuid = [[NSProcessInfo processInfo] globallyUniqueString];
		NSString *movePath = [[[[NSApp delegate] guaranteedShelfItemsFolder] stringByAppendingPathComponent:uuid] stringByAppendingPathExtension:[filePath pathExtension]];
		BOOL moved = [fm moveItemAtPath:filePath toPath:movePath error:&err];
		if ((!moved || err) && SHOULDLOG) {
			NSLog(@"%s Error moving item %@ to shelf.  Error message: %@", _cmd, filePath, err);
			return;
		}
		ShelfItem *item = [ShelfItem item];
		item.path = movePath;
		item.desc = [[filePath lastPathComponent] stringByDeletingPathExtension];
		[item fetchMetadata];
		if (SHOULDLOG) NSLog(@"[ShelfRule %s] Adding item: %@", _cmd, item);
		[fm removeItemAtPath:filePath error:nil];
		[[NSNotificationCenter defaultCenter] postNotificationName:NC_REFRESH_SHELF_KEY object:nil];
	}
	else if (self.action == kMoveToAction) {
		NSFileManager *fm = [NSFileManager defaultManager];
		NSError *err = nil;
		if ((![fm moveItemAtPath:filePath toPath:self.actionData error:&err] || err) && SHOULDLOG)
			NSLog(@"%s Error moving file %@ to folder %@: %@", _cmd, filePath, self.actionData, err);		
	}
	else if (self.action == kRunShellScriptAction) {
		if (![ShellScriptLauncher canLaunchScriptAtPath:self.actionData]) {
			if (SHOULDLOG) NSLog(@"%s Cannot run shell script at path: %@", _cmd, self.actionData);
			return;
		}
		[ShellScriptLauncher launchScriptAtPath:self.actionData withArguments:[NSArray arrayWithObject:filePath]];
	}
}

- (NSDictionary *)dictionaryRepresentation {
	return [NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithUnsignedInt:self.verb], @"verb",
		self.value, @"value",
		self.folder ? self.folder : @"<null>", @"folder",
		[NSNumber numberWithUnsignedInt:self.action], @"action",
		self.actionData ? self.actionData : @"<null>", @"actionData",
		@"1", @"version",
		nil];
}

- (NSString *)description {
	NSString *locformat = NSLocalizedString(@"<ShelfRule: If a file in %@ %@ %@, perform action %@ (%@)>", @"localized rule description");
	return [NSString stringWithFormat:locformat, self.folder, [[self verbs] objectAtIndex:self.verb], self.value, [[self actions] objectAtIndex:self.action], self.actionData, nil];
}

@end
