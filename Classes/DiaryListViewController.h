//
//  DiaryListViewController.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 16..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiaryListTableViewController.h"
#import "EditDiaryViewController.h"
#import "YearMonthPickerViewController.h"

@interface DiaryListViewController : UIViewController<YearMonthPickerViewControllerDelegate, DiaryListTableViewControllerDelegate> {
	DiaryListTableViewController *diaryTableView;
	EditDiaryViewController *editDiaryController;
	
	NSManagedObjectContext *managedObjectContext;
	//	UIBarButtonItem *editButton;
	BOOL editing;
	NSString *conditionString;
}

@property (nonatomic, retain) DiaryListTableViewController *diaryTableView;
@property (nonatomic, retain) EditDiaryViewController *editDiaryController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
//@property(nonatomic, retain) UIBarButtonItem *editButton;
@property (nonatomic, retain) NSString *conditionString;
@property(nonatomic, getter=isEditing) BOOL editing;

@end
