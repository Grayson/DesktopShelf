//
//  SyncController.m
//  DesktopShelf
//
//  Created by Grayson Hansard on 3/30/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import "SyncController.h"

@interface SyncController (NSPersistentStoreCoordinatorSyncingMethods)
- (NSArray *)managedObjectContextsToMonitorWhenSyncingPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;
- (NSArray *)managedObjectContextsToReloadAfterSyncingPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;
- (void)persistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator didApplyChange:(ISyncChange *)change toManagedObject:(NSManagedObject *)managedObject inSyncSession:(ISyncSession *)session;
- (void)persistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator didCancelSyncSession:(ISyncSession *)session error:(NSError *)error;
- (void)persistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator didCommitChanges:(NSDictionary *)changes inSyncSession:(ISyncSession *)session;
- (void)persistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator didFinishSyncSession:(ISyncSession *)session;
- (void)persistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator didPullChangesInSyncSession:(ISyncSession *)session;
- (void)persistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator didPushChangesInSyncSession:(ISyncSession *)session;
- (ISyncChange *)persistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator willApplyChange:(ISyncChange *)change toManagedObject:(NSManagedObject *)managedObject inSyncSession:(ISyncSession *)session;
- (BOOL)persistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator willDeleteRecordWithIdentifier:(NSString *)identifier inSyncSession:(ISyncSession *)session;
- (void)persistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator willPullChangesInSyncSession:(ISyncSession *)session;
- (void)persistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator willPushChangesInSyncSession:(ISyncSession *)session;
- (NSDictionary *)persistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator willPushRecord:(NSDictionary *)record forManagedObject:(NSManagedObject *)managedObject inSyncSession:(ISyncSession *)session;
- (BOOL)persistentStoreCoordinatorShouldStartSyncing:(NSPersistentStoreCoordinator *)coordinator;
@end

@interface SyncController (PrivateMethods)
- (void)_sendErrorToDelegateWithMessage:(NSString *)errorMessage code:(NSInteger)code;
@end


@implementation SyncController
@synthesize delegate = _delegate;

- (id)init
{
	return nil;
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
	self.delegate = nil;
    [super dealloc];
}

- (ISyncClient *)syncClient {
	NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
	ISyncClient *client = [[ISyncManager sharedManager] clientWithIdentifier:identifier];
	if (client) return client;
	
	NSString *syncSchemaName = [[[NSProcessInfo processInfo] processName] stringByAppendingString:@"Sync"];
	if (![[ISyncManager sharedManager] registerSchemaWithBundlePath:[[NSBundle mainBundle] pathForResource:syncSchemaName ofType:@"syncschema"]])
		return nil;
	
	NSString *clientDescriptionPath = [[NSBundle mainBundle] pathForResource:@"ClientDescription" ofType:@"plist"];
	if (!clientDescriptionPath) {
		[self _sendErrorToDelegateWithMessage: NSLocalizedString(@"Could not locate ClientDescription.plist in the Resources folder.", @"sync error message") code:CouldntFindClientDescriptionPath];
		return nil;
	}
	
	@try {
		client = [[ISyncManager sharedManager] registerClientWithIdentifier:identifier descriptionFilePath:clientDescriptionPath];
	    [client setShouldSynchronize:YES withClientsOfType:ISyncClientTypeApplication];
	    [client setShouldSynchronize:YES withClientsOfType:ISyncClientTypeDevice];
	    [client setShouldSynchronize:YES withClientsOfType:ISyncClientTypeServer];
	    [client setShouldSynchronize:YES withClientsOfType:ISyncClientTypePeer];
	
		return client;
	}
	@catch (NSException *exception) {
		[self _sendErrorToDelegateWithMessage: [NSString stringWithFormat:NSLocalizedString(@"ISyncManager threw an exception: %@", @"sync error message"), exception] code:CaughtAnException];
	}
	return nil;
}

- (BOOL)sync {
	if (![[NSApp delegate] respondsToSelector:@selector(persistentStoreCoordinator)]) {
		[self _sendErrorToDelegateWithMessage: NSLocalizedString(@"The NSApp delegate does not respond to -persistentStoreCoordinator.", @"sync error message") code:AppDelegateDoesNotProvidePersistentStoreCoordinator];
		return NO;
	}
	
	ISyncClient *client = [self syncClient];
	NSLog(@"%s %@", _cmd, client);
	if (!client) return NO;
	NSError *err = nil;
	id syncDelegate = (self.delegate && [self.delegate conformsToProtocol:@protocol(NSPersistentStoreCoordinatorSyncing)]) ? self.delegate : self;
	[[[NSApp delegate] performSelector:@selector(persistentStoreCoordinator)] syncWithClient:client inBackground:YES handler:syncDelegate error:&err];
	return YES;
}

#pragma mark -
#pragma mark Private Methods

- (void)_sendErrorToDelegateWithMessage:(NSString *)errorMessage code:(NSInteger)code {
	if (![self.delegate respondsToSelector:@selector(syncController:encounteredError:)]) return;
	NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:errorMessage, NSLocalizedDescriptionKey, nil];
	NSError *err = [NSError errorWithDomain:@"com.fcs.sharedcode.synccontroller.error" code:code userInfo:userInfo];
	[self.delegate syncController:self encounteredError:err];
}

#pragma mark -
#pragma mark Syncing delegation stuff

// - (void)client:(ISyncClient *)client mightWantToSyncEntityNames:(NSArray *)entityNames { }
// 
// - (NSArray *)managedObjectContextsToMonitorWhenSyncingPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator
// {
// 	if (![[NSApp delegate] respondsToSelector:@selector(managedObjectContext)]) {
// 		return nil;
// 	}
// 	return [[NSApp delegate] performSelector:@selector(managedObjectContext)];
// }
// 
// - (NSArray *)managedObjectContextsToReloadAfterSyncingPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator
// {
// 	return [self managedObjectContextsToMonitorWhenSyncingPersistentStoreCoordinator:coordinator];
// }
- (void)persistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator didApplyChange:(ISyncChange *)change toManagedObject:(NSManagedObject *)managedObject inSyncSession:(ISyncSession *)session {}
- (void)persistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator didCancelSyncSession:(ISyncSession *)session error:(NSError *)error {}
- (void)persistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator didCommitChanges:(NSDictionary *)changes inSyncSession:(ISyncSession *)session {}
- (void)persistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator didFinishSyncSession:(ISyncSession *)session {}
- (void)persistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator didPullChangesInSyncSession:(ISyncSession *)session {}
- (void)persistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator didPushChangesInSyncSession:(ISyncSession *)session {}
// - (ISyncChange *)persistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator willApplyChange:(ISyncChange *)change toManagedObject:(NSManagedObject *)managedObject inSyncSession:(ISyncSession *)session {}
// - (BOOL)persistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator willDeleteRecordWithIdentifier:(NSString *)identifier inSyncSession:(ISyncSession *)session {}
- (void)persistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator willPullChangesInSyncSession:(ISyncSession *)session {}
- (void)persistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator willPushChangesInSyncSession:(ISyncSession *)session {}
// - (NSDictionary *)persistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator willPushRecord:(NSDictionary *)record forManagedObject:(NSManagedObject *)managedObject inSyncSession:(ISyncSession *)session {}
- (BOOL)persistentStoreCoordinatorShouldStartSyncing:(NSPersistentStoreCoordinator *)coordinator { return YES; }

@end
