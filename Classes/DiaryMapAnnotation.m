//
//  DiaryMapAnnotation.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 26..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "DiaryMapAnnotation.h"


@implementation DiaryMapAnnotation

@synthesize coordinate = _coordinate;
@synthesize title;
@synthesize subtitle;

+ (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    self = [super alloc];
    [self setCoordinate:coordinate];
    return self;
}

+ (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString*) title {
    self = [super alloc];
    [self setCoordinate:coordinate];
    title = [title retain];
    return self;
}

+ (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString*) title andSubtitle:(NSString*) subtitle {
    self = [super alloc];
    [self setCoordinate:coordinate];
    title = [title retain];
    subtitle = [subtitle retain];
    return self;
}

- (void) setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    _coordinate = newCoordinate;
}

-(void) dealloc {
	[title release];
    [subtitle release];
    [super dealloc];
}

@end
