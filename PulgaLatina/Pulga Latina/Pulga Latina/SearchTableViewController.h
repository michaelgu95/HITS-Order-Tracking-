//
//  SearchTableViewController.h
//  
//
//  Created by Michael Gu on 11/3/14.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface SearchTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate> {
    
}
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong)   NSMutableArray *filteredCells;
@property (nonatomic, strong) NSMutableArray *loadedCells;

@end
