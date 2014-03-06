//
//  Localisator.h
//  CustomLocalisator
//
//  Created by Michael Azevedo on 05/03/2014.
//  Copyright (c) 2014 TEB. All rights reserved.
//

#import <Foundation/Foundation.h>


static NSString * const kNotificationLanguageChanged = @"kNotificationLanguageChanged";



@interface Localisator : NSObject

@property (nonatomic, readonly) NSArray* availableLanguagesArray;


+ (Localisator*)sharedInstance;
-(NSString *)localizedStringForKey:(NSString*)key;
-(void)setLanguage:(NSString*)newLanguage;

@end
