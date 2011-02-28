//
//  WeblocFile.m
//  SiteTagger
//
//  Created by Grayson Hansard on 11/11/06.
//  Copyright 2006 From Concentrate Software. All rights reserved.
//

#import "WeblocFile.h"


@implementation WeblocFile

+ (id)weblocFileWithName:(NSString *)name andURI:(NSString *)uri
{
	WeblocFile *f = [[[self alloc] init] autorelease];
	[f setName:name];
	[f setURI:uri];
	return f;
}

+ (id)weblocFileWithFile:(NSString *)path
{
	WeblocFile *f = [[[self alloc] initWithFile:path] autorelease];
	return f;
}

- (id)initWithFile:(NSString *)path
{
	self = [super init];
	if (!self) return nil;
	
	// If one of the newer plist formats, grab it and bail.  So easy.
	NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:path];
	if (d && [d objectForKey:@"URL"]) {
		[self setURI:[d objectForKey:@"URL"]];
		[self setName:[[path lastPathComponent] stringByDeletingPathExtension]];
		return self;
	}
	
	// Otherwise, we'll need to delve into the evil, evil RSRC fork
	FSRef ref;
	Handle handle = nil;
	SInt16 file;
	NSString *title = nil, *url = nil;
	OSErr err = noErr;
	
	if ([path hasPrefix:@"file:/"]) path = [path substringFromIndex:6];
	if ([path hasPrefix:@"/localhost"]) path = [path substringFromIndex:10];
	
	if (FSPathMakeRef((const UInt8 *)[path UTF8String], &ref, NO) == noErr)
	{
		file = FSOpenResFile(&ref, fsRdPerm);
		err = ResError();		
		if (err == noErr)
		{
			UseResFile(file);
			handle = Get1Resource('url ', 256);
			if (handle)
			{	
				HLock(handle);
				NSData *tmp = [NSData dataWithBytes:*handle length:GetHandleSize(handle)];
				if (tmp && [tmp length]) url = [NSString stringWithUTF8String:[tmp bytes]];
				HUnlock(handle);
			}
		}
		else err = -1;
		
		if (err == noErr)
		{
			handle = Get1Resource('urln', 256);
			if (handle)
			{	
				HLock(handle);
				NSData *tmp = [NSData dataWithBytes:*handle length:GetHandleSize(handle)];
				if (tmp && [tmp length]) title = [NSString stringWithUTF8String:[tmp bytes]];
				HUnlock(handle);
			}
		}
		// else err = -1;
		ReleaseResource(handle);
		CloseResFile(file);
		FSCloseFork(file);
		err = ResError();
		
		if (url && (!title || [title isEqualToString:@""]) )
		{
			err = noErr;
			title = [[path lastPathComponent] stringByDeletingPathExtension];
		}
		
		if (err != noErr || !title || !url || ![title length] || ![url length])
			return nil;
			
		[self setName:title];
		[self setURI:url];
	}
	else return nil;
	
	
	return self;
}

-(BOOL)writeToFile:(NSString *)path
{
	NSDictionary *d = [NSDictionary dictionaryWithObject:[self uri] forKey:@"URL"];
	return [d writeToFile:path atomically:YES];
	// 	FSRef fref;
	// 	FSSpec spec;
	// 	OSErr err;
	// 	BOOL success = YES;
	// 	short file = -1;
	// 
	// 	NSString *url = [self uri];
	// 	NSString *title = [self name];
	// 	[url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
	// 	err = FSPathMakeRef((const UInt8 *)[path fileSystemRepresentation], &fref, NO);
	// 	if (err != noErr) { NSLog(@"FSPathMakeRef failed: %d", err); goto failed; }
	// 
	// 	err = FSGetCatalogInfo(&fref, kFSCatInfoNone, NULL, NULL, &spec, NULL);
	// 	if (err != noErr) { NSLog(@"FSGetCatalogInfo failed: %d", err); goto failed; }
	// 
	// 	OSType type = kInternetLocationGeneric;
	// 	if ([url hasPrefix:@"http://"]) type = kInternetLocationHTTP;
	// 	else if ([url hasPrefix:@"ftp://"]) type = kInternetLocationFTP;
	// 	FSpCreateResFile(&spec, kInternetLocationCreator, type, smUnicodeScript);
	// 	err = ResError();
	// 	if (err != noErr) { NSLog(@"FSpCreateResFile failed: %d", err); goto failed;}
	// 
	// 	file = FSOpenResFile(&fref, fsRdWrPerm);
	// 	if (file == -1) { NSLog(@"FSOpenResFile failed."); goto failed; }
	// 	UseResFile(file);
	// 
	// 	if (ResError() != noErr) { NSLog(@"UseResFile failed: %d", ResError()); goto failed; }
	// 
	// 	Handle urlHandle;
	// 	Handle titleHandle;
	// 	Handle textHandle;
	// 
	// 	PtrToHand([url UTF8String], &urlHandle, [url lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
	// 	PtrToHand([title UTF8String], &titleHandle, [title lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
	// 	PtrToHand([url UTF8String], &textHandle, [url lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
	// 
	// 	AddResource(textHandle, 'TEXT', 256, "\p");
	// 	AddResource(urlHandle, 'url ', 256, "\p");
	// 	AddResource(titleHandle, 'urln', 256, "\p");
	// 
	// 	goto cleanup;
	// 
	// failed:;
	// 	success = NO;
	// 
	// cleanup:;
	// 	if (file > -1)
	// 	{
	// 		CloseResFile(file);
	// 		FSCloseFork(file);
	// 	}
	// 	return success;
}

- (NSURL *)url
{
	return [NSURL URLWithString:[self uri]];
}

- (NSString *)name
{
	return _name;
}

- (void)setName:(NSString *)aName
{
	aName = [aName copy];
	[_name release];
	_name = aName;
}

- (NSString *)uri
{
	return _uri;
}

- (void)setURI:(NSString *)aUri
{
	aUri = [aUri copy];
	[_uri release];
	_uri = aUri;
}


@end
