//
//  EventData.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 8. 18..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ChildData;

@interface EventData :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * notifytime;
@property (nonatomic, retain) NSString * enddate;
@property (nonatomic, retain) NSString * eventmemo;
@property (nonatomic, retain) NSString * eventname;
@property (nonatomic, retain) NSString * childname;
@property (nonatomic, retain) NSString * startdate;
@property (nonatomic, retain) NSString * googlecalendar;
@property (nonatomic, retain) NSString * publicity;
@property (nonatomic, retain) NSDecimalNumber * eventtype;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * repeatrate;
@property (nonatomic, retain) NSString * conditionDate;
@property (nonatomic, retain) NSDate * eventdate;
@property (nonatomic, retain) NSString * mystate;
@property (nonatomic, retain) NSString * notifymethod;
@property (nonatomic, retain) NSString * sectionDate;
@property (nonatomic, retain) ChildData * child;

@end



