//
//  EventListTableViewController.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 16..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "EventListTableViewController.h"
#import "EXFLogging.h"


@implementation EventListTableViewController

@synthesize fetchedResultsController;
@synthesize managedObjectContext;

@synthesize childData;
@synthesize eventData;

@synthesize delegate;
@synthesize conditionString;

#pragma mark -
#pragma mark View lifecycle
- (id)initWithStyle:(UITableViewStyle)style withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext andCondition:(NSString *)condition {
    if (self = [super initWithStyle:style]) {
		self.managedObjectContext = managedObjectContext;
		self.conditionString = condition;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setDateFormat:@"yyyy-MM-dd' 'HH:mm"];
	
	//	NSDate *formatterDate = [inputFormatter dateFromString:@"1999-07-11 at 10:30"];
	
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:@"yyyy'년' MM'월'"];
	
	if (conditionString == nil) {
		conditionString = [outputFormatter stringFromDate:[NSDate date]];
	}
	
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


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
#pragma mark Editing

- (void)processEdit:(BOOL) editing {
	self.editing = editing;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSInteger count = [[fetchedResultsController sections] count];
    
	//	if (count == 0) {
	//		count = 1;
	//	}
	
	Debug(@"numberOfSectionsInTableView = %d", count);
    return count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Return the number of rows in the section.
    NSInteger numberOfRows = 0;
	
    if ([[fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    
	Debug(@"numberOfRowsInSection = %d", numberOfRows);
    return numberOfRows;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	eventData = (EventData *)[fetchedResultsController objectAtIndexPath:indexPath];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
	cell.text = nil;
	cell.image = nil;
	cell.detailTextLabel.text = nil;
	
	if (eventData != nil) {
		cell.text = [eventData valueForKey:@"eventname"];
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [eventData valueForKey:@"conditionDate"]];
		cell.image = [UIImage imageNamed:@"event_icon.png"];
	}
    // Configure the cell...
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	// Display the authors' names as section headings.
	//	NSString *date = [self.dateFormatter stringFromDate:writedate];
	Debug(@"titleForHeaderInSection : section = %d, [fetchedResultsController sections] count = %d", section, [[fetchedResultsController sections] count]);
	
    return [[[fetchedResultsController sections] objectAtIndex:section] name];//[self.dateFormatter stringFromDate:writedate]];
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		// Delete the managed object.
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
		
		NSError *error;
		if (![context save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
    }   
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
#pragma mark Fetched results controller

/**
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController {
	[NSFetchedResultsController deleteCacheWithName:nil];
	
	NSPredicate *predicate = nil;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	Debug("fetchedResultsController : conditionString = %@", conditionString);
	NSString *attributeName = @"sectionDate";
	if (![conditionString isEqualToString:@"All"]) {
		Debug(@"[conditionString length] = %d, %@", [conditionString length], conditionString);
		if ([conditionString length] >= 9) {
			Debug(@"sectionDate == %@", conditionString);
			predicate = [NSPredicate predicateWithFormat:@"%K LIKE[cd] %@", attributeName, [conditionString stringByAppendingString:@"*"]];
			[fetchRequest setPredicate:predicate];
		} else if ([conditionString length] < 9) {
			Debug(@"sectionDate like %@*", conditionString);
			predicate = [NSPredicate predicateWithFormat:@"%K LIKE[cd] %@", attributeName, [conditionString stringByAppendingString:@"*"]];
			[fetchRequest setPredicate:predicate];
		}
	} else {
		predicate = [NSPredicate predicateWithFormat:@"%K LIKE[cd] %@", attributeName, @"*"];
		[fetchRequest setPredicate:predicate];
	}
	
    Debug(@"fetchedResultsController");
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
	// Create and configure a fetch request with the Book entity.
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"EventData" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Create the sort descriptors array.
	NSSortDescriptor *birthdayDescriptor = [[NSSortDescriptor alloc] initWithKey:@"eventdate" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:birthdayDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController = 
	[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
										managedObjectContext:managedObjectContext sectionNameKeyPath:@"sectionDate" cacheName:@"Root"];
	self.fetchedResultsController = aFetchedResultsController;
	fetchedResultsController.delegate = self;
	
	// Memory management.
	[aFetchedResultsController release];
	[fetchRequest release];
	[birthdayDescriptor release];
	[sortDescriptors release];
	
	return fetchedResultsController;
}    


/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	Debug(@"controllerWillChangeContent");
	[self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	Debug(@"didChangeObject");
	UITableView *tableView = self.tableView;
	Debug(@"didChangeObject.type = %d", type);
	switch(type) {
			
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeUpdate:
			[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			// Reloading the section inserts a new row and ensures that titles are updated appropriately.
			[tableView reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	Debug(@"didChangeSection");
	switch(type) {
			
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
	[self.tableView endUpdates];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
    // Configure the cell to show the book's title
	//	diaryData = [fetchedResultsController objectAtIndexPath:indexPath];
	//	cell.textLabel.text = diaryData.tag;
	[delegate reloadTableView:[eventData valueForKey:@"sectionDate"]];
}

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
	AddEventBackgroundViewController *addEventView = [[AddEventBackgroundViewController alloc] initWithManagedObjectContext:self.managedObjectContext];
	eventData = (EventData *)[fetchedResultsController objectAtIndexPath:indexPath];
	addEventView.eventData = self.eventData;
	[delegate changeViewController:addEventView];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.conditionString = nil;
	self.fetchedResultsController = nil;
	self.managedObjectContext = nil;
	
	self.childData = nil;
	self.eventData = nil;
	
	[super viewDidUnload];
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[conditionString release];
	[fetchedResultsController release];
	[managedObjectContext release];
	
	[childData release];
	[eventData release];
	
    [super dealloc];
}


@end

