//
//  SyncController.h
//  DesktopShelf
//
//  Created by Grayson Hansard on 3/30/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SyncServices/SyncServices.h>

#define kSyncControllerErrorDomain @"com.fcs.sharedcode.synccontroller.error"
enum {
	AppDelegateDoesNotProvidePersistentStoreCoordinator = 0,
	AppDelegateDoesNotProvideManagedObjectContext,
	CouldntFindClientDescriptionPath,
	CaughtAnException,
};

@interface SyncController : NSObject <NSPersistentStoreCoordinatorSyncing> {
	id _delegate;
}
@property (retain) id delegate;

- (ISyncClient *)syncClient;
- (BOOL)sync;

@end


@interface NSObject (SyncControllerDelegateInformalProtocol)
- (void)syncController:(SyncController *)controller encounteredError:(NSError *)error;
@end
