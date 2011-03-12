//
//  EventListViewController.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 15..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventListTableViewController.h"
#import "AddEventBackgroundViewController.h"
#import "iPhotoDiaryAppDelegate.h"
#import "YearMonthPickerViewController.h"

#import "ChildData.h"
#import "EventData.h"

@interface EventListViewController : UIViewController<NSFetchedResultsControllerDelegate, EventListTableViewControllerDelegate, YearMonthPickerViewControllerDelegate> {
	EventListTableViewController *eventTableView;
	AddEventBackgroundViewController *addEventController;
	UIBarButtonItem *editButton;
	
	BOOL editing;
	
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	
	ChildData *childData;
	EventData *eventData;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) ChildData *childData;
@property (nonatomic, retain) EventData *eventData;

@property (nonatomic, retain) EventListTableViewController *eventTableView;
@property (nonatomic, retain) AddEventBackgroundViewController *addEventController;
@property (nonatomic, retain) UIBarButtonItem *editButton;

@property(nonatomic, getter=isEditing) BOOL editing;

@end
