//
//  YearMonthPickerViewController.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 7. 4..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define	YEAR_COMPONENT	0
#define	MONTH_COMPONENT	1

@protocol YearMonthPickerViewControllerDelegate;

@interface YearMonthPickerViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource> {
	UIPickerView *doublePicker;
	NSArray *yearsArray;
	NSArray *monthsArray;
	
	NSString *returnValue;
	NSString *mode;
	UIButton *todayButto;
	
	id<YearMonthPickerViewControllerDelegate> delegate;
}

@property(nonatomic, retain) IBOutlet UIPickerView *doublePicker;
@property(nonatomic, retain) IBOutlet UIButton *todayButto;
@property(nonatomic, retain) NSArray *yearsArray;
@property(nonatomic, retain) NSArray *monthsArray;
@property(nonatomic, retain) NSString *returnValue;
@property(nonatomic, retain) NSString *mode;
@property(nonatomic, assign) id<YearMonthPickerViewControllerDelegate> delegate;

- (IBAction)setToday;

@end

@protocol YearMonthPickerViewControllerDelegate

- (void)loadNewTableView:(NSString *)conditionStr;

@end