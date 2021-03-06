//
//  DesktopShelf_AppDelegate.h
//  DesktopShelf
//
//  Created by Grayson Hansard on 2/24/11.
//  Copyright From Concentrate Software 2011 . All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DesktopShelfController.h"

@interface DesktopShelf_AppDelegate : NSObject 
{
	DesktopShelfController *_shelfController;
	
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
}
@property (retain) DesktopShelfController *shelfController;

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

- (NSString *)applicationSupportDirectory;
- (IBAction)saveAction:sender;

@end
