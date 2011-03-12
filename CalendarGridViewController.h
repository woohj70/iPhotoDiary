//
//  CalendarGridViewController.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 5. 6..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCalendarView.h"
#import "EditDiaryViewController.h"
#import "DiaryListViewController.h"
#import "EventListViewController.h"
#import "AddAnniversaryViewController.h"
#import "CalendarDetailView.h"
#import "CalendarButton.h"

@class CalendarViewController;

@interface CalendarGridViewController : UIViewController<MyCalendarViewDelegate> {
	MyCalendarView *myCalendarView;
	//	UINavigationController *navController;
	UIBarButtonItem *edit;
	CalendarViewController *calendarViewController;
	
	EditDiaryViewController *editDiaryViewController;
	NSManagedObjectContext *managedObjectContext;
	CalendarDetailView *detailView;
	CalendarButton *calButton;
    UISegmentedControl *segment;
}

//@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) CalendarViewController *calendarViewController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) CalendarDetailView *detailView;
@property (nonatomic, retain) CalendarButton *calButton;
@property (nonatomic, retain) UISegmentedControl *segment;


- (void)viewChange;

@end
