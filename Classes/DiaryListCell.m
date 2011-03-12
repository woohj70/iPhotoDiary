//
//  DiaryListCell.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 23..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "DiaryListCell.h"


@implementation DiaryListCell

@synthesize titleField;
@synthesize dateField;
@synthesize photoView;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[titleField release];
	[dateField release];
	
	[photoView release];
    [super dealloc];
}


@end
