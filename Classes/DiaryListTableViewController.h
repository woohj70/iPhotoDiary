//
//  DiaryListTableViewController.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 16..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiaryData.h"
#import "DiaryListCell.h"
#import "EditDiaryViewController.h"

@protocol DiaryListTableViewControllerDelegate;

@interface DiaryListTableViewController : UITableViewController<NSFetchedResultsControllerDelegate, DiaryListCellDelegate> {
	DiaryListCell *diaryCell;
	NSArray *dataArr;
	DiaryData *diaryData;
	
	EditDiaryViewController *editDiaryController;
	
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	
	id<DiaryListTableViewControllerDelegate> delegate;
	
	NSDateFormatter *dateFormatter;
	
	NSString *conditionString;
}

@property (nonatomic, retain) DiaryListCell *diaryCell;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) EditDiaryViewController *editDiaryController;

@property(nonatomic, retain) NSArray *dataArr;
@property(nonatomic, retain) DiaryData *diaryData;

@property (nonatomic, assign) id<DiaryListTableViewControllerDelegate> delegate;

@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSString *conditionString;

- (void)moveDiaryView;

@end


@protocol DiaryListTableViewControllerDelegate

- (void)changeViewController:(DiaryData *)diaryData;
	
@end