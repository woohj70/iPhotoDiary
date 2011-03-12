//
//  TodayEventTableViewController.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 30..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChildData.h"
#import "EventData.h"


@interface TodayEventTableViewController : UITableViewController {
	ChildData *childData;
	NSArray *eventArray;
	NSMutableArray *newEventArray;
	
	NSDateFormatter *dateFormatter;
}

@property(nonatomic, retain) ChildData *childData;
@property(nonatomic, retain) NSArray *eventArray;
@property(nonatomic, retain) NSMutableArray *newEventArray;
@property(nonatomic, retain) NSDateFormatter *dateFormatter;

@end
