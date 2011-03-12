//
//  ChildInfoCell.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 5. 31..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "ChildInfoCell.h"
#import "EXFLogging.h"


@implementation ChildInfoCell

@synthesize labelField;
@synthesize valueField;
@synthesize delegate;
@synthesize valueStr;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		valueField.returnKeyType = UIReturnKeyDone;
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)beginEditing {
	Debug(@"beginEditing");
    static NSString *CellIdentifier = @"ChildInfo";
	
	ChildInfoCell *cellAux=(ChildInfoCell *)self;
	
	UITableView *table=(UITableView*)[cellAux superview];
	NSIndexPath *path=[table indexPathForCell:cellAux];
	[delegate scrollNewPosition:self];
	NSLog(@"been pressed %d si %d",path.section, path.row);}

- (IBAction)endEditing {
	Debug(@"endEditing");
}


#pragma mark -
#pragma mark Memory management
- (void)dealloc {
    [super dealloc];
	
	[labelField release];
	[valueField release];
	[valueStr release];
}


@end
