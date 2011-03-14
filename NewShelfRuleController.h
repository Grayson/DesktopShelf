//
//  NewShelfRuleController.h
//  DesktopShelf
//
//  Created by Grayson Hansard on 3/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NewShelfRuleController : NSObject {
	IBOutlet NSTextField *_fileEndingTextField;
	IBOutlet NSTextField *_filePathTextField;
	IBOutlet NSTextField *_actionPathTextField;
	IBOutlet NSPopUpButton *_fileMatchPopUpButton;
	IBOutlet NSPopUpButton *_actionPopUpButton;
	IBOutlet NSImageView *_folderImageView;
	IBOutlet NSImageView *_actionImageView;
}

@property (retain) NSTextField *fileEndingTextField;
@property (retain) NSTextField *filePathTextField;
@property (retain) NSTextField *actionPathTextField;
@property (retain) NSPopUpButton *fileMatchPopUpButton;
@property (retain) NSPopUpButton *actionPopUpButton;
@property (retain) NSImageView *folderImageView;
@property (retain) NSImageView *actionImageView;

- (IBAction)chooseFolder:(id)sender;
- (IBAction)chooseAction:(id)sender;
- (IBAction)actionChanged:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)addRule:(id)sender;

@end
