//
//  ChildrenPickerViewController.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 25..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventSettingCell.h"
#import "AppMainViewController.h"

@protocol ChildrenPickerViewControllerDelegate;

@interface ChildrenPickerViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource> {
	UIPickerView *childrenPicker;
	EventSettingCell *settingCell;
	
	UIBarButtonItem *closeViewButton;
	NSMutableArray *pickerData;
	id<ChildrenPickerViewControllerDelegate> delegate;
}

@property(nonatomic, retain) IBOutlet UIPickerView *childrenPicker;
@property(nonatomic, retain) EventSettingCell *settingCell;
@property(nonatomic, retain) UIBarButtonItem *closeViewButton;
@property(nonatomic, retain) NSMutableArray *pickerData;
@property(nonatomic, assign) id<ChildrenPickerViewControllerDelegate> delegate;

@end

@protocol ChildrenPickerViewControllerDelegate

- (void)setChangedChild:(NSString *)childName;

@end