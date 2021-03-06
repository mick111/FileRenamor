//
//  FRSpecialToken.m
//  FileRenamor
//
//  Created by Michael Mouchous on 20/10/12.
//  Copyright (c) 2012 Michael Mouchous. All rights reserved.
//

#import "FRSpecialToken.h"
#import "FRAppDelegate.h"


@implementation FRSpecialToken
{
    NSUInteger _counterStart;
    NSUInteger _counterStep;
    NSUInteger _counterNbDigits;
    NSUInteger _counterNbIterationsNeededToIncrement;
    
    BOOL _extensionIncludesDot;
    
    BOOL _fileNameWithExtension;
    BOOL _useRegEx;
    BOOL _caseSensitive;
    NSString * _searchValue;
    NSString * _replaceValue;
}

@synthesize tokenType = _tokenType;

+(FRTokenType) tokenTypeForString:(NSString *)string
{
    if ([string isEqualToString:@"\x1B" @"Counter"])
    {
        return FRTokenTypeCounter;
    }
    else if ([string isEqualToString:@"\x1B" @"Day"])
    {
        return FRTokenTypeDay;
    }
    else if ([string isEqualToString:@"\x1B" @"Hour"])
    {
        return FRTokenTypeHour;
    }
    else if ([string isEqualToString:@"\x1B" @"Min"])
    {
        return FRTokenTypeMinute;
    }
    else if ([string isEqualToString:@"\x1B" @"Month"])
    {
        return FRTokenTypeMonth;
    }
    else if ([string isEqualToString:@"\x1B" @"Year"])
    {
        return FRTokenTypeYear;
    }
    else if ([string isEqualToString:@"\x1B" @"File Name"])
    {
        return FRTokenTypeFileName;
    }
    else if ([string isEqualToString:@"\x1B" @"Extension"])
    {
        return FRTokenTypeFileExtension;
    }
    else if ([string isEqualToString:@"\x1B" @"Group Name"])
    {
        return FRTokenTypeFileGroupName;
    }
    return FRTokenTypeUser;
    
}

-(NSMenuItem *)addSubMenuItemToMenuItem:(NSMenuItem *)menuItem
                         withDateFormat:(NSString *) dateFormat
{
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:dateFormat];
    
    NSString * dateFormatExample = [df stringFromDate:[NSDate date]];
    dateFormatExample = [NSString stringWithFormat:@"%@ (Eg: %@)", dateFormat, dateFormatExample];
    
    NSMenuItem * subMenuItem = [menuItem.submenu addItemWithTitle:dateFormatExample
                                                           action:@selector(setFormatDate:)
                                                    keyEquivalent:@""];
    subMenuItem.target = self;
    [subMenuItem setEnabled:TRUE];
    
    return subMenuItem;
}

