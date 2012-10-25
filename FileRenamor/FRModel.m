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

-(NSImage *)icon
{
    if (!_icon)
    {
        NSError * error;
        NSFileWrapper * fileWrapper = [[NSFileWrapper alloc] initWithURL:self.url
                                                                 options:NSFileWrapperReadingImmediate
                                                                   error:&error];
        _icon = fileWrapper.icon;
    }
    return _icon;
}

-(NSString *)originalFileName
{
    if (!_originalFileName)
    {
        NSError * error;
        NSFileWrapper * fileWrapper = [[NSFileWrapper alloc] initWithURL:self.url
                                                                 options:NSFileWrapperReadingImmediate
                                                                   error:&error];
        _originalFileName = fileWrapper.filename;
    }
    return _originalFileName;
}

-(void)applyNewFileName
{
    NSError * error;
    NSFileWrapper * fileWrapper = [[NSFileWrapper alloc] initWithURL:self.url
                                                             options:NSFileWrapperReadingImmediate
                                                               error:&error];
    fileWrapper.filename = _newFileName;
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

/* Return true if all files are url */
- (BOOL)addFilesToArrayOfUrls:(NSArray *)urls
{
    BOOL allURLs = TRUE;
    for (id url in urls)
    {
        if ([url isKindOfClass:[NSURL class]])
        {
            FRFile * file = [FRFile fileWithURL:url];
            [_arrayOfFiles addObject:file];
        }
        else
        {
            allURLs = FALSE;
        }
    }
    return allURLs;
}

/* Return true if okay */
- (BOOL)addFileToArrayOfUrls:(NSURL *)url atIndex:(NSUInteger)index
{
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

- (BOOL)moveFileFromPosition:(NSUInteger)fromPosition toPosition:(NSUInteger)toPosition
{
    if (fromPosition < _arrayOfFiles.count && toPosition < _arrayOfFiles.count)
    {
        id object = [_arrayOfFiles objectAtIndex:fromPosition];
        [_arrayOfFiles removeObjectAtIndex:fromPosition];
        [_arrayOfFiles insertObject:object atIndex:toPosition];
        return TRUE;
    }
    return FALSE;
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

-(void)toogleSelectionAtIndex:(NSUInteger) index
{
    [self fileAtIndex:index].selected = ![self fileAtIndex:index].selected;
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
            NSString * newString = [token getStringValueForFile:file atRow:currentFileNb];
            file.newFileName = [file.newFileName stringByAppendingString:newString];
        }
        currentFileNb++;
    }
}
@end
