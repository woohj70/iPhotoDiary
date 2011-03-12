//
//  DiaryListViewController.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 16..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "DiaryListViewController.h"


@implementation DiaryListViewController

@synthesize diaryTableView, editDiaryController, managedObjectContext;
@synthesize editing;
@synthesize conditionString;

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	Debug(@"viewDidLoad"); 
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
	label.text = @"\nDiary List";
	self.navigationItem.titleView = label;
    self.navigationItem.hidesBackButton = NO;
	
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
    
	//	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	//    UIButton *edButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 0, 40, 30)];
	//    [edButton setTitle:@"Edit" forState:UIControlStateNormal];
	//    [edButton addTarget:self action:@selector(processEdit) forControlEvents:UIControlEventTouchDown];
    
	//    edButton.backgroundColor = [UIColor redColor];
	//	UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithCustomView:edButton];
	//    self.navigationItem.leftBarButtonItem = editButton;
	//	[editButton release];
	//    [edButton release];
    
    
	//	UIBarButtonItem *rangeButton = [[UIBarButtonItem alloc] initWithTitle:@"기간선택" style:UIBarButtonItemStylePlain target:self action:@selector(setConditionStringYM)];
	//    self.navigationItem.rightBarButtonItem = rangeButton;
	//	[rangeButton release];
	
	//BarButtonItem의 타이틀을 변경하기 위해서는 위의 editButton처럼 initWithTitle 메서드를 이용해야 한다.
	//	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDiary)];
	//    self.navigationItem.leftBarButtonItem = addButton;
	//    [addButton release];
	
	diaryTableView = [[DiaryListTableViewController alloc] initWithStyle:UITableViewStylePlain withManagedObjectContext:self.managedObjectContext andCondition:nil];
	diaryTableView.view.backgroundColor = [UIColor clearColor];//colorWithRed:194/256*100 green:156/256*100 blue:1.0f alpha:0.3f];
	diaryTableView.view.opaque = YES;
	diaryTableView.delegate = self;
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"diarylist_background.png"]];
	diaryTableView.view.frame = CGRectMake(90, 10, 230, 350);
	[self.view addSubview:diaryTableView.view];
	
	Debug(@"DiaryListViewController : viewDidLoad - before button set");
	
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
	
	Debug(@"DiaryListViewController : viewDidLoad");
	//	[diaryTableView release];
}

/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 Debug(@"DiaryListViewController : viewWillAppear");
 
 //	if (self.conditionString != nil) {
 //		[self loadNewTableView:conditionString];
 //	} else {
 //		[self loadNewTableView:nil];
 //	}
 
 }
 */

- (void) segmentTouched:(UISegmentedControl *)sender {
    Debug(@"sender.selectedSegmentIndex = %d", sender.selectedSegmentIndex);
    if(sender.selectedSegmentIndex == 0) {
        [self processEdit:sender];
    } else if(sender.selectedSegmentIndex == 1) {
        [self addDiary];
    }
    sender.selectedSegmentIndex = -1;
}

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

- (void)reloadTableView:(NSString *)condition {
	Debug(@"loadNewTableView");
	Debug(@"self.conditionString != nil");
	
	if (diaryTableView != nil) {
		[diaryTableView.tableView beginUpdates];
		[diaryTableView.tableView reloadData];
		[diaryTableView.tableView endUpdates];
	} else {
		[self loadNewTableView:condition];
	}
	
}

#pragma mark -
#pragma mark YearMonthPickerViewControllerDelegate

- (void)loadNewTableView:(NSString *)condition {
	Debug(@"setConditionString");
	
	[diaryTableView.view removeFromSuperview];
	
	diaryTableView = [[DiaryListTableViewController alloc] initWithStyle:UITableViewStylePlain withManagedObjectContext:self.managedObjectContext andCondition:condition];
	diaryTableView.view.backgroundColor = [UIColor clearColor];//colorWithRed:194/256*100 green:156/256*100 blue:1.0f alpha:0.3f];
	diaryTableView.view.opaque = YES;
	diaryTableView.delegate = self;
	
	diaryTableView.view.frame = CGRectMake(90, 10, 230, 395);
	[self.view addSubview:diaryTableView.view];
	
	//	[self loadNewTableView:condition];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */
#pragma mark -
#pragma mark Cancel & Edit

- (void)processEdit:(UISegmentedControl *)segment {
	if (editing) {
		Debug(@"processEdit : editing = YES");
        [segment setTitle:@"Done" forSegmentAtIndex:0];
		//		self.navigationItem.leftBarButtonItem.title = @"Done";
		//		self.editButton.image = [UIImage imageNamed:@"btnHome.png"];
	} else {
		Debug(@"processEdit : editing = NO");
        [segment setTitle:@"Edit" forSegmentAtIndex:0];
        
		//		self.navigationItem.leftBarButtonItem.title = @"Edit";
	}
	
	[diaryTableView processEdit:editing];
    segment.selectedSegmentIndex = -1;
	editing = !editing;
}

- (void) addDiary {
    EditDiaryViewController *editDiaryViewController = [[EditDiaryViewController alloc] initWithNibName:@"EditDiaryViewController" bundle:nil];
    //	[calendarViewController hideTabBar];
    //	[self.navigationController presentModalViewController:editDiaryViewController animated:YES];
	editDiaryViewController.managedObjectContext = self.managedObjectContext;
	editDiaryViewController.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:editDiaryViewController animated:YES];
    //	[editDiaryViewController release];
}

- (void) cancelEdit {
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark DiaryListTableViewControllerDelegate

- (void)changeViewController:(EditDiaryViewController *)editDiaryController {
	Debug(@"changeViewController");
	editDiaryController.hidesBottomBarWhenPushed = YES;
	editDiaryController.delegate = self;
	[self.navigationController pushViewController:editDiaryController animated:YES];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	Debug(@"viewDidUnload");
	//	self.diaryTableView = nil;
	self.editDiaryController = nil;
	self.managedObjectContext = nil;
	self.conditionString = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[diaryTableView release];
	[editDiaryController release]; 
	[managedObjectContext release];
	[conditionString release];
	
    [super dealloc];
}


@end
