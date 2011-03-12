//
//  DataPickerViewController.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 20..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "DataPickerViewController.h"
#import "EXFLogging.h"


@implementation DataPickerViewController

@synthesize editedObject, datePicker, dateFormatter;
@synthesize eventCell;
@synthesize todayButton;

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
	label.text = @"\n날짜 선택";
	self.navigationItem.titleView = label;
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mainbg417.png"]];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
	
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
#pragma mark IBAction Today setting

- (IBAction)setToday {
	[datePicker setDate:[NSDate date] animated:YES];
}

#pragma mark -
#pragma mark Save & Cancel

- (void)save:(id)sender {
	if (editedObject != nil) {
		editedObject.birthDate = datePicker.date;
		editedObject.birthDay.text = [self.dateFormatter stringFromDate:datePicker.date];
	} else if (eventCell != nil) {
		eventCell.eventDate = datePicker.date;
		eventCell.valueLabel.text = [self.dateFormatter stringFromDate:datePicker.date];
	}
	
	Debug(@"selected date = %@", [self.dateFormatter stringFromDate:datePicker.date]);
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)cancel:(id)sender {
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	
	[editedObject release];
	[datePicker release];
	
	[dateFormatter release];
	[todayButton release];
}


@end
