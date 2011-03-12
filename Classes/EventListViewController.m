//
//  EventListViewController.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 15..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "EventListViewController.h"
#import "EXFLogging.h"


@implementation EventListViewController

@synthesize eventTableView;
@synthesize addEventController;
@synthesize editButton;
@synthesize editing;

@synthesize fetchedResultsController, managedObjectContext, childData, eventData;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	editing = YES;
	
	CGRect labelFrame = CGRectMake(140.0, 28.0, 170.0, 40.0); 
	UILabel *label = [[[UILabel alloc] initWithFrame:labelFrame] autorelease]; 
	label.font = [UIFont boldSystemFontOfSize:18]; 
	label.numberOfLines = 2; 
	label.backgroundColor = [UIColor clearColor]; 
	label.textAlignment = UITextAlignmentRight; 
	label.textColor = [UIColor blackColor]; 
	label.shadowColor = [UIColor whiteColor]; 
	label.shadowOffset = CGSizeMake(0.0, -1.0); 
	label.lineBreakMode = UILineBreakModeCharacterWrap;
	label.text = @"\nEvent List";
	self.navigationItem.titleView = label;
	
	//	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEvent)];
	//    self.navigationItem.rightBarButtonItem = addButton;
	//    [addButton release];
    
    NSArray *segNames = [[NSArray alloc] initWithObjects:@"Edit", @"+", nil];
    UISegmentedControl *editAndAdd = [[UISegmentedControl alloc] initWithItems:segNames];
    editAndAdd.tintColor = [UIColor colorWithRed:1.0 green:0.67 blue:0.98 alpha:1.0];
    editAndAdd.frame = CGRectMake(5, 267, 80, 30);
    editAndAdd.segmentedControlStyle = UISegmentedControlStyleBar;
    [editAndAdd addTarget:self action:@selector(segmentTouched:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:editAndAdd];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
    [editAndAdd release];
    [segNames release];
	
	//	editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(processEdit)];
	//    self.navigationItem.leftBarButtonItem = editButton;
	
	eventTableView = [[EventListTableViewController alloc] initWithStyle:UITableViewStylePlain withManagedObjectContext:self.managedObjectContext andCondition:nil];
	eventTableView.tableView.backgroundColor = [UIColor clearColor];
	eventTableView.tableView.opaque = NO;
	eventTableView.delegate = self;
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"eventlist_background.png"]];
	eventTableView.tableView.frame = CGRectMake(90, 10, 230, 350);
	[self.view addSubview:eventTableView.tableView];
	
	UIButton *searchYMButton = [UIButton buttonWithType:UIButtonTypeCustom];
	searchYMButton.frame = CGRectMake(10, 10, 60, 31);
	[searchYMButton setBackgroundImage:[UIImage imageNamed:@"btnSelectYM.png"] forState:UIControlStateNormal];
	[self.view addSubview:searchYMButton];
	[searchYMButton addTarget:self action:@selector(setConditionStringYM) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton *searchYButton = [UIButton buttonWithType:UIButtonTypeCustom];
	searchYButton.frame = CGRectMake(10, 44, 60, 31);
	[searchYButton setBackgroundImage:[UIImage imageNamed:@"btnSelectY.png"] forState:UIControlStateNormal];
	[self.view addSubview:searchYButton];
	[searchYButton addTarget:self action:@selector(setConditionStringY) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton *searchAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
	searchAllButton.frame = CGRectMake(10, 78, 60, 31);
	[searchAllButton setBackgroundImage:[UIImage imageNamed:@"btnSelectAll.png"] forState:UIControlStateNormal];
	[self.view addSubview:searchAllButton];
	[searchAllButton addTarget:self action:@selector(setConditionStringNil) forControlEvents:UIControlEventTouchUpInside];
}

- (void) segmentTouched:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        [self processEdit:sender];
    } else if (sender.selectedSegmentIndex == 1) {
        [self addEvent];
    }
	
	sender.selectedSegmentIndex = -1;
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)setConditionStringYM {
	Debug(@"setConditionStringYM");
	YearMonthPickerViewController *pikerView = [[YearMonthPickerViewController alloc] initWithNibName:@"YearMonthPickerViewController" bundle:nil withMode:@"YM"];
	pikerView.delegate = self;
	pikerView.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:pikerView animated:YES];
}

- (void)setConditionStringY {
	Debug(@"setConditionStringY");
	YearMonthPickerViewController *pikerView = [[YearMonthPickerViewController alloc] initWithNibName:@"YearMonthPickerViewController" bundle:nil withMode:@"Y"];
	pikerView.delegate = self;
	pikerView.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:pikerView animated:YES];
}

- (void)setConditionStringNil {
	Debug(@"setConditionStringNil");
	[self loadNewTableView:@"All"];
}

