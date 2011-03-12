//
//  AddAnniversaryTableViewController.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 27..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnniversaryDetailViewController.h"

@protocol AddAnniversaryTableViewControllerDelegate;

@interface AddAnniversaryTableViewController : UITableViewController {
//	BOOL editing;
	id<AddAnniversaryTableViewControllerDelegate> delegate;
	NSMutableDictionary *annData;
	NSMutableDictionary *tempData;
	
	NSInteger totalCount;
}

@property(nonatomic, assign) id<AddAnniversaryTableViewControllerDelegate> delegate;
@property(nonatomic, retain) NSMutableDictionary *annData;

- (NSString *)dataFilePath;
- (void)applicationWillTerminate:(NSNotification *)notification;

@end

@protocol AddAnniversaryTableViewControllerDelegate

- (void)changeViewController:(AnniversaryDetailViewController *)anniversaryView;
- (void)cancelEdit;

@end