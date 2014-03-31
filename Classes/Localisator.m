//
//  Localisator.m
//  CustomLocalisator
//
//  Created by Michael Azevedo on 05/03/2014.
//

#import "Localisator.h"

static NSString * const kSaveLanguageDefaultKey = @"kSaveLanguageDefaultKey";


@interface Localisator()

@property NSDictionary * dicoLocalisation;
@property NSUserDefaults * defaults;

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
        _defaults                       = [NSUserDefaults standardUserDefaults];
        _availableLanguagesArray        = @[@"DeviceLanguage", @"English", @"French"];
        _dicoLocalisation               = nil;
        
        _currentLanguage                = @"DeviceLanguage";
        
        NSString * languageSaved = [_defaults objectForKey:kSaveLanguageDefaultKey];
        
        if (languageSaved != nil && ![languageSaved isEqualToString:@"DeviceLanguage"])
        {
            [self loadDictionaryForLanguage:languageSaved];
        }
    }
    return self;
}


#pragma mark - saveInIUserDefaults custom accesser/setter

-(BOOL)saveInUserDefaults
{
    return ([self.defaults objectForKey:kSaveLanguageDefaultKey] != nil);
}

-(void)setSaveInUserDefaults:(BOOL)saveInUserDefaults
{
    if (saveInUserDefaults)
    {
        [self.defaults setObject:_currentLanguage forKey:kSaveLanguageDefaultKey];
    }
    else
    {
        [self.defaults removeObjectForKey:kSaveLanguageDefaultKey];
    }
    [self.defaults synchronize];
}

#pragma mark - Private  Instance methods

-(BOOL)loadDictionaryForLanguage:(NSString *)newLanguage
{
    NSURL * urlPath = [[NSBundle bundleForClass:[self class]] URLForResource:@"Localizable" withExtension:@"strings" subdirectory:nil localization:newLanguage];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:urlPath.path])
    {
        self.currentLanguage = [newLanguage copy];
        self.dicoLocalisation = [[NSDictionary dictionaryWithContentsOfFile:urlPath.path] copy];
        
        return YES;
    }
    return NO;
}


#pragma mark - Public Instance methods

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
        BOOL isLoadingOk = [self loadDictionaryForLanguage:newLanguage];
        
        if (isLoadingOk)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLanguageChanged
                                                                object:nil];
            if ([self saveInUserDefaults])
            {
                [self.defaults setObject:_currentLanguage forKey:kSaveLanguageDefaultKey];
                [self.defaults synchronize];
            }
        }
        return isLoadingOk;
    }
}


@end
