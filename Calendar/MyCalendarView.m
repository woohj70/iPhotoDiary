//
//  MyCalendarView.m
//  MyCalendarTest
//
//  Created by HYOUNG JUN WOO on 10. 4. 18..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "MyCalendarView.h"
#import "KLCalendarModel.h"
//#import "KLColors.h"
//#import "KLGraphicsUtils.h"
#import "THCalendarInfo.h"

#import "EXFLogging.h"

@interface MyCalendarView ()
- (void)addUI;
- (void)refreshViewWithPushDirection:(NSString *)caTransitionSubtype;
- (void)showPreviousMonth;
- (void)showFollowingMonth;
@end

static int tterms[24] =
{
    -6418939, -5146737, -3871136, -2589569, -1299777, 0, 1310827, 2633103, 3966413, 5309605, 6660762, 8017383,
    9376511, 10735018, 12089855, 13438199, 14777792, 16107008, 17424841, 18731368, 20027093, 21313452, 22592403, 23866369
};

@implementation MyCalendarView

@synthesize delegate;
@synthesize dateButtons;
@synthesize dates;
@synthesize calendarContainer;
@synthesize fetchedResultsController;
@synthesize managedObjectContext;
@synthesize childDatas;
@synthesize eventDatas;
@synthesize diaryDatas;
@synthesize anniversaryDatas;
@synthesize dateFormatter;
@synthesize hterms, julgi;
//@synthesize container;

/*
 - (id)initWithImage:(UIImage *)image  delegate:(id <MyCalendarViewDelegate>)aDelegate{
 if (self = [super initWithImage:image]) {
 // Initialization code
 self.delegate = aDelegate;
 self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
 self.autoresizesSubviews = YES;
 self.userInteractionEnabled = YES;
 self.frame = CGRectMake(0.0f, 44.0f, 320.0f, 416.0f);
 
 calendarModel = [[KLCalendarModel alloc] init];
 self.calendarContainer = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 54.0f, 320.0f, 323.0f)] autorelease];		
 self.dates = [[NSMutableArray alloc] init];
 self.dateButtons = [[NSMutableArray alloc]	init];
 
 [self addUI];
 [self refreshViewWithPushDirection:nil];
 }
 return self;
 }
 */


- (id)initWithFrame:(CGRect)frame  delegate:(id <MyCalendarViewDelegate>)aDelegate withManagedObjectContext:managedObjectContext {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
        prevYear = 0;
        //        self.julgi = [[NSMutableDictionary alloc] init];
        self.hterms = [[NSArray alloc] initWithObjects:@"소한",@"대한",@"입춘",@"우수",@"경칩",@"춘분",@"청명",@"곡우",@"입하",@"소만",@"망종",@"하지",
                       @"소서",@"대서",@"입추",@"처서",@"백로",@"추분",@"한로",@"상강",@"입동",@"소설",@"대설",@"동지",nil];
        
		self.delegate = aDelegate;
		//		self.backgroundColor = [UIColor blackColor];
		//		self.image = [UIImage imageNamed:@"background.png"];
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.autoresizesSubviews = YES;
		self.userInteractionEnabled = YES;
		self.frame = CGRectMake(0.0f, 0.0f, 320.0f, 460.0f);
		
		calendarModel = [[KLCalendarModel alloc] init];
		self.calendarContainer = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 94.0f, 320.0f, 406.0f)] autorelease];		
		self.dates = [[NSMutableArray alloc] init];
		self.dateButtons = [[NSMutableArray alloc]	init];
		
		self.managedObjectContext = managedObjectContext;
		
		NSError *error = nil;
		if (![[self fetchedResultsController] performFetch:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
        
		[self loadData];
		[self addUI];
		[self refreshViewWithPushDirection:nil];
		[self setNeedsDisplay];
    }
    return self;
}

#pragma mark -
#pragma mark Persistance File Process

- (void)loadData {
	Debug(@"loadData start");
	NSString *filePath = [self dataFilePath];
	//	Debug("filePath = %@", filePath);
	//		NSError *error;
	//		[[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
	//	tempData = [[NSMutableDictionary alloc] init];
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
		annData = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
		
		//		if ([annData isKindOfClass:[NSMutableDictionary class]]) {
		//			Debug("loadData : OK - annData.count = %d", [annData count]);
		//		} else {
		//			Debug("loadData : NOT OK - class name = %@", [[annData class] name]);
		//		}
	} else {
		Debug(@"File Not Exist");
		annData = [[NSMutableDictionary alloc] init];
		NSMutableDictionary *firstData = [[NSMutableDictionary alloc] init];
		[annData setObject:firstData forKey:@"AnnData"];
		[annData writeToFile:filePath atomically:YES];
	}
	Debug(@"loadData end");
}

- (NSString *)dataFilePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [paths objectAtIndex:0];
	return [documentDirectory stringByAppendingPathComponent:@"AnnData.plist"];
}


#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == alertView.cancelButtonIndex) {
		//		[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
	}
}

#pragma mark -
#pragma mark Draw Calendar

- (void)drawCalendarHead {
}


- (void)selectedDateButton:(CalendarButton *)dateButton {
	//	dateButton.selected = !dateButton.selected;
	Debug(@"before dateButton.retainCount = %d", [dateButton retainCount]);
	[delegate popupView:dateButton];
	//	[dateButton release];
	Debug(@"after dateButton.retainCount = %d", [dateButton retainCount]);
}

- (CGFloat)headerHeight { return 0.13707f * self.bounds.size.height; }

