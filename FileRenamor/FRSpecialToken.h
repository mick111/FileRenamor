//
//  FRSpecialToken.h
//  FileRenamor
//
//  Created by Michael Mouchous on 20/10/12.
//  Copyright (c) 2012 Michael Mouchous. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRModel.h"

@class FRFile;

#define FRSOURCEDATE_NOW          0
#define FRSOURCEDATE_MODIFICATION 2
#define FRSOURCEDATE_CREATION     1

@interface FRSpecialToken : NSViewController
typedef enum FRTokenType_t {
    FRTokenTypeUser = 0,
    FRTokenTypeCounter = 1,
    FRTokenTypeMinute = 2,
    FRTokenTypeHour = 3,
    FRTokenTypeDay = 4,
    FRTokenTypeMonth = 5,
    FRTokenTypeYear = 6,
    FRTokenTypeFileName = 7,
    FRTokenTypeFileExtension = 8,
    FRTokenTypeFileGroupName = 9
} FRTokenType;

-(id)initWithString:(NSString *)string;

@property (strong) NSString * string;

/* Counter Properties */
@property (assign) NSUInteger counterStart;
@property (assign) NSUInteger counterStep;
@property (assign) NSUInteger counterNbDigits;
@property (assign) NSUInteger
counterNbIterationsNeededToIncrement;

/* DateFormat Properties */
@property (strong) NSString * dateFormat;
@property (assign) NSUInteger dateSource;

/* FileName Properties */
@property (assign) BOOL fileNameWithExtension;
@property (assign) BOOL useRegEx;
@property (assign) BOOL caseSensitive;
@property (weak) NSString * searchValue;
@property (weak) NSString * replaceValue;

/* Extension Properties */
@property (assign) BOOL extensionIncludesDot;

@property (assign, readonly) FRTokenType tokenType;
@property (strong) NSMenu * menu;


-(NSString *)getStringValueForFile:(FRFile*)file
                             atRow:(NSUInteger)fileNumber;
@end
