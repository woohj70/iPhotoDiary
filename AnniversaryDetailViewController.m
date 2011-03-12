//
//  AnniversaryDetailViewController.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 28..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "AnniversaryDetailViewController.h"
#import "AnniversaryModel.h"

#import "EXFLogging.h"


@implementation AnniversaryDetailViewController

@synthesize closeViewButton;
@synthesize anniversaryDetailView;
@synthesize annData, existData;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization

    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	UIApplication *app = [UIApplication sharedApplication];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(applicationWillTerminate:)
												name :UIApplicationWillTerminateNotification
											   object:app];
	
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
	label.text = @"\n기념일 등록";
	self.navigationItem.titleView = label;
	
	closeViewButton = [[[UIBarButtonItem alloc] initWithTitle:@"취 소" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)] autorelease];
	self.navigationItem.leftBarButtonItem = closeViewButton;
	//	[closeViewButton release];
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];
	
	anniversaryDetailView = [[AnniversaryDetailTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	anniversaryDetailView.view.backgroundColor = [UIColor clearColor];//colorWithRed:194/256*100 green:156/256*100 blue:1.0f alpha:0.3f];
	anniversaryDetailView.view.opaque = YES;
	anniversaryDetailView.delegate = self;
	anniversaryDetailView.annData = self.existData;
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"anniversary_background.png"]];
	anniversaryDetailView.view.frame = CGRectMake(0, 0, 320, 460);
	[self.view addSubview:anniversaryDetailView.view];
}

- (void)viewWillAppear:(BOOL)animated {
	Debug(@"viewWillAppear");
    [super viewWillAppear:animated];
	
	EventSettingCell *cell = nil;
	
	cell = [anniversaryDetailView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
	
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *dateComponent = [cal components:unitFlags fromDate:cell.eventDate];
	cell.valueLabel.text = [NSString stringWithFormat:@"%d. %d. %d.", dateComponent.year, dateComponent.month, dateComponent.day];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
#pragma mark -
#pragma mark AnniversaryDetailTableViewControllerDelegate

- (void)moveEditView:(NSInteger)row withViewController:(AnniversaryDetailTableViewController *)addEventController andTableViewCell:(UITableViewCell *)tableViewCell {
	if (row == 0) {
		EditEventViewController *eventController = [[EditEventViewController alloc] initWithNibName:@"EditEventViewController" bundle:nil];
		eventController.settingCell = tableViewCell;
		
		[self.navigationController pushViewController:eventController animated:YES];
	} else if (row == 1) {
		DataPickerViewController *pickerViewController = [[DataPickerViewController alloc] init];
		
		pickerViewController.eventCell = tableViewCell;
		
		[self.navigationController pushViewController:pickerViewController animated:YES];
	}
}

#pragma mark -
#pragma mark Persistance File Process

- (void)loadData {
	
	NSString *filePath = [self dataFilePath];
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
		annData = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
		
		if ([annData isKindOfClass:[NSMutableDictionary class]]) {
			Debug("loadData : OK - annData.count = %d", [annData count]);
			NSArray *keys = [annData allKeys];
			
			for (NSInteger i = 0; i < [keys count]; i++) {
				Debug("loadData : OK - key[%d] = %@", i, [keys objectAtIndex:i]);
			}
		} else {
			Debug("loadData : NOT OK - class name = %@", [[annData class] name]);
		}
	}
}

- (NSString *)dataFilePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [paths objectAtIndex:0];
	return [documentDirectory stringByAppendingPathComponent:@"AnnData.plist"];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
	[self save];
}

#pragma mark -
#pragma mark Cancel & Save

- (void)save {
	[self loadData];
	
	if (self.existData != nil) {
		NSMutableDictionary *delData = [annData objectForKey:[self.existData objectForKey:@"date"]];
		[delData removeObjectForKey:[self.existData objectForKey:@"name"]];
	}
	
	EventSettingCell *cell = nil;
	NSMutableDictionary *newdata = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *newDateData = [[NSMutableDictionary alloc] init];
		
	cell = [anniversaryDetailView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	Debug("cell Value = %@", cell.valueLabel.text);
	[newdata setValue:cell.valueLabel.text forKey:@"name"];
	NSString *name = cell.valueLabel.text;
		
	cell = [anniversaryDetailView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
	Debug("cell Value = %@", cell.valueLabel.text);
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *dateComponent = [cal components:unitFlags fromDate:cell.eventDate];
	
	[newdata setValue:[NSString stringWithFormat:@"%d. %d.", dateComponent.month, dateComponent.day] forKey:@"date"];
	
//	[newdata setValue:cell.valueLabel.text forKey:@"date"];
	NSString *date = [NSString stringWithFormat:@"%d. %d.", dateComponent.month, dateComponent.day];//cell.valueLabel.text;
	
	UISwitch * sw = nil;
	cell = [anniversaryDetailView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
	
	sw = (UISwitch *)cell.accessoryView;
	if (sw.on) {
		Debug("cell Value = ON");
		[newdata setValue:@"ON" forKey:@"holy"];
	} else {
		Debug("cell Value = OFF");
		[newdata setValue:@"OFF" forKey:@"holy"];
	}
	
	cell = [anniversaryDetailView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
	
	sw = (UISwitch *)cell.accessoryView;
	if (sw.on) {
		Debug("cell Value = ON");
		[newdata setValue:@"ON" forKey:@"lunar"];
	} else {
		Debug("cell Value = OFF");
		[newdata setValue:@"OFF" forKey:@"lunar"];
	}
//	[eventData setValue:cell.eventDate forKey:@"eventdate"];
	Debug("if check : annData.count = %d", [annData count]);
	if ([annData count] > 0) {
		
		NSMutableDictionary *tempData = [annData objectForKey:date];
		Debug("save - 2222 : loadedData != nil");	
		if (tempData != nil) {
			Debug("save - 3333 : tempData != nil");
			[tempData setObject:newdata forKey:name];
			[annData setObject:tempData forKey:date];
			Debug(@"save - 3333 : end data setting");
		} else {
			Debug("save - 3333 : tempData == nil");
			[newDateData setObject:newdata forKey:name];
			Debug("save - 3333 - 1 : tempData == nil");
			[annData setObject:newDateData forKey:date];
//			NSMutableDictionary *newLoadedData = [[NSMutableDictionary alloc] initWithDictionary:loadedData];
			
//			[newLoadedData setObject:newDateData forKey:date];
			Debug("save - 3333 - 2 : tempData == nil");
		}
	} else {
		Debug("save - 2222 : loadedData == nil");
//		loadedData = [[NSMutableDictionary alloc] init];
		
		[newDateData setObject:newdata forKey:name];
		Debug("save - 2222 : end data setting : newdata.count = %d", [newdata count]);
		Debug("save - 2222 : end data setting : newDateData.count = %d", [newDateData count]);
//		[self.annData setObject:newDateData forKey:date];
		[annData setObject:@"TEST" forKey:date];
		
		if ([annData isKindOfClass:[NSMutableDictionary class]]) {
			Debug("save - 2222 : OK");
		} else {
			Debug("save - 2222 : NOT OK");
		}

		
		Debug("save - 2222 : end data setting : date = %@", date);
		Debug("save - 2222 : end data setting : annData.count = %d", [annData count]);
	}
	
	[annData writeToFile:[self dataFilePath] atomically:YES];

	[self.navigationController popViewControllerAnimated:YES];
}

- (void)cancel {
	[self.navigationController popViewControllerAnimated:YES];
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
	[closeViewButton release];
	[anniversaryDetailView release];
	[annData release];
	[existData release];
    [super dealloc];
}


@end
