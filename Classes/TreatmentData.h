//
//  TreatmentData.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 7. 16..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ChildData;
@class HospitalImage;
@class PrescriptionImage;

@interface TreatmentData :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * treatmentResult;
@property (nonatomic, retain) NSString * treatmentSubject;
@property (nonatomic, retain) NSString * childname;
@property (nonatomic, retain) NSString * hospitalName;
@property (nonatomic, retain) NSNumber * treatmentCount;
@property (nonatomic, retain) NSString * doctorName;
@property (nonatomic, retain) NSString * hospitalAddress;
@property (nonatomic, retain) NSDate * treatmentDate;
@property (nonatomic, retain) NSString * drugstore;
@property (nonatomic, retain) NSString * hospitalTel;
@property (nonatomic, retain) NSString * prescription;
@property (nonatomic, retain) ChildData * child;
@property (nonatomic, retain) NSSet* prescriptionImage;
@property (nonatomic, retain) HospitalImage* hospitalImage;

@end


@interface TreatmentData (CoreDataGeneratedAccessors)
- (void)addPrescriptionImageObject:(PrescriptionImage *)value;
- (void)removePrescriptionImageObject:(PrescriptionImage *)value;
- (void)addPrescriptionImage:(NSSet *)value;
- (void)removePrescriptionImage:(NSSet *)value;

- (void)addHospitalImageObject:(HospitalImage *)value;
- (void)removeHospitalImageObject:(HospitalImage *)value;

@end

