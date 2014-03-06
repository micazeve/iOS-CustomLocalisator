//
//  TestViewController.m
//  CustomLocalisator
//
//  Created by Michael Azevedo on 06/03/2014.
//
//

#import "TestViewController.h"
#import "Localisator.h"

@interface TestViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UITableView *tableViewLanguages;

@property NSArray * arrayOfLangugages;

@end

@implementation TestViewController

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
    
    self.arrayOfLangugages = [[[Localisator sharedInstance] availableLanguagesArray] copy];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLanguageChangedNotification:)
                                                 name:kNotificationLanguageChanged
                                               object:nil];
    [self configureViewFromLocalisation];
}

-(void)configureViewFromLocalisation
{
    [self.label1 setText:[[Localisator sharedInstance] localizedStringForKey:@"StringLabel1"]];
    [self.label2 setText:[[Localisator sharedInstance] localizedStringForKey:@"StringLabel2"]];
    
    
    // disable the flash when changing the button title
    [UIView performWithoutAnimation:^{
        
        [self.button setTitle:[[Localisator sharedInstance] localizedStringForKey:@"StringButton"] forState:UIControlStateNormal];
    }];
    
    [self.tableViewLanguages reloadData];
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
    if (self.arrayOfLangugages == nil)
        return 0;
    
    return [self.arrayOfLangugages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"] ;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    cell.textLabel.text = [[Localisator sharedInstance] localizedStringForKey:self.arrayOfLangugages[indexPath.row]];
    
    /* Now that the cell is configured we return it to the table view so that it can display it */
    
    return cell;
}

#pragma mark - UITableViewDelegate protocol conformance

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[Localisator sharedInstance] setLanguage:self.arrayOfLangugages[indexPath.row]];
    
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
