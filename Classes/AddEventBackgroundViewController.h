//
//  AddEventBackgroundViewController.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 25..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddEventViewController.h"
#import "iPhotoDiaryAppDelegate.h"
#import "AppMainViewController.h"

#import "EditEventViewController.h";

#import "ChildData.h"
#import "EventData.h"

#import "EventSettingCell.h"


@interface AddEventBackgroundViewController : UIViewController<NSFetchedResultsControllerDelegate, AddEventViewControllerDelegate, UIAlertViewDelegate> {
	AddEventViewController *addEventController;
	UIBarButtonItem *closeViewButton;
	
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	
	ChildData *childData;
	EventData *eventData;
	
	NSDateFormatter *dateFormatter;
}

@property(nonatomic, retain) AddEventViewController *addEventController;
@property(nonatomic, retain) UIBarButtonItem *closeViewButton;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) ChildData *childData;
@property (nonatomic, retain) EventData *eventData;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
