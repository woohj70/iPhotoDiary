//
//  DataPickerViewController.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 20..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChildBasicInfoCell.h"
#import "EventSettingCell.h"


@interface DataPickerViewController : UIViewController {
	ChildBasicInfoCell *editedObject;
	EventSettingCell *eventCell;
	UIDatePicker *datePicker;
	
	NSDateFormatter *dateFormatter;
	UIButton *todayButton;
}

@property (nonatomic, retain) ChildBasicInfoCell *editedObject;
@property (nonatomic, retain) EventSettingCell *eventCell;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet UIButton *todayButton;

- (IBAction)setToday;
@end
