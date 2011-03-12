    //
//  DiaryViewController.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 4. 23..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "CalendarViewController.h"


@implementation CalendarViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		        // Custom initialization
    }
    return self;
}
*/

/*
- (id) init {
	NSLog(@"init Start");
	if (self = [super init]) {
		edit = [[[UIBarButtonItem alloc] initWithTitle:@"일기 쓰기" style:UIBarButtonItemStylePlain target:self action:@selector(viewChange)] autorelease];
		navController.navigationItem.rightBarButtonItem = edit;
	}
	
	return self;
}
*/

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
	label.text = @"\nCalendar";
	self.navigationItem.titleView = label;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
//	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mainbg.png"]];
	
	calendarGridViewController = [[CalendarGridViewController alloc] init];
	editDiaryViewController = [[EditDiaryViewController alloc] init];

	[calendarGridViewController setCalendarViewController:self];
	[editDiaryViewController setCalendarViewController:self];
	
//	[self hideTabBar];
//	navController = [[UINavigationController alloc] initWithRootViewController:calendarGridViewController];
//	navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	
//	[self.view addSubview:navController.view];
	
}


- (void)hideTabBar {
	NSLog(@"hideTabBar");
	self.tabBarController.tabBar.hidden = YES;
	self.tabBarController.view.frame = CGRectMake(0,0,320,528);
	[self.tabBarController.tabBar setFrame:CGRectMake(0,528,0,0)];
}

- (void)viewTabBar {
	NSLog(@"viewTabBar");
	self.tabBarController.tabBar.hidden = NO;
	self.tabBarController.view.frame = CGRectMake(0,0,320,480);
	[self.tabBarController.tabBar setFrame:CGRectMake(0,431,320,49)];
}


/*
 Calendar Delegate implementation 

- (void)didChangeMonths {
}
 */

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mainbg.png"]];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
//	[myCalendarView release];
    [super dealloc];
	[navController release];
	[editDiaryViewController release];
	[calendarGridViewController release];
}


@end
