//
//  NewShelfRuleController.m
//  DesktopShelf
//
//  Created by Grayson Hansard on 3/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewShelfRuleController.h"
#import "ShelfRule.h"

#define kSheetMinSize 167
#define kSheetMaxSize 189


@implementation NewShelfRuleController

@synthesize fileEndingTextField = _fileEndingTextField;
@synthesize filePathTextField = _filePathTextField;
@synthesize actionPathTextField = _actionPathTextField;
@synthesize fileMatchPopUpButton = _fileMatchPopUpButton;
@synthesize actionPopUpButton = _actionPopUpButton;
@synthesize folderImageView = _folderImageView;
@synthesize actionImageView = _actionImageView;
@synthesize actionButton = _actionButton;
@synthesize delegate = _delegate;

- (id)init
{
	self = [super initWithWindowNibName:@"NewShelfRuleWindow"];
	if (!self) return nil;
	
	return self;
}

-(void)dealloc {
	self.fileEndingTextField = nil;
	self.filePathTextField = nil;
	self.actionPathTextField = nil;
	self.fileMatchPopUpButton = nil;
	self.actionPopUpButton = nil;
	self.folderImageView = nil;
	self.actionImageView = nil;
	self.delegate = nil;

	[super dealloc];
}


- (IBAction)chooseFolder:(id)sender {
	NSOpenPanel *op = [NSOpenPanel openPanel];
	[op setCanChooseDirectories:YES];
	[op setCanCreateDirectories:YES];
	[op setCanChooseFiles:NO];
	if ([op runModal] != NSOKButton) return;
	
	[self.filePathTextField setStringValue:[NSString stringWithString:[op filename]]];
	self.folderImageView.image = [[NSWorkspace sharedWorkspace] iconForFile:[op filename]];
}

- (IBAction)chooseAction:(id)sender {
	BOOL isMoveAction = self.actionPopUpButton.indexOfSelectedItem == 1;
	
	NSOpenPanel *op = [NSOpenPanel openPanel];
	[op setCanChooseDirectories:isMoveAction];
	[op setCanCreateDirectories:isMoveAction];
	[op setCanChooseFiles:!isMoveAction];
	if ([op runModal] != NSOKButton) return;
	
	[self.actionPathTextField setStringValue:[NSString stringWithString:[op filename]]];
	self.actionImageView.image = [[NSWorkspace sharedWorkspace] iconForFile:[op filename]];
}

- (IBAction)actionChanged:(id)sender {
	NSRect f = self.window.frame;
	BOOL isShortWindow = self.actionPopUpButton.indexOfSelectedItem == 0;
	
	f.size.height = isShortWindow ? kSheetMinSize : kSheetMaxSize;
	
	[self.window setFrame:f display:YES animate:YES];

	[self.actionImageView setHidden: isShortWindow];
	[self.actionPathTextField setHidden: isShortWindow];
	[self.actionButton setHidden: isShortWindow];
}

- (IBAction)cancel:(id)sender; {
	[[self window] orderOut:sender];
	[NSApp endSheet:[self window]];
}

- (IBAction)addRule:(id)sender {
	ShelfRule *rule = [ShelfRule rule];
	rule.verb = [self.fileMatchPopUpButton indexOfSelectedItem];
	rule.value = [NSString stringWithString:[self.fileEndingTextField stringValue]];
	rule.folder = [NSString stringWithString:[self.filePathTextField stringValue]];
	rule.action = [self.actionPopUpButton indexOfSelectedItem];
	rule.actionData = [NSString stringWithString:[self.actionPathTextField stringValue]];
	if (self.delegate && [self.delegate respondsToSelector:@selector(newRuleWasCreated:)]) [self.delegate newRuleWasCreated:rule];
	
	[self cancel:sender]; // To close the window.
}

- (IBAction)showWindow:(id)sender {	
	[self window]; // Stub used to force the window controller to load items in the nib.
	
	// Set up defaults
	NSArray *desktops = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
	NSString *folder = [desktops lastObject];
	if (!folder) folder = NSHomeDirectory();

	NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFile:folder];
	self.folderImageView.image = icon;
	self.actionImageView.image = icon;

	[self.filePathTextField setStringValue:folder];
	[self.actionPathTextField setStringValue: folder];
	
	[self.actionPopUpButton selectItemAtIndex:0];
	
	// Resize after a delay so that it doesn't mess up the window orientation.
	[self performSelector:@selector(actionChanged:) withObject:sender afterDelay:0.01];
	
	// Finally, I can show the damn window.
	[NSApp beginSheet:[self window] modalForWindow:[NSApp keyWindow] modalDelegate:self didEndSelector:@selector(sheetWillClose:) contextInfo:nil];
}

- (void)sheetWillClose:(id)anArgument
{
	NSLog(@"%s", _cmd);
}

@end
