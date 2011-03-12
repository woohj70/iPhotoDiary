//
//  AddChildViewController.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 5. 31..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "AddChildViewController.h"
#import "EXFLogging.h"

@implementation AddChildViewController
#define BASIC_SECTION 0
#define BODY_SECTION 1
#define BORN_SECTION 2

@synthesize childData, delegate, managedObjectContext;
@synthesize childInfoCell, childBasicInfoCell, childGenderCell;
@synthesize cellTitle1, cellTitle2;
@synthesize dateFormatter;

#pragma mark -
#pragma mark View lifecycle
/*
- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        UINavigationItem *navigationItem = self.navigationItem;
        navigationItem.title = @"아기 등록";
		
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        self.navigationItem.leftBarButtonItem = cancelButton;
        [cancelButton release];
		
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
        self.navigationItem.rightBarButtonItem = saveButton;
        [saveButton release];
    }
    return self;
}
*/
- (id)initWithStyle:(UITableViewStyle)style withDelegate:(id)delegate withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    if (self = [super initWithStyle:style]) {
	
		
		self.delegate = delegate;
		self.managedObjectContext = managedObjectContext;

		keyboardShown = NO;
		[self registerForKeyboardNotifications];
		self.tableView.scrollEnabled = NO;
		
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style withDelegate:(id)delegate withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext withChildData:(ChildData *)childData {
    if (self = [super initWithStyle:style]) {
		self.delegate = delegate;
		self.managedObjectContext = managedObjectContext;
		self.childData = childData;
		
		keyboardShown = NO;
		[self registerForKeyboardNotifications];
		self.tableView.scrollEnabled = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (childData != nil) {
		Debug(@"prepareUpdate : childData가 nil이 아니므로 화면에 출력하고 저장을 준비합니다! : %@", childData.childname);
	} else {
		Debug(@"prepareUpdate : childData가 nil이므로 새 데이터 생성을 준비합니다!");
	}
	
	self.cellTitle1 = (NSArray *)[NSArray arrayWithObjects:@"키 : ", @"몸무게 : ", nil];
	self.cellTitle2 = (NSArray *)[NSArray arrayWithObjects:@"주민번호 : ", @"출생지 : ", @"성별 : ", nil];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	Debug(@"viewWillAppear");
}
*/

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark Keyboard Notification
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasShown:)
												 name:UIKeyboardDidShowNotification object:nil];
	
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasHidden:)
												 name:UIKeyboardDidHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
	Debug(@"keyboardWasShown");
	[delegate enableSaveButton:NO];
	
	 if (keyboardShown)
	 return;
	
	

    keyboardShown = YES;
}


