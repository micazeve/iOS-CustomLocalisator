//
//  LocalisatorViewController.m
//  CustomLocalisator
//
//  Created by Michael Azevedo on 06/03/2014.
//
//

#import "LocalisatorViewController.h"
#import "Localisator.h"

@interface LocalisatorViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableViewLanguages;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewFlag;

@property (weak, nonatomic) IBOutlet UILabel *labelCurrentLanguage;
@property (weak, nonatomic) IBOutlet UILabel *labelChooseLanguage;



@property NSArray * arrayOfLanguages;

@end

@implementation LocalisatorViewController

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
    
    self.arrayOfLanguages = [[[Localisator sharedInstance] availableLanguagesArray] copy];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLanguageChangedNotification:)
                                                 name:kNotificationLanguageChanged
                                               object:nil];
    [self configureViewFromLocalisation];
}

-(void)configureViewFromLocalisation
{
    self.title = LOCALIZATION(@"LocalisatorViewTitle");
    
    [self.labelCurrentLanguage setText:LOCALIZATION(@"LocalisatorViewCurrentLanguageText")];
    [self.labelChooseLanguage setText:LOCALIZATION(@"LocalisatorViewTitle")];
    
    [self.tableViewLanguages reloadData];

    [self.imageViewFlag setImage:[UIImage imageNamed:[[Localisator sharedInstance] currentLanguage]]];

}
#pragma mark - Notification methods

- (void) receiveLanguageChangedNotification:(NSNotification *) notification
{
    if ([notification.name isEqualToString:kNotificationLanguageChanged])
    {
        [self configureViewFromLocalisation];
    }
}

#pragma mark - UITableViewDataSource protocol conformance

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.arrayOfLanguages == nil)
        return 0;
    
    return [self.arrayOfLanguages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyIdentifier"] ;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    cell.imageView.image = [UIImage imageNamed:self.arrayOfLanguages[indexPath.row]];
    cell.textLabel.text = LOCALIZATION(self.arrayOfLanguages[indexPath.row]);
    
    /* Now that the cell is configured we return it to the table view so that it can display it */
    
    return cell;
}

#pragma mark - UITableViewDelegate protocol conformance

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([[Localisator sharedInstance] setLanguage:self.arrayOfLanguages[indexPath.row]])
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:LOCALIZATION(@"languageChangedWarningMessage") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
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
