//
//  Localisator.m
//  CustomLocalisator
//
//  Created by Michael Azevedo on 05/03/2014.
//  Copyright (c) 2014 TEB. All rights reserved.
//

#import "Localisator.h"


@interface Localisator()

@property NSDictionary * dicoLocalisation;

@end

@implementation Localisator


#pragma  mark - Singleton Method

+ (Localisator*)sharedInstance
{
    static Localisator *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[Localisator alloc] init];
    });
    return _sharedInstance;
}


#pragma mark - Init methods

- (id)init
{
    self = [super init];
    if (self)
    {
        _availableLanguagesArray    = @[@"DeviceLanguage", @"English", @"French"];
        _currentLanguage             = @"DeviceLanguage";
        _dicoLocalisation            = nil;
    }
    return self;
}


#pragma mark - Instance methods


-(NSString *)localizedStringForKey:(NSString*)key
{
    if (self.dicoLocalisation == nil)
    {
        return NSLocalizedString(key, key);
    }
    else
    {
        NSString * localizedString = self.dicoLocalisation[key];
        if (localizedString == nil)
            localizedString = key;
        return localizedString;
    }
}

-(BOOL)setLanguage:(NSString *)newLanguage
{
    if (newLanguage == nil || [newLanguage isEqualToString:self.currentLanguage] || ![self.availableLanguagesArray containsObject:newLanguage])
        return NO;
    
    if ([newLanguage isEqualToString:@"DeviceLanguage"])
    {
        self.currentLanguage = [newLanguage copy];
        self.dicoLocalisation = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLanguageChanged
                                                            object:nil];
        return YES;
    }
    else
    {
        NSURL * urlPath = [[NSBundle bundleForClass:[self class]] URLForResource:@"Localizable" withExtension:@"strings" subdirectory:nil localization:newLanguage];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:urlPath.path])
        {
            self.currentLanguage = [newLanguage copy];
            self.dicoLocalisation = [[NSDictionary dictionaryWithContentsOfFile:urlPath.path] copy];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLanguageChanged
                                                                object:nil];
            return YES;
        }
        return NO;
    }
}


@end