- (void)drawDayNamesInContext:(CGContextRef)ctx
{
	CGFloat columnWidth = 44.0f;
	CGFloat fontSize = 0.3f * columnWidth;
    
    for (NSInteger columnIndex = 0; columnIndex < 7; columnIndex++) {
		UILabel *weekDayName = [[UILabel alloc] initWithFrame:CGRectMake(columnIndex * columnWidth + 6 + 17, [self headerHeight] - fontSize + 40, columnWidth, fontSize)];
        NSString *header = [calendarModel dayNameAbbreviationForDayOfWeek:columnIndex];
		weekDayName.backgroundColor = [UIColor clearColor];
        if (columnIndex == 0) { 
			weekDayName.textColor = [UIColor redColor];
		} else if (columnIndex == 6) {
			weekDayName.textColor = [UIColor blueColor];
		} else {
			weekDayName.textColor = [UIColor blackColor];		
		}
		
		weekDayName.font = [UIFont systemFontOfSize:fontSize];
		weekDayName.text = header;
        
		[self addSubview:weekDayName];
		[weekDayName release];
    }
}

// --------------------------------------------------------------------------------------------
//      drawGradientHeaderInContext:
// 
//      Draw the subtle gray vertical gradient behind the month, year, arrows, and day names
//
/*
 - (void)drawGradientHeaderInContext:(CGContextRef)ctx
 {
 CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
 
 CGColorRef rawColors[2] = { kCalendarHeaderLightColor, kCalendarHeaderDarkColor };
 CFArrayRef colors = CFArrayCreate(NULL, (void*)&rawColors, 2, NULL);
 
 CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, NULL);
 CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0,0), CGPointMake(0, [self headerHeight]), kCGGradientDrawsBeforeStartLocation);
 
 CGGradientRelease(gradient);
 CFRelease(colors);
 CGColorSpaceRelease(colorSpace);    
 }
 */

// --------------------------------------------------------------------------------------------
//      addUI:
// 
//      Create the calendar header buttons and labels and add them to the calendar view.
//      This setup is only performed once during the life of the calendar.
//

- (void)addUI
{			
	//	CGContextRef ctx = UIGraphicsGetCurrentContext();
	//	[self drawGradientHeaderInContext:ctx];
	//   [self drawDayNamesInContext:ctx];
	
	//	[self setNeedsDisplay];
	
	// Create the previous month button on the left side of the view
    CGRect previousYearButtonFrame = CGRectMake(self.bounds.origin.x,
												self.bounds.origin.y + 40,
												KL_CHANGE_MONTH_BUTTON_WIDTH, 
												KL_CHANGE_MONTH_BUTTON_HEIGHT);
    UIButton *previousYearButton = [[UIButton alloc] initWithFrame:previousYearButtonFrame];
    [previousYearButton setImage:[UIImage imageNamed:@"left-duparrow.png"] forState:UIControlStateNormal];
    previousYearButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    previousYearButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [previousYearButton addTarget:self action:@selector(showPreviousYear) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:previousYearButton];
    [previousYearButton release];
	
	
    // Create the previous month button on the left side of the view
    CGRect previousMonthButtonFrame = CGRectMake(self.bounds.origin.x + KL_CHANGE_MONTH_BUTTON_WIDTH,
                                                 self.bounds.origin.y + 40,
                                                 KL_CHANGE_MONTH_BUTTON_WIDTH, 
                                                 KL_CHANGE_MONTH_BUTTON_HEIGHT);
    UIButton *previousMonthButton = [[UIButton alloc] initWithFrame:previousMonthButtonFrame];
    [previousMonthButton setImage:[UIImage imageNamed:@"left-arrow.png"] forState:UIControlStateNormal];
    previousMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    previousMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [previousMonthButton addTarget:self action:@selector(showPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:previousMonthButton];
    [previousMonthButton release];
    
    // Draw the selected month name centered and at the top of the view	
    CGRect selectedMonthLabelFrame = CGRectMake((self.bounds.size.width/2.0f) - (KL_SELECTED_MONTH_WIDTH/2.0f),
                                                self.bounds.origin.y + 40, 
                                                KL_SELECTED_MONTH_WIDTH, 
                                                KL_HEADER_HEIGHT);
    _selectedMonthLabel = [[UILabel alloc] initWithFrame:selectedMonthLabelFrame];
    _selectedMonthLabel.textColor = [UIColor darkGrayColor];
    _selectedMonthLabel.backgroundColor = [UIColor clearColor];
    _selectedMonthLabel.font = [UIFont boldSystemFontOfSize:KL_HEADER_FONT_SIZE];
    _selectedMonthLabel.textAlignment = UITextAlignmentCenter;
    [self addSubview:_selectedMonthLabel];
    
	// Create the next month button on the right side of the view
    CGRect nextMonthButtonFrame = CGRectMake(self.bounds.size.width - KL_CHANGE_MONTH_BUTTON_WIDTH * 2, 
                                             self.bounds.origin.y + 40, 
                                             KL_CHANGE_MONTH_BUTTON_WIDTH, 
                                             KL_CHANGE_MONTH_BUTTON_HEIGHT);
    UIButton *nextMonthButton = [[UIButton alloc] initWithFrame:nextMonthButtonFrame];
    [nextMonthButton setImage:[UIImage imageNamed:@"right-arrow.png"] forState:UIControlStateNormal];
    nextMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    nextMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [nextMonthButton addTarget:self action:@selector(showFollowingMonth) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextMonthButton];
    [nextMonthButton release];
	
	
    // Create the next month button on the right side of the view
    CGRect nextYearButtonFrame = CGRectMake(self.bounds.size.width - KL_CHANGE_MONTH_BUTTON_WIDTH, 
											self.bounds.origin.y + 40, 
											KL_CHANGE_MONTH_BUTTON_WIDTH, 
											KL_CHANGE_MONTH_BUTTON_HEIGHT);
    UIButton *nextYearButton = [[UIButton alloc] initWithFrame:nextYearButtonFrame];
    [nextYearButton setImage:[UIImage imageNamed:@"right-duparrow.png"] forState:UIControlStateNormal];
    nextYearButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    nextYearButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [nextYearButton addTarget:self action:@selector(showFollowingYear) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextYearButton];
    [nextYearButton release];
	
	[self addSubview:self.calendarContainer];
	//	[calendarContainer release];
}

// --------------------------------------------------------------------------------------------
//      showPreviousMonth
// 
//      Triggered whenever the previous button is tapped or when a date in
//      the previous month is tapped. Selects the previous month and updates the view.
//      Note that it is disabled while the calendar is in editing mode.
//
- (void)showPreviousMonth
{   
    [calendarModel decrementMonth];
	[self refreshViewWithPushDirection:kCATransitionFromLeft];
}

// --------------------------------------------------------------------------------------------
//      showFollowingMonth
// 
//      Triggered whenever the 'next' button is tapped or when a date in
//      the following month is tapped. Selects the next month and updates the view.
//      Note that it is disabled while the calendar is in editing mode.
//

- (void)showFollowingMonth
{	
    [calendarModel incrementMonth];
	[self refreshViewWithPushDirection:kCATransitionFromRight];
	//	[self setNeedsDisplay];
}

// --------------------------------------------------------------------------------------------
//      showPreviousMonth
// 
//      Triggered whenever the previous button is tapped or when a date in
//      the previous month is tapped. Selects the previous month and updates the view.
//      Note that it is disabled while the calendar is in editing mode.
//
- (void)showPreviousYear
{   
    [calendarModel decrementYear];
    [self.julgi release];
    self.julgi = [[NSMutableDictionary alloc] init];
    [self termsWithYear:[calendarModel selectedYear] andMonth:nil andLength:nil];
	[self refreshViewWithPushDirection:kCATransitionFromTop];
	//	[self setNeedsDisplay];
}

// --------------------------------------------------------------------------------------------
//      showFollowingMonth
// 
//      Triggered whenever the 'next' button is tapped or when a date in
//      the following month is tapped. Selects the next month and updates the view.
//      Note that it is disabled while the calendar is in editing mode.
//

- (void)showFollowingYear
{	
    [calendarModel incrementYear];
    [self.julgi release];
    self.julgi = [[NSMutableDictionary alloc] init];
    [self termsWithYear:[calendarModel selectedYear] andMonth:nil andLength:nil];
	[self refreshViewWithPushDirection:kCATransitionFromBottom];
	//	[self setNeedsDisplay];
}


// --------------------------------------------------------------------------------------------
//      refreshViewWithPushDirection:
// 
//      Triggered when the calendar is first created and whenever the selected month changes.
//
- (void)refreshViewWithPushDirection:(NSString *)caTransitionSubtype
{
    // Update the header month and year
    _selectedMonthLabel.text = [NSString stringWithFormat:@"%@ %ld", [calendarModel selectedMonthName], (long)[calendarModel selectedYear]];
	
	
    if (!caTransitionSubtype) {   // refresh without animation
		[self addButtonArray];
		[self drawCalendarBody];
		
        return;
    }
    
    // Configure the animation for sliding the tiles in
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];
    [CATransaction setValue:[NSNumber numberWithFloat:0.5f] forKey:kCATransactionAnimationDuration];
    
    CATransition *push = [CATransition animation];
	/*
	 Animation type List
	 
	 - pageCurl
	 - pageUnCurl
	 - suckEffect
	 - spewEffect
	 - cameraIris
	 - cameraIrisHollowOpen
	 - unGenieEffect
	 - cameraIrisHollowClose
	 - genieEffect
	 - rippleEffect
	 - twist
	 - tubey
	 - swirl
	 - charminUltra
	 - zoomIn
	 - zoomOut
	 - oglFlip
	 */
	/*	
	 - Common Transition Types
	 NSString * const kCATransitionFade;
	 NSString * const kCATransitionMoveIn;
	 NSString * const kCATransitionPush;
	 NSString * const kCATransitionReveal;
	 
	 -Common Transition Subtypes
	 NSString * const kCATransitionFromRight;
	 NSString * const kCATransitionFromLeft;
	 NSString * const kCATransitionFromTop;
	 NSString * const kCATransitionFromBottom;
	 */
	
	
	
	[push setType:@"pageCurl"];
	//    push.type = kCATransitionPush;
    push.subtype = caTransitionSubtype;
	
    [self.calendarContainer.layer addAnimation:push forKey:kCATransition];
    [self removeAllButtons];
	[self addButtonArray];
	Debug(@"refreshViewWithPushDirection [self addButtonArray];");
	[self drawCalendarBody];
    
    [CATransaction commit];
	
}

