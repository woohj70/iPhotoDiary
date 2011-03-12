//
//  AnniversaryDetailTableViewController.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 28..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "AnniversaryDetailTableViewController.h"
#import "EXFLogging.h"


@implementation AnniversaryDetailTableViewController

@synthesize delegate;
@synthesize annData;
#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"EventSettingCell";
    
    EventSettingCell *cell = (EventSettingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EventSettingCell" owner:self options:nil];
		
		for (id oneObject in nib) {
			if ([oneObject isKindOfClass:[EventSettingCell class]]) {
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				cell = (EventSettingCell *) oneObject;
				//					cell.backgroundColor = [UIColor whiteColor];
				//cell.delegate = self;
			}
		}
    }
	
	cell.text = nil;
	cell.image = nil;
	cell.accessoryView = nil;
	
	if (annData != nil) {
		if (indexPath.row == 0) {
			cell.titleLabel.text = @"기념일 : ";
			cell.valueLabel.text = [annData objectForKey:@"name"];
		} else if (indexPath.row == 1) {
			cell.titleLabel.text = @"날짜 : ";
			cell.valueLabel.text = [annData objectForKey:@"date"];
		} else if (indexPath.row == 2) {
			cell.titleLabel.text = @"공휴일 : ";
			cell.accessoryView = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
			
			UISwitch *sw = (UISwitch *)cell.accessoryView;
			Debug("holy = %@", [annData objectForKey:@"holy"]);
			if ([@"ON" isEqualToString:[annData objectForKey:@"holy"]]) {
				Debug(@"ON");
				[sw setOn:YES animated:YES];
			} else {
				Debug(@"OFF");
				[sw setOn:NO animated:YES];
			}

		} else if (indexPath.row == 3) {
			cell.titleLabel.text = @"음력 : ";
			cell.accessoryView = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
			
			UISwitch *sw = (UISwitch *)cell.accessoryView;
			Debug("lunar = %@", [annData objectForKey:@"lunar"]);
			if ([@"ON" isEqualToString:[annData objectForKey:@"lunar"]]) {
				[sw setOn:YES animated:YES];
			} else {
				[sw setOn:NO animated:YES];
			}
		}
	} else {
		if (indexPath.row == 0) {
			cell.titleLabel.text = @"기념일 : ";
		} else if (indexPath.row == 1) {
			cell.titleLabel.text = @"날짜 : ";
		} else if (indexPath.row == 2) {
			cell.titleLabel.text = @"공휴일 : ";
			cell.accessoryView = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
		} else if (indexPath.row == 3) {
			cell.titleLabel.text = @"음력 : ";
			cell.accessoryView = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
		}
	}

    
    // Configure the cell...
    
    return cell;
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	[delegate moveEditView:indexPath.row withViewController:self andTableViewCell:[tableView cellForRowAtIndexPath:indexPath]];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

