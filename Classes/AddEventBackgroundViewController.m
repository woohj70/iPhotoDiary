    //
//  AddEventBackgroundViewController.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 25..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "AddEventBackgroundViewController.h"
#import "EXFLogging.h"


@implementation AddEventBackgroundViewController

@synthesize addEventController;
@synthesize closeViewButton;

@synthesize fetchedResultsController;
@synthesize managedObjectContext;

@synthesize childData;
@synthesize eventData;

@synthesize dateFormatter;

#pragma mark -
#pragma mark View lifecycle
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
	
	if (self = [super init]) {
		//		UINavigationItem *navigationItem = self.navigationItem;
		self.managedObjectContext = managedObjectContext;
	}
	
	return self;
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	Debug(@"AddEventBackgroundViewController.viewDidLoad : [AppMainViewController childrenArray] = %@", [AppMainViewController childrenArray]);
	
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
	label.text = @"\nEvent 등록";
	self.navigationItem.titleView = label;
	
	closeViewButton = [[[UIBarButtonItem alloc] initWithTitle:@"취 소" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)] autorelease];
	self.navigationItem.leftBarButtonItem = closeViewButton;
	//	[closeViewButton release];
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];

	if (eventData != nil) {
		Debug(@"eventData가 nil이 아니므로 화면에 출력하고 저장을 준비합니다! : %@", childData.childname);
		addEventController = [[AddEventViewController alloc] initWithStyle:UITableViewStyleGrouped withEventData:eventData];
	} else {
		Debug(@"eventData가 nil이므로 새 데이터 생성을 준비합니다!");
		addEventController = [[AddEventViewController alloc] initWithStyle:UITableViewStyleGrouped];		
	}
	
	addEventController.view.backgroundColor = [UIColor clearColor];
	addEventController.view.opaque = YES;
	addEventController.delegate = self;
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"eventlist_background.png"]];
	addEventController.tableView.frame = CGRectMake(0, 0, 320, 460);
	
	[self.view addSubview:addEventController.tableView];
	
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
	
	[self fetchRequestResult:[AppMainViewController selectedChildName]];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == alertView.cancelButtonIndex) {
		Debug(@"cancel butoon clicked");
		[self.navigationController popViewControllerAnimated:YES];
	}
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
	
	if ([childDatas count] > 0) {
		for (NSInteger i = 0; i < [childDatas count]; i++) {
			childData = [childDatas objectAtIndex:i];
			Debug(@"childData.name = %@, childData.nickname = %@", childData.childname, childData.nickname);
		}
	} 
	
	if ([childDatas count] > 0) {
		for (NSInteger i = 0; i < [childDatas count]; i++) {
			childData = [childDatas objectAtIndex:i];
			Debug(@"childData.name = %@, childData.nickname = %@", childData.childname, childData.nickname);
		}
	} else {
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"미등록 알림" 
							  message:@"등록된 아기가 없습니다.\n아기를 먼저 등록해주세요."
							  delegate:self 
							  cancelButtonTitle:@"확 인" 
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
	 
	 //	AddChildViewController *nextViewController = [[AddChildViewController alloc] initWithStyle:UITableViewStyleGrouped withDelegate:self withManagedObjectContext:self.managedObjectContext];
	}
	
	
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
#pragma mark AddEventViewControllerDelegate

- (void)changeChild:(NSString *)childName {
	Debug("changed child name = %@", childName);
	[self fetchRequestResult:childName];
}

- (void)moveEditView:(NSInteger)row withViewController:(AddEventViewController *)addEventController andTableViewCell:(UITableViewCell *)tableViewCell {
	Debug("moveEditView : row = %d", row);
	if (row == 0 || row == 1) {
		EditEventViewController *eventController = [[EditEventViewController alloc] initWithNibName:@"EditEventViewController" bundle:nil];
		eventController.settingCell = tableViewCell;
		
		[self.navigationController pushViewController:eventController animated:YES];
	} else if (row == 2) {
		DataPickerViewController *pickerViewController = [[DataPickerViewController alloc] init];
		
		pickerViewController.eventCell = tableViewCell;
		
		[self.navigationController pushViewController:pickerViewController animated:YES];
	} else if (row == 3) {
		ChildrenPickerViewController *childrenPicker = [[ChildrenPickerViewController alloc] initWithNibName:@"ChildrenPickerViewController" bundle:nil];
		childrenPicker.delegate = addEventController;
		childrenPicker.settingCell = tableViewCell;
		[self.navigationController pushViewController:childrenPicker animated:YES];
	}
	
}

#pragma mark -
#pragma mark Cancel & Save

