//
//  URLFile.h
//  SiteTagger
//
//  Created by Grayson Hansard on 3/3/07.
//  Copyright 2007 From Concentrate Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface URLFile : NSObject {
	NSDictionary *_data;
}

+ (id)URLFileWithContentsOfFile:(NSString *)path;
- (id)initWithContentsOfFile:(NSString *)path;

- (NSString *)uri;
- (NSURL *)url;
- (NSString *)title;
- (NSString *)name;

- (NSDictionary *)data;

@end
