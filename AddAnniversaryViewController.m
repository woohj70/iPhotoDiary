//
//  AddAnniversaryViewController.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 27..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "AddAnniversaryViewController.h"
#import "EXFLogging.h"


@implementation AddAnniversaryViewController

@synthesize editButton;
@synthesize anniversaryTableView;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}



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
	label.text = @"\n기념일 List";
	self.navigationItem.titleView = label;
	
	//	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(processEdit)];
    self.navigationItem.rightBarButtonItem = editButton;
	
	//BarButtonItem의 타이틀을 변경하기 위해서는 위의 editButton처럼 initWithTitle 메서드를 이용해야 한다.
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEdit)];
    self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
	
	anniversaryTableView = [[AddAnniversaryTableViewController alloc] initWithStyle:UITableViewStylePlain];
	anniversaryTableView.view.backgroundColor = [UIColor clearColor];//colorWithRed:194/256*100 green:156/256*100 blue:1.0f alpha:0.3f];
	anniversaryTableView.view.opaque = YES;
	anniversaryTableView.delegate = self;
	anniversaryTableView.tableView.allowsSelectionDuringEditing = YES;
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"anniversary_background.png"]];
	anniversaryTableView.view.frame = CGRectMake(90, 10, 230, 450);
	[self.view addSubview:anniversaryTableView.view];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewWillAppear:(BOOL)animated {
	Debug(@"viewWillAppear");
    [super viewWillAppear:animated];
	
	[anniversaryTableView loadData];

//	[anniversaryTableView loadData];
//	[anniversaryTableView.tableView reloadData];
	//	[self loadData];
	//	Debug(@"Default = %@", [annData count]);
}

#pragma mark -
#pragma mark Cancel & Edit

- (void)processEdit {
	if (editing) {
		Debug(@"processEdit : editing = YES");
		self.editButton.title = @"Done";
//		[anniversaryTableView setEditing:YES animated:YES];
		//		self.editButton.image = [UIImage imageNamed:@"btnHome.png"];
	} else {
		Debug(@"processEdit : editing = NO");
		self.editButton.title = @"Edit";
//		[anniversaryTableView setEditing:NO animated:YES];
	}
	
	[anniversaryTableView processEdit:editing];
	
	editing = !editing;
}

- (void) cancelEdit {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark AddAnniversaryTableViewControllerDelegate

- (void)changeViewController:(AnniversaryDetailViewController *)anniversaryView {
	[self.navigationController pushViewController:anniversaryView animated:YES];
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
	[anniversaryTableView release];
    [super dealloc];
}


@end
