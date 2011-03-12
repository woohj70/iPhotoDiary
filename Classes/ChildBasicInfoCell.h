//
//  ChildBasicInfoCell.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 5. 31..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChildBasicInfoCellDelegate;
@class AddChildViewController;

@interface ChildBasicInfoCell : UITableViewCell<UIActionSheetDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>  {
	UIButton *photoViewButton;
	UITextField *nameField;
//	UITextField *nickName;
	UISegmentedControl *isLunar;
	UITextField *birthDay;
	
	UITextField *activeField;
	id <ChildBasicInfoCellDelegate> delegate;
	
	NSDate *birthDate;
}

@property(nonatomic, retain) IBOutlet UIButton *photoViewButton;
@property(nonatomic, retain) IBOutlet UITextField *nameField;
//@property(nonatomic, retain) IBOutlet UITextField *nickName;
@property(nonatomic, retain) IBOutlet UITextField *birthDay;
@property(nonatomic, retain) IBOutlet UISegmentedControl *isLunar;
@property(nonatomic, retain) NSDate *birthDate;

@property(nonatomic, assign) id <ChildBasicInfoCellDelegate> delegate;

- (IBAction) photoViewButtonClicked;
- (IBAction) movePickerView;

@end

@protocol ChildBasicInfoCellDelegate <NSObject>

- (void)showActionSheet;
- (void)showArgString:(NSString *)string;
- (void) movePickerView:(ChildBasicInfoCell *)basicCell;
@end