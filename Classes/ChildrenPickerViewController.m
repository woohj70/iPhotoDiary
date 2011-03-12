//
//  ChildrenPickerViewController.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 25..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "ChildrenPickerViewController.h"


@implementation ChildrenPickerViewController

@synthesize childrenPicker;
@synthesize closeViewButton;
@synthesize settingCell;
@synthesize pickerData;
@synthesize delegate;

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
	label.text = @"\n아이 선택";
	self.navigationItem.titleView = label;
	
	closeViewButton = [[[UIBarButtonItem alloc] initWithTitle:@"취 소" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)] autorelease];
	self.navigationItem.leftBarButtonItem = closeViewButton;
	//	[closeViewButton release];
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];
	
}

- (void)viewWillAppear:(BOOL)animated {
	Debug(@"viewWillAppear : [AppMainViewController childrenArray] = %@", [AppMainViewController childrenArray]);
//	Debug(@"viewWillAppear : [AppMainViewController childrenArray] count = %d", [[AppMainViewController childrenArray] count]);
	self.pickerData = [AppMainViewController childrenArray];
}

#pragma mark -
#pragma mark Cancel & Save

- (void)save {
//	settingCell.valueLabel.text = childrenPicker.;
	NSInteger row = [childrenPicker selectedRowInComponent:0];
	settingCell.valueLabel.text = [pickerData objectAtIndex:row];
	[delegate setChangedChild:[pickerData objectAtIndex:row]];
	
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)cancel {
	[self.navigationController popViewControllerAnimated:YES];
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark Picker Data Source Method

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	Debug(@"ChildrenPickerViewController : %@", pickerData);
	Debug(@"numberOfRowsInComponent : [pickerData count] = %d", [pickerData count]);
	return [pickerData count];
}

#pragma mark Picker Delegate Method

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [pickerData objectAtIndex:row];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    
	
	self.childrenPicker = nil;
	self.pickerData = nil;
	
	[super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[childrenPicker release];
	[closeViewButton release];
	[settingCell release];
	[pickerData release];
    [super dealloc];
}


@end
