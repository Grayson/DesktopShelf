//
//  ShelfRule.h
//  DesktopShelf
//
//  Created by Grayson Hansard on 2/25/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/*
	Rule:
		if file in [checkFolder] [begins with/ends with/contains] [value] then [action].
	
	Example:
		if file in Desktop ends with .webloc then add to shelf
		if file in ~ ends with .txt then move to ~/Documents
		if file in Desktop/blah contains "dosomething" then run shell script ~/bin/script.sh
*/

enum rule_verbs {
	kEndsWithVerb = 0,
	kBeginsWithVerb,
	kContainsVerb,
};

enum rule_actions {
	kAddToShelfAction = 0,
	kMoveToAction,
	kRunShellScriptAction,
};

#import "ShellScriptLauncher.h"
#import "DesktopShelf_AppDelegate+Additions.h"
#import "includes.h"
#import "ShelfItem.h"

@interface ShelfRule : NSObject {
	NSUInteger _verb;
	NSString *_value;
	NSString *_folder;
	NSUInteger _action;
	NSString *_actionData;
}
@property (assign) NSUInteger verb;
@property (retain) NSString *value;
@property (retain) NSString *folder;
@property (assign) NSUInteger action;
@property (retain) NSString *actionData;

+ (id)rule;
+ (id)ruleWithDictionaryRepresentation:(NSDictionary *)representation;
+ (NSArray *)defaultRules;

- (NSArray *)verbs;
- (NSArray *)actions;

- (NSArray *)matchedFiles;
- (BOOL)matchesFile:(NSString *)filePath;
- (void)performActionOnFile:(NSString *)filePath;

- (NSDictionary *)dictionaryRepresentation;

@end
