//
//  AnniversaryDetailTableViewController.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 28..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventSettingCell.h"

@protocol AnniversaryDetailTableViewControllerDelegate;

@interface AnniversaryDetailTableViewController : UITableViewController {
	id<AnniversaryDetailTableViewControllerDelegate> delegate;
	NSMutableDictionary *annData;
}

@property(nonatomic, assign) id<AnniversaryDetailTableViewControllerDelegate> delegate;
@property(nonatomic, retain) NSMutableDictionary *annData;

@end


@protocol AnniversaryDetailTableViewControllerDelegate

- (void)moveEditView:(NSInteger)row withViewController:(AnniversaryDetailTableViewController *)addEventController andTableViewCell:(UITableViewCell *)tableViewCell;

@end