- (void)removeAllButtons {
	for (NSInteger i = 0; i < [self.dateButtons count]; i++) {
		//		UIButton *lDateButton = [self.dateButtons objectAtIndex:i];
		[[self.dateButtons objectAtIndex:i] retain];
		Debug(@"removeAllButtons - dateButton.retainCout = %d", [[self.dateButtons objectAtIndex:i] retainCount]);
		[[self.dateButtons objectAtIndex:i] removeFromSuperview];
		
	}
	[self.dateButtons removeAllObjects];
	//	Debug(@"removeAllButtons - dateButtons.retainCout = %d", [dateButtons retainCount]);	
	[self.dates removeAllObjects];
}

- (void)addButtonArray {
	
	NSInteger prevMonthDays = [[calendarModel daysInFinalWeekOfPreviousMonth] count];
	NSInteger currentMonthDays = [[calendarModel daysInSelectedMonth] count];
	//	NSInteger nextMonthDays = [[calendarModel daysInFirstWeekOfFollowingMonth] count];
	
	[self.dates addObjectsFromArray:[calendarModel daysInFinalWeekOfPreviousMonth]];
	[self.dates addObjectsFromArray:[calendarModel daysInSelectedMonth]];
	[self.dates addObjectsFromArray:[calendarModel daysInFirstWeekOfFollowingMonth]];
	
    NSInteger yyyy = [calendarModel selectedYear];
    
    if (prevYear != yyyy) {
        [self.julgi release];
        self.julgi = [[NSMutableDictionary alloc] init];
        [self termsWithYear:yyyy andMonth:nil andLength:nil];
        Debug(@"self.julgi =  %@", self.julgi);
    }
    
	//	
	NSInteger i = 0;
	
	for (KLDate *date in self.dates) {
		CalendarButton *lDateButton = [CalendarButton buttonWithType:UIButtonTypeCustom];
		MCLunarDate *lunarDate = [calendarModel sol2lunYear:[date yearOfCommonEra] Month:[date monthOfYear] Day:[date dayOfMonth]];	
		[lDateButton setKlDate:date];		
		[lDateButton setLunarDate:lunarDate];
		//이벤트 데이터 불러오기 ////////////////////////////////////////////////////////////////		
		NSInteger y = [date yearOfCommonEra];
		NSInteger m = [date monthOfYear];
		NSInteger d = [date dayOfMonth];
		
		//inputFormatter 에 지정한 형식대로 NSDate 가 생성된다.
		NSString *holy = @"OFF";	
		NSString *lunar = @"OFF";
		NSInteger badgeCount = 0;
		
		
		[self fetchRequestResult:[NSString stringWithFormat:@"%d. %d. %d.", y, m, d]  withEntity:@"EventData" andProperty:@"eventdate"];
		[self fetchRequestResult:[NSString stringWithFormat:@"%d. %d. %d.", y, m, d]  withEntity:@"DiaryData" andProperty:@"writedate"];
		
        //		[self fetchRequestResult:nil  withEntity:@"ChildData" andProperty:@"birthdaySolar"];
		
		NSMutableDictionary *anniversaryData = [annData objectForKey:[NSString stringWithFormat:@"%d. %d.", m, d]];
		NSMutableDictionary *addDic = [[NSMutableDictionary alloc] init];
		if ([anniversaryData count] > 0) {
			NSArray *keys = [anniversaryData allKeys];
			
			
			for (NSInteger k = 0; k < [keys count]; k++) {		
				NSMutableDictionary *tempDic = [anniversaryData objectForKey:[keys objectAtIndex:k]];
				lunar = [tempDic objectForKey:@"lunar"];
				
				
				if (![lunar isEqualToString:@"ON"]) {
					holy = [tempDic objectForKey:@"holy"];
					if ([holy isEqualToString:@"OFF"]) {
						holy = [tempDic objectForKey:@"holy"];
					}
					
					[addDic setObject:tempDic forKey:[keys objectAtIndex:k]];
				}
				
			}
			
			//			lDateButton.anniversaryDic = addDic;
			//			[addDic release];
		}
		
		
		NSMutableDictionary *anniversaryDataLun = [annData objectForKey:[NSString stringWithFormat:@"%d. %d.", lDateButton.lunarDate.lunarMonth, lDateButton.lunarDate.lunarDay]];		
		if ([anniversaryDataLun count] > 0) {
			NSArray *keys = [anniversaryDataLun allKeys];
			
			//			NSMutableDictionary *addDic = [[NSMutableDictionary alloc] init];
			for (NSInteger k = 0; k < [keys count]; k++) {
				NSMutableDictionary *tempDic = [anniversaryDataLun objectForKey:[keys objectAtIndex:k]];
				lunar = [tempDic objectForKey:@"lunar"];
				
				if ([lunar isEqualToString:@"ON"]) {
					holy = [tempDic objectForKey:@"holy"];
					if ([holy isEqualToString:@"OFF"]) {
						holy = [tempDic objectForKey:@"holy"];
					}
					
					[addDic setObject:tempDic forKey:[keys objectAtIndex:k]];
				}
			}
			
			//			lDateButton.anniversaryDic = addDic;
			//			[addDic release];
		}
		
		lDateButton.anniversaryDic = addDic;
		[addDic release];
		
		
		
		if ([eventDatas count] > 0) {
			NSArray *dataArray = [[[NSArray alloc] initWithArray:eventDatas] autorelease];
			lDateButton.eventArray = dataArray;
		}
		
		if ([diaryDatas count] > 0) {
			NSArray *dataArray = [[[NSArray alloc] initWithArray:diaryDatas] autorelease];
			lDateButton.diaryArray = dataArray;
		}
		
		//		if (d == 26) {
		//			Debug(@"eventDatas.count = %d", [eventDatas count]);
		//		}
		
		/////////////////////////////////////////////////////////////////////////////////////
		
		//음력 날짜 설정
		UILabel *lunarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 27.0f, 44.0f, 20.0f)];
		
		[lunarLabel setBackgroundColor:[UIColor clearColor]];
		
		lunarLabel.textAlignment = UITextAlignmentCenter;
		
		//날짜 타이틀 세팅	
		lDateButton.titleLabel.font = [UIFont systemFontOfSize:16];
		lDateButton.titleLabel.shadowOffset = CGSizeMake(1.0, 0.0);			
		lDateButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		
		[lDateButton setTitle:[NSString stringWithFormat:@"%d  ", [date dayOfMonth]] forState:UIControlStateNormal];
		
        NSString *header = @"";
        NSString *julgiStr = [self.julgi valueForKey:[NSString stringWithFormat:@"%d/%d", m, d]];
        
        Debug(@"julgi date = %d/%d : julgiStr = %@", m, d, julgiStr);
        
		if (i < prevMonthDays || i >= (prevMonthDays + currentMonthDays)) {
			lunarLabel.textColor = [UIColor lightGrayColor];
			[lDateButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
			
			if (i < prevMonthDays) {
				[lDateButton addTarget:self action:@selector(showPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
			} else {
				[lDateButton addTarget:self action:@selector(showFollowingMonth) forControlEvents:UIControlEventTouchUpInside];
			}
			
		} else {
			if (julgiStr != nil && ![julgiStr isEqualToString:@""]) {
				lunarLabel.textColor = [UIColor blueColor];
			} else {
				lunarLabel.textColor = [UIColor darkGrayColor];
			}
			
			
			
			[lDateButton addTarget:self action:@selector(selectedDateButton:) forControlEvents:UIControlEventTouchUpInside];
			if (i % 7 == 0) {
				[lDateButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			} else if (i % 7 == 6) {
				//				if ([holy isEqualToString:@"ON"]) {
				//					[lDateButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
				//				} else {
				[lDateButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
				//				}
			} else {
				//				if ([holy isEqualToString:@"ON"]) {
				//					[lDateButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
				//				} else {
				[lDateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
				//				}
			}		
		}
        
        
        if (julgiStr == nil || [julgiStr isEqualToString:@""]) {
            header = [header stringByAppendingFormat:@"%d/%d", lDateButton.lunarDate.lunarMonth, lDateButton.lunarDate.lunarDay];
            lDateButton.todayJulgi = @"";
        } else {
            header = [header stringByAppendingString:julgiStr];
            lDateButton.todayJulgi = julgiStr;
        }
        
        //		NSString *header = [lDateButton.klDate todayJeulgi] != @""?[lDateButton.klDate todayJeulgi] : [NSString stringWithFormat:@"%d/%d", lDateButton.lunarDate.lunarMonth, lDateButton.lunarDate.lunarDay];
        
        
		UIFont *lunarFont = nil;
		if ([eventDatas count] > 0 && [diaryDatas count] <= 0 && [lDateButton.anniversaryDic count] <= 0) {
			if ([date isToday]) {			
				[lDateButton setBackgroundImage:[UIImage imageNamed:@"TE.png"] forState:UIControlStateNormal];
			} else {	
				[lDateButton setBackgroundImage:[UIImage imageNamed:@"E.png"] forState:UIControlStateNormal];	
			}
		} else if ([eventDatas count] <= 0 && [diaryDatas count] > 0 && [lDateButton.anniversaryDic count] <= 0) {
			if ([date isToday]) {			
				[lDateButton setBackgroundImage:[UIImage imageNamed:@"TD.png"] forState:UIControlStateNormal];
			} else {	
				[lDateButton setBackgroundImage:[UIImage imageNamed:@"D.png"] forState:UIControlStateNormal];	
			}
		} else if ([eventDatas count] <= 0 && [diaryDatas count] <= 0 && [lDateButton.anniversaryDic count] > 0) {
			if ([date isToday]) {			
				[lDateButton setBackgroundImage:[UIImage imageNamed:@"TA.png"] forState:UIControlStateNormal];
			} else {	
				[lDateButton setBackgroundImage:[UIImage imageNamed:@"A.png"] forState:UIControlStateNormal];	
			}
			
			if ([holy isEqualToString:@"ON"]) {
				[lDateButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			}
		} else if ([eventDatas count] > 0 && [diaryDatas count] > 0 && [lDateButton.anniversaryDic count] > 0) {
			if ([date isToday]) {			
				[lDateButton setBackgroundImage:[UIImage imageNamed:@"TAED.png"] forState:UIControlStateNormal];
			} else {	
				[lDateButton setBackgroundImage:[UIImage imageNamed:@"AED.png"] forState:UIControlStateNormal];	
			}
			
			if ([holy isEqualToString:@"ON"]) {
				[lDateButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			}
		} else if ([eventDatas count] > 0 && [diaryDatas count] > 0 && [lDateButton.anniversaryDic count] <= 0) {
			if ([date isToday]) {			
				[lDateButton setBackgroundImage:[UIImage imageNamed:@"TED.png"] forState:UIControlStateNormal];
			} else {	
				[lDateButton setBackgroundImage:[UIImage imageNamed:@"ED.png"] forState:UIControlStateNormal];	
			}
		} else if ([eventDatas count] > 0 && [diaryDatas count] <= 0 && [lDateButton.anniversaryDic count] > 0) {
			if ([date isToday]) {			
				[lDateButton setBackgroundImage:[UIImage imageNamed:@"TAE.png"] forState:UIControlStateNormal];
			} else {	
				[lDateButton setBackgroundImage:[UIImage imageNamed:@"AE.png"] forState:UIControlStateNormal];	
			}
			
			if ([holy isEqualToString:@"ON"]) {
				[lDateButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			}
		} else if ([eventDatas count] <= 0 && [diaryDatas count] > 0 && [lDateButton.anniversaryDic count] > 0) {
			if ([date isToday]) {			
				[lDateButton setBackgroundImage:[UIImage imageNamed:@"TAD.png"] forState:UIControlStateNormal];
			} else {	
				[lDateButton setBackgroundImage:[UIImage imageNamed:@"AD.png"] forState:UIControlStateNormal];	
			}
			
			if ([holy isEqualToString:@"ON"]) {
				[lDateButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			}
		} else {
			if ([date isToday]) {			
				[lDateButton setBackgroundImage:[UIImage imageNamed:@"today.png"] forState:UIControlStateNormal];
			} else {	
				[lDateButton setBackgroundImage:[UIImage imageNamed:@"calendarButton.png"] forState:UIControlStateNormal];	
			}
		}
		
		lunarFont = [UIFont fontWithName:@"Arial" size:11.0f];
		lunarLabel.text = header;
		lunarLabel.font = lunarFont;
		
		//		if ([date isToday]) {
		//			badgeCount += [lDateButton.anniversaryDic count];
		//			badgeCount += [lDateButton.diaryArray count];
		//			badgeCount += [lDateButton.eventArray count];
		
		//			Debug(@"badgeCount = %d", badgeCount);
		//			[[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeCount];
		//		}
		
		//음력 명절 설정		///////////////////////////////////////////////////////////////////////////////////////////
		if (lDateButton.lunarDate.lunarMonth == 8) {
			if (lDateButton.lunarDate.lunarDay == 14 || lDateButton.lunarDate.lunarDay == 16) {
				[lDateButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			} else if (lDateButton.lunarDate.lunarDay == 15) {
				lunarLabel.textColor = [UIColor redColor];
				[lDateButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
				lunarLabel.text = @"추석";
			}
		} else if (lDateButton.lunarDate.lunarMonth == 1 && (lDateButton.lunarDate.lunarDay == 1 || lDateButton.lunarDate.lunarDay == 2)) {
			[lDateButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			if (lDateButton.lunarDate.lunarDay == 1) {
				lunarLabel.textColor = [UIColor redColor];
				lunarLabel.text = @"설날";
			}
		} else if (lDateButton.lunarDate.lunarMonth == 12 && lDateButton.lunarDate.lunarDay == 30) {
			[lDateButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
		}
		
		
		//음력 명절 설정		///////////////////////////////////////////////////////////////////////////////////////////
		[lDateButton setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
		lDateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
		lDateButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
		[lDateButton addSubview:lunarLabel];
		
		//버튼 이미지 설정
		
		//		lDateButton.opaque = NO;
		//		lDateButton.alpha = 0.2f;
		
		
		[self.dateButtons addObject:lDateButton];
		Debug(@"before addButtonArray - dateButton.retainCout = %d", [lDateButton retainCount]);
		Debug(@"addButtonArray - dateButtons.retainCout = %d", [self.dateButtons retainCount]);
		//		Debug(@"lunarDate.retaincount = %d", [lunarDate retainCount]);
		
		[lDateButton release];
		Debug(@"after addButtonArray - dateButton.retainCout = %d", [lDateButton retainCount]);
		//		Debug(@"lunarLabel.retaincount = %d", [lunarLabel retainCount]);
		[lunarLabel release];
		//		Debug(@"after release lunarLabel.retaincount = %d", [lunarLabel retainCount]);
		//		[lunarDate release];	
		i++;
	}
}

- (void)drawCalendarBody {
	NSInteger row = 0;
	NSInteger col = 0;
	NSInteger i = 0;
	
	UIView *container = nil;
	CalendarButton *lDateButton = nil;
	Debug(@"drawCalendarBody - self.dateButtons.count = %d", [self.dateButtons count]);
	for (lDateButton in self.dateButtons) {
		Debug(@"drawCalendarBody - lDateButton.retainCount = %d", [lDateButton retainCount]);
		//		lDateButton.frame = CGRectMake(0, 0, 44.0f, 44.0f);
		lDateButton.frame = CGRectMake(col * 44 + 6, row * 44, 44.0f, 44.0f);
		
		//		container = [[UIView alloc] init]; //WithFrame:lDateButton.frame
		//		container.frame = CGRectMake(col * 44 + 6, row * 44, 44.0f, 44.0f);
		//		container.opaque = YES;		
		//		container.backgroundColor = [UIColor clearColor];
		//		[container addSubview:lDateButton];
		
		//		[self.calendarContainer addSubview:container];
		[self.calendarContainer addSubview:lDateButton];
		
		//		[container release];
		//		[lDateButton release];
		col++;
		if (col == 7) {
			row++;
			col = 0;
		}
		i++;
	}	
	//	[container release];
	//	Debug(@"container.retaincount = %d", [container retainCount]);
	Debug(@"lDateButton.retaincount = %d", [lDateButton retainCount]);
	[lDateButton release];
}

-(void)redrawSelf
{
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
	[super drawRect:rect];
	UIImage *img = [UIImage imageNamed: @"main_background.png"];
	[img drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	//	[self drawGradientHeaderInContext:ctx];
    [self drawDayNamesInContext:ctx];
	
}

#pragma mark -
#pragma mark Fetched results controller

- (void)fetchRequestResult:(NSString *)date withEntity:(NSString *)ent andProperty:(NSString *)prop {
	//	Debug(@"section count = %d", [[fetchedResultsController sections] count]);
	
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:0];
	//	Debug(@"row count = %d", [sectionInfo numberOfObjects]);
	
	NSPredicate *predicate = nil;
	
	if (date != nil) {
		predicate = [NSPredicate predicateWithFormat:@"conditionDate == %@", date];
	}
	
	[fetchedResultsController.fetchRequest setPredicate:predicate];
	
	managedObjectContext = [fetchedResultsController managedObjectContext];
	
	//	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchedResultsController.fetchRequest setEntity:[NSEntityDescription entityForName:ent inManagedObjectContext:managedObjectContext]];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:prop ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
	[fetchedResultsController.fetchRequest setSortDescriptors:sortDescriptors];
	
	NSError *error;
	
	if ([ent isEqualToString:@"EventData"]) {
		eventDatas = [managedObjectContext executeFetchRequest:fetchedResultsController.fetchRequest error:&error];
	} else if ([ent isEqualToString:@"DiaryData"]) {
		diaryDatas = [managedObjectContext executeFetchRequest:fetchedResultsController.fetchRequest error:&error];
	} else if ([ent isEqualToString:@"ChildData"]) {
		childDatas = [managedObjectContext executeFetchRequest:fetchedResultsController.fetchRequest error:&error];
	}
    
	
	
	//	[fetchRequest release];
	[sortDescriptor release];
	[sortDescriptors release];
	//	Debug(@"self.eventDatas count = %d, date = %@", [eventDatas count], date);
}

/**
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController {
	//    Debug(@"fetchedResultsController");
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
	// Create and configure a fetch request with the Book entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"EventData" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Create the sort descriptors array.
	NSSortDescriptor *birthdayDescriptor = [[NSSortDescriptor alloc] initWithKey:@"eventdate" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:birthdayDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
	self.fetchedResultsController = aFetchedResultsController;
	fetchedResultsController.delegate = self;
	
	// Memory management.
	[aFetchedResultsController release];
	[fetchRequest release];
	[birthdayDescriptor release];
	[sortDescriptors release];
	
	return fetchedResultsController;
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

- (void)dealloc {
	[dates release];
	[dateButtons release];
	[self.calendarContainer release];
	[calendarModel release];
	[_selectedMonthLabel release];
	
	[fetchedResultsController release];
	[managedObjectContext release];
	[eventDatas release];
	[dateFormatter release];
	
	[calendarContainer release];
	
	[childDatas release];
	[diaryDatas release];
	[anniversaryDatas release];
	
	[annData release];
	[tempData release];
	
    [hterms release];
    [julgi release];
    [super dealloc];
}

#pragma mark -
#pragma mark JULGI Methods
- (NSArray *) tterms:(NSString *)year {
    NSDictionary *addstime = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInteger:1545], @"1902", [NSNumber numberWithInteger:1734], @"1903", 
                              [NSNumber numberWithInteger:1740], @"1904", [NSNumber numberWithInteger:475], @"1906", 
                              [NSNumber numberWithInteger:432], @"1907", [NSNumber numberWithInteger:480], @"1908", 
                              [NSNumber numberWithInteger:462],@"1909",  [NSNumber numberWithInteger:-370], @"1915", 
                              [NSNumber numberWithInteger:-332], @"1916", [NSNumber numberWithInteger:-335], @"1918", 
                              [NSNumber numberWithInteger:-263],@"1919",  [NSNumber numberWithInteger:340], @"1925", 
                              [NSNumber numberWithInteger:344], @"1927", [NSNumber numberWithInteger:2133], @"1928", 
                              [NSNumber numberWithInteger:2112],@"1929",  [NSNumber numberWithInteger:2100], @"1930", 
                              [NSNumber numberWithInteger:1858], @"1931", [NSNumber numberWithInteger:-400], @"1936", 
                              [NSNumber numberWithInteger:-400], @"1937", [NSNumber numberWithInteger:-342], @"1938", 
                              [NSNumber numberWithInteger:-300], @"1939", [NSNumber numberWithInteger:365], @"1944", 
                              [NSNumber numberWithInteger:380], @"1945", [NSNumber numberWithInteger:400], @"1946", 
                              [NSNumber numberWithInteger:200], @"1947", [NSNumber numberWithInteger:244], @"1948", 
                              [NSNumber numberWithInteger:-266], @"1953", [NSNumber numberWithInteger:2600], @"1954", 
                              [NSNumber numberWithInteger:3168], @"1955", [NSNumber numberWithInteger:3218],@"1956", 
                              [NSNumber numberWithInteger:3366], @"1957", [NSNumber numberWithInteger:3300], @"1958", 
                              [NSNumber numberWithInteger:3483], @"1959", [NSNumber numberWithInteger:2386], @"1960", 
                              [NSNumber numberWithInteger:3015], @"1961", [NSNumber numberWithInteger:2090], @"1962", 
                              [NSNumber numberWithInteger:2090], @"1963", [NSNumber numberWithInteger:2264], @"1964", 
                              [NSNumber numberWithInteger:2370], @"1965", [NSNumber numberWithInteger:2185], @"1966", 
                              [NSNumber numberWithInteger:2144], @"1967", [NSNumber numberWithInteger:1526], @"1968", 
                              [NSNumber numberWithInteger:-393], @"1971", [NSNumber numberWithInteger:-430], @"1972", 
                              [NSNumber numberWithInteger:-445], @"1973", [NSNumber numberWithInteger:-543], @"1974", 
                              [NSNumber numberWithInteger:-393], @"1975", [NSNumber numberWithInteger:300], @"1980", 
                              [NSNumber numberWithInteger:490], @"1981", [NSNumber numberWithInteger:400], @"1982", 
                              [NSNumber numberWithInteger:445], @"1983", [NSNumber numberWithInteger:393], @"1984", 
                              [NSNumber numberWithInteger:-1530], @"1987", [NSNumber numberWithInteger:-1600], @"1988", 
                              [NSNumber numberWithInteger:-362], @"1990", [NSNumber numberWithInteger:-366], @"1991", 
                              [NSNumber numberWithInteger:-400], @"1992", [NSNumber numberWithInteger:-449], @"1993", 
                              [NSNumber numberWithInteger:-321], @"1994", [NSNumber numberWithInteger:-344], @"1995", 
                              [NSNumber numberWithInteger:356], @"1999", [NSNumber numberWithInteger:480], @"2000",  
                              [NSNumber numberWithInteger:483], @"2001", [NSNumber numberWithInteger:504], @"2002", 
                              [NSNumber numberWithInteger:294], @"2003", [NSNumber numberWithInteger:-206], @"2007", 
                              [NSNumber numberWithInteger:-314], @"2008", [NSNumber numberWithInteger:-466], @"2009", 
                              [NSNumber numberWithInteger:-416], @"2010", [NSNumber numberWithInteger:-457], @"2011", 
                              [NSNumber numberWithInteger:-313], @"2012", [NSNumber numberWithInteger:347], @"2018", 
                              [NSNumber numberWithInteger:257], @"2020", [NSNumber numberWithInteger:351], @"2021", 
                              [NSNumber numberWithInteger:159], @"2022", [NSNumber numberWithInteger:177], @"2023", 
                              [NSNumber numberWithInteger:-134], @"2026", [NSNumber numberWithInteger:-340], @"2027", 
                              [NSNumber numberWithInteger:-382], @"2028", [NSNumber numberWithInteger:-320], @"2029", 
                              [NSNumber numberWithInteger:-470], @"2030", [NSNumber numberWithInteger:-370], @"2031", 
                              [NSNumber numberWithInteger:-373], @"2032", [NSNumber numberWithInteger:349], @"2036", 
                              [NSNumber numberWithInteger:523], @"2037", nil];
    
    NSDictionary *addttime = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:-160], [NSNumber numberWithInteger:-14], nil], @"1919", 
                              [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:-508], [NSNumber numberWithInteger:10], nil], @"1939", 
                              [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:220], [NSNumber numberWithInteger:0], nil], @"1953", 
                              [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:-2973], [NSNumber numberWithInteger:1], nil], @"1954", 
                              [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:241], [NSNumber numberWithInteger:18], nil], @"1982", 
                              [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:-2455], [NSNumber numberWithInteger:13], nil], @"1988", 
                              [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:356], [NSNumber numberWithInteger:6], nil], @"2013",  
                              [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:411], [NSNumber numberWithInteger:20], nil], @"2031", 
                              [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:399], [NSNumber numberWithInteger:0], [NSNumber numberWithInteger:-571], [NSNumber numberWithInteger:11], nil], @"2023", nil];
    
    return [NSArray arrayWithObjects:[addstime objectForKey:year], [addttime objectForKey:year], nil];
}

- (NSInteger) moon2valid:(NSInteger)moon
{
    //$moon = max($moon,1);
    //$moon = min($moon,12);
    NSInteger m = moon;
    if(m < 1) m = 1;
    else if(m > 12) m = 12;
    
    return m;
}

//PHP의 fmod에 해당하는 함수
- (double) fmodWithX:(double) x andY:(double) y {
    int div = floor(x / y);
    
    return x - div * y;
}

- (double) deg2valid:(double) deg
{
    //if($deg <= 360 && $deg >=0) return $deg;
    //    double d = deg;
    double d = 0.0;
    
    if (deg >= 0) {
        d = [self fmodWithX:deg andY:360.0];
    } else {
        d = [self fmodWithX:deg andY:360.0]+360.0;
    }
    //(deg >= 0) ? deg % 360 : (deg % 360)+360.0;
    
    return d; // float degress
}

- (double) deg2solartime:(double)deg
{
    double retVal = [[NSString stringWithFormat:@"%.4f", deg*87658.1256] doubleValue];
    return retVal;
}

- (NSArray *) sunlWithUTime:(long)utime andGMT:(BOOL)GMT //($utime, $GMT=FALSE, $D=0, $JD=0, $J='', $deg2rad=array())
{
    if(GMT) utime += 32400; // force GMT to static KST, see 946727936
    
    double D = utime - 946727936; // number of time
    NSString *strD = [NSString stringWithFormat:@"%.10f", D/86400]; //  sprintf('%.10f',$D/86400); // float, number of days
    
    NSString *strg = [NSString stringWithFormat:@"%.10f", 357.529 + (0.98560028 * [strD doubleValue])];
    NSString *strq = [NSString stringWithFormat:@"%.10f", 280.459 + (0.98564736 * [strD doubleValue])];
    
    //## fixed
    //##
    double g = [self deg2valid:[strg doubleValue]]; // to valid degress
    double q = [self deg2valid:[strq doubleValue]]; // to valid degress
    //## convert
    //##
    NSArray *deg2rad = [NSArray arrayWithObjects:[NSNumber numberWithDouble:(g * M_PI / 180)], [NSNumber numberWithDouble:(g * 2 * M_PI / 180)], nil];
    
    double sing = sin((g * M_PI / 180)); // degress
    double sin2g = sin((g * 2 * M_PI / 180)); // degress
    //## L is an approximation to the Sun's geocentric apparent ecliptic longitude
    //##
    NSString *strL = [NSString stringWithFormat:@"%.10f", q + (1.915 * sing) + (0.020*sin2g)]; // sprintf('%.10f',$q + (1.915 * $sing) + (0.020*$sin2g)); 
    
    double L = [self deg2valid:[strL doubleValue]]; // degress
    double atime = [self deg2solartime:round(L)-L]; // float
    
    return [NSArray arrayWithObjects:[NSNumber numberWithDouble:L], [NSNumber numberWithDouble:atime], nil]; //array($L,$atime); // array, float degress, float seconds
}

- (void) termsWithYear:(NSInteger)y andMonth:(NSInteger)m andLength:(NSInteger)l {
    NSInteger year  = y;
    //    NSArray *sun = [[NSArray alloc] init];
    NSInteger smoon = m;
    NSInteger length = l;
    //    NSMutableArray *times = [[NSMutableArray alloc] init];
    NSDictionary *julgiDic = [[[NSDictionary alloc] init] autorelease];
    //    $times = array();
    
    if (!year) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy"];
        
        year = [[formatter stringFromDate:[NSDate date]] integerValue];
        [formatter release];
    }
    
    if (l == nil) {
        length = 12;
    }
    
    if (m == nil) {
        smoon = 1;
    }
    //    if(!$year) $year = date('Y');
    
    /***
     if($year<1902 || $year>2037)
     {
     echo "\nerror: invalid input $year, 1902 <= year <= 2037\n";
     return -1;
     }
     ***/
    
    //    list($hterms,$tterms) = solar::gterms();
    //    list($addstime,$addttime) = solar::tterms($year);
    
    //## mktime(7+9,36,19-64,3,20,2000), 2000-03-20 16:35:15(KST)
    //##
    long start = __SOLAR_START__; // start base unix timestamp
    long tyear = __SOLAR_TYEAR__; // tropicalyear to seconds
    long byear = __SOLAR_BYEAR__; // start base year
    
    start += (year - byear) * tyear;
    
    if(length < -12) length = -12;
    else if(length > 12) length = 12;
    
    smoon = [self moon2valid:smoon];
    NSInteger emoon = [self moon2valid:smoon+length];
    
    NSInteger sidx =  (min(smoon,emoon) - 1) * 2;
    NSInteger eidx = ((max(smoon,emoon) - 1) * 2) + 1;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M/d"];
    for(int i=sidx; i<=eidx; i++)
    {
        NSArray *ttermsArr = [self tterms:[NSString stringWithFormat:@"%d", year]];
        
        double time = start + tterms[i]; // $tterms[$i];
        double atime = [[[self sunlWithUTime:time andGMT:NO] objectAtIndex:1] doubleValue];
        if ([ttermsArr count] > 1) {
            NSDictionary *addttimeDic = [ttermsArr objectAtIndex:1];
            time += atime + [[ttermsArr objectAtIndex:0] longValue] + [[addttimeDic objectForKey:[NSNumber numberWithInteger:i]] integerValue];// $addttime[$i]; // re-fixed
        } else if ([ttermsArr count] == 1) {
            time += atime + [[ttermsArr objectAtIndex:0] longValue];// $addttime[$i]; // re-fixed
        } else {
            time += atime;
        }
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
        
        Debug(@"date = %@ : julgi = %@", [formatter stringFromDate:date], [self.hterms objectAtIndex:i]);
        NSString *keyStr = [formatter stringFromDate:date];
        [self.julgi setValue:[self.hterms objectAtIndex:i] forKey:keyStr];
        //       $terms[calendar::_date('nd',$time)] = &$hterms[$i];
        //       $times[] = $time; // fixed utime
    }
    [formatter release];
}
@end
