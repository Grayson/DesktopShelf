// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ShelfItem.h instead.

#import <CoreData/CoreData.h>












@interface ShelfItemID : NSManagedObjectID {}
@end

@interface _ShelfItem : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ShelfItemID*)objectID;



@property (nonatomic, retain) NSString *desc;

//- (BOOL)validateDesc:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *type;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *path;

//- (BOOL)validatePath:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSData *icon;

//- (BOOL)validateIcon:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSData *data;

//- (BOOL)validateData:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSData *extraData;

//- (BOOL)validateExtraData:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSDate *dateModified;

//- (BOOL)validateDateModified:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSDate *dateCreated;

//- (BOOL)validateDateCreated:(id*)value_ error:(NSError**)error_;





@end

@interface _ShelfItem (CoreDataGeneratedAccessors)

@end

@interface _ShelfItem (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveDesc;
- (void)setPrimitiveDesc:(NSString*)value;


- (NSString*)primitiveType;
- (void)setPrimitiveType:(NSString*)value;


- (NSString*)primitivePath;
- (void)setPrimitivePath:(NSString*)value;


- (NSData*)primitiveIcon;
- (void)setPrimitiveIcon:(NSData*)value;


- (NSData*)primitiveData;
- (void)setPrimitiveData:(NSData*)value;


- (NSData*)primitiveExtraData;
- (void)setPrimitiveExtraData:(NSData*)value;


- (NSDate*)primitiveDateModified;
- (void)setPrimitiveDateModified:(NSDate*)value;


- (NSDate*)primitiveDateCreated;
- (void)setPrimitiveDateCreated:(NSDate*)value;



@end
