//
//  DiaryListTableViewController.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 16..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "DiaryListTableViewController.h"
#import "EXFLogging.h"

@implementation DiaryListTableViewController

@synthesize managedObjectContext, fetchedResultsController;
@synthesize dataArr, diaryData;
@synthesize delegate;
@synthesize dateFormatter;
@synthesize diaryCell;
@synthesize editDiaryController;
@synthesize conditionString;

#pragma mark -
#pragma mark View lifecycle

/*
- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
		
    }
    return self;
}
*/

- (id)initWithStyle:(UITableViewStyle)style withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext andCondition:(NSString *)condition {
    if (self = [super initWithStyle:style]) {
		self.managedObjectContext = managedObjectContext;
		conditionString = condition;
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
	
	[inputFormatter release];
	[outputFormatter release];
	
	Debug("DiaryListTableViewController : conditionString = %@", conditionString);
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
	//    self.clearsSelectionOnViewWillAppear = NO;
	
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
#pragma mark Fetched results controller

/**
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController {
	[NSFetchedResultsController deleteCacheWithName:nil];
	
    Debug(@"fetchedResultsController");
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
	
    if (fetchedResultsController != nil) {
		Debug(@"return fetchedResultsController;");
        return fetchedResultsController;
    }
	
	
	// Create and configure a fetch request with the Book entity.
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"DiaryData" inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Create the sort descriptors array.
	NSSortDescriptor *birthdayDescriptor = [[NSSortDescriptor alloc] initWithKey:@"writedate" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:birthdayDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController = 
		[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
											managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"sectionDate" cacheName:@"Root"];
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

#pragma mark -
#pragma mark Editing

- (void)processEdit:(BOOL) editing {
//	Debug(@"processEdit : conditionString = %@", conditionString);
	self.editing = editing;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    NSInteger count = [[fetchedResultsController sections] count];
    
//	if (count == 0) {
//		count = 1;
//	}
	
	Debug(@"numberOfSectionsInTableView = %d", count);
    return count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	Debug(@"numberOfRowsInSection start");
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
    
	diaryData = (DiaryData *)[fetchedResultsController objectAtIndexPath:indexPath];
	Debug(@"1111");
    static NSString *CellIdentifier = @"DiaryListCell";
    Debug(@"2222");
	DiaryListCell *cell = (DiaryListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	Debug(@"3333");
	
    if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DiaryListCell" owner:self options:nil];
		Debug(@"cell == nil : nib.count = %d", [nib count]);
		for (id oneObject in nib) {
			if ([oneObject isKindOfClass:[DiaryListCell class]]) {
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				cell = (DiaryListCell *) oneObject;
				//					cell.backgroundColor = [UIColor whiteColor];
				cell.delegate = self;
			}
		}
    }
	
	if (diaryData != nil) {
		// Configure the cell...
		cell.titleField.text = diaryData.tag;
		cell.dateField.text = [NSString stringWithFormat:@"%@", diaryData.writedate]; //
		cell.photoView.image = diaryData.thumbnailImage;
	}
    Debug(@"4444 : tag = %@, date = %@", diaryData.tag, [self.dateFormatter stringFromDate:diaryData.writedate]);
    
    return cell;
    
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
    // Configure the cell to show the book's title
//	diaryData = [fetchedResultsController objectAtIndexPath:indexPath];
//	cell.textLabel.text = diaryData.tag;
	Debug(@"configureCell : [diaryData valueForKey:@\"sectionDate\"] = %@", [diaryData valueForKey:@"sectionDate"]);
	[self.delegate reloadTableView:[diaryData valueForKey:@"sectionDate"]];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	// Display the authors' names as section headings.
//	NSString *date = [self.dateFormatter stringFromDate:writedate];
	Debug(@"titleForHeaderInSection : section = %d, [fetchedResultsController sections] count = %d", section, [[fetchedResultsController sections] count]);
	Debug(@"[[[fetchedResultsController sections] objectAtIndex:section] name] = %@", [[[fetchedResultsController sections] objectAtIndex:section] name]);
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
    Debug(@"commitEditingStyle");
//	Debug("commitEditingStyle : conditionString = %@", conditionString);
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSError *error;
//		if (![[self fetchedResultsController] performFetch:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
//			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//			abort();
//		}
		
		 Debug(@"delete : indexPath.row = %d", indexPath.row);
		// Delete the managed object.
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		Debug(@"delete : 2222 : context = %@", context);
		Debug(@"delete : 2222 : [fetchedResultsController objectAtIndexPath:indexPath] = %@", [fetchedResultsController objectAtIndexPath:indexPath]);
		
		[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
		Debug(@"delete : 3333");

		if (![context save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
		Debug(@"delete : 4444");
    }   
}


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
	EditDiaryViewController *diaryView = [[EditDiaryViewController alloc] initWithNibName:@"EditDiaryViewController" bundle:nil withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext];
	diaryData = (DiaryData *)[fetchedResultsController objectAtIndexPath:indexPath];
	diaryView.diaryData = self.diaryData;

	Debug(@"diaryData.tag = %@", diaryData.tag);
	
	[delegate changeViewController:diaryView];
//	[diaryView release];
}

#pragma mark -
#pragma mark Date Formatter

- (NSDateFormatter *)dateFormatter {	
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	}
	return dateFormatter;
}

#pragma mark -
#pragma mark DiaryListCellDelegate

- (void)moveDiaryView {
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.managedObjectContext = nil;
	self.fetchedResultsController = nil;
	self.dataArr = nil;
	self.diaryData = nil;
	self.dateFormatter = nil;
	self.diaryCell = nil;
	self.editDiaryController = nil;
	self.conditionString = nil;
	
	[super viewDidUnload];
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[managedObjectContext release]; 
	[fetchedResultsController release];
	[dataArr release]; 
	[diaryData release];
	[dateFormatter release];
	[diaryCell release];
	[editDiaryController release];
	[conditionString release];
    [super dealloc];
}


@end

