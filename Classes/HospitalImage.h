//
//  HospitalImage.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 7. 16..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <CoreData/CoreData.h>

@class TreatmentData;

@interface HospitalImage :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) TreatmentData * treatment;

@end



