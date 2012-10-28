//
//  FRModel.m
//  FileRenamor
//
//  Created by Michael Mouchous on 19/10/12.
//  Copyright (c) 2012 Michael Mouchous. All rights reserved.
//

#import "FRModel.h"

@implementation FRFile

@synthesize selected = _selected;
@synthesize groupName = _groupName;
@synthesize originalFileName = _originalFileName;
@synthesize newFileName = _newFileName;
@synthesize icon = _icon;
@synthesize url;

-(NSDate *)creationDate
{
    NSDate * creationDate;
    NSError * error;
    [self.url getResourceValue:&creationDate
                        forKey:NSURLCreationDateKey
                         error:&error];
    return creationDate;
}

-(NSDate *)modificationDate
{
    NSDate * modificationDate;
    NSError * error;
    [self.url getResourceValue:&modificationDate
                        forKey:NSURLContentModificationDateKey
                         error:&error];
    return modificationDate;
}

-(NSImage *)icon
{
    NSWorkspace * ws = [NSWorkspace sharedWorkspace];
    _icon = [ws iconForFile:self.url.path];
    return _icon;
}

-(NSString *)originalFileName
{
    NSError * error;
    NSString * fileName;
    [self.url getResourceValue:&fileName
                        forKey:NSURLNameKey
                         error:&error];
    _originalFileName = fileName;
    return _originalFileName;
}

-(void)applyNewFileName
{
//    NSError * error;
//    NSFileWrapper * fileWrapper = [[NSFileWrapper alloc] initWithURL:self.url
//                                                             options:NSFileWrapperReadingImmediate
//                                                               error:&error];
//    fileWrapper.filename = _newFileName;
}

-(void)setNewFileName:(NSString *)newFileName
{
    _newFileName = newFileName;
}

-(NSString *)newFileName
{
    if (!_newFileName)
    {
        return @"";
    }
    return _newFileName;
}


- (id)initWithURL:(NSURL *)newUrl
{
    self = [super init];
    if (self) {
        self.url = newUrl;
        _selected = TRUE;
        _groupName = @"";
        _newFileName = nil;
        _originalFileName = nil;
    }
    return self;
}

-(NSString *)originalFileNameExtension
{
    NSString * filename = self.originalFileName;
    return [filename pathExtension];
}

-(NSString *)originalFileNameBaseName
{
    NSString * filename = self.originalFileName;
    return [filename stringByDeletingPathExtension];
}

+ (FRFile *)fileWithURL:(NSURL *)newUrl
{
    return [[FRFile alloc] initWithURL:newUrl];
}
@end

@interface FRModel()
{
    NSMutableArray * _arrayOfFiles;
}

@end

@implementation FRModel
- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialize self.
        _arrayOfFiles = [[NSMutableArray alloc] init];
    }
    
    // See if instance variable have been created.
    if (!_arrayOfFiles)
    {
        // Freeing all instance variables.
        _arrayOfFiles = nil;
        return nil;
    }
    
    return self;
}

/* Return true if all files are added */
- (NSUInteger)addFilesToArrayOfUrls:(NSArray *)urls
{
    return [self addFilesToArrayOfUrls:urls atIndex:_arrayOfFiles.count];
}
- (NSUInteger)addFilesToArrayOfUrls:(NSArray *)urls
                      atIndex:(NSUInteger)index
{
    if (index > _arrayOfFiles.count) return 0;
    
    NSMutableArray * urlsToAdd = [NSMutableArray arrayWithArray:urls];
    NSUInteger nbOfFiles = index;
    for (id url in urlsToAdd)
    {
        if ([url isKindOfClass:[NSURL class]])
        {
            if ([self addFileToArrayOfUrls:url
                                   atIndex:nbOfFiles])
            {
                nbOfFiles++;
            }
        }
    }
    return (nbOfFiles - index);
}

/* Return true if okay */
- (BOOL)addFileToArrayOfUrls:(NSURL *)url atIndex:(NSUInteger)index
{
    for (FRFile * existingUrl in _arrayOfFiles) {
        if ([url isEqual:existingUrl.url])
        {
            //URL is already present
            return FALSE;
        }
    }
    
    if (index <= _arrayOfFiles.count)
    {
        FRFile * file = [FRFile fileWithURL:url];
        [_arrayOfFiles insertObject:file atIndex:index];
        return TRUE;
    }
    return FALSE;
}

- (NSURL *)getFileAtIndex:(NSUInteger)index
{
    if (index < _arrayOfFiles.count)
    {
        return ((FRFile*)[_arrayOfFiles objectAtIndex:index]).url;
    }
    return nil;
}

- (BOOL)isFileSelectedAtIndex:(NSUInteger)index
{
    if (index < _arrayOfFiles.count)
    {
        return ((FRFile*)[_arrayOfFiles objectAtIndex:index]).selected;
    }
    return FALSE;
}

- (BOOL)removeFilesAtIndexes:(NSIndexSet*)indexes
{
    [_arrayOfFiles removeObjectsAtIndexes:indexes];
    return TRUE;
}

- (NSIndexSet *)moveFilesFromPositions:(NSIndexSet*)fromPositions
                            toPosition:(NSUInteger)toPosition
{
    NSUInteger __block nbElementsAbove = 0;
    [fromPositions enumerateIndexesUsingBlock:
     ^(NSUInteger idx, BOOL *stop)
     {
         if (idx < toPosition) nbElementsAbove++;
     }];
    
    NSArray * objectsToMove = [_arrayOfFiles objectsAtIndexes:fromPositions];
    [_arrayOfFiles removeObjectsAtIndexes:fromPositions];
    
    NSIndexSet * newPositions = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(toPosition-nbElementsAbove, objectsToMove.count)];
    [_arrayOfFiles insertObjects:objectsToMove
                       atIndexes:newPositions];
    return newPositions;
}


-(NSUInteger) numberOfFiles
{
    return _arrayOfFiles.count;
}

-(void) selectAllFiles
{
    for (FRFile * file in _arrayOfFiles) {
        file.selected = TRUE;
    }
}

-(void) unselectAllFiles
{
    for (FRFile * file in _arrayOfFiles) {
        file.selected = FALSE;
    }
}

-(void) toogleSelectionForIndex:(NSUInteger)index
{
    if (index < _arrayOfFiles.count)
    {
        FRFile* file = [_arrayOfFiles objectAtIndex:index];
        file.selected = !file.selected;
    }
}

-(FRFile *)fileAtIndex:(NSUInteger)index
{
    if (index < _arrayOfFiles.count)
    {
        FRFile* file = [_arrayOfFiles objectAtIndex:index];
        return file;
    }
    return nil;
}

-(void)setSelection:(NSInteger)newSelection
            atIndex:(NSUInteger)index
{
    if (newSelection == -1)
        [self fileAtIndex:index].selected = ![self fileAtIndex:index].selected;
    else
        [self fileAtIndex:index].selected = newSelection;
}

-(void)calculateAllNewNamesWithTokens:(NSArray *)arrayOfTokens
{
    NSLog(@"%s : %@", __FUNCTION__, arrayOfTokens);
    NSUInteger currentFileNb = 0;
    for (FRFile * file in _arrayOfFiles)
    {
        file.newFileName = @"";
        if (!file.selected)
        {
            continue;
        }
        for (FRSpecialToken * token in arrayOfTokens)
        {
            NSString * newString = [token getStringValueForFile:file
                                                          atRow:currentFileNb];
            file.newFileName = [file.newFileName stringByAppendingString:newString];
        }
        currentFileNb++;
    }
}
@end
