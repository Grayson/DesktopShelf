//
//  DesktopShelf_AppDelegate.h
//  DesktopShelf
//
//  Created by Grayson Hansard on 2/24/11.
//  Copyright From Concentrate Software 2011 . All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DesktopShelf_AppDelegate : NSObject 
{
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:sender;

@end
