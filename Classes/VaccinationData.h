//
//  VaccinationData.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 7. 16..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ChildData;

@interface VaccinationData :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * childname;
@property (nonatomic, retain) NSString * vaccinDesciprtion;
@property (nonatomic, retain) NSDate * completeDate;
@property (nonatomic, retain) NSString * vaccinationLoc;
@property (nonatomic, retain) NSNumber * vaccinationCount;
@property (nonatomic, retain) NSDate * vaccinationDate;
@property (nonatomic, retain) NSString * vaccinName;
@property (nonatomic, retain) ChildData * child;

@end



