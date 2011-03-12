//
//  AppMainView.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 5. 22..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "AppMainViewController.h"
#import "iPhotoDiaryAppDelegate.h"

static NSString *selectedChildName;
static NSInteger *childCount = 0;
static NSMutableArray *childrenArray;

@implementation AppMainViewController

@synthesize childPhotoView;
@synthesize backgroundImageView;
@synthesize childName;
@synthesize ddi;
@synthesize childBirthday;
@synthesize childYear;
@synthesize zodiac;
@synthesize jewelry;
@synthesize childGender;
@synthesize birthLabel;
//@synthesize todaysEventTable;
@synthesize childData;
@synthesize entityDescription;
@synthesize childDatas;
@synthesize childList;

@synthesize managedObjectContext, fetchedResultsController;
@synthesize dateFormatter;
@synthesize childButtonName;

@synthesize ddiImageView;
@synthesize zodiacImageView;
@synthesize jewelryImageView;
@synthesize genderImageView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle

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
	label.text = @"\nMy Children";
	self.navigationItem.titleView = label;

	
	// Configure the add button.
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addChild)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
	
	UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editChild)];
    self.navigationItem.leftBarButtonItem = editButton;
	[editButton release];
	
	iPhotoDiaryAppDelegate *appDelegate = (iPhotoDiaryAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.managedObjectContext = appDelegate.managedObjectContext;

//	NSError *error;
//	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
//		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//		exit(-1);  // Fail
//	}
	
	childButtonName = nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark selectedChildName 

+ (NSString *)selectedChildName {
	return selectedChildName;
}

+ (NSMutableArray *)childrenArray {
	Debug(@"childrenArray : [children count] = %d", [childrenArray count]);
	return childrenArray;
}

+ (NSInteger)childCount {
	return childCount;
}

+ (void)addChildCount:(NSInteger)num {
	childCount += num;
	
	if (childCount < 0) {
		childCount = 0;
	}
}
#pragma mark -
#pragma mark Responding View event 

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	Debug("child count = %d, %d", [self.childDatas count], childCount);
	if ([self.childDatas count] == 0 || [self.childDatas count] != childCount) {
		[self fetchRequestResult:childButtonName];
	}
}

#pragma mark -
#pragma mark Navigation

- (void)addChild {
	
//	AddChildViewController *nextViewController = [[AddChildViewController alloc] initWithStyle:UITableViewStyleGrouped withDelegate:self withManagedObjectContext:self.managedObjectContext];
	AddNewChildViewController *nextViewController = [[AddNewChildViewController alloc] initWithManagedObjectContext:managedObjectContext];
	
	nextViewController.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:nextViewController animated:YES];
}

- (void)editChild {
	childList = [[ChildListViewController alloc] initWithManagedObjectContext:self.managedObjectContext];
	
	childList.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:childList animated:YES];
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
#pragma mark -
#pragma mark Setting data to Controlls

- (void)setDatatoControlls:(ChildData *)cData {
	selectedChildName = cData.childname;
	
	self.childName.text = cData.childname;
//	self.childPreName.text = cData.nickname;
	if ([[cData valueForKey:@"islunar"] integerValue] == 1) {
		self.childBirthday.text = [NSString stringWithFormat:@"%@(양)", [self.dateFormatter stringFromDate:cData.birthday]];
	} else {
		self.childBirthday.text = [NSString stringWithFormat:@"%@(음)", [self.dateFormatter stringFromDate:cData.birthday]];
	}

	NSDate *solDate = nil;
	NSTimeInterval interval = 0;
	NSDate *tmpDate = nil;
	
	if ([[cData valueForKey:@"islunar"] integerValue] == 0) {
		solDate = [dateFormatter dateFromString:cData.birthdaySolar];
		interval = [solDate timeIntervalSinceNow];
		tmpDate = solDate;
	} else {
		interval = [cData.birthday timeIntervalSinceNow];
		tmpDate = cData.birthday;
	}

	
	// Get the system calendar
	NSCalendar *sysCalendar = [NSCalendar currentCalendar];
	
	// Create the NSDates
	NSDate *date1 = [[NSDate alloc] init];
	NSDate *date2 = [[NSDate alloc] initWithTimeInterval:interval sinceDate:date1]; 
	
	// Get conversion to months, days, hours, minutes
	unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit;
	
	NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:date2  toDate:date1  options:0];
	
