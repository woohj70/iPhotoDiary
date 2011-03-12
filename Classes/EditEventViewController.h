//
//  EditEventViewController.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 25..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventSettingCell.h"


@interface EditEventViewController : UIViewController {
	UITextView *contentView;
	UITextField *titleField;
	
	EventSettingCell *settingCell;
	NSString *title;
	
	UIBarButtonItem *closeViewButton;
}

@property(nonatomic, retain) IBOutlet UITextView *contentView;
@property(nonatomic, retain) IBOutlet UITextField *titleField;

@property(nonatomic, retain) EventSettingCell *settingCell;
@property(nonatomic, retain) NSString *title;

@property(nonatomic, retain) UIBarButtonItem *closeViewButton;

@end
