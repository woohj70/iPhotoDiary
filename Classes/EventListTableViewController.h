//
//  EventListTableViewController.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 16..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iPhotoDiaryAppDelegate.h"
#import "AddEventBackgroundViewController.h"

#import "ChildData.h"
#import "EventData.h"


@protocol EventListTableViewControllerDelegate;

@interface EventListTableViewController : UITableViewController<NSFetchedResultsControllerDelegate> {
	id<EventListTableViewControllerDelegate> delegate;
	
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	
	ChildData *childData;
	EventData *eventData;
	NSString *conditionString;
}

@property (nonatomic, assign) id<EventListTableViewControllerDelegate> delegate;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) ChildData *childData;
@property (nonatomic, retain) EventData *eventData;
@property (nonatomic, retain) NSString *conditionString;

- (void)processEdit:(BOOL) editing;

@end

@protocol EventListTableViewControllerDelegate

- (void)changeViewController:(AddEventBackgroundViewController *)addEventView;

@end