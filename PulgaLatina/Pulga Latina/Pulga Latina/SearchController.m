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
    
    
    NSLog(@"%@",self.loadedCells);
    [self.tableView reloadData];
    
    UINib *adNib = [UINib nibWithNibName: @"AdCell" bundle: nil];
    [self.tableView registerNib:adNib forCellReuseIdentifier:@"Ad"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return self.filteredCells.count;
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
//-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
//{
//    [self.filteredCells removeAllObjects];
//
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.titleForSearch contains[c] %@", searchText];
//    self.filteredCells = [NSMutableArray arrayWithArray:[self.loadedCells filteredArrayUsingPredicate:predicate]];
//    [self.tableView reloadData];
//}
//
//#pragma mark - UISearchDisplayController Delegate Methods
//-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
//
//    [self filterContentForSearchText:searchString scope:
//     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
//
//    return YES;
//}


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
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