//	NSLog(@"Break down: %dmin %dhours %ddays %dmoths",[breakdownInfo minute], [breakdownInfo hour], [breakdownInfo day], [breakdownInfo month]);
	NSInteger days = ceil(fabs(interval) / (24 * 60 * 60));
	
	NSString *age = @"";
	
	if ([breakdownInfo month] > 36) {
		age = [NSString stringWithFormat:@"%d개월(%d세)",[breakdownInfo month],[breakdownInfo year]];
	} else {
		age = [NSString stringWithFormat:@"%d일(%d개월)",days, [breakdownInfo month]];
//		if ([breakdownInfo day] > 0) {
//			age = [NSString stringWithFormat:@"%d일(%d개월)",days, [breakdownInfo month] + 1];
//		} else {
//			age = [NSString stringWithFormat:@"%d일(%d개월)",days, [breakdownInfo month]];
//		}

	}

	unsigned unitFlags2 = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
	NSDateComponents *dateComponent = [sysCalendar components:unitFlags2 fromDate:tmpDate];
	
//	[newdata setValue:[NSString stringWithFormat:@"%d. %d.", dateComponent.month, dateComponent.day] forKey:@"date"];
	
	KLCalendarModel *calModel = [[KLCalendarModel alloc] init];
	
	Debug("y = %d, m = %d, d = %d",dateComponent.year, dateComponent.month, dateComponent.day);
	MCLunarDate *lunarDate = [calModel sol2lunYear:dateComponent.year Month:dateComponent.month Day:dateComponent.day];
	
	self.ddi.text = lunarDate.currentYearDdi;
	
	Debug("띠 : %@", lunarDate.currentYearDdi);
	
	if ([lunarDate.currentYearDdi isEqualToString:@"쥐"]) {
		ddiImageView.image = [UIImage imageNamed:@"56.png"];
	} else if ([lunarDate.currentYearDdi isEqualToString:@"소"]) {
		ddiImageView.image = [UIImage imageNamed:@"57.png"];
	} else if ([lunarDate.currentYearDdi isEqualToString:@"범"]) {
		ddiImageView.image = [UIImage imageNamed:@"58.png"];
	} else if ([lunarDate.currentYearDdi isEqualToString:@"토끼"]) {
		ddiImageView.image = [UIImage imageNamed:@"59.png"];
	} else if ([lunarDate.currentYearDdi isEqualToString:@"용"]) {
		ddiImageView.image = [UIImage imageNamed:@"60.png"];
	} else if ([lunarDate.currentYearDdi isEqualToString:@"뱀"]) {
		ddiImageView.image = [UIImage imageNamed:@"61.png"];
	} else if ([lunarDate.currentYearDdi isEqualToString:@"말"]) {
		ddiImageView.image = [UIImage imageNamed:@"62.png"];
	} else if ([lunarDate.currentYearDdi isEqualToString:@"양"]) {
		ddiImageView.image = [UIImage imageNamed:@"63.png"];
	} else if ([lunarDate.currentYearDdi isEqualToString:@"원숭이"]) {
		ddiImageView.image = [UIImage imageNamed:@"64.png"];
	} else if ([lunarDate.currentYearDdi isEqualToString:@"닭"]) {
		ddiImageView.image = [UIImage imageNamed:@"65.png"];
	} else if ([lunarDate.currentYearDdi isEqualToString:@"개"]) {
		ddiImageView.image = [UIImage imageNamed:@"66.png"];
	} else if ([lunarDate.currentYearDdi isEqualToString:@"돼지"]) {
		ddiImageView.image = [UIImage imageNamed:@"67.png"];
	}
	
//	NSString *newM = nil;
	NSString *newD = nil;
	
