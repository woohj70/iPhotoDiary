//
//  ChildListTableViewController.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 17..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChildData.h"
#import "AddNewChildViewController.h"

@class AppMainViewController;

@protocol ChildListTableViewControllerDelegate;

@interface ChildListTableViewController : UITableViewController<NSFetchedResultsControllerDelegate> {
	NSArray *dataArr;
	ChildData *childData;
	
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	
	id<ChildListTableViewControllerDelegate> delegate;
	
	NSDateFormatter *dateFormatter;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property(nonatomic, retain) NSArray *dataArr;
@property(nonatomic, retain) ChildData *childData;

@property (nonatomic, retain) NSDateFormatter *dateFormatter;

@property (nonatomic, assign) id<ChildListTableViewControllerDelegate> delegate;

@end

@protocol ChildListTableViewControllerDelegate

- (void)changeViewController:(AddNewChildViewController *)addChildView;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end