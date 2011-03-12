//
//  AddAnniversaryViewController.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 27..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddAnniversaryTableViewController.h";
#import "AnniversaryDetailViewController.h";


@interface AddAnniversaryViewController : UIViewController<AddAnniversaryTableViewControllerDelegate> {
	UIBarButtonItem *editButton;
	AddAnniversaryTableViewController *anniversaryTableView;
	
	BOOL editing;
}

@property(nonatomic, retain) UIBarButtonItem *editButton;
@property(nonatomic, retain) AddAnniversaryTableViewController *anniversaryTableView;

@end