//	if (dateComponent.month < 10) {
//		newM = [NSString stringWithFormat:@"0%d", dateComponent.month];
//	} else {
//		newM = [NSString stringWithFormat:@"%d", dateComponent.month];
//	}
	Debug(@"11111");
	if (dateComponent.day < 10) {
		newD = [NSString stringWithFormat:@"0%d", dateComponent.day];
	} else {
		newD = [NSString stringWithFormat:@"%d", dateComponent.day];
	}
	
	Debug(@"22222 - %@", newD);
	
	NSString *md = [NSString stringWithFormat:@"%d%@", dateComponent.month, newD];
	Debug(@"3333");
	if ([md integerValue] >= [@"321" integerValue] && [md integerValue] <= [@"419" integerValue]) {
		self.zodiac.text = @"양자리";
		zodiacImageView.image = [UIImage imageNamed:@"3-4.png"];
	} else if ([md integerValue] >= 420 && [md integerValue] <= 520) {
		self.zodiac.text = @"황소자리";
		zodiacImageView.image = [UIImage imageNamed:@"4-5.png"];
	} else if ([md integerValue] >= 521 && [md integerValue] <= 621) {
		self.zodiac.text = @"쌍둥이자리";
		zodiacImageView.image = [UIImage imageNamed:@"5-6.png"];
	} else if ([md integerValue] >= 622 && [md integerValue] <= 722) {
		self.zodiac.text = @"게자리";
		zodiacImageView.image = [UIImage imageNamed:@"6-7.png"];
	} else if ([md integerValue] >= 723 && [md integerValue] <= 822) {
		self.zodiac.text = @"사자자리";
		zodiacImageView.image = [UIImage imageNamed:@"7-8.png"];
	} else if ([md integerValue] >= 823 && [md integerValue] <= 922) {
		self.zodiac.text = @"처녀자리";
		zodiacImageView.image = [UIImage imageNamed:@"8-9.png"];
	} else if ([md integerValue] >= 923 && [md integerValue] <= 1023) {
		self.zodiac.text = @"천칭자리";
		zodiacImageView.image = [UIImage imageNamed:@"9-10.png"];
	} else if ([md integerValue] >= 1024 && [md integerValue] <= 1121) {
		self.zodiac.text = @"전갈자리";
		zodiacImageView.image = [UIImage imageNamed:@"10-11.png"];
	} else if ([md integerValue] >= 1122 && [md integerValue] <= 1221) {
		self.zodiac.text = @"궁수자리";
		zodiacImageView.image = [UIImage imageNamed:@"11-12.png"];
	} else if (([md integerValue] >= 1222 && [md integerValue] <= 1231) ||
				([md integerValue] >= 101 && [md integerValue] <= 119)) {
		self.zodiac.text = @"염소자리";
		zodiacImageView.image = [UIImage imageNamed:@"12-1.png"];
	} else if ([md integerValue] >= 120 && [md integerValue] <= 218) {
		self.zodiac.text = @"물병자리";
		zodiacImageView.image = [UIImage imageNamed:@"1-2.png"];
	} else if ([md integerValue] >= 219 && [md integerValue] <= 320) {
		self.zodiac.text = @"물고기자리";
		zodiacImageView.image = [UIImage imageNamed:@"2-3.png"];
	}

				
	jewelryImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png", dateComponent.month]];
				
	switch(dateComponent.month) {
		case 1:
			self.jewelry.text = @"가넷";
			break;
		case 2:
			self.jewelry.text = @"자수정";
			break;
		case 3:
			self.jewelry.text = @"아쿠아마린";
			break;
		case 4:
			self.jewelry.text = @"다이아몬드";
			break;
		case 5:
			self.jewelry.text = @"에메랄드";
			break;
		case 6:
			self.jewelry.text = @"진주";
			break;
		case 7:
			self.jewelry.text = @"루비";
			break;
		case 8:
			self.jewelry.text = @"페리도트";
			break;
		case 9:
			self.jewelry.text = @"사파이어";
			break;
		case 10:
			self.jewelry.text = @"오팔";
			break;
		case 11:
			self.jewelry.text = @"토파즈";
			break;
		case 12:
			self.jewelry.text = @"터키석";
			break;
	}
	
//	Debug("days = %f", days);
	[date1 release];
	[date2 release];
	
	self.childYear.text = age;
