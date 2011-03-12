//
//  MCSolarDate.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 8. 26..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MCSolarDate : NSObject {
	NSInteger year;
	NSInteger month;
	NSInteger day;
	NSInteger dayofweek;
}

@property(nonatomic) NSInteger year;
@property(nonatomic) NSInteger month;
@property(nonatomic) NSInteger day;
@property(nonatomic) NSInteger dayofweek;

@end