-(id)initWithString:(NSString *)string
{
    self = [super init];
    if (self)
    {
        
        _tokenType = [[self class] tokenTypeForString:string];
        
        self.string = [[NSString alloc] initWithString:string];
        
        switch (self.tokenType) {
            case FRTokenTypeCounter:
            {
                /* Setting default Values for Token */
                self.counterNbDigits = 4;
                self.counterStart = 0;
                self.counterStep = 1;
                self.counterNbIterationsNeededToIncrement = 1;
                
                /* Setting Menu for Token */
                self.menu = [[NSMenu alloc] initWithTitle:@"Counter"];
                
                
                NSMenuItem * menuItem = [[NSMenuItem alloc] initWithTitle:@"CounterMenu"
                                                                   action:@selector(setCounterProperties)
                                                            keyEquivalent:@""];
                
                menuItem.view = [FRAppDelegate loadMainViewFromNib:@"FRCustomViewForCounter"
                                                         withOwner:self];
                
                if (menuItem.view) [self.menu addItem:menuItem];
            }
                break;
            case FRTokenTypeMinute:
            case FRTokenTypeHour:
            case FRTokenTypeDay:
            case FRTokenTypeMonth:
            case FRTokenTypeYear:
            {
                /* Setting default Values for Token */
                self.dateSource = FRSOURCEDATE_NOW;
                
                /* Setting Menu for Token */
                self.menu = [[NSMenu alloc] initWithTitle:@"Date Format Menu"];
                
                self.menu.autoenablesItems = NO;
                
                NSMenuItem * menuItem = [self.menu addItemWithTitle:@"Date source"
                                                             action:NULL
                                                      keyEquivalent:@""];
                menuItem.enabled = TRUE;
                NSMenuItem * subMenuItem;
                menuItem.submenu = [[NSMenu alloc] initWithTitle:@"Date Source Menu"];
                menuItem.submenu.autoenablesItems = NO;
                subMenuItem = [menuItem.submenu addItemWithTitle:@"Modification Date"
                                                          action:@selector(setSourceDate:)
                                                   keyEquivalent:@""];
                subMenuItem.target = self;
                [subMenuItem setEnabled:TRUE];
                subMenuItem.tag = FRSOURCEDATE_MODIFICATION;
                
                subMenuItem = [menuItem.submenu addItemWithTitle:@"Creation Date"
                                                          action:@selector(setSourceDate:)
                                                   keyEquivalent:@""];
                subMenuItem.target = self;
                [subMenuItem setEnabled:TRUE];
                subMenuItem.tag = FRSOURCEDATE_CREATION;
                
                subMenuItem = [menuItem.submenu addItemWithTitle:@"Now"
                                                          action:@selector(setSourceDate:)
                                                   keyEquivalent:@""];
                subMenuItem.target = self;
                [subMenuItem setEnabled:TRUE];
                subMenuItem.tag = FRSOURCEDATE_NOW;
                subMenuItem.state = NSOnState;
                
                menuItem = [self.menu addItemWithTitle:@"Date format"
                                                action:NULL
                                         keyEquivalent:@""];
                [subMenuItem setEnabled:TRUE];
                
                menuItem.submenu = [[NSMenu alloc] initWithTitle:@"Date Format Menu"];
                menuItem.submenu.autoenablesItems = NO;
                
                switch (self.tokenType) {
                    case FRTokenTypeMinute:
                    {
                        [self addSubMenuItemToMenuItem:menuItem withDateFormat:@"m"];
                        [self setFormatDate:[self addSubMenuItemToMenuItem:menuItem withDateFormat:@"mm"]];
                    }
                        break;
                    case FRTokenTypeHour:
                    {
                        [self addSubMenuItemToMenuItem:menuItem withDateFormat:@"h"];
                        [self addSubMenuItemToMenuItem:menuItem withDateFormat:@"hh"];
                        [self addSubMenuItemToMenuItem:menuItem withDateFormat:@"a"];
                        [self addSubMenuItemToMenuItem:menuItem withDateFormat:@"H"];
                        [self setFormatDate:[self addSubMenuItemToMenuItem:menuItem withDateFormat:@"HH"]];
                    }
                        break;
                    case FRTokenTypeDay:
                    {
                        [self addSubMenuItemToMenuItem:menuItem withDateFormat:@"d"];
                        [self setFormatDate:[self addSubMenuItemToMenuItem:menuItem withDateFormat:@"dd"]];
                    }
                        break;
                    case FRTokenTypeMonth:
                    {
                        [self addSubMenuItemToMenuItem:menuItem withDateFormat:@"MM"];
                        [self addSubMenuItemToMenuItem:menuItem withDateFormat:@"MMM"];
                        [self setFormatDate:[self addSubMenuItemToMenuItem:menuItem withDateFormat:@"MMMM"]];
                        [self addSubMenuItemToMenuItem:menuItem withDateFormat:@"MMMMM"];
                    }
                        break;
                    case FRTokenTypeYear:
                    {
                        [self addSubMenuItemToMenuItem:menuItem withDateFormat:@"yy"];
                        [self setFormatDate:[self addSubMenuItemToMenuItem:menuItem withDateFormat:@"yyyy"]];
                    }
                        break;
                    default:
                        break;
                }
            }
                break;
            case FRTokenTypeFileName:
            {
                /* Setting default Values for Token */
                self.fileNameWithExtension = YES;
                self.searchValue = @"";
                self.replaceValue = @"";
                
                /* Setting Menu for Token */
                self.menu = [[NSMenu alloc] initWithTitle:@"FileName Format Menu"];
                
                self.menu.autoenablesItems = NO;
                
                NSMenuItem * menuItem = [self.menu addItemWithTitle:@"include extension"
                                                             action:@selector(toogleFileNameWithExtension:)
                                                      keyEquivalent:@""];
                menuItem.target = self;
                menuItem.enabled = TRUE;
                menuItem.state = NSOnState;
                
                
                menuItem = [NSMenuItem separatorItem];
                [self.menu addItem:menuItem];
                
                menuItem = [[NSMenuItem alloc] initWithTitle:@"FilenameMenu"
                                                      action:NULL
                                               keyEquivalent:@""];
                menuItem.view = [FRAppDelegate loadMainViewFromNib:@"FRCustomViewForFileName"
                                                         withOwner:self];
                
                if (menuItem.view) [self.menu addItem:menuItem];
            }
                break;
            case FRTokenTypeFileExtension:
            {
                /* Setting default Values for Token */
                self.extensionIncludesDot = NO;
                
                /* Setting Menu for Token */
                self.menu = [[NSMenu alloc] initWithTitle:@"Extension Format Menu"];
                
                self.menu.autoenablesItems = NO;
                
                NSMenuItem * menuItem = [self.menu addItemWithTitle:@"include dot"
                                                             action:@selector(toogleExtensionIncludesDot:)
                                                      keyEquivalent:@""];
                menuItem.target = self;
                menuItem.enabled = TRUE;
                menuItem.state = NSOffState;
                
            }
                break;
            default:
                self.menu = nil;
                break;
        }
    }
    return self;
}

