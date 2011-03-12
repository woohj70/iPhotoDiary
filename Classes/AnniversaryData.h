//
//  AnniversaryData.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 18..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface AnniversaryData :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * holidayflag;
@property (nonatomic, retain) NSDate * anniversarydate;
@property (nonatomic, retain) NSString * sectionDate;
@property (nonatomic, retain) NSString * conditionDate;
@property (nonatomic, retain) NSString * anniversaryname;
@property (nonatomic, retain) NSNumber * alarmsetting;
@property (nonatomic, retain) NSDecimalNumber * anniversarytype;
@property (nonatomic, retain) NSString * childname;

@end



