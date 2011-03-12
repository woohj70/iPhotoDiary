//
//  ChildListViewController.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 17..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "ChildListViewController.h"
#import "EXFLogging.h"


@implementation ChildListViewController

@synthesize childTableView, dataArr, managedObjectContext, editButton;
@synthesize editing;

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
	if(self = [super init]) {
		self.managedObjectContext = managedObjectContext;
		editing = YES;
	}
	
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
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
	label.text = @"\nEdit Children";
	self.navigationItem.titleView = label;
	
//	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(processEdit)];
    self.navigationItem.rightBarButtonItem = editButton;
//	[editButton release];
	
	//BarButtonItem의 타이틀을 변경하기 위해서는 위의 editButton처럼 initWithTitle 메서드를 이용해야 한다.
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEdit)];
    self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"children_background.png"]];
	
	childTableView = [[ChildListTableViewController alloc] initWithStyle:UITableViewStylePlain withManagedObjectContext:self.managedObjectContext];
	childTableView.view.backgroundColor = [UIColor clearColor];
	childTableView.delegate = self;
	
	childTableView.view.frame = CGRectMake(90, 10, 230, 450);
	[self.view addSubview:childTableView.view];
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

- (void)processEdit {
	if (editing) {
		Debug(@"processEdit : editing = YES");
		self.editButton.title = @"Done";
//		self.editButton.image = [UIImage imageNamed:@"btnHome.png"];
	} else {
		Debug(@"processEdit : editing = NO");
		self.editButton.title = @"Edit";
	}
	
	[childTableView processEdit:editing];
	editing = !editing;
}

- (void) cancelEdit {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark ChildListTableViewControllerDelegate

- (void)changeViewController:(AddNewChildViewController *)addChildView {
	[self.navigationController pushViewController:addChildView animated:YES];
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
    [super dealloc];
	[childTableView release];
	[dataArr release]; 
	[managedObjectContext release];
	[editButton release];
}


@end
