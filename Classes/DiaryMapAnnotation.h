//
//  DiaryMapAnnotation.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 26..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface DiaryMapAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D _coordinate;
    NSString * _title;
    NSString * _subtitle;
	
	NSString *title;
    NSString *subtitle;
}

+ (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate;
+ (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString *) title;
+ (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString *) title andSubtitle:(NSString *)subtitle;

@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *subtitle;

@end