- (void)save {
	Debug("Save 0000");
	NSManagedObjectContext *context = managedObjectContext;
	Debug("Save 0000 - 1");

	/*
	 If there isn't an ingredient object, create and configure one.
	 */
	BOOL editmode = YES;
	
    if (!eventData) {
		editmode = NO;
		
		Debug("Save 1111");
        eventData = [NSEntityDescription insertNewObjectForEntityForName:@"EventData" inManagedObjectContext:context];
		Debug("Save 2222");
        [childData addEventsObject:eventData];
		Debug("Save 3333");
		//		ingredient.displayOrder = [NSNumber numberWithInteger:[recipe.ingredients count]];
    }
	
	/*
	 @dynamic eventmemo;
	 @dynamic eventdate;
	 @dynamic eventname;
	 @dynamic eventtype;
	 @dynamic child;
	 */
	
	//	imageSet = [[NSMutableSet alloc] initWithArray:imageArray];
	EventSettingCell *cell = nil;
	
	cell = [addEventController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	Debug("cell Value = %@", cell.valueLabel.text);
	[eventData setValue:cell.valueLabel.text forKey:@"eventname"];
	
	cell = [addEventController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
	Debug("cell Value = %@", cell.valueLabel.text);
	[eventData setValue:cell.valueLabel.text forKey:@"eventmemo"];
	
	cell = [addEventController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
	Debug("cell Value = %@", [self.dateFormatter stringFromDate:cell.eventDate]);
	[eventData setValue:cell.eventDate forKey:@"eventdate"];
	
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *dateComponent = [cal components:unitFlags fromDate:cell.eventDate];
	
	[eventData setValue:[NSString stringWithFormat:@"%d. %d. %d.", dateComponent.year, dateComponent.month, dateComponent.day] forKey:@"conditionDate"];
	
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setDateFormat:@"yyyy-MM-dd' 'HH:mm"];
	
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:@"yyyy'년' MM'월'"];
	
	NSString *newDateString = [outputFormatter stringFromDate:cell.eventDate];
	Debug("Save 3333 - newDateString = %@", newDateString);
	
	[eventData setValue:newDateString forKey:@"sectionDate"];
	
	cell = [addEventController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
	Debug("cell Value = %@", cell.valueLabel.text);
	[eventData setValue:cell.valueLabel.text forKey:@"childname"];
	
	
	
	
	[eventData setValue:childData forKey:@"child"];
	
//	cell = [addEventController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];	
//	UISwitch *sw = (UISwitch *)cell.accessoryView;
//	if (sw.on) {
//		Debug("cell Value = On");
//		[eventData setValue:[[NSNumber alloc] initWithInteger:1] forKey:@"eventtype"];
//	} else {
//		Debug("cell Value = Off");
//		[eventData setValue:[[NSNumber alloc] initWithInteger:1] forKey:@"eventtype"];
//	}

//	[sw release];
	
	NSError *error = nil;
	if (![context save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	Debug("Save DiaryData");
	
	if (!editmode) {
		[childData addEventsObject:eventData];
		
		NSManagedObjectContext *context2 = childData.managedObjectContext;
		
		if (![context2 save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
		Debug("Save ChildData");
	}
	

	[self.navigationController popViewControllerAnimated:YES];
	
/*	
	eventData.tag = self.titleField.text;
	eventData.content = self.contentView.text;
	
	if (!editmode) {
		diaryData.writedate = [NSDate date];
	}
	
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setDateFormat:@"yyyy-MM-dd' 'HH:mm"];
	
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:@"yyyy'년' MM'월'"];
	
	NSString *newDateString = [outputFormatter stringFromDate:[NSDate date]];
	Debug("Save 3333 - newDateString = %@", newDateString);
	
	diaryData.sectionDate = newDateString;
	diaryData.child = childData;
	Debug("Save 3333 - 1");
	
	
	
	Debug("Save 3333 - 2");
	diaryData.thumbnailImage = photoZone.image;
	Debug("Save 4444 : imageArray.count = %d", [imageArray count]);
	NSError *error = nil;
	if (![context save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	Debug("Save DiaryData");
	
	if (!editmode) {
		NSManagedObjectContext *context2 = childData.managedObjectContext;
		
		if (![context2 save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
		Debug("Save ChildData");
	}
	
	[self.navigationController popViewControllerAnimated:YES];
 */
}

- (void)cancel {
	[self.navigationController popViewControllerAnimated:YES];
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
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.addEventController = nil;
	self.closeViewButton = nil;
	
	self.fetchedResultsController = nil;
	self.managedObjectContext = nil;
	
	self.childData = nil;
	self.eventData = nil;
	
	self.dateFormatter = nil;
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[addEventController release];
	[closeViewButton release];
	
	[fetchedResultsController release];
	[managedObjectContext release];
	
	[childData release];
	[eventData release];
	
	[dateFormatter release];
	

    [super dealloc];
}


@end
