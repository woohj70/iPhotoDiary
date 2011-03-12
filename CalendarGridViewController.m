//
//  CalendarGridViewController.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 5. 6..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "CalendarGridViewController.h"
#import "CalendarViewController.h"
#import "EXFLogging.h"


@implementation CalendarGridViewController

@synthesize calendarViewController;
@synthesize managedObjectContext;
@synthesize detailView;
@synthesize calButton;
@synthesize segment;
//@synthesize navController;

//@synthesize navController;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */

- (id)init {
	if (self = [super init]) {
		//self.title = @"    Calendar";
		
		
	}
	
	return self;
}

- (void)loadView {
	Debug(@"loadView");
	[super loadView];
	myCalendarView = [[[MyCalendarView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 416.0f) delegate:self  withManagedObjectContext:self.managedObjectContext] autorelease];
	[self.view addSubview:myCalendarView];
	
	//	self.view = myCalendarView;
}

- (void)viewChange {
	editDiaryViewController = [[EditDiaryViewController alloc] initWithNibName:@"EditDiaryViewController" bundle:nil];
	//	[calendarViewController hideTabBar];
	//	[self.navigationController presentModalViewController:editDiaryViewController animated:YES];
	editDiaryViewController.managedObjectContext = self.managedObjectContext;
	editDiaryViewController.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:editDiaryViewController animated:YES];
	//	[editDiaryViewController release];
}

- (void)viewWillAppear:(BOOL)animated {
	//	[calendarViewController viewTabBar];
	//	Debug(@"viewTabBar");
	//	[myCalendarView setNeedsDisplay];
	//	Debug(@"[myCalendarView setNeedsDisplay]");
	[detailView setNeedsDisplay];
	Debug(@"[detailView setNeedsDisplay];");
	[myCalendarView loadData];
	Debug(@"[myCalendarView loadData];");
}

/*
 Calendar Delegate implementation 
 */
- (void)didChangeMonths {
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	Debug(@"viewDidLoad");
    [super viewDidLoad];
	
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
	label.text = @"\nCalendar";
	self.navigationItem.titleView = label;
	
	//	edit = [[[UIBarButtonItem alloc] initWithTitle:@"일기" style:UIBarButtonItemStylePlain target:self action:@selector(viewChange)] autorelease];
	//	self.navigationItem.leftBarButtonItem = edit;
	//  [edit release];
	
	//	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAnniversary)];
	//    self.navigationItem.rightBarButtonItem = addButton;
	//    [addButton release];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
	self.navigationItem.backBarButtonItem = backButton;
    [backButton release];
    
    NSArray *items = [[NSArray alloc] initWithObjects:@"일기", @"이벤트", @"기념일", nil];
    segment = [[UISegmentedControl alloc] initWithItems:items];
    segment.segmentedControlStyle = UISegmentedControlStyleBar;
    [segment addTarget:self action:@selector(segmentTouched:) forControlEvents:UIControlEventValueChanged];
    segment.frame = CGRectMake(10, 5, 300, 35);
    segment.tintColor = [UIColor colorWithRed:1.0 green:0.67 blue:0.98 alpha:1.0];
    [self.view addSubview:segment];
    
    [items release];
}

- (void) segmentTouched:(UISegmentedControl *)sender {
    Debug(@"segment.selectedSegmentIndex = %d", segment.selectedSegmentIndex);
    if (segment.selectedSegmentIndex == 0) {
        DiaryListViewController *diaryController = [[DiaryListViewController alloc] initWithNibName:@"DiaryListViewController" bundle:nil];
        diaryController.managedObjectContext = self.managedObjectContext;
        diaryController.hidesBottomBarWhenPushed = YES;
        
        //	AddAnniversaryTableViewController *anniversaryController = [[AddAnniversaryTableViewController alloc]  initWithStyle:UITableViewStylePlain];
        //	anniversaryController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:diaryController animated:YES];
    } else if (segment.selectedSegmentIndex == 1) {
		EventListViewController *eventController = [[EventListViewController alloc] init];
        eventController.managedObjectContext = self.managedObjectContext;
        eventController.hidesBottomBarWhenPushed = YES;
        
        //	AddAnniversaryTableViewController *anniversaryController = [[AddAnniversaryTableViewController alloc]  initWithStyle:UITableViewStylePlain];
        //	anniversaryController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:eventController animated:YES];
    } else if (segment.selectedSegmentIndex == 2) {
        AddAnniversaryViewController *anniversaryController = [[AddAnniversaryViewController alloc] initWithNibName:@"AddAnniversaryViewController" bundle:nil];
        anniversaryController.hidesBottomBarWhenPushed = YES;
        
        //	AddAnniversaryTableViewController *anniversaryController = [[AddAnniversaryTableViewController alloc]  initWithStyle:UITableViewStylePlain];
        //	anniversaryController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:anniversaryController animated:YES];
    } 
    segment.selectedSegmentIndex = -1;
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)addAnniversary {
	AddAnniversaryViewController *anniversaryController = [[AddAnniversaryViewController alloc] initWithNibName:@"AddAnniversaryViewController" bundle:nil];
	anniversaryController.hidesBottomBarWhenPushed = YES;
	
	//	AddAnniversaryTableViewController *anniversaryController = [[AddAnniversaryTableViewController alloc]  initWithStyle:UITableViewStylePlain];
	//	anniversaryController.hidesBottomBarWhenPushed = YES;
	
	[self.navigationController pushViewController:anniversaryController animated:YES];
}

- (void)popupView:(CalendarButton *)dateButton {
	Debug(@"delegate popupView - dateButton.retainCount = %d", [dateButton retainCount]);
	calButton = dateButton;
	//	[dateButton release];
	Debug(@"CalendarGridViewController - dateButton.retainCount = %d", [dateButton retainCount]);
	detailView = [[CalendarDetailView alloc] initWithFrame:CGRectMake(5, 40, 305, 231) andButton:calButton];
	[self.view addSubview:detailView];
}

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
	Debug(@"dealloc");
    [super dealloc];
	[myCalendarView release];
	//	[navController release];
	[editDiaryViewController release];
	[calendarViewController release];
	[detailView release];
	[edit release];
	[calButton release];
    [segment release];
}


@end