- (void)loadNewTableView:(NSString *)condition {
	Debug(@"loadNewTableView");
	Debug(@"self.conditionString != nil");
	[eventTableView.view removeFromSuperview];
	
	eventTableView = [[EventListTableViewController alloc] initWithStyle:UITableViewStylePlain withManagedObjectContext:self.managedObjectContext andCondition:condition];
	eventTableView.view.backgroundColor = [UIColor clearColor];//colorWithRed:194/256*100 green:156/256*100 blue:1.0f alpha:0.3f];
	eventTableView.view.opaque = YES;
	eventTableView.delegate = self;
	
	eventTableView.view.frame = CGRectMake(90, 10, 230, 395);
	[self.view addSubview:eventTableView.view];
	
}

#pragma mark -
#pragma mark YearMonthPickerViewControllerDelegate

- (void)reloadTableView:(NSString *)condition {
	Debug(@"setConditionString");
	[self loadNewTableView:condition];
}

#pragma mark -
#pragma mark AddEventBackgroundViewController

- (void)changeViewController:(AddEventBackgroundViewController *)addEventView {
	[self.navigationController pushViewController:addEventView animated:YES];
}

#pragma mark -
#pragma mark Fetched results controller

- (void)fetchRequestResult:(NSString *)cName {
	Debug(@"section count = %d", [[fetchedResultsController sections] count]);
	
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:0];
	Debug(@"row count = %d", [sectionInfo numberOfObjects]);
	
	NSPredicate *predicate = nil;
	
	if (cName != nil && [cName length]) {
		predicate = [NSPredicate predicateWithFormat:@"childname == %@", cName];
	}
	
	[fetchedResultsController.fetchRequest setPredicate:predicate];
	
	managedObjectContext = [fetchedResultsController managedObjectContext];
	
	//	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchedResultsController.fetchRequest setEntity:[NSEntityDescription entityForName:@"ChildData" inManagedObjectContext:managedObjectContext]];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"birthday" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
	[fetchedResultsController.fetchRequest setSortDescriptors:sortDescriptors];
	
	NSError *error;
	NSArray *childDatas = [managedObjectContext executeFetchRequest:fetchedResultsController.fetchRequest error:&error];
	
	//	[fetchRequest release];
	[sortDescriptor release];
	[sortDescriptors release];
	Debug(@"self.childDatas count = %d, cName = %@", [childDatas count], cName);
	
	/*
	 if ([childDatas count] > 0) {
	 for (NSInteger i = 0; i < [childDatas count]; i++) {
	 childData = [childDatas objectAtIndex:i];
	 Debug(@"childData.name = %@, childData.nickname = %@", childData.childname, childData.nickname);
	 }
	 } else {
	 UIAlertView *alert = [[UIAlertView alloc]
	 initWithTitle:@"미등록 알림" 
	 message:@"등록된 아기가 없습니다.\n아기 등록 화면으로 이동합니다."
	 delegate:self 
	 cancelButtonTitle:@"취 소" 
	 otherButtonTitles:@"이 동", nil];
	 [alert show];
	 [alert release];
	 
	 //	AddChildViewController *nextViewController = [[AddChildViewController alloc] initWithStyle:UITableViewStyleGrouped withDelegate:self withManagedObjectContext:self.managedObjectContext];
	 }
	 */
	
}

/**
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController {
    Debug(@"fetchedResultsController");
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
	// Create and configure a fetch request with the Book entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"EventData" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Create the sort descriptors array.
	NSSortDescriptor *birthdayDescriptor = [[NSSortDescriptor alloc] initWithKey:@"eventdate" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:birthdayDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
	self.fetchedResultsController = aFetchedResultsController;
	fetchedResultsController.delegate = self;
	
	// Memory management.
	[aFetchedResultsController release];
	[fetchRequest release];
	[birthdayDescriptor release];
	[sortDescriptors release];
	
	return fetchedResultsController;
}


#pragma mark -
#pragma mark Add & Edit

- (void) addEvent {
	addEventController = [[AddEventBackgroundViewController alloc] init];
	addEventController.managedObjectContext = self.managedObjectContext;
	addEventController.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:addEventController animated:YES];
}


- (void)processEdit:(UISegmentedControl *)segment {
	if (editing) {
		Debug(@"processEdit : editing = YES");
        [segment setTitle:@"Done" forSegmentAtIndex:0];
		//		self.editButton.title = @"Done";
		//		self.editButton.image = [UIImage imageNamed:@"btnHome.png"];
	} else {
		Debug(@"processEdit : editing = NO");
        [segment setTitle:@"Edit" forSegmentAtIndex:0];
		//		self.editButton.title = @"Edit";
	}
	
    segment.selectedSegmentIndex = -1;
	[eventTableView processEdit:editing];
	editing = !editing;
}

#pragma mark -
#pragma mark Memory management
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[editButton release];
	[eventTableView release];
	[addEventController release];
    [super dealloc];
}


@end
