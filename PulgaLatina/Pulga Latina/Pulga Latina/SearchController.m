//
//  SearchController.m
//
//
//  Created by Michael Gu on 11/3/14.
//
//

#import "SearchController.h"
#import "Pulga_Latina-Swift.h"


@implementation SearchController: UITableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = (id)self;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.tableView reloadData];
    [self.searchBar becomeFirstResponder];
    
    UINib *adNib = [UINib nibWithNibName: @"AdCell" bundle: nil];
    [self.tableView registerNib:adNib forCellReuseIdentifier:@"Ad"];
    
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - keyboard first responder methods
- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self.searchBar resignFirstResponder];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return self.filteredCells.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    AdCell *cell = (AdCell *)[self.tableView dequeueReusableCellWithIdentifier:@"Ad" forIndexPath:indexPath];
    if (cell == nil)
        cell = [[AdCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Ad"];
    
    AdCell *filteredCell = [self.filteredCells objectAtIndex: indexPath.row];
    
    NSString *names = filteredCell.titleLabel.text;
    NSString *locations = filteredCell.locationLabel.text;
    NSString *prices = filteredCell.priceLabel.text;
    UIImage *adImage = filteredCell.adImageLabel.image;
    NSString *adContents = filteredCell.listedAdContent;
    NSString *emails = filteredCell.listedAdEmail;
    [cell loadAd: names price: prices location: locations adImage: adImage adContent: adContents email: emails];
    
    
    return cell;
}

#pragma mark Content Filtering
-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    
    self.filteredCells = [[NSMutableArray alloc] init];
    
    for (AdCell* cell in self.loadedCells)
    {
        NSRange nameRange = [cell.titleForSearch rangeOfString:text options:NSCaseInsensitiveSearch];
        NSRange descriptionRange = [cell.locationForSearch rangeOfString:text options:NSCaseInsensitiveSearch];
        if(nameRange.location != NSNotFound || descriptionRange.location != NSNotFound)
        {
            [self.filteredCells addObject:cell];
        }
    }
    
    
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
    
    [self performSegueWithIdentifier: @"showDetail" sender: tableView];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if ([[segue identifier] isEqualToString: @"showDetail"]){
         AdCell *filteredCell = [self.filteredCells objectAtIndex: indexPath.row];
        UINavigationController *controller = segue.destinationViewController;
        DetailViewController *detailController = (DetailViewController *)controller.topViewController;
        detailController.detailAdContent = filteredCell.listedAdContent;
        detailController.detailAdEmail = filteredCell.listedAdEmail;
        detailController.navigationItem.leftItemsSupplementBackButton = TRUE;

        
    }
}

@end
