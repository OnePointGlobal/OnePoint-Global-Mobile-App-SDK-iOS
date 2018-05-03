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

#import <Foundation/Foundation.h>
#import "OPGPlugin.h"

//NSString* const kCDVAssetsLibraryPrefix;
//NSString* const kOPGFilesystemURLPrefix;

enum CDVFileError {
    NO_ERROR = 0,
    NOT_FOUND_ERR = 1,
    SECURITY_ERR = 2,
    ABORT_ERR = 3,
    NOT_READABLE_ERR = 4,
    ENCODING_ERR = 5,
    NO_MODIFICATION_ALLOWED_ERR = 6,
    INVALID_STATE_ERR = 7,
    SYNTAX_ERR = 8,
    INVALID_MODIFICATION_ERR = 9,
    QUOTA_EXCEEDED_ERR = 10,
    TYPE_MISMATCH_ERR = 11,
    PATH_EXISTS_ERR = 12
};
typedef int CDVFileError;

@interface OPGFilesystemURL : NSObject  {
    NSURL *_url;
    NSString *_fileSystemName;
    NSString *_fullPath;
}

- (id) initWithString:(NSString*)strURL;
- (id) initWithURL:(NSURL*)URL;
+ (OPGFilesystemURL *)fileSystemURLWithString:(NSString *)strURL;
+ (OPGFilesystemURL *)fileSystemURLWithURL:(NSURL *)URL;

- (NSString *)absoluteURL;

@property (atomic) NSURL *url;
@property (atomic) NSString *fileSystemName;
@property (atomic) NSString *fullPath;

@end

@interface OPGFilesystemURLProtocol : NSURLProtocol
@end

@protocol OPGFileSystem
- (OPGPluginResult *)entryForLocalURI:(OPGFilesystemURL *)url;
- (OPGPluginResult *)getFileForURL:(OPGFilesystemURL *)baseURI requestedPath:(NSString *)requestedPath options:(NSDictionary *)options;
- (OPGPluginResult *)getParentForURL:(OPGFilesystemURL *)localURI;
- (OPGPluginResult *)setMetadataForURL:(OPGFilesystemURL *)localURI withObject:(NSDictionary *)options;
- (OPGPluginResult *)removeFileAtURL:(OPGFilesystemURL *)localURI;
- (OPGPluginResult *)recursiveRemoveFileAtURL:(OPGFilesystemURL *)localURI;
- (OPGPluginResult *)readEntriesAtURL:(OPGFilesystemURL *)localURI;
- (OPGPluginResult *)truncateFileAtURL:(OPGFilesystemURL *)localURI atPosition:(unsigned long long)pos;
- (OPGPluginResult *)writeToFileAtURL:(OPGFilesystemURL *)localURL withData:(NSData*)encData append:(BOOL)shouldAppend;
- (void)copyFileToURL:(OPGFilesystemURL *)destURL withName:(NSString *)newName fromFileSystem:(NSObject<OPGFileSystem> *)srcFs atURL:(OPGFilesystemURL *)srcURL copy:(BOOL)bCopy callback:(void (^)(OPGPluginResult *))callback;
- (void)readFileAtURL:(OPGFilesystemURL *)localURL start:(NSInteger)start end:(NSInteger)end callback:(void (^)(NSData*, NSString* mimeType, CDVFileError))callback;
- (void)getFileMetadataForURL:(OPGFilesystemURL *)localURL callback:(void (^)(OPGPluginResult *))callback;

- (NSDictionary *)makeEntryForLocalURL:(OPGFilesystemURL *)url;
- (NSDictionary*)makeEntryForPath:(NSString*)fullPath isDirectory:(BOOL)isDir;

@property (nonatomic,strong) NSString *name;

@optional
- (NSString *)filesystemPathForURL:(OPGFilesystemURL *)localURI;
- (OPGFilesystemURL *)URLforFilesystemPath:(NSString *)path;

@end

@interface OPGFile : OPGPlugin {
    NSString* rootDocsPath;
    NSString* appDocsPath;
    NSString* appLibraryPath;
    NSString* appTempPath;

    NSMutableArray* fileSystems_;
    BOOL userHasAllowed;
}

- (NSNumber*)checkFreeDiskSpace:(NSString*)appPath;
- (NSDictionary*)makeEntryForPath:(NSString*)fullPath fileSystemName:(NSString *)fsName isDirectory:(BOOL)isDir;
- (NSDictionary *)makeEntryForURL:(NSURL *)URL;
- (OPGFilesystemURL *)fileSystemURLforLocalPath:(NSString *)localPath;

- (NSObject<OPGFileSystem> *)filesystemForURL:(OPGFilesystemURL *)localURL;

/* Native Registration API */
- (void)registerFilesystem:(NSObject<OPGFileSystem> *)fs;
- (NSObject<OPGFileSystem> *)fileSystemByName:(NSString *)fsName;

/* Exec API */
- (void)requestFileSystem:(OPGInvokedUrlCommand*)command;
- (void)resolveLocalFileSystemURI:(OPGInvokedUrlCommand*)command;
- (void)getDirectory:(OPGInvokedUrlCommand*)command;
- (void)getFile:(OPGInvokedUrlCommand*)command;
- (void)getParent:(OPGInvokedUrlCommand*)command;
- (void)removeRecursively:(OPGInvokedUrlCommand*)command;
- (void)remove:(OPGInvokedUrlCommand*)command;
- (void)copyTo:(OPGInvokedUrlCommand*)command;
- (void)moveTo:(OPGInvokedUrlCommand*)command;
- (void)getFileMetadata:(OPGInvokedUrlCommand*)command;
- (void)readEntries:(OPGInvokedUrlCommand*)command;
- (void)readAsText:(OPGInvokedUrlCommand*)command;
- (void)readAsDataURL:(OPGInvokedUrlCommand*)command;
- (void)readAsArrayBuffer:(OPGInvokedUrlCommand*)command;
- (void)write:(OPGInvokedUrlCommand*)command;
- (void)testFileExists:(OPGInvokedUrlCommand*)command;
- (void)testDirectoryExists:(OPGInvokedUrlCommand*)command;
- (void)getFreeDiskSpace:(OPGInvokedUrlCommand*)command;
- (void)truncate:(OPGInvokedUrlCommand*)command;
- (void)doCopyMove:(OPGInvokedUrlCommand*)command isCopy:(BOOL)bCopy;

/* Compatibilty with older File API */
- (NSString*)getMimeTypeFromPath:(NSString*)fullPath;
- (NSDictionary *)getDirectoryEntry:(NSString *)target isDirectory:(BOOL)bDirRequest;

/* Conversion between filesystem paths and URLs */
- (NSString *)filesystemPathForURL:(OPGFilesystemURL *)URL;

/* Internal methods for testing */
- (void)_getLocalFilesystemPath:(OPGInvokedUrlCommand*)command;

@property (nonatomic, strong) NSString* rootDocsPath;
@property (nonatomic, strong) NSString* appDocsPath;
@property (nonatomic, strong) NSString* appLibraryPath;
@property (nonatomic, strong) NSString* appTempPath;
@property (nonatomic, strong) NSString* persistentPath;
@property (nonatomic, strong) NSString* temporaryPath;
@property (nonatomic, strong) NSMutableArray* fileSystems;

@property BOOL userHasAllowed;

@end

#define kW3FileTemporary @"temporary"
#define kW3FilePersistent @"persistent"
