//
//  AnniversaryDetailViewController.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 28..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataPickerViewController.h"
#import "EditEventViewController.h"
#import "AnniversaryDetailTableViewController.h"

@interface AnniversaryDetailViewController : UIViewController<AnniversaryDetailTableViewControllerDelegate> {
	UIBarButtonItem *closeViewButton;	
	AnniversaryDetailTableViewController *anniversaryDetailView;
	
	NSMutableDictionary *annData;
	NSMutableDictionary *existData;
}

@property(nonatomic, retain) UIBarButtonItem *closeViewButton;
@property(nonatomic, retain) AnniversaryDetailTableViewController *anniversaryDetailView;
@property(nonatomic, retain) NSMutableDictionary *annData;
@property(nonatomic, retain) NSMutableDictionary *existData;

@end
