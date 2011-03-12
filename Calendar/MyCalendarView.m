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


- (id)initWithFrame:(CGRect)frame  delegate:(id <MyCalendarViewDelegate>)aDelegate withManagedObjectContext:managedObjectContext{
    if (self = [super initWithFrame:frame]) {
        // Initialization code
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
		
		if (i < prevMonthDays || i >= (prevMonthDays + currentMonthDays)) {
			lunarLabel.textColor = [UIColor lightGrayColor];
			[lDateButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
			
			if (i < prevMonthDays) {
				[lDateButton addTarget:self action:@selector(showPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
			} else {
				[lDateButton addTarget:self action:@selector(showFollowingMonth) forControlEvents:UIControlEventTouchUpInside];
			}
			
		} else {
			if ([lDateButton.klDate todayJeulgi] != @"") {
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
		
		NSString *header = [lDateButton.klDate todayJeulgi] != @""?[lDateButton.klDate todayJeulgi] : [NSString stringWithFormat:@"%d/%d", lDateButton.lunarDate.lunarMonth, lDateButton.lunarDate.lunarDay];
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
	
    [super dealloc];
}


@end
