//
//  YearMonthPickerViewController.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 7. 4..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "YearMonthPickerViewController.h"
#import "EXFLogging.h"


@implementation YearMonthPickerViewController

@synthesize doublePicker;
@synthesize yearsArray;
@synthesize monthsArray;
@synthesize returnValue;
@synthesize mode;
@synthesize todayButto;
@synthesize delegate;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withMode:(NSString *)mode {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		Debug(@"Initialize : mode = %@", mode);
		self.mode = mode;
		
		unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
		NSCalendar *cal = [NSCalendar currentCalendar];
		NSDateComponents *dateComponent = [cal components:unitFlags fromDate:[NSDate date]];
		
		if ([self.mode isEqualToString:@"YM"]) {
			Debug(@"1111");
			NSArray *monthsArr = [[NSArray alloc] initWithObjects:@"01월",@"02월",@"03월",@"04월",@"05월",@"06월",@"07월",@"08월",@"09월",@"10월",@"11월",@"12월",nil];
			self.monthsArray = monthsArr;
			[doublePicker selectRow:dateComponent.month - 1 inComponent:MONTH_COMPONENT animated:YES];
			[monthsArr release];
		}
		
		Debug(@"2222");
		NSMutableArray *yearsArr = [[NSMutableArray alloc] init];
		
		NSInteger rowcnt = 0;
		for(NSInteger i = 1970; i <= 2100; i++) {
			[yearsArr addObject:[NSString stringWithFormat:@"%d년", i]];
			
			if (dateComponent.year == i) {
				[doublePicker selectRow:rowcnt inComponent:YEAR_COMPONENT animated:YES];
			}
			
			rowcnt++;
		}
		Debug(@"3333");
		self.yearsArray = yearsArr;
		Debug(@"4444 : self.yearsArray.count = %d", [self.yearsArray count]);
		[yearsArr release];
		Debug(@"5555 : self.yearsArray.count = %d", [self.yearsArray count]);
		
		
		Debug(@"6666");
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
	label.text = @"\n기간 선택";
	self.navigationItem.titleView = label;
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mainbg417.png"]];
	
	[self setToday];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark SAVE & CANCEL
								
- (void)save:(id)sender {
	if ([mode isEqualToString:@"YM"]) {
		NSInteger monthRow = [doublePicker selectedRowInComponent:MONTH_COMPONENT];
		NSInteger yearRow = [doublePicker selectedRowInComponent:YEAR_COMPONENT];
		
		NSString *month = [monthsArray objectAtIndex:monthRow];
		NSString *year = [yearsArray objectAtIndex:yearRow];
		
		returnValue = [NSString stringWithFormat:@"%@ %@", year, month];
	} else {
		NSInteger yearRow = [doublePicker selectedRowInComponent:YEAR_COMPONENT];
		NSString *year = [yearsArray objectAtIndex:yearRow];
		
		returnValue = [NSString stringWithFormat:@"%@", year];
	}

	[delegate loadNewTableView:returnValue];
	
	[self.navigationController popViewControllerAnimated:YES];
}
								
- (void)cancel:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UIPickerViewDelegate								

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	
	if ([mode isEqualToString:@"YM"]) {
		if (component == MONTH_COMPONENT) {
			Debug(@"titleForRow : YM : M : %@ : row = %d", [self.monthsArray objectAtIndex:row], row);
			return [self.monthsArray objectAtIndex:row];
		} else if (component == YEAR_COMPONENT) {
			Debug(@"titleForRow : YM : Y : %@ : row = %d", [self.yearsArray objectAtIndex:row], row);
			return [self.yearsArray objectAtIndex:row];
		}
	} else {
		if (component == YEAR_COMPONENT) {
			Debug(@"titleForRow : Y : Y : %@ : row = %d", [self.yearsArray objectAtIndex:row], row);
			return [self.yearsArray objectAtIndex:row];
		}
	}

}

#pragma mark -
#pragma mark UIPickerViewDataSource
								
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	Debug(@"numberOfComponentsInPickerView : %@", mode);
	if ([mode isEqualToString:@"YM"]) {
		return 2;
	} else {
		return 1;
	}

}
								
							
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if ([mode isEqualToString:@"YM"]) {
		if (component == MONTH_COMPONENT) {
			Debug(@"numberOfRowsInComponent : YM : M : %d", [self.monthsArray count]);
			return [self.monthsArray count];
		} else if (component == YEAR_COMPONENT) {
			Debug(@"numberOfRowsInComponent : YM : Y : %d", [self.yearsArray count]);
			return [self.yearsArray count];
		}
	} else {
		if (component == YEAR_COMPONENT) {
			Debug(@"numberOfRowsInComponent : Y : Y : %d", [self.yearsArray count]);
			return [self.yearsArray count];
		}
	}

}

#pragma mark -
#pragma mark IBAction Today setting

- (IBAction)setToday {
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *dateComponent = [cal components:unitFlags fromDate:[NSDate date]];
	
	for(NSInteger i = 0; i < [yearsArray count]; i++) {
		if (dateComponent.year == [[yearsArray objectAtIndex:i] integerValue]) {
			[doublePicker selectRow:i inComponent:YEAR_COMPONENT animated:YES];
			[doublePicker reloadComponent:YEAR_COMPONENT];
		}
	}
	
	if ([mode isEqualToString:@"YM"]) { 
		[doublePicker selectRow:dateComponent.month - 1 inComponent:MONTH_COMPONENT animated:YES];
		[doublePicker reloadComponent:MONTH_COMPONENT];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.doublePicker = nil;
	self.yearsArray = nil;
	self.monthsArray = nil;
	self.returnValue = nil;
	self.mode = nil;
	self.todayButto = nil;
	
	[super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[doublePicker release];
	[yearsArray release];
	[monthsArray release];
	[returnValue release];
	[mode release];
	[todayButto release];
    [super dealloc];
}


@end
