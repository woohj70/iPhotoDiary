//
//  AddChildViewController.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 5. 31..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChildInfoCell.h"
#import "ChildBasicInfoCell.h"
#import "ChildGenderInfoCell.h"
#import "ChildData.h"
#import "AnniversaryData.h"
#import "EventData.h"

#import "KLCalendarModel.h"
#import "MCLunarDate.h"
#import "MCSolarDate.h"
#import "KLDate.h"

@protocol AddChildViewControllerDelegate;
@class ConfigViewController;

@interface AddChildViewController : UITableViewController<ChildInfoCellDelegate, ChildBasicInfoCellDelegate, ChildGenderInfoCellDelegate,
								UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	ChildBasicInfoCell *childBasicInfoCell;
	ChildInfoCell *childInfoCell;
	ChildGenderInfoCell *childGenderCell;
	
	ChildData *childData;
	id<AddChildViewControllerDelegate> delegate;
	
	NSManagedObjectContext *managedObjectContext;
	BOOL keyboardShown;
	
	NSArray *cellTitle1;
	NSArray *cellTitle2;
	
	NSDateFormatter *dateFormatter;
}

@property (nonatomic, retain) ChildData *childData;
@property (nonatomic, assign) id <AddChildViewControllerDelegate> delegate;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) IBOutlet ChildBasicInfoCell *childBasicInfoCell;
@property (nonatomic, retain) IBOutlet ChildInfoCell *childInfoCell;
@property (nonatomic, retain) IBOutlet ChildGenderInfoCell *childGenderCell;

@property (nonatomic, retain) NSArray *cellTitle1;
@property (nonatomic, retain) NSArray *cellTitle2;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;

- (id)initWithStyle:(UITableViewStyle)style withDelegate:(id)delegate withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (id)initWithStyle:(UITableViewStyle)style withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (void)prepareUpdate:(ChildData *)childData;
- (IBAction)textFieldDoneEditing:(id)sender;

@end

@protocol AddChildViewControllerDelegate

- (void)actionSheet:(ChildBasicInfoCell *)childCell;
- (void)saveChildBasicInfo:(ChildBasicInfoCell *)childCell andChildInfo:(ChildInfoCell *)cell;
- (void)endSave;
- (void) movePickerView:(ChildBasicInfoCell *)basicCell;
- (void) enableSaveButton:(BOOL)enable;

@end