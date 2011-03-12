//
//  EditEventViewController.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 25..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "EditEventViewController.h"


@implementation EditEventViewController

@synthesize contentView, titleField;
@synthesize settingCell;
@synthesize title;
@synthesize closeViewButton;

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
	label.text = [NSString stringWithFormat:@"\n%@ 입력", settingCell.titleLabel.text];
	self.navigationItem.titleView = label;
	
	closeViewButton = [[[UIBarButtonItem alloc] initWithTitle:@"취 소" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)] autorelease];
	self.navigationItem.leftBarButtonItem = closeViewButton;
	//	[closeViewButton release];
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];

}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
	//이름을 체크하는 것은 기념일 등록에서도 같이 사용하기 위함임
	if (settingCell.titleLabel.text == @"제목 : " || settingCell.titleLabel.text == @"기념일 : " ) {
		titleField.hidden = NO;
		contentView.hidden = YES;
		[titleField becomeFirstResponder];
	} else {
		titleField.hidden = YES;
		contentView.hidden = NO;
		[contentView becomeFirstResponder];
	}
}


#pragma mark -
#pragma mark Cancel & Save

- (void)save {
	if (settingCell.titleLabel.text == @"제목 : " || settingCell.titleLabel.text == @"기념일 : ") {
		settingCell.valueLabel.text = titleField.text;
	} else {
		settingCell.valueLabel.text = contentView.text;
	}
	
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
	[contentView release];
	[titleField release];
	[settingCell release];
	[title release];
	[closeViewButton release];
    [super dealloc];
}


@end
