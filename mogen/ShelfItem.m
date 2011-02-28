#import "ShelfItem.h"

@implementation ShelfItem

+ (id)item
{
	NSManagedObjectContext *context = [[NSApp delegate] managedObjectContext];
	NSEntityDescription *desc = [NSEntityDescription entityForName:[[self class] entityName] inManagedObjectContext:context];
	id obj = [[[self class] alloc] initWithEntity:desc insertIntoManagedObjectContext:context];
	[obj setValue:[NSDate date] forKey:@"dateCreated"];
	return [obj autorelease];	
}

+ (NSArray *)everyItem {
	NSManagedObjectContext *moc = [[NSApp delegate] managedObjectContext];
	NSEntityDescription *desc = [NSEntityDescription entityForName:[[self class] entityName] inManagedObjectContext:moc];
	NSFetchRequest *req = [[NSFetchRequest new] autorelease];
	[req setEntity:desc];
	return [moc executeFetchRequest:req error:nil];		
}

- (void)updateDateModified {
	self.dateModified = [NSDate date];
}

- (void)fetchIcon {
	if (SHOULDLOG) NSLog(@"[ShelfItem %s] Fetching icon for type: %@", _cmd, self.type);
	// 
	// dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	// void (^block)(void) = nil;
	// 
	// if ([self.type isEqualToString:@"bookmark"]) {
	// 	block = ^{
	// 		NSURL *url = [NSURL URLWithString:self.url];
	// 		NSURL *faviconURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/favicon.png", [url scheme], [url host]]];
	// 		NSData *d = [NSData dataWithContentsOfURL:faviconURL];
	// 		if (!d) {
	// 			faviconURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/favicon.ico", [url scheme], [url host]]];
	// 			d = [NSData dataWithContentsOfURL:faviconURL];
	// 		}
	// 		
	// 		if (!d) return;
	// 		self.icon = d;
	// 	};
	// }
	// else if ([self.type isEqualToString:@"file"]) {
	// 	block = ^{
	// 		NSURL *url = [NSURL URLWithString:self.url];
	// 		NSImage *img = [[NSWorkspace sharedWorkspace] iconForFile:[url path]];
	// 		self.icon = [img TIFFRepresentation];
	// 	};
	// }
	// 
	// dispatch_async(queue, block);
}

-(void)open {
	NSURL *url = [NSURL fileURLWithPath:self.path];//URLWithString:self.url];
	[[NSWorkspace sharedWorkspace] openURL:url];
}

@end
