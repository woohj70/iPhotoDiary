//
//  DiaryViewController.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 4. 23..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MyCalendarView.h"
#import "EditDiaryViewController.h"
#import "CalendarGridViewController.h"

@interface CalendarViewController : UIViewController { //<MyCalendarViewDelegate> {
//	MyCalendarView *myCalendarView;
	UINavigationController *navController;
	UIBarButtonItem *edit;
	EditDiaryViewController *editDiaryViewController;
	CalendarGridViewController *calendarGridViewController;
}

- (void)hideTabBar;
- (void)viewTabBar;

@end