// Called when the UIKeyboardDidHideNotification is sent
- (void)keyboardWasHidden:(NSNotification*)aNotification
{
    // Reset the height of the scroll view to its original value
	self.tableView.frame = CGRectMake(0.0, 0.0, 320.0, 460);
	[self.tableView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
	
    keyboardShown = NO;
	[delegate enableSaveButton:YES];
	Debug(@"keyboardWasHidden");
}

#pragma mark -
#pragma mark ChildInfoCellDelegate

- (void)scrollNewPosition:(UITableViewCell *)cell {
	Debug(@"scrollNewPosition : section = %d, row = %d", [self.tableView indexPathForCell:cell].section, [self.tableView indexPathForCell:cell].row);
	
	self.tableView.frame = CGRectMake(0.0, 0.0, 320.0, 460 - 216 - 44);
	[self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	self.tableView.scrollEnabled = NO;
}

#pragma mark -
#pragma mark ChildBasicInfoCellDelegate

- (void) movePickerView:(ChildBasicInfoCell *)basicCell {
	[delegate movePickerView:basicCell];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSInteger rows = 0;
    
    /*
     The number of rows depends on the section.
     In the case of ingredients, if editing, add a row in editing mode to present an "Add Ingredient" cell.
	 */
    switch (section) {
        case BASIC_SECTION:
			rows = 1;
			break;
        case BODY_SECTION:
            rows = 2;
            break;
        case BORN_SECTION:
			rows = 3;

          break;
		default:
            break;
    }
    return rows;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	Debug(@"cellForRowAtIndexPath : section = %d", indexPath.section);
	if (indexPath.section == BASIC_SECTION) {
		static NSString *CellIdentifier = @"ChildBasicInfo";
    
		ChildBasicInfoCell *cell = (ChildBasicInfoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) {
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChildBasicInfoCell" owner:self options:nil];
			
			for (id oneObject in nib) {
				if ([oneObject isKindOfClass:[ChildBasicInfoCell class]]) {
					cell = (ChildBasicInfoCell *) oneObject;
//					cell.backgroundColor = [UIColor whiteColor];
					cell.delegate = self;
					
					if (childData != nil) {
						cell.nameField.text = childData.childname;
//						cell.nickName.text = childData.nickname;
						cell.birthDay.text = [self.dateFormatter stringFromDate:childData.birthday];
						cell.birthDate = childData.birthday;
						cell.isLunar.selectedSegmentIndex = [[childData valueForKey:@"islunar"] integerValue];
						
						CGSize size = childData.thumbnailImage.size;
						CGFloat ratio = 0;
						if (size.width > size.height) {
							ratio = 116.0 / size.width;
						} else {
							ratio = 116.0 / size.height;
						}
						CGRect rect = CGRectMake(0.0, 0.0, ratio * size.width, ratio * size.height);
						
						UIGraphicsBeginImageContext(rect.size);
						[childData.thumbnailImage drawInRect:rect];					
						[cell.photoViewButton setImage:UIGraphicsGetImageFromCurrentImageContext() forState:UIControlStateNormal];
						UIGraphicsEndImageContext();
					}
					
					childBasicInfoCell = cell;
				}
			}
//			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		
		return cell;
	} else {
		if (indexPath.section == BORN_SECTION && indexPath.row == 2) {
			static NSString *CellIdentifier = @"childGenderInfo";
			
			ChildGenderInfoCell *cell = (ChildGenderInfoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			
			if (cell == nil) {
				NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChildGenderInfoCell" owner:self options:nil];
				
				//			NSInteger i = 0;
				for (id oneObject in nib) {
					if ([oneObject isKindOfClass:[ChildGenderInfoCell class]]) {
						Debug(@"cell = ChildGenderInfoCell");
						cell = (ChildGenderInfoCell *) oneObject;
						cell.delegate = self;
						cell.labelField.text = @"";
					}
				}
			}
			
			cell.labelField.text = [self.cellTitle2 objectAtIndex:indexPath.row];		
						
			if (childData != nil) {
				Debug("childData.gender = %d", [[childData valueForKey:@"gender"] integerValue]);
						
				cell.genderControl.selectedSegmentIndex = [[childData valueForKey:@"gender"] integerValue];	
			}
			
			return cell;
		} else {
			static NSString *CellIdentifier = @"ChildInfo";
			
			ChildInfoCell *cell = (ChildInfoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			
			if (cell == nil) {
//				cell = [[[ChildInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
				NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChildInfoCell" owner:self options:nil];
				
				//			NSInteger i = 0;
//				for (id oneObject in nib) {
				for (NSInteger i = 0; i < [nib count]; i++) {
					id oneObject = [nib objectAtIndex:i];
					if ([oneObject isKindOfClass:[ChildInfoCell class]]) {
						Debug(@"cell = ChildInfoCell");
						cell = (ChildInfoCell *) oneObject;		
						cell.delegate = self;
						cell.labelField.text = @"";
						cell.valueField.text = @"";
						//					cell.backgroundColor = [UIColor whiteColor];
					}
				}
			}
			
			
			if (indexPath.section == BODY_SECTION) {
				Debug(@"cellTitle1 : section = %d, row = %d, title = %@", indexPath.section, indexPath.row, [self.cellTitle1 objectAtIndex:indexPath.row]);
				cell.labelField.text = [self.cellTitle1 objectAtIndex:indexPath.row];
			} else {
				Debug(@"cellTitle1 : section = %d, row = %d, title = %@", indexPath.section, indexPath.row, [self.cellTitle2 objectAtIndex:indexPath.row]);
				cell.labelField.text = [self.cellTitle2 objectAtIndex:indexPath.row];		
			}
			
			
			if (childData != nil) {
				if (indexPath.section == BODY_SECTION) {
					if (indexPath.row == 0) {
						cell.valueField.text = [childData.height stringValue];
					} else if (indexPath.row == 1) {
						cell.valueField.text = [childData.weight stringValue];
					}
					
				} else {
					if (indexPath.row == 0) {
						cell.valueField.text = childData.idnum;
					} else if (indexPath.row == 1) {
						cell.valueField.text = childData.location;
					}
				}
				
			}

			
			if (indexPath.section == BODY_SECTION || (indexPath.section == BORN_SECTION && indexPath.row == 0)) {
				cell.valueField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
			} else {
				cell.valueField.keyboardType = UIKeyboardTypeDefault;
			}

			
			return cell;
		}

		
	}	
    
    // Configure the cell...
    
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	
//	ChildInfoCell *cell = (ChildInfoCell *)[tableView cellForRowAtIndexPath:indexPath];
//	Debug(@"didSelectRowAtIndexPath : section = %d, row = %d", indexPath.section, indexPath.row);
//	[cell release];
//	[tView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark -
#pragma mark TableViewCell Height

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == BASIC_SECTION) {
		return 120.0f;
	} else {
		return 44.0f;
	}

}


#pragma mark -
#pragma mark ChildBasicInfoCellDelegate
- (void)showActionSheet {
	Debug(@"showActionSheet");
	[self.delegate actionSheet:childBasicInfoCell];
	//	[photoSelector release];
}

#pragma mark -
#pragma mark Update

- (void)prepareUpdate:(ChildData *)childData {

}

#pragma mark -
#pragma mark Save & Cancel
- (void)save:(id)sender withManagedObject:(NSManagedObject *)imageContext withImage:(UIImage *)originalImage withDate:(NSDate *)birthDate {
	Debug(@"AddChildViewController.save - 1111");
	NSManagedObjectContext *context = self.managedObjectContext;//[childData managedObjectContext];
	Debug(@"AddChildViewController.save - 2222");
	
	if (self.managedObjectContext == nil) {
		Debug(@"self.managedObjectContext = nil");
	} else {
		Debug(@"self.managedObjectContext != nil");
	}
	 
	/*
	 If there isn't an ingredient object, create and configure one.
	 */
	
	NSDate *prevBirth = nil;
    if (!childData) {
		Debug(@"AddChildViewController.save - ChildData is nil");
        childData = (ChildData *)[NSEntityDescription insertNewObjectForEntityForName:@"ChildData" inManagedObjectContext:self.managedObjectContext];
		//        [self.delegate saveChild:childData];
//		childData.displayOrder = [NSNumber numberWithInteger:[recipe.ingredients count]];
		prevBirth = birthDate;
    } else {
		prevBirth = childData.birthday;
	}


	if (birthDate != nil) {
		childData.birthday = birthDate;
	}
	
	NSCalendar *sysCalendar = [NSCalendar currentCalendar];
	unsigned unitFlags2 = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
	NSDateComponents *dateComponent = [sysCalendar components:unitFlags2 fromDate:childData.birthday];
	NSDateComponents *prevDateComponent = [sysCalendar components:unitFlags2 fromDate:prevBirth];
	NSString *prevBirthStr = [NSString stringWithFormat:@"%d. %d.", prevDateComponent.month, prevDateComponent.day];
	
	
	//	[newdata setValue:[NSString stringWithFormat:@"%d. %d.", dateComponent.month, dateComponent.day] forKey:@"date"];
	
	KLCalendarModel *calModel = [[KLCalendarModel alloc] init];
	BOOL isleaf = ((dateComponent.year % 4 == 0) && (dateComponent.year % 100 != 0)) || (dateComponent.year % 400 == 0);
	
	NSString *dolDateStr = nil;
	NSString *hundredDateStr = nil;
	NSString *mStr = nil;
	NSString *dStr = nil;
	NSString *birthStr = [NSString stringWithFormat:@"%d. %d.", dateComponent.month, dateComponent.day];
	
	if ([[childData valueForKey:@"islunar"] integerValue] == 1) {
		MCLunarDate *lunarDate = [calModel sol2lunYear:dateComponent.year Month:dateComponent.month Day:dateComponent.day];
		childData.birthdaySolar = [NSString stringWithFormat:@"%d. %d. %d.", dateComponent.year, dateComponent.month, dateComponent.day];
		childData.birthdayLunar = [NSString stringWithFormat:@"%d. %d. %d.", lunarDate.yearLunar, lunarDate.lunarMonth, lunarDate.lunarDay];
		
		dolDateStr = [NSString stringWithFormat:@"%d-%d-%d", dateComponent.year + 1, dateComponent.month, dateComponent.day];
		hundredDateStr = [NSString stringWithFormat:@"%d-%d-%d", dateComponent.year, dateComponent.month, dateComponent.day];
	} else {
		MCSolarDate *solarDate = [calModel lun2solYear:dateComponent.year Month:dateComponent.month Day:dateComponent.day Leaf:isleaf];
		childData.birthdayLunar = [NSString stringWithFormat:@"%d. %d. %d.", dateComponent.year, dateComponent.month, dateComponent.day];
		childData.birthdaySolar = [NSString stringWithFormat:@"%d. %d. %d.", solarDate.year, solarDate.month, solarDate.day];
		hundredDateStr = [NSString stringWithFormat:@"%d-%d-%d", solarDate.year, solarDate.month, solarDate.day];
		
		MCSolarDate *solarDate2 = [calModel lun2solYear:dateComponent.year+1 Month:dateComponent.month Day:dateComponent.day Leaf:isleaf];
		dolDateStr = [NSString stringWithFormat:@"%d-%d-%d", solarDate2.year, solarDate2.month, solarDate2.day];
	}
	
	
	ChildBasicInfoCell *bcell = nil;
    bcell = (ChildBasicInfoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	Debug("save : bcell.nameField.text = %@", bcell.nameField.text);
    childData.childname = bcell.nameField.text;
	Debug("save :bcell.isLunar.selectedSegmentIndex = %d", bcell.isLunar.selectedSegmentIndex);
	childData.islunar = [[[NSNumber alloc] initWithInt:bcell.isLunar.selectedSegmentIndex] autorelease];

	EventData *eventData = nil;
	NSInteger hundredOrDol = 0;
	
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	NSDate *eventDate = nil;
	NSString *evename = nil;
	
	if (!childData) {
		eventData = (EventData *)[NSEntityDescription insertNewObjectForEntityForName:@"EventData" inManagedObjectContext:self.managedObjectContext];
	} else {
		NSSet *eventSet = [childData valueForKey:@"events"];
		NSArray *eventArr = [eventSet allObjects];
		NSInteger cnt = 0;
		for (EventData *eData in eventArr) {
			cnt++;
			Debug(@"cnt = %d, [eData valueForKey:@'childname'] = %@, [eData valueForKey:@'eventname'] = %@", cnt, [eData valueForKey:@"childname"], [eData valueForKey:@"eventname"]);
			if ([[eData valueForKey:@"childname"] isEqualToString:childData.childname] && [[eData valueForKey:@"eventname"] isEqualToString:[NSString stringWithFormat:@"%@ 백일", childData.childname]]) {
				eventData = eData;
				[outputFormatter setDateFormat:@"yyyy-M-d"];
				eventDate = [NSDate dateWithTimeInterval:60*60*24*99 sinceDate:[outputFormatter dateFromString:hundredDateStr]];
				Debug(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>hundredDateStr = %@", hundredDateStr);
				Debug(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>eventDate = %@", eventDate);
				evename = [NSString stringWithFormat:@"%@ 백일", childData.childname];
				
				[eventData setValue:evename forKey:@"eventname"];
				[eventData setValue:@"" forKey:@"eventmemo"];
				[eventData setValue:childData.childname forKey:@"childname"];
				
				[outputFormatter setDateFormat:@"yyyy. M. d."];
				[eventData setValue:[outputFormatter stringFromDate:eventDate] forKey:@"conditionDate"];
				[eventData setValue:eventDate forKey:@"eventdate"];
				
				[outputFormatter setDateFormat:@"yyyy'년' MM'월'"];
				[eventData setValue:[outputFormatter stringFromDate:eventDate] forKey:@"sectionDate"];
				[eventData setValue:childData forKey:@"child"];
			} else if ([[eData valueForKey:@"childname"] isEqualToString:childData.childname] && [[eData valueForKey:@"eventname"] isEqualToString:[NSString stringWithFormat:@"%@ 첫돌", childData.childname]]) {
				eventData = eData;
				[outputFormatter setDateFormat:@"yyyy-M-d"];
				eventDate = [outputFormatter dateFromString:dolDateStr];
				Debug(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>dolDateStr = %@", dolDateStr);
				Debug(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>eventDate = %@", eventDate);
				evename = [NSString stringWithFormat:@"%@ 첫돌", childData.childname];
				
				[eventData setValue:evename forKey:@"eventname"];
				[eventData setValue:@"" forKey:@"eventmemo"];
				[eventData setValue:childData.childname forKey:@"childname"];
				
				[outputFormatter setDateFormat:@"yyyy. M. d."];
				[eventData setValue:[outputFormatter stringFromDate:eventDate] forKey:@"conditionDate"];
				[eventData setValue:eventDate forKey:@"eventdate"];
				
				[outputFormatter setDateFormat:@"yyyy'년' MM'월'"];
				[eventData setValue:[outputFormatter stringFromDate:eventDate] forKey:@"sectionDate"];
				[eventData setValue:childData forKey:@"child"];
			}
		}
	}
																								  
	if (eventData == nil) {
		eventData = (EventData *)[NSEntityDescription insertNewObjectForEntityForName:@"EventData" inManagedObjectContext:self.managedObjectContext];
		
		[outputFormatter setDateFormat:@"yyyy-M-d"];
		eventDate = [NSDate dateWithTimeInterval:60*60*24*99 sinceDate:[outputFormatter dateFromString:hundredDateStr]];
		Debug(@"nil>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>hundredDateStr = %@", hundredDateStr);
		Debug(@"nil>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>eventDate = %@", eventDate);
		evename = [NSString stringWithFormat:@"%@ 백일", childData.childname];
		
		[eventData setValue:evename forKey:@"eventname"];
		[eventData setValue:@"" forKey:@"eventmemo"];
		[eventData setValue:childData.childname forKey:@"childname"];
		
		[outputFormatter setDateFormat:@"yyyy. M. d."];
		[eventData setValue:[outputFormatter stringFromDate:eventDate] forKey:@"conditionDate"];
		[eventData setValue:eventDate forKey:@"eventdate"];
		
		[outputFormatter setDateFormat:@"yyyy'년' MM'월'"];
		[eventData setValue:[outputFormatter stringFromDate:eventDate] forKey:@"sectionDate"];
		[eventData setValue:childData forKey:@"child"];
		
		eventData = (EventData *)[NSEntityDescription insertNewObjectForEntityForName:@"EventData" inManagedObjectContext:self.managedObjectContext];
		[outputFormatter setDateFormat:@"yyyy-M-d"];
		eventDate = [outputFormatter dateFromString:dolDateStr];
		Debug(@"nil>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>dolDateStr = %@", dolDateStr);
		Debug(@"nil>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>eventDate = %@", eventDate);
		evename = [NSString stringWithFormat:@"%@ 첫돌", childData.childname];
		
		[eventData setValue:evename forKey:@"eventname"];
		[eventData setValue:@"" forKey:@"eventmemo"];
		[eventData setValue:childData.childname forKey:@"childname"];
		
		[outputFormatter setDateFormat:@"yyyy. M. d."];
		[eventData setValue:[outputFormatter stringFromDate:eventDate] forKey:@"conditionDate"];
		[eventData setValue:eventDate forKey:@"eventdate"];
		
		[outputFormatter setDateFormat:@"yyyy'년' MM'월'"];
		[eventData setValue:[outputFormatter stringFromDate:eventDate] forKey:@"sectionDate"];
		[eventData setValue:childData forKey:@"child"];
	}

	
	
	/*
	 @property (nonatomic, retain) NSString * notifytime;
	 @property (nonatomic, retain) NSString * enddate;
	 @property (nonatomic, retain) NSString * eventmemo;
	 @property (nonatomic, retain) NSString * eventname;
	 @property (nonatomic, retain) NSString * childname;
	 @property (nonatomic, retain) NSString * startdate;
	 @property (nonatomic, retain) NSString * googlecalendar;
	 @property (nonatomic, retain) NSString * publicity;
	 @property (nonatomic, retain) NSDecimalNumber * eventtype;
	 @property (nonatomic, retain) NSString * location;
	 @property (nonatomic, retain) NSString * repeatrate;
	 @property (nonatomic, retain) NSString * conditionDate;
	 @property (nonatomic, retain) NSDate * eventdate;
	 @property (nonatomic, retain) NSString * mystate;
	 @property (nonatomic, retain) NSString * notifymethod;
	 @property (nonatomic, retain) NSString * sectionDate;
	 @property (nonatomic, retain) ChildData * child;
	 
	 */	

	Debug("solar = %@, lunar = %@", childData.birthdaySolar, childData.birthdayLunar);
	
//	Debug(@"AddChildViewController.save - 3333");
	
	/*
	 Update the ingredient from the values in the text fields.
	 */
	
	
    
	
//	Debug("save : bcell.nickName.text = %@", bcell.nickName.text);
//	childData.nickname = bcell.nickName.text;

	if (originalImage != nil) {
		//Image 관련 데이터 저장 /////////////////////////////////////////////
		NSManagedObject *oldImage = childData.image;
		if (oldImage != nil) {
			[self.managedObjectContext deleteObject:oldImage];
		}
		childData.image = imageContext;
		
		// Set the image for the image managed object.
		[imageContext setValue:originalImage forKey:@"image"];
		
		// Create a thumbnail version of the image for the recipe object.
		CGSize size = originalImage.size;
		CGFloat ratio = 0;
		if (size.width > size.height) {
			ratio = 150.0 / size.width;
		} else {
			ratio = 150.0 / size.height;
		}
		CGRect rect = CGRectMake(0.0, 0.0, ratio * size.width, ratio * size.height);
		
		Debug(@"thumbnail rect = %f, %f", ratio * size.width, ratio * size.height);
		
		UIGraphicsBeginImageContext(rect.size);
		[originalImage drawInRect:rect];
		childData.thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
		Debug(@"AddChildViewController.save - thumbnail 저장.");
		UIGraphicsEndImageContext();
		///////////////////////////////////////////////////////////////////
	}
	
	
	//두 번 째 섹션 저장
	ChildInfoCell *infocell = nil;
	
	infocell = (ChildInfoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
	Debug(@"AddChildViewController.save - height : value = %@", infocell.valueField.text);
	childData.height = [[[NSNumber alloc] initWithDouble:[infocell.valueField.text doubleValue]] autorelease];
	
	infocell = (ChildInfoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
	Debug(@"AddChildViewController.save - weight : value = %@", infocell.valueField.text);
	childData.weight = [[[NSNumber alloc] initWithDouble:[infocell.valueField.text doubleValue]] autorelease];

	//세 번 째 섹션 저장
	infocell = (ChildInfoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
	Debug(@"AddChildViewController.save - idnum : value = %@", infocell.valueField.text);
	childData.idnum = infocell.valueField.text;
	
	ChildGenderInfoCell *genderCell = nil;
	genderCell = (ChildGenderInfoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:2]];
	Debug(@"AddChildViewController.save - gender : value = %@", infocell.valueField.text);
	
	childData.gender = [[[NSNumber alloc] initWithInt:genderCell.genderControl.selectedSegmentIndex] autorelease];
//	if (segment.selectedSegmentIndex == 0) {
//		childData.gender = [[NSNumber alloc] initWithInt:0];
//	} else {
//		childData.gender = [[NSNumber alloc] initWithInt:1];
//	}

	infocell = (ChildInfoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:2]];
	Debug(@"AddChildViewController.save - doctor : value = %@", infocell.valueField.text);
	childData.doctor = infocell.valueField.text;
	
	infocell = (ChildInfoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
	Debug(@"AddChildViewController.save - location : value = %@", infocell.valueField.text);
	childData.location = infocell.valueField.text;

	 /*
	 Save the managed object context.
	 */
	
//	[self.delegate saveChildBasicInfo:cell andChildInfo:nil];
	
	NSError *error = nil;
	
	if (![self.managedObjectContext save:&error]) {
		Debug(@"AddChildViewController.save - context:error");
		
		// Replace this implementation with code to handle the error appropriately.
		 
		// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"ERROR" 
							  message:@"테이블 뷰의 데이터를 저장하던 중\n에러가 발생했습니다!"
							  delegate:nil 
							  cancelButtonTitle:@"닫 기" 
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		//abort();
	}
	Debug(@"AddChildViewController.save - 8888");
	
	//기념일 데이터 저장 : 생일 -> plist파일에 저장!!!
	
	NSString *filePath = [self dataFilePath];
	Debug("filePath = %@", filePath);
	//	NSError *error;
	//	[[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
	NSMutableDictionary *annData = nil;
	NSMutableDictionary *tempData = nil;
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
		annData = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
	} else {
		Debug(@"File Not Exist");
		annData = [[NSMutableDictionary alloc] init];
		NSMutableDictionary *firstData = [[NSMutableDictionary alloc] init];
		[annData setObject:firstData forKey:@"AnnData"];
		[annData writeToFile:filePath atomically:YES];
	}
	
	
	tempData = [annData objectForKey:birthStr];
	BOOL istmprel = NO;
	if (tempData == nil) {
		tempData = [[NSMutableDictionary alloc] init];
		istmprel = YES;
	} else {
		if ([tempData objectForKey:[NSString stringWithFormat:@"%@ 생일", childData.childname]]) {
			[tempData removeObjectForKey:[NSString stringWithFormat:@"%@ 생일", childData.childname]];
		}
	}

	NSMutableDictionary *newData = [[NSMutableDictionary alloc] init];
	Debug(@"set new data");
	[newData setObject:birthStr forKey:@"date"];
	Debug(@"[[childData valueForKey:@'islunar'] stringValue] = %@", [[childData valueForKey:@"islunar"] stringValue]);
	if ([[childData valueForKey:@"islunar"] integerValue] == 0) {
		[newData setObject:@"ON" forKey:@"lunar"];
	} else {
		[newData setObject:@"OFF" forKey:@"lunar"];
	}
	[newData setObject:@"1" forKey:@"holy"];
	[newData setObject:[NSString stringWithFormat:@"%@ 생일", childData.childname] forKey:@"name"];
	
	Debug(@"set new data into tempData");
	[tempData setObject:newData forKey:[NSString stringWithFormat:@"%@ 생일", childData.childname]];
	
	Debug(@"set tempData into annData");
	[annData setObject:tempData forKey:birthStr];
	
	NSMutableDictionary *prevData = [annData objectForKey:prevBirthStr];
	NSMutableDictionary *prevBirthData = [prevData objectForKey:[NSString stringWithFormat:@"%@ 생일", childData.childname]];
	
	if (prevBirthData != nil && ![birthStr isEqualToString:prevBirthStr]) {
		[prevData removeObjectForKey:[NSString stringWithFormat:@"%@ 생일", childData.childname]];
		
		if ([prevData count] == 0) {
			[annData removeObjectForKey:prevBirthStr];
		}
	}

	Debug(@"annData writeToFile");
	[annData writeToFile:[self dataFilePath] atomically:YES];
	
	Debug(@"release");
	[newData release];
	if (istmprel) {
		[tempData release];
	}
	[annData release];
	[self.delegate endSave];
//    [self.navigationController popViewControllerAnimated:YES];
	Debug(@"AddChildViewController.save - 9999");
 
}

- (void)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)textFieldDoneEditing:(id)sender {
	[sender resignFirstResponder];
}

- (NSString *)dataFilePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [paths objectAtIndex:0];
	return [documentDirectory stringByAppendingPathComponent:@"AnnData.plist"];
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
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[childData release]; 
	[managedObjectContext release]; 
	[childInfoCell release]; 
	[childBasicInfoCell release]; 
	[childGenderCell release];
	[cellTitle1 release]; 
	[cellTitle2 release];
	[dateFormatter release];
}


@end

