//
//  ChildListViewController.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 17..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChildListTableViewController.h"


@interface ChildListViewController : UIViewController<UINavigationControllerDelegate, ChildListTableViewControllerDelegate> {
	ChildListTableViewController *childTableView;
	NSArray *dataArr;
	
	NSManagedObjectContext *managedObjectContext;
	UIBarButtonItem *editButton;
	BOOL editing;
}

@property(nonatomic, retain) ChildListTableViewController *childTableView;
@property(nonatomic, retain) NSArray *dataArr;
@property(nonatomic, retain) UIBarButtonItem *editButton;
@property(nonatomic, getter=isEditing) BOOL editing;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
