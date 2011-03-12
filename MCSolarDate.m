//
//  MCSolarDate.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 8. 26..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "MCSolarDate.h"

@implementation MCSolarDate

@synthesize year, month, day, dayofweek;

- (id) init {
	if (![super init])
        return nil;
	
	return self;
}

- (void)dealloc {
	[super dealloc];
}
@end
