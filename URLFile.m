//
//  URLFile.m
//  SiteTagger
//
//  Created by Grayson Hansard on 3/3/07.
//  Copyright 2007 From Concentrate Software. All rights reserved.
//

#import "URLFile.h"


@implementation URLFile

+ (id)URLFileWithContentsOfFile:(NSString *)path
{
	id f = [[[self class] alloc] initWithContentsOfFile:(NSString *)path];
	return [f autorelease];
}

- (id)initWithContentsOfFile:(NSString *)path
{
	self = [super init];
	if (!self) return nil;
	
	NSString *s = [NSString stringWithContentsOfFile:path usedEncoding:nil error:nil];
	NSArray *lines = [s componentsSeparatedByString:@"\n"];
	NSEnumerator *lineEnumerator = [lines objectEnumerator];
	NSString *line;
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	while (line = [lineEnumerator nextObject])
	{
		if ([line rangeOfString:@"="].location != NSNotFound)
		{
			NSArray *split = [line componentsSeparatedByString:@"="];
			[dict setObject:[split objectAtIndex:1] forKey:[split objectAtIndex:0]];
		}
	}
	_data = [[NSDictionary alloc] initWithDictionary:dict];
	
	return self;
}

- (void)dealloc
{
	[_data release];
	_data = nil;
	[super dealloc];
}

- (NSString *)uri { return [_data valueForKey:@"URL"]; }
- (NSURL *)url { return [NSURL URLWithString:[_data valueForKey:@"URL"]]; }
- (NSString *)title { return [_data valueForKey:@"Title"]; }
- (NSString *)name { return [self title]; }

- (NSDictionary *)data { return [[_data copy] autorelease]; }

@end
