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

/* Return the number of elements added */
- (NSUInteger)addFilesToArrayOfUrls:(NSArray *)urls;
- (NSUInteger)addFilesToArrayOfUrls:(NSArray *)urls
                            atIndex:(NSUInteger)index;

/* Return true if okay */
- (BOOL)addFileToArrayOfUrls:(NSURL *)url atIndex:(NSUInteger)index;

/* Return nil if index is incorrect */
- (NSURL *)getFileAtIndex:(NSUInteger)index;

/* Return true if okay */
- (NSIndexSet *)moveFilesFromPositions:(NSIndexSet*)fromPosition toPosition:(NSUInteger)toPosition;

- (BOOL)removeFilesAtIndexes:(NSIndexSet*)indexes;

@property (readonly) NSUInteger numberOfFiles;

-(FRFile *)fileAtIndex:(NSUInteger)index;

-(void)setSelection:(NSInteger)newSelection atIndex:(NSUInteger) index;

-(void)calculateAllNewNamesWithTokens:(NSArray *)arrayOfTokens;
@end
