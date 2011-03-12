//
//  MyCalendarView.h
//  MyCalendarTest
//
//  Created by HYOUNG JUN WOO on 10. 4. 18..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "KLDate.h"
#import "MCLunarDate.h"
#import "CalendarButton.h"

#import "ChildData.h"
#import "DiaryData.h"
#import "EventData.h"
#import "AnniversaryData.h"

#import "iPhotoDiaryAppDelegate.h"

#define KL_CHANGE_MONTH_BUTTON_WIDTH    44.0f
#define KL_CHANGE_MONTH_BUTTON_HEIGHT   32.0f
#define KL_SELECTED_MONTH_WIDTH        200.0f
#define KL_HEADER_HEIGHT                27.0f
#define KL_HEADER_FONT_SIZE             (KL_HEADER_HEIGHT-6.0f)

@class KLCalendarModel;

@protocol MyCalendarViewDelegate;

@interface MyCalendarView : UIView<NSFetchedResultsControllerDelegate, UIAlertViewDelegate> {
	IBOutlet id <MyCalendarViewDelegate> delegate;
	NSMutableArray *dateButtons;
	NSMutableArray *dates;
	KLCalendarModel *calendarModel;
	UILabel *_selectedMonthLabel;
	UIView *calendarContainer;
	//	UIView *container;
	
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	
	NSArray *diaryDatas;
	NSArray *eventDatas;
	NSArray *childDatas;
	NSArray *anniversaryDatas;
	NSDateFormatter *dateFormatter;
	
	NSMutableDictionary *annData;
	NSMutableDictionary *tempData;
}

@property(nonatomic, assign) id <MyCalendarViewDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *dateButtons;
@property (nonatomic, retain) NSMutableArray *dates;
@property (nonatomic, retain) UIView *calendarContainer;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) NSArray *childDatas;
@property (nonatomic, retain) NSArray *diaryDatas;
@property (nonatomic, retain) NSArray *eventDatas;
@property (nonatomic, retain) NSArray *anniversaryDatas;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
//@property (nonatomic, retain) UIView *container;

//- (id)initWithImage:(UIImage *)image delegate:(id <MyCalendarViewDelegate>)delegate;
- (id)initWithFrame:(CGRect)frame  delegate:(id <MyCalendarViewDelegate>)aDelegate;
- (void)drawCalendarHead;
- (void)drawCalendarBody;
- (void)removeAllButtons;
- (void)addButtonArray;
- (void)selectedDateButton:(UIButton *)dateButton;

@end

@protocol MyCalendarViewDelegate <NSObject>
@required
- (void)didChangeMonths;
- (void)popupView:(CalendarButton *)dateButton;
@optional
- (void)wasSwipedToTheLeft;
- (void)wasSwipedToTheRight;
@end