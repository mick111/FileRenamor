//
//  FRSpecialToken.m
//  FileRenamor
//
//  Created by Michael Mouchous on 20/10/12.
//  Copyright (c) 2012 Michael Mouchous. All rights reserved.
//

#import "FRSpecialToken.h"

@implementation FRSpecialToken

@synthesize tokenType;

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

-(id)initWithString:(NSString *)string
{
    self = [super init];
    if (self)
    {
        
        self.tokenType = [[self class] tokenTypeForString:string];
        
        self.string = [[NSString alloc] initWithString:string];
//        if (self.tokenType == FRTokenTypeUser)
//        {
//            NSMutableString * mutableString = [[NSMutableString alloc] initWithString:string];
//            [mutableString replaceOccurrencesOfString:@"\x1B"
//                                           withString:@""
//                                              options:NSCaseInsensitiveSearch
//                                                range:NSMakeRange(0, string.length)];
//            self.string = [[NSString alloc] initWithString:mutableString];
//            mutableString = nil;
//        }
//        else
//        {
//            self.string = [[NSString alloc] initWithString:string];
//        }
        
        //self.tokenType = pTokenType;
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
                NSNib * nib = [[NSNib alloc] initWithNibNamed:@"FRCustomViewForCounter"
                                                       bundle:nil];
                NSArray * arrayOfViews;
                if (![nib instantiateNibWithOwner:self
                             topLevelObjects:&arrayOfViews])
                {
                    NSLog(@"Cannot instanciate view from FRCustomViewForCounter");
                    return nil;
                }
                NSLog(@"Nib loaded");
                NSMenuItem * menuItem = [[NSMenuItem alloc] initWithTitle:@"CounterMenu"
                                                                   action:@selector(setCounterProperties)
                                                            keyEquivalent:@""];
                
                for (id object in arrayOfViews)
                {
                    if ([object isKindOfClass:[NSView class]])
                    {
                        menuItem.view = object;
                    }
                }
                
                [self.menu addItem:menuItem];
                
                
            }
                break;
            case FRTokenTypeMinute:
            case FRTokenTypeHour:
            case FRTokenTypeDay:
            case FRTokenTypeMonth:
            case FRTokenTypeYear:
            {
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
                                                   keyEquivalent:@"m"];
                subMenuItem.target = self;
                [subMenuItem setEnabled:TRUE];
                subMenuItem = [menuItem.submenu addItemWithTitle:@"Creation Date"
                                                          action:@selector(setSourceDate:)
                                                   keyEquivalent:@"c"];
                subMenuItem.target = self;
                [subMenuItem setEnabled:TRUE];
                subMenuItem = [menuItem.submenu addItemWithTitle:@"Now"
                                                          action:@selector(setSourceDate:)
                                                   keyEquivalent:@"n"];
                subMenuItem.target = self;
                [subMenuItem setEnabled:TRUE];
                
                
                menuItem = [self.menu addItemWithTitle:@"Date format"
                                                action:NULL
                                         keyEquivalent:@""];
                [subMenuItem setEnabled:TRUE];
                menuItem.submenu = [[NSMenu alloc] initWithTitle:@"Date Format Menu"];
                menuItem.submenu.autoenablesItems = NO;
                subMenuItem = [menuItem.submenu addItemWithTitle:@"Long"
                                                          action:@selector(setFormatDate:)
                                                   keyEquivalent:@""];
                subMenuItem.target = self;
                [subMenuItem setEnabled:TRUE];
                subMenuItem = [menuItem.submenu addItemWithTitle:@"Short"
                                                          action:@selector(setFormatDate:)
                                                   keyEquivalent:@""];
                subMenuItem.target = self;
                [subMenuItem setEnabled:TRUE];
                subMenuItem = [menuItem.submenu addItemWithTitle:@"AM"
                                                          action:@selector(setFormatDate:)
                                                   keyEquivalent:@""];
                subMenuItem.target = self;
                [subMenuItem setEnabled:TRUE];
            }
                break;
            default:
                self.menu = nil;
                break;
        }
    }
    return self;
}

-(void)setFormatDate:(NSMenuItem *)sender
{
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
}

-(void)setSourceDate:(NSMenuItem *)sender
{
    
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

-(NSString *)getStringValueForFile:(FRFile*)file atRow:(NSUInteger)fileNumber
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
            return self.string;
            break;
        case FRTokenTypeFileExtension:
        {
            return file.originalFileNameExtension;
        }
            break;
        case FRTokenTypeFileName:
        {
            if (self.fileNameWithExtension)
            {
                return file.originalFileName;
            }
            return file.originalFileNameBaseName;
        }
            break;
        case FRTokenTypeFileGroupName:
        {
            return file.groupName;
        }
        case FRTokenTypeDay:
        {
            NSDateFormatter * df = [[NSDateFormatter alloc] init]; [df setDateFormat:@"dd"];
            return [df stringFromDate:[NSDate date]];
        }
        case FRTokenTypeMinute:
        {
            NSDateFormatter * df = [[NSDateFormatter alloc] init]; [df setDateFormat:@"mm"];
            return [df stringFromDate:[NSDate date]];
        }
        case FRTokenTypeMonth:
        {
            NSDateFormatter * df = [[NSDateFormatter alloc] init]; [df setDateFormat:@"MMM"];
            return [df stringFromDate:[NSDate date]];
        }
        case FRTokenTypeYear:
        {
            NSDateFormatter * df = [[NSDateFormatter alloc] init]; [df setDateFormat:@"yyyy"];
            return [df stringFromDate:[NSDate date]];
        }
        case FRTokenTypeHour:
        {
            NSDateFormatter * df = [[NSDateFormatter alloc] init]; [df setDateFormat:@"HH"];
            return [df stringFromDate:[NSDate date]];
        }
        default:
            break;
    }
    return @"";
}
@end