-(void)toogleExtensionIncludesDot:(NSMenuItem *)sender
{
    /* Update Token property */
    self.extensionIncludesDot = !self.extensionIncludesDot;
    
    /* Update Menu */
    sender.state = (self.extensionIncludesDot) ? NSOnState : NSOffState;
    
    if (_owner.autoPreview) [_owner previewRenaming:self];
}

-(void)toogleFileNameWithExtension:(NSMenuItem *)sender
{
    /* Update Token property */
    self.fileNameWithExtension = !self.fileNameWithExtension;
    
    /* Update Menu */
    sender.state = (self.fileNameWithExtension) ? NSOnState : NSOffState;
    
    if (_owner.autoPreview) [_owner previewRenaming:self];
}

-(void)setFormatDate:(NSMenuItem *)sender
{
    if (!sender) return;
    
    /* Update Token property */
    self.dateFormat = [[sender.title componentsSeparatedByString:@" "] objectAtIndex:0];
    
    /* Update Menu */
    for (NSMenuItem * sibling in sender.parentItem.submenu.itemArray) {
        if (sibling != sender)
        {
            sibling.state = NSOffState;
        }
        else
        {
            sibling.state = NSOnState;
        }
    }
    if (_owner.autoPreview) [_owner previewRenaming:self];
}

-(void)setSourceDate:(NSMenuItem *)sender
{
    /* Update Token property */
    switch (sender.tag) {
        case FRSOURCEDATE_CREATION:
        case FRSOURCEDATE_MODIFICATION:
        case FRSOURCEDATE_NOW:
            self.dateSource = sender.tag;
            break;
        default:
            self.dateSource = FRSOURCEDATE_NOW;
            break;
    }
    
    /* Update Menu */
    for (NSMenuItem * sibling in sender.parentItem.submenu.itemArray) {
        if (sibling != sender)
        {
            sibling.state = NSOffState;
        }
        else
        {
            sibling.state = NSOnState;
        }
    }
    if (_owner.autoPreview) [_owner previewRenaming:self];
}

-(BOOL)extensionIncludesDot
{
    return _extensionIncludesDot;
}
-(void)setExtensionIncludesDot:(BOOL)extensionIncludesDot
{
    _extensionIncludesDot = extensionIncludesDot;
    if (_owner.autoPreview) [_owner previewRenaming:self];
}

-(BOOL)useRegEx
{
    return _useRegEx;
}
-(void)setUseRegEx:(BOOL)useRegEx
{
    _useRegEx = useRegEx;
    if (_owner.autoPreview) [_owner previewRenaming:self];
}
-(BOOL)caseSensitive
{
    return _caseSensitive;
}
-(void)setCaseSensitive:(BOOL)caseSensitive
{
    _caseSensitive = caseSensitive;
    if (_owner.autoPreview) [_owner previewRenaming:self];
}

