//
//  AddNewChildViewController.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 13..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "AddNewChildViewController.h"
#import "EXFLogging.h"
#import "AppMainViewController.h"


@implementation AddNewChildViewController

@synthesize managedObjectContext, childBasicInfoCell, childData;
@synthesize originalImage, thumbnail, imageContext; 

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
	
	if (self = [super init]) {
//		UINavigationItem *navigationItem = self.navigationItem;
		self.managedObjectContext = managedObjectContext;
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
	label.text = @"\n아기 등록";
	self.navigationItem.titleView = label;
	//		navigationItem.title = @"아기 등록";
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mainbg417.png"]];
	
	if (childData != nil) {
		Debug(@"childData가 nil이 아니므로 화면에 출력하고 저장을 준비합니다! : %@", childData.childname);
		childViewController = [[AddChildViewController alloc] initWithStyle:UITableViewStyleGrouped withDelegate:self withManagedObjectContext:self.managedObjectContext withChildData:childData];
	} else {
		Debug(@"childData가 nil이므로 새 데이터 생성을 준비합니다!");
		childViewController = [[AddChildViewController alloc] initWithStyle:UITableViewStyleGrouped withDelegate:self withManagedObjectContext:self.managedObjectContext];
	}
	
//	childViewController.delegate = self;
	childViewController.view.backgroundColor = [UIColor clearColor];
	
//	self.view.frame = CGRectMake(0, 0, 320, 760);
	childViewController.tableView.frame = CGRectMake(0, 0, 320, 460);
	[self.view addSubview:childViewController.view];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark AddChildViewControllerDelegate

- (void)actionSheet:(ChildBasicInfoCell *)childCell {
	self.childBasicInfoCell = childCell;
	UIActionSheet *photoSelector = [[UIActionSheet alloc]
									initWithTitle:@"사진 선택" 
									delegate:self 
									cancelButtonTitle:@"취 소" 
									destructiveButtonTitle:nil 
									otherButtonTitles:@"사진 새로 찍기", @"찍은 사진 가져오기", nil];
	[photoSelector showInView:self.view];
}

- (void)endSave {
	[AppMainViewController addChildCount:1];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) movePickerView:(ChildBasicInfoCell *)basicCell {
	DataPickerViewController *pickerViewController = [[DataPickerViewController alloc] init];
	childBasicInfoCell = basicCell;
	pickerViewController.editedObject = basicCell;
	 
	
	[self.navigationController pushViewController:pickerViewController animated:YES];
}

- (void) enableSaveButton:(BOOL)enable {
	self.navigationItem.rightBarButtonItem.enabled = enable;
}

#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {		
	
	if (buttonIndex != [actionSheet cancelButtonIndex]) {
		
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		picker.allowsEditing = YES;
		picker.view.userInteractionEnabled = YES;
		
		if (buttonIndex == 0) {
			picker.sourceType = UIImagePickerControllerSourceTypeCamera;
		} else if (buttonIndex == 1) {		
			picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		}
		
		[self presentModalViewController:picker animated:YES];
		[picker release];
		Debug(@"picker release");
		
	}
	
	[actionSheet release];
	Debug(@"actionSheet release");
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
	[actionSheet release];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)selectedImage editingInfo:(NSDictionary *)editingInfo {
	Debug(@"didFinishPickingImage");
	// Delete any existing image.
//	NSManagedObject *oldImage = childData.image;
//	if (oldImage != nil) {
//		[self.managedObjectContext deleteObject:oldImage];
//	}
	
	Debug(@"Delete any existing image.");
    // Create an image object for the new image.
	imageContext = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:self.managedObjectContext];
	originalImage = selectedImage;
	
	[childBasicInfoCell.photoViewButton setBackgroundImage:selectedImage forState: UIControlStateNormal];
		
	[childBasicInfoCell.photoViewButton setTitle:@"" forState:UIControlStateNormal];
	
	
	[picker dismissModalViewControllerAnimated:YES];
	
//    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Save & Cancel
- (void)save:(id)sender {
	[childViewController save:nil withManagedObject:imageContext withImage:originalImage withDate:childBasicInfoCell.birthDate];
}

- (void)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    [super dealloc];
	
	[managedObjectContext release];
	[childBasicInfoCell release];
	[childInfoCell release];
	[childData release];
	
	[originalImage release];
	[thumbnail release]; 
	[imageContext release];
	[childViewController release];
}


@end
