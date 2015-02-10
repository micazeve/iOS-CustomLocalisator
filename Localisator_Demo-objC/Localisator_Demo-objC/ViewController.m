//
//  ViewController.m
//  Localisator_Demo-objC
//
//  Created by Michaël Azevedo on 10/02/2015.
//  Copyright (c) 2015 Michaël Azevedo. All rights reserved.
//

#import "ViewController.h"
#import "Localisator.h"
#import "LocalisatorViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *homeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeDescLabel;
@property (weak, nonatomic) IBOutlet UIButton *languageButton;

@end

@implementation ViewController

#pragma mark - Init methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Localisator";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLanguageChangedNotification:)
                                                 name:kNotificationLanguageChanged
                                               object:nil];
    
    [self configureViewFromLocalisation];
}

-(void)configureViewFromLocalisation
{
    [self.homeTitleLabel    setText:LOCALIZATION(@"HomeTitleText")];
    [self.homeDescLabel     setText:LOCALIZATION(@"HomeDescText")];
    
    [self.languageButton setTitle:LOCALIZATION(@"HomeButtonTitle") forState:UIControlStateNormal];
}

#pragma mark - Notification methods

- (void) receiveLanguageChangedNotification:(NSNotification *) notification
{
    if ([notification.name isEqualToString:kNotificationLanguageChanged])
    {
        [self configureViewFromLocalisation];
    }
}

#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLanguageChanged object:nil];
}


@end