-(NSString *)searchValue
{
    return _searchValue;
}
-(void)setSearchValue:(NSString *)searchValue
{
    _searchValue = searchValue;
    if (_owner.autoPreview) [_owner previewRenaming:self];
}
-(NSString *)replaceValue
{
    return _replaceValue;
}
-(void)setReplaceValue:(NSString *)replaceValue
{
    _replaceValue = replaceValue;
    if (_owner.autoPreview) [_owner previewRenaming:self];
}

-(NSUInteger)counterStart
{
    return _counterStart;
}
-(void)setCounterStart:(NSUInteger)counterStart
{
    _counterStart = counterStart;
    if (_owner.autoPreview) [_owner previewRenaming:self];
}
-(NSUInteger)counterStep
{
    return _counterStep;
}
-(void)setCounterStep:(NSUInteger)counterStep
{
    _counterStep = counterStep;
    if (_owner.autoPreview) [_owner previewRenaming:self];
}
-(NSUInteger)counterNbIterationsNeededToIncrement
{
    return _counterNbIterationsNeededToIncrement;
}
-(void)setCounterNbIterationsNeededToIncrement:(NSUInteger)counterNbIterationsNeededToIncrement
{
    _counterNbIterationsNeededToIncrement = counterNbIterationsNeededToIncrement;
    if (_owner.autoPreview) [_owner previewRenaming:self];
}
-(NSUInteger)counterNbDigits
{
    return _counterNbDigits;
}
-(void)setCounterNbDigits:(NSUInteger)counterNbDigits
{
    _counterNbDigits = counterNbDigits;
    if (_owner.autoPreview) [_owner previewRenaming:self];
}

-(NSString *) description
{
    switch (self.tokenType)
    {
        case FRTokenTypeCounter:
        {
            return [self.string stringByAppendingString:[NSString stringWithFormat:@" [%lu,%lu,%lu,%lu]",self.counterStart, self.counterStep,self.counterNbDigits, self.counterNbIterationsNeededToIncrement]];
        }
            break;
            
        default:
            break;
    }
    return self.string;
}

-(NSString *)getStringValueForFile:(FRFile*)file
                             atRow:(NSUInteger)fileNumber
{
    switch (self.tokenType) {
        case FRTokenTypeCounter:
        {
            NSUInteger counterValue = self.counterStart + (NSUInteger)(fileNumber/self.counterNbIterationsNeededToIncrement)*self.counterStep;
            NSString * format = [NSString stringWithFormat:@"%%0%lulu", self.counterNbDigits];
            NSString * value = [NSString stringWithFormat:format, counterValue];
            value = [value substringFromIndex:(value.length-self.counterNbDigits)];
            return value;
        }
            break;
        case FRTokenTypeUser:
        {
            return self.string;
        }
            break;
        case FRTokenTypeFileExtension:
        {
            if (self.extensionIncludesDot && !([file.originalFileNameExtension isEqualToString:@""]))
                return [@"." stringByAppendingString:file.originalFileNameExtension];
            else
                return file.originalFileNameExtension;
        }
            break;
        case FRTokenTypeFileName:
        {
            NSString * fileName = (self.fileNameWithExtension) ? file.originalFileName : file.originalFileNameBaseName;
            NSStringCompareOptions options = (self.useRegEx ? NSRegularExpressionSearch : 0) | (self.caseSensitive ? 0 : NSCaseInsensitiveSearch);
            return [fileName stringByReplacingOccurrencesOfString:self.searchValue
                                                       withString:self.replaceValue
                                                          options:options
                                                            range:NSMakeRange(0, fileName.length)];
        }
            break;
        case FRTokenTypeFileGroupName:
        {
            return file.groupName;
        }
        case FRTokenTypeDay:
        case FRTokenTypeMinute:
        case FRTokenTypeMonth:
        case FRTokenTypeYear:
        case FRTokenTypeHour:
        {
            NSDate * date;
            switch (self.dateSource) {
                case FRSOURCEDATE_NOW:
                    date = [NSDate date];
                    break;
                case FRSOURCEDATE_MODIFICATION:
                    date = file.modificationDate;
                    break;
                case FRSOURCEDATE_CREATION:
                    date = file.creationDate;
                    break;
                default:
                    date = [NSDate date];
                    break;
            }
            NSDateFormatter * df = [[NSDateFormatter alloc] init]; [df setDateFormat:self.dateFormat];
            return [df stringFromDate:date];
        }
        default:
            break;
    }
    return @"";
}
@end