//	self.childLength.text = [NSString stringWithFormat:@"%@ cm", [cData.height stringValue]];
//	self.childWeghit.text = [NSString stringWithFormat:@"%@ Kg", [cData.weight stringValue]];
	Debug(@"[childData valueForKey:@'gender'] = %d", [[cData valueForKey:@"gender"] integerValue]);
	
	if ([[cData valueForKey:@"gender"] integerValue] == 1) {
		self.childGender.text = @"여";
		genderImageView.image = [UIImage imageNamed:@"female.png"];
	} else {
		self.childGender.text = @"남";
		genderImageView.image = [UIImage imageNamed:@"male.png"];
	}

	
	self.childPhotoView.image = cData.thumbnailImage;
	
	Debug(@"set todayEvent");
	if (todayEvent != nil) {
		Debug(@"todayEvent != nil");
		[todayEvent.view removeFromSuperview];
		Debug(@"todayEvent removeFromSuperview");
	}
	
	todayEvent = [[TodayEventTableViewController alloc] initWithStyle:UITableViewStylePlain andChildData:cData];
	todayEvent.view.frame = CGRectMake(0, 227, 320, 79);
	todayEvent.view.backgroundColor = [UIColor clearColor];
	[self.view addSubview:todayEvent.view];
	
	[calModel release];
//	[todayEvent release];
	
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == alertView.cancelButtonIndex) {
		Debug(@"cancel butoon clicked");
		return;
	} else {
		Debug(@"other butoon clicked : button index = %d", buttonIndex);
		AddNewChildViewController *nextViewController = [[AddNewChildViewController alloc] initWithManagedObjectContext:managedObjectContext];
		
		nextViewController.hidesBottomBarWhenPushed = YES;
		[self.navigationController pushViewController:nextViewController animated:YES];
		[nextViewController release];
	}
	
}


#pragma mark -
#pragma mark Fetched results controller

- (void)fetchRequestResult:(NSString *)cName {
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"ChildData" inManagedObjectContext:managedObjectContext]];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"birthday" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSError *error;
	self.childDatas = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
