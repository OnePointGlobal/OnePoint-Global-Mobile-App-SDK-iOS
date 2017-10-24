/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import "OPGFile.h"
#import "OPGAssetLibraryFilesystem.h"
#import "OPG.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

//NSString* const kCDVAssetsLibraryPrefix = @"assets-library://";
//NSString* const kCDVAssetsLibraryScheme = @"assets-library";

@implementation OPGAssetLibraryFilesystem
@synthesize name=_name;

/*
 The OPGAssetLibraryFilesystem works with resources which are identified
 by iOS as
   asset-library://<path>
 and represents them internally as URLs of the form
   cdvfile://localhost/assets-library/<path>
 */

- (NSURL *)assetLibraryURLForLocalURL:(OPGFilesystemURL *)url
{
    if ([url.url.scheme isEqualToString:@"cdvfile"]) {
        NSString *path = [[url.url absoluteString] substringFromIndex:[@"cdvfile://localhost/assets-library" length]];
        return [NSURL URLWithString:[NSString stringWithFormat:@"assets-library:/%@", path]];
    }
    return url.url;
}

- (OPGPluginResult *)entryForLocalURI:(OPGFilesystemURL *)url
{
    NSDictionary* entry = [self makeEntryForLocalURL:url];
    return [OPGPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:entry];
}

- (NSDictionary *)makeEntryForLocalURL:(OPGFilesystemURL *)url {
    return [self makeEntryForPath:url.fullPath isDirectory:NO];
}

- (NSDictionary*)makeEntryForPath:(NSString*)fullPath isDirectory:(BOOL)isDir
{
    NSMutableDictionary* dirEntry = [NSMutableDictionary dictionaryWithCapacity:5];
    NSString* lastPart = [fullPath lastPathComponent];
    if (isDir && ![fullPath hasSuffix:@"/"]) {
        fullPath = [fullPath stringByAppendingString:@"/"];
    }
    [dirEntry setObject:[NSNumber numberWithBool:!isDir]  forKey:@"isFile"];
    [dirEntry setObject:[NSNumber numberWithBool:isDir]  forKey:@"isDirectory"];
    [dirEntry setObject:fullPath forKey:@"fullPath"];
    [dirEntry setObject:lastPart forKey:@"name"];
    [dirEntry setObject:self.name forKey: @"filesystemName"];
    dirEntry[@"nativeURL"] = [NSString stringWithFormat:@"assets-library:/%@",fullPath];

    return dirEntry;
}

/* helper function to get the mimeType from the file extension
 * IN:
 *	NSString* fullPath - filename (may include path)
 * OUT:
 *	NSString* the mime type as type/subtype.  nil if not able to determine
 */
+ (NSString*)getMimeTypeFromPath:(NSString*)fullPath
{
    NSString* mimeType = nil;

    if (fullPath) {
        CFStringRef typeId = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[fullPath pathExtension], NULL);
        if (typeId) {
            mimeType = (__bridge_transfer NSString*)UTTypeCopyPreferredTagWithClass(typeId, kUTTagClassMIMEType);
            if (!mimeType) {
                // special case for m4a
                if ([(__bridge NSString*)typeId rangeOfString : @"m4a-audio"].location != NSNotFound) {
                    mimeType = @"audio/mp4";
                } else if ([[fullPath pathExtension] rangeOfString:@"wav"].location != NSNotFound) {
                    mimeType = @"audio/wav";
                } else if ([[fullPath pathExtension] rangeOfString:@"css"].location != NSNotFound) {
                    mimeType = @"text/css";
                }
            }
            CFRelease(typeId);
        }
    }
    return mimeType;
}

- (id)initWithName:(NSString *)name
{
    if (self) {
        _name = name;
    }
    return self;
}

- (OPGPluginResult *)getFileForURL:(OPGFilesystemURL *)baseURI requestedPath:(NSString *)requestedPath options:(NSDictionary *)options
{
    // return unsupported result for assets-library URLs
   return [OPGPluginResult resultWithStatus:CDVCommandStatus_MALFORMED_URL_EXCEPTION messageAsString:@"getFile not supported for assets-library URLs."];
}

- (OPGPluginResult*)getParentForURL:(OPGFilesystemURL *)localURI
{
    // we don't (yet?) support getting the parent of an asset
    return [OPGPluginResult resultWithStatus:CDVCommandStatus_IO_EXCEPTION messageAsInt:NOT_READABLE_ERR];
}

- (OPGPluginResult*)setMetadataForURL:(OPGFilesystemURL *)localURI withObject:(NSDictionary *)options
{
    // setMetadata doesn't make sense for asset library files
    return [OPGPluginResult resultWithStatus:CDVCommandStatus_ERROR];
}

- (OPGPluginResult *)removeFileAtURL:(OPGFilesystemURL *)localURI
{
    // return error for assets-library URLs
    return [OPGPluginResult resultWithStatus:CDVCommandStatus_IO_EXCEPTION messageAsInt:INVALID_MODIFICATION_ERR];
}

- (OPGPluginResult *)recursiveRemoveFileAtURL:(OPGFilesystemURL *)localURI
{
    // return error for assets-library URLs
    return [OPGPluginResult resultWithStatus:CDVCommandStatus_MALFORMED_URL_EXCEPTION messageAsString:@"removeRecursively not supported for assets-library URLs."];
}

