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
+ (NSArray *)defaultRules;

- (NSArray *)verbs;
- (NSArray *)actions;

@end