//	childData = [childDatas objectAtIndex:0];
	[fetchRequest release];
	[sortDescriptor release];
	[sortDescriptors release];
	Debug(@"self.childDatas count = %d, cName = %@", [self.childDatas count], cName);
	
	childCount = [self.childDatas count];
	
	if ([self.childDatas count] > 0) {
		Debug(@"childButtons.retaincount = %d, [childButtons count] = %d", [childButtons retainCount], [childButtons count]);
		if ([childButtons count] > 0) {
			for (NSInteger i = 0; i < [childButtons count]; i++) {
				[[childButtons objectAtIndex:i] removeFromSuperview];
			}
//			[childButtons removeAllObjects];
//			[childButtons release];
		}
		
		childButtons = [[NSMutableArray alloc] initWithCapacity:[self.childDatas count]];
		Debug(@"1111");
		//아이 버튼 설정
		NSInteger buttonsWidth = 55.0 * [self.childDatas count];
		NSInteger startX = (self.view.frame.size.width / 2) - (buttonsWidth / 2);
		Debug(@"2222");				
		childrenArray = [[NSMutableArray alloc] initWithCapacity:[self.childDatas count]];
		Debug(@"3333");
		
		NSString *hundredChild = @"";
		NSString *dolChild = @"";
		NSString *birthChild = @"";
		
		for (NSInteger i = 0; i < [self.childDatas count]; i++) {
			ChildData *cData = [childDatas objectAtIndex:i];
			UIButton *childButton = [UIButton buttonWithType:UIButtonTypeCustom];
			childButton.frame = CGRectMake(startX + 55.0 * i, 308, 55.0, 55.0);
			[childButtons addObject:childButton];
			
			if ((cName != nil && [cName length] && [cName isEqualToString:[cData childname]]) || [self.childDatas count] == 1) {
				if ([[cData valueForKey:@"gender"] integerValue] == 1) {
					[childButton setBackgroundImage:[UIImage imageNamed:@"btnChildSelected.png"] forState:UIControlStateNormal];
				} else {
					[childButton setBackgroundImage:[UIImage imageNamed:@"btnChildSelected_m.png"] forState:UIControlStateNormal];
				}

				[self setDatatoControlls:[childDatas objectAtIndex:i]];
			} else {
				if (i == 0 && cName == nil) {
					if ([[cData valueForKey:@"gender"] integerValue] == 1) {
						[childButton setBackgroundImage:[UIImage imageNamed:@"btnChildSelected.png"] forState:UIControlStateNormal];
					} else {
						[childButton setBackgroundImage:[UIImage imageNamed:@"btnChildSelected_m.png"] forState:UIControlStateNormal];
					}

					[self setDatatoControlls:[childDatas objectAtIndex:i]];
				} else {
					if ([[cData valueForKey:@"gender"] integerValue] == 1) {
						[childButton setBackgroundImage:[UIImage imageNamed:@"btnChild.png"] forState:UIControlStateNormal];
					} else {
						[childButton setBackgroundImage:[UIImage imageNamed:@"btnChild_m.png"] forState:UIControlStateNormal];
					}

				}
			}
			
			if ([[cData valueForKey:@"gender"] integerValue] == 1) {
				[childButton setBackgroundImage:[UIImage imageNamed:@"btnChildSelected.png"] forState:UIControlStateSelected];
			} else {
				[childButton setBackgroundImage:[UIImage imageNamed:@"btnChildSelected_m.png"] forState:UIControlStateSelected];
			}

			[childButton setTitle:[NSString stringWithFormat:@"%@", [cData childname]] forState:UIControlStateNormal];
			[childButton addTarget:self action:@selector(selectChild:) forControlEvents:UIControlEventTouchDown];
			childButton.titleLabel.font = [UIFont systemFontOfSize: 12];
			[self.view addSubview:childButton];
//			[childButton release];
			
			if ([cData childname] == nil) {
				[childrenArray addObject:@"아무개"];
			} else {
				[childrenArray addObject:[cData childname]];
			}
			
			//100일, 돌, 매해 생일 알림
			NSDate *solDate = [dateFormatter dateFromString:cData.birthdaySolar];
			NSTimeInterval interval = [solDate timeIntervalSinceNow];
			NSInteger days = ceil(fabs(interval) / (24 * 60 * 60));
			
			
			
			Debug(@"interval : %f, days = %d", interval, days);
			
			if (days == 100) {
				hundredChild = [hundredChild stringByAppendingString:[NSString stringWithFormat:@"%@ ", [cData childname]]];
			}
			
			NSCalendar *sysCalendar = [NSCalendar currentCalendar];
			KLCalendarModel *calModel = [[KLCalendarModel alloc] init];
			
			unsigned unitFlags2 = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
			
			if ([[cData valueForKey:@"islunar"] integerValue] == 0) {
				isLunarOrSolar = YES;
				NSDateComponents *todayComponent = [sysCalendar components:unitFlags2 fromDate:[NSDate date]];
				NSDateComponents *birthComponent = [sysCalendar components:unitFlags2 fromDate:[cData birthday]];
				
				Debug("y = %d, m = %d, d = %d",todayComponent.year, todayComponent.month, todayComponent.day);
				MCLunarDate *todayLunarDate = [calModel sol2lunYear:todayComponent.year Month:todayComponent.month Day:todayComponent.day];
				Debug("y = %d, m = %d, d = %d",birthComponent.year, birthComponent.month, birthComponent.day);
				
				
				if ((todayLunarDate.yearLunar == (birthComponent.year + 1)) &&
					(todayLunarDate.lunarMonth == birthComponent.month) &&
					(todayLunarDate.lunarDay == birthComponent.day)) {
					dolChild = [dolChild stringByAppendingString:[NSString stringWithFormat:@"%@ ", [cData childname]]];
				} else if ((todayLunarDate.lunarMonth == birthComponent.month) &&
						   (todayLunarDate.lunarDay == birthComponent.day)) {
					birthChild = [birthChild stringByAppendingString:[NSString stringWithFormat:@"%@ ", [cData childname]]];
				}

			} else {
				isLunarOrSolar = NO;
				NSDateComponents *todayComponent = [sysCalendar components:unitFlags2 fromDate:[NSDate date]];
				NSDateComponents *birthComponent = [sysCalendar components:unitFlags2 fromDate:[cData birthday]];
				
				if ((todayComponent.year == (birthComponent.year + 1)) &&
					(todayComponent.month == birthComponent.month) &&
					(todayComponent.day == birthComponent.day)) {
					dolChild = [dolChild stringByAppendingString:[NSString stringWithFormat:@"%@ ", [cData childname]]];
				} else if ((todayComponent.month == birthComponent.month) &&
						   (todayComponent.day == birthComponent.day)) {
					birthChild = [birthChild stringByAppendingString:[NSString stringWithFormat:@"%@ ", [cData childname]]];
				}
			}

			
			[calModel release];
			Debug(@"cData[%d].childname  = %@", i, [cData childname]);
		}

		Debug(@"fetchRequestResult : children count = %d", [childrenArray count]);
		Debug(@"hundredChild : %@", hundredChild);
		if (![hundredChild isEqualToString:@""]) {
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle:@"백일 알림" 
								  message:[NSString stringWithFormat:@"%@ 백일입니다.\n건강히 자라 준 것에\n감사합니다!", hundredChild]
								  delegate:self 
								  cancelButtonTitle:@"확 인" 
								  otherButtonTitles:nil];
			[alert show];
			[alert release];
			
		}
		
		if (![dolChild isEqualToString:@""]) {
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle:@"첫돌 알림" 
								  message:[NSString stringWithFormat:@"%@ 첫돌입니다.\n건강히 자라 준 것에\n감사합니다!", dolChild]
								  delegate:self 
								  cancelButtonTitle:@"확 인" 
								  otherButtonTitles:nil];
			[alert show];
			[alert release];
			
		}
		
		if (![birthChild isEqualToString:@""]) {
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle:@"생일 알림" 
								  message:[NSString stringWithFormat:@"%@ 생일입니다.\n생일을 진심으로 축하해주세요!", birthChild]
								  delegate:self 
								  cancelButtonTitle:@"확 인" 
								  otherButtonTitles:nil];
			[alert show];
			[alert release];
			
		}
	} else {
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"미등록 알림" 
							  message:@"등록된 아기가 없습니다.\n아기 등록 화면으로 이동합니다."
							  delegate:self 
							  cancelButtonTitle:@"취 소" 
							  otherButtonTitles:@"이 동", nil];
		[alert show];
		[alert release];
		
		//	AddChildViewController *nextViewController = [[AddChildViewController alloc] initWithStyle:UITableViewStyleGrouped withDelegate:self withManagedObjectContext:self.managedObjectContext];
	}
}

