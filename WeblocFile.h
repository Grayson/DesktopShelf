//
//  WeblocFile.h
//  SiteTagger
//
//  Created by Grayson Hansard on 11/11/06.
//  Copyright 2006 From Concentrate Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

@interface WeblocFile : NSObject {
	NSString *_name;
	NSString *_uri;
}

+ (id)weblocFileWithName:(NSString *)name andURI:(NSString *)uri;
+ (id)weblocFileWithFile:(NSString *)path;
- (id)initWithFile:(NSString *)path;

-(BOOL)writeToFile:(NSString *)path;

- (NSString *)name;
- (NSString *)uri;
- (NSURL *)url;

- (void)setName:(NSString *)aString;
- (void)setURI:(NSString *)aString;

@end
