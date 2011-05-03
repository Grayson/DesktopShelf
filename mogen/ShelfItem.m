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
	if (SHOULDLOG) NSLog(@"[ShelfItem fetchIcon] Fetching icon for file: %@", self.path);
	
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	void (^block)(void) = nil;
	
	if ([self.path.pathExtension isEqualToString:@"webloc"] || [self.path.pathExtension isEqualToString:@"url"]) {
		block = ^{
			id file = nil;
			if ([self.path.pathExtension isEqualToString:@"webloc"]) file = [WeblocFile weblocFileWithFile:self.path];
			else file = [URLFile URLFileWithContentsOfFile:self.path];
			NSURL *url = [file url];
			NSURL *faviconURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/favicon.png", [url scheme], [url host]]];
			NSData *d = [NSData dataWithContentsOfURL:faviconURL];
			if (!d) {
				faviconURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/favicon.ico", [url scheme], [url host]]];
				d = [NSData dataWithContentsOfURL:faviconURL];
			}
			
			if (!d) return;
			self.icon = d;
			[self updateDateModified];
		};
	}
	else {
		block = ^{
			NSURL *url = [NSURL fileURLWithPath:self.path];
			NSImage *img = [[NSWorkspace sharedWorkspace] iconForFile:[url path]];
			if (!img) return;
			self.icon = [img TIFFRepresentation];
			[self updateDateModified];
		};
	}
	if (block) dispatch_async(queue, block);
}

-(void)open {
	NSURL *url = [NSURL fileURLWithPath:self.path];
	[[NSWorkspace sharedWorkspace] openURL:url];
}

-(void)fetchMetadata {
	if (!self.icon) [self fetchIcon];
}

@end
