//
//  NewShelfRuleController.m
//  DesktopShelf
//
//  Created by Grayson Hansard on 3/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewShelfRuleController.h"

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
	
	[self.filePathTextField setStringValue:[NSString stringWithString:[op filename]]];
	self.folderImageView.image = [[NSWorkspace sharedWorkspace] iconForFile:[op filename]];
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
	NSLog(@"%s", _cmd);
	[self cancel:sender];
}

- (IBAction)showWindow:(id)sender {	
	NSRect f = self.window.frame;
	float adjust = f.size.height - kSheetMinSize;
	f.size.height = kSheetMinSize;
	f.origin.y += adjust;

	[self.actionImageView setHidden: YES];
	[self.actionPathTextField setHidden: YES];
	[self.actionButton setHidden: YES];

	[self.window setFrame:f display:YES animate:NO];
	
	[NSApp beginSheet:[self window] modalForWindow:[NSApp keyWindow] modalDelegate:self didEndSelector:@selector(sheetWillClose:) contextInfo:nil];
}

- (void)sheetWillClose:(id)anArgument
{
	NSLog(@"%s", _cmd);
}

@end
