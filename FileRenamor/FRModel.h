//
//  FRModel.h
//  FileRenamor
//
//  Created by Michael Mouchous on 19/10/12.
//  Copyright (c) 2012 Michael Mouchous. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRSpecialToken.h"
@interface FRFile : NSObject


@property BOOL selected;
@property (readonly, strong) NSImage * icon;
@property (readonly, strong) NSString * originalFileName;
@property (strong) NSString * newFileName;
@property (strong) NSString * groupName;

@property (strong) NSURL * url;

@property (readonly) NSDate * creationDate;
@property (readonly) NSDate * modificationDate;


@property (readonly) NSString * originalFileNameBaseName;
@property (readonly) NSString * originalFileNameExtension;

+ (FRFile *)fileWithURL:(NSURL *)newUrl;
@end

@interface FRModel : NSObject

/* Return true if all files are url */
- (BOOL)addFilesToArrayOfUrls:(NSArray *)urls;

/* Return true if okay */
- (BOOL)addFileToArrayOfUrls:(NSURL *)url atIndex:(NSUInteger)index;

/* Return nil if index is incorrect */
- (NSURL *)getFileAtIndex:(NSUInteger)index;

/* Return true if okay */
- (BOOL)moveFileFromPosition:(NSUInteger)fromPosition toPosition:(NSUInteger)toPosition;


@property (readonly) NSUInteger numberOfFiles;

-(FRFile *)fileAtIndex:(NSUInteger)index;

-(void)toogleSelectionAtIndex:(NSUInteger) index;

-(void)calculateAllNewNamesWithTokens:(NSArray *)arrayOfTokens;
@end
