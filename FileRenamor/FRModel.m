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
@synthesize fullPath = _fullPath;
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

-(NSString *)fullPath
{
    _fullPath = [self.url absoluteString];
    return _fullPath;
}

-(void)applyNewFileName
{
    NSError * error = nil;
    NSURL * newURL = [NSURL URLWithString:[self.newFileName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                            relativeToURL:self.url.URLByDeletingLastPathComponent];
    [[NSFileManager defaultManager] moveItemAtURL:self.url
                                            toURL:newURL
                                            error:&error];
    if (!error)
    {
        self.url = newURL;
    }
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
        
        // See if instance variable have been created.
        if (!_arrayOfFiles)
        {
            // Freeing all instance variables.
            _arrayOfFiles = nil;
            return nil;
        }
    }
    
    return self;
}

/* Return number of files added are added */
- (NSUInteger)addFilesToArrayOfUrls:(NSArray *)urls
                        withOptions:(NSDirectoryEnumerationOptions) options
{
    
    NSMutableArray * files = [[NSMutableArray alloc] initWithCapacity:urls.count];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    /* NSDirectoryEnumerationSkipsSubdirectoryDescendants
     NSDirectoryEnumerationSkipsPackageDescendants
     NSDirectoryEnumerationSkipsHiddenFiles */
    
    for (NSURL * url in urls)
    {
        BOOL isDirectory;
        BOOL fileExists;
        
        fileExists = [fileManager fileExistsAtPath:url.path isDirectory:&isDirectory];
        
        if (!fileExists)
        {
            NSLog(@"URL %@ does not exist", url);
            continue;
        }
        
        if (isDirectory)
        {
            NSDirectoryEnumerator * directoryEnumerator =
            [fileManager enumeratorAtURL:url
              includingPropertiesForKeys:nil
                                 options:options
                            errorHandler:^BOOL(NSURL * url, NSError *error)
             {
                 NSLog(@"  -- URL %@", url.path);
                 NSLog(@"  -- ERROR %@", error);
                 return YES;
             }];
            for (NSURL * urla in directoryEnumerator)
            {
                BOOL isDirectory;
                BOOL fileExists;
                fileExists = [fileManager fileExistsAtPath:urla.path isDirectory:&isDirectory];
                
                if (!fileExists)
                {
                    NSLog(@"URL %@ does not exist", urla);
                    continue;
                }
                if (!isDirectory)
                {
                    [files addObject:urla];
                }
            }
        }
        else
        {
            [files addObject:url];
        }
    }
    
    NSUInteger sum = 0;
    sum += [self addFilesToArrayOfUrls:files
                               atIndex:_arrayOfFiles.count];
    return sum;
}


- (NSUInteger)addFilesToArrayOfUrls:(NSArray *)urls
{
    return [self addFilesToArrayOfUrls:urls
                               atIndex:_arrayOfFiles.count];
}
/* Return number of files added are added */
- (NSUInteger)addFilesOnlyToArrayOfUrls:(NSArray *)urls
{
    NSMutableArray * files = [[NSMutableArray alloc] initWithCapacity:urls.count];
    return [self addFilesToArrayOfUrls:files
                               atIndex:_arrayOfFiles.count];
}
/* Return number of files added are added */
- (NSUInteger)addFilesAndFoldersContentToArrayOfUrls:(NSArray *)urls
{
    return [self addFilesToArrayOfUrls:urls
                           withOptions:NSDirectoryEnumerationSkipsPackageDescendants | NSDirectoryEnumerationSkipsSubdirectoryDescendants | NSDirectoryEnumerationSkipsHiddenFiles];
}
/* Return number of files added are added */
- (NSUInteger)addFilesAndFoldersContentRecursivelyToArrayOfUrls:(NSArray *)urls
{
    return [self addFilesToArrayOfUrls:urls
                           withOptions:NSDirectoryEnumerationSkipsPackageDescendants | NSDirectoryEnumerationSkipsHiddenFiles];
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
- (BOOL)addFileToArrayOfUrls:(NSURL *)url
                     atIndex:(NSUInteger)index
{
    for (FRFile * existingUrl in _arrayOfFiles) {
        if ([url.absoluteURL isEqual:existingUrl.url.absoluteURL])
        {
            //URL is already present
            return FALSE;
        }
    }
    
    if (index <= _arrayOfFiles.count)
    {
        FRFile * file = [FRFile fileWithURL:url];
        [_arrayOfFiles insertObject:file
                            atIndex:index];
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

-(BOOL)calculateAllNewNamesWithTokens:(NSArray *)arrayOfTokens
{
    NSLog(@"%s : %@", __FUNCTION__, arrayOfTokens);
    NSUInteger currentFileNb = 0;
    BOOL fileNameHaveChanged = NO;
    for (FRFile * file in _arrayOfFiles)
    {
        NSString * oldNewFileName = file.newFileName;
        file.newFileName = @"";
        if (!file.selected)
        {
            continue;
        }
        for (FRSpecialToken * token in arrayOfTokens)
        {
            NSString * newString = [token getStringValueForFile:file
                                                          atRow:currentFileNb];
            if (newString)
                file.newFileName = [file.newFileName stringByAppendingString:newString];
        }
        currentFileNb++;
        fileNameHaveChanged |= !([oldNewFileName isEqualToString:file.newFileName]);
    }
    return fileNameHaveChanged;
}

-(void)applyRenaming:(BOOL)removeWhenFinished
{
    if (!_arrayOfFiles.count) return;
    for (FRFile * file in _arrayOfFiles)
    {
        if (!file.selected) continue;
        [file applyNewFileName];
    }
    
    /* Purge duplicates */
    NSUInteger i,j;
    NSURL * urlI, * urlJ;
    for (i=0; i < _arrayOfFiles.count - 1; i++)
    {
        urlI = [self fileAtIndex:i].url;
        for (j=i+1; j < _arrayOfFiles.count; j++)
        {
            urlJ = [self fileAtIndex:j].url;
            if ([urlI.absoluteURL isEqual:urlJ.absoluteURL])
            {
                [_arrayOfFiles removeObjectAtIndex:j];
                j--;
            }
        }
    }
    
    /* Purge treated items */
    if (removeWhenFinished) {
        NSMutableArray * filesToRemove = [[NSMutableArray alloc] init];
        for (FRFile * file in _arrayOfFiles)
        {
            if (!file.selected) continue;
            [filesToRemove addObject:file];
        }
        [_arrayOfFiles removeObjectsInArray:filesToRemove];
        [filesToRemove removeAllObjects];
        filesToRemove = nil;
    }
    
}

-(void)sortUsingDescriptors:(NSArray *)sortDescriptors
{
    [_arrayOfFiles sortUsingDescriptors:sortDescriptors];
}
@end
