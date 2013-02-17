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
@property (readonly,strong) NSString * fullPath;

@property (strong) NSURL * url;

@property (readonly) NSDate * creationDate;
@property (readonly) NSDate * modificationDate;


@property (readonly) NSString * originalFileNameBaseName;
@property (readonly) NSString * originalFileNameExtension;

+ (FRFile *)fileWithURL:(NSURL *)newUrl;
@end

@interface FRModel : NSObject

@property (readonly) NSUInteger numberOfFiles;

/* Return the number of elements added */
- (NSUInteger)addFilesToArrayOfUrls:(NSArray *)urls;
- (NSUInteger)addFilesAndFoldersContentToArrayOfUrls:(NSArray *)urls;
- (NSUInteger)addFilesAndFoldersContentRecursivelyToArrayOfUrls:(NSArray *)urls;
- (NSUInteger)addFilesToArrayOfUrls:(NSArray *)urls
                            atIndex:(NSUInteger)index;

/* Return true if okay */
- (BOOL)addFileToArrayOfUrls:(NSURL *)url atIndex:(NSUInteger)index;

/* Return nil if index is incorrect */
- (NSURL *)getFileAtIndex:(NSUInteger)index;

- (NSIndexSet *)moveFilesFromPositions:(NSIndexSet*)fromPosition toPosition:(NSUInteger)toPosition;

- (BOOL)removeFilesAtIndexes:(NSIndexSet*)indexes;

/* File sorting */
-(void)sortUsingDescriptors:(NSArray *)sortDescriptors;

-(FRFile *)fileAtIndex:(NSUInteger)index;

-(void)setSelection:(NSInteger)newSelection atIndex:(NSUInteger) index;

-(BOOL)calculateAllNewNamesWithTokens:(NSArray *)arrayOfTokens;

/* Apply renaming */
-(void)applyRenaming:(BOOL)removeWhenFinished;

/* File moving */
-(NSMutableIndexSet*)moveFilesUp:(NSIndexSet*)indexes;
-(NSMutableIndexSet*)moveFilesDown:(NSIndexSet*)indexes;
@end
