#import "ShelfItem.h"

@implementation ShelfItem

+ (id)item
{
	NSManagedObjectContext *context = [[NSApp delegate] managedObjectContext];
	NSEntityDescription *desc = [NSEntityDescription entityForName:[[self class] entityName] inManagedObjectContext:context];
	id obj = [[[self class] alloc] initWithEntity:desc insertIntoManagedObjectContext:context];
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

@end
