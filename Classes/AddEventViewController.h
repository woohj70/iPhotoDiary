//
//  AddEventViewController.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 25..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventSettingCell.h"
#import "DataPickerViewController.h"
#import "EditEventViewController.h"
#import "ChildrenPickerViewController.h"
#import "EventData.h"
#import "ChildData.h"

@class AppMainViewController;

@protocol AddEventViewControllerDelegate;

@interface AddEventViewController : UITableViewController<ChildrenPickerViewControllerDelegate> {
	EventSettingCell *eventSettingCell;
	UIBarButtonItem *closeViewButton;
//	EditEventViewController *editController;
	
	NSDateFormatter *dateFormatter;
	id<AddEventViewControllerDelegate> delegate;
	
	EventData *eventData;
}

@property(nonatomic, retain) IBOutlet EventSettingCell *eventSettingCell;
@property(nonatomic, retain) UIBarButtonItem *closeViewButton;
//@property(nonatomic, retain) EditEventViewController *editController;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property(nonatomic, assign) id<AddEventViewControllerDelegate> delegate;

@property (nonatomic, retain) EventData *eventData;

@end

@protocol AddEventViewControllerDelegate

- (void)changeChild:(NSString *)childName;
- (void)moveEditView:(NSInteger)row withViewController:(AddEventViewController *)addEventController andTableViewCell:(UITableViewCell *)tableViewCell;

@end