- (void)selectChild:(UIButton *)sender {
	childButtonName = [sender titleForState:UIControlStateNormal];
//	[self fetchRequestResult:childButtonName];
	for (NSInteger i = 0; i < [self.childDatas count]; i++) {
		NSString *cname = [[childDatas objectAtIndex:i] valueForKey:@"childname"];
		
		if ([[[childDatas objectAtIndex:i] valueForKey:@"gender"] integerValue] == 1) {
			if ([cname isEqualToString:childButtonName]) {
				[self setDatatoControlls:[childDatas objectAtIndex:i]];
				childData = [childDatas objectAtIndex:i];
				[[childButtons objectAtIndex:i] setBackgroundImage:[UIImage imageNamed:@"btnChildSelected.png"] forState:UIControlStateNormal];
			} else {
				[[childButtons objectAtIndex:i] setBackgroundImage:[UIImage imageNamed:@"btnChild.png"] forState:UIControlStateNormal];
			}
		} else {
			if ([cname isEqualToString:childButtonName]) {
				[self setDatatoControlls:[childDatas objectAtIndex:i]];
				childData = [childDatas objectAtIndex:i];
				[[childButtons objectAtIndex:i] setBackgroundImage:[UIImage imageNamed:@"btnChildSelected_m.png"] forState:UIControlStateNormal];
			} else {
				[[childButtons objectAtIndex:i] setBackgroundImage:[UIImage imageNamed:@"btnChild_m.png"] forState:UIControlStateNormal];
			}
		}

	}
}

- (IBAction)toggleLunarAndSolar {
	if (isLunarOrSolar) {
		childBirthday.text = [NSString stringWithFormat:@"%@(양)", [childData valueForKey:@"birthdaySolar"]];
	} else {
		childBirthday.text = [NSString stringWithFormat:@"%@(음)", [childData valueForKey:@"birthdayLunar"]];
	}
	isLunarOrSolar = !isLunarOrSolar;
}

/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */
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

- (void)dealloc {
	[childPhotoView release];
	[backgroundImageView release];
	[childName release];
	[ddi release];
	[childBirthday release];
	[childYear release];
	[zodiac release];
	[jewelry release];
	[childGender release];
	[birthLabel release];
//	[todaysEventTable release];
	
	[managedObjectContext release];
	[fetchedResultsController release];
	[childList release];
	[childButtons release];
	[childDatas release];
	[childData release];
	
	[ddiImageView release];
	[zodiacImageView release];
	[jewelryImageView release];
	[genderImageView release];
	
	[todayEvent release];
	[entityDescription release];
	[dateFormatter release];
	[childButtonName release];

	//	UITableView *todaysEventTable;

    [super dealloc];
}


@end