- (OPGPluginResult *)readEntriesAtURL:(OPGFilesystemURL *)localURI
{
    // return unsupported result for assets-library URLs
    return [OPGPluginResult resultWithStatus:CDVCommandStatus_MALFORMED_URL_EXCEPTION messageAsString:@"readEntries not supported for assets-library URLs."];
}

- (OPGPluginResult *)truncateFileAtURL:(OPGFilesystemURL *)localURI atPosition:(unsigned long long)pos
{
    // assets-library files can't be truncated
    return [OPGPluginResult resultWithStatus:CDVCommandStatus_IO_EXCEPTION messageAsInt:NO_MODIFICATION_ALLOWED_ERR];
}

- (OPGPluginResult *)writeToFileAtURL:(OPGFilesystemURL *)localURL withData:(NSData*)encData append:(BOOL)shouldAppend
{
    // text can't be written into assets-library files
    return [OPGPluginResult resultWithStatus:CDVCommandStatus_IO_EXCEPTION messageAsInt:NO_MODIFICATION_ALLOWED_ERR];
}

- (void)copyFileToURL:(OPGFilesystemURL *)destURL withName:(NSString *)newName fromFileSystem:(NSObject<OPGFileSystem> *)srcFs atURL:(OPGFilesystemURL *)srcURL copy:(BOOL)bCopy callback:(void (^)(OPGPluginResult *))callback
{
    // Copying to an assets library file is not doable, since we can't write it.
    OPGPluginResult *result = [OPGPluginResult resultWithStatus:CDVCommandStatus_IO_EXCEPTION messageAsInt:INVALID_MODIFICATION_ERR];
    callback(result);
}

- (NSString *)filesystemPathForURL:(OPGFilesystemURL *)url
{
    NSString *path = nil;
    if ([[url.url scheme] isEqualToString:@"assets-library"]) {
        path = [url.url path];
    } else {
       path = url.fullPath;
    }
    if ([path hasSuffix:@"/"]) {
      path = [path substringToIndex:([path length]-1)];
    }
    return path;
}

- (void)readFileAtURL:(OPGFilesystemURL *)localURL start:(NSInteger)start end:(NSInteger)end callback:(void (^)(NSData*, NSString* mimeType, CDVFileError))callback
{
    ALAssetsLibraryAssetForURLResultBlock resultBlock = ^(ALAsset* asset) {
        if (asset) {
            // We have the asset!  Get the data and send it off.
            ALAssetRepresentation* assetRepresentation = [asset defaultRepresentation];
            Byte* buffer = (Byte*)malloc([assetRepresentation size]);
            NSUInteger bufferSize = [assetRepresentation getBytes:buffer fromOffset:0.0 length:[assetRepresentation size] error:nil];
            NSData* data = [NSData dataWithBytesNoCopy:buffer length:bufferSize freeWhenDone:YES];
            NSString* MIMEType = (__bridge_transfer NSString*)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)[assetRepresentation UTI], kUTTagClassMIMEType);

            callback(data, MIMEType, NO_ERROR);
        } else {
            callback(nil, nil, NOT_FOUND_ERR);
        }
    };

    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError* error) {
        // Retrieving the asset failed for some reason.  Send the appropriate error.
        NSLog(@"Error: %@", error);
        callback(nil, nil, SECURITY_ERR);
    };

    ALAssetsLibrary* assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary assetForURL:[self assetLibraryURLForLocalURL:localURL] resultBlock:resultBlock failureBlock:failureBlock];
}

- (void)getFileMetadataForURL:(OPGFilesystemURL *)localURL callback:(void (^)(OPGPluginResult *))callback
{
    // In this case, we need to use an asynchronous method to retrieve the file.
    // Because of this, we can't just assign to `result` and send it at the end of the method.
    // Instead, we return after calling the asynchronous method and send `result` in each of the blocks.
    ALAssetsLibraryAssetForURLResultBlock resultBlock = ^(ALAsset* asset) {
        if (asset) {
            // We have the asset!  Populate the dictionary and send it off.
            NSMutableDictionary* fileInfo = [NSMutableDictionary dictionaryWithCapacity:5];
            ALAssetRepresentation* assetRepresentation = [asset defaultRepresentation];
            [fileInfo setObject:[NSNumber numberWithUnsignedLongLong:[assetRepresentation size]] forKey:@"size"];
            [fileInfo setObject:localURL.fullPath forKey:@"fullPath"];
            NSString* filename = [assetRepresentation filename];
            [fileInfo setObject:filename forKey:@"name"];
            [fileInfo setObject:[OPGAssetLibraryFilesystem getMimeTypeFromPath:filename] forKey:@"type"];
            NSDate* creationDate = [asset valueForProperty:ALAssetPropertyDate];
            NSNumber* msDate = [NSNumber numberWithDouble:[creationDate timeIntervalSince1970] * 1000];
            [fileInfo setObject:msDate forKey:@"lastModifiedDate"];

            callback([OPGPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:fileInfo]);
        } else {
            // We couldn't find the asset.  Send the appropriate error.
            callback([OPGPluginResult resultWithStatus:CDVCommandStatus_IO_EXCEPTION messageAsInt:NOT_FOUND_ERR]);
        }
    };
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError* error) {
        // Retrieving the asset failed for some reason.  Send the appropriate error.
        callback([OPGPluginResult resultWithStatus:CDVCommandStatus_IO_EXCEPTION messageAsString:[error localizedDescription]]);
    };

    ALAssetsLibrary* assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary assetForURL:[self assetLibraryURLForLocalURL:localURL] resultBlock:resultBlock failureBlock:failureBlock];
    return;
}
@end
