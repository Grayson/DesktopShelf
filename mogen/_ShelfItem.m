// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ShelfItem.m instead.

#import "_ShelfItem.h"

@implementation ShelfItemID
@end

@implementation _ShelfItem

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"ShelfItem" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"ShelfItem";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"ShelfItem" inManagedObjectContext:moc_];
}

- (ShelfItemID*)objectID {
	return (ShelfItemID*)[super objectID];
}




@dynamic desc;






@dynamic dateAdded;






@dynamic type;






@dynamic icon;






@dynamic data;






@dynamic extraData;






@dynamic dateModified;






@dynamic url;










@end
