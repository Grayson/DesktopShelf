//
//  NewShelfRuleController.m
//  DesktopShelf
//
//  Created by Grayson Hansard on 3/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewShelfRuleController.h"


@implementation NewShelfRuleController

@synthesize fileEndingTextField = _fileEndingTextField;
@synthesize filePathTextField = _filePathTextField;
@synthesize actionPathTextField = _actionPathTextField;
@synthesize fileMatchPopUpButton = _fileMatchPopUpButton;
@synthesize actionPopUpButton = _actionPopUpButton;
@synthesize folderImageView = _folderImageView;
@synthesize actionImageView = _actionImageView;


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


@end
