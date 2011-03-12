//
//  AddEventViewController.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 25..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "AddEventViewController.h"
#import "EXFLogging.h"
#import "AppMainViewController.h"

@implementation AddEventViewController

@synthesize eventSettingCell;
@synthesize closeViewButton;
@synthesize dateFormatter;
@synthesize delegate;
@synthesize eventData;
//@synthesize delegate;
//@synthesize editController;

#pragma mark -
#pragma mark View lifecycle

- (id)initWithStyle:(UITableViewStyle)style withEventData:(EventData *)eventData {
    if (self = [super initWithStyle:style]) {
		self.eventData = eventData;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {

    }
    return self;
}

/*
- (void)viewDidLoad {
    [super viewDidLoad];

	Debug("children[0] = %@, children[1] = %@", [[AppMainViewController childrenArray] objectAtIndex:0], [[AppMainViewController childrenArray] objectAtIndex:1]);
	
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Date Formatter

- (NSDateFormatter *)dateFormatter {	
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	}
	return dateFormatter;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"EventSettingCell";
    
    EventSettingCell *cell = (EventSettingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EventSettingCell" owner:self options:nil];

		for (id oneObject in nib) {
			if ([oneObject isKindOfClass:[EventSettingCell class]]) {
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				cell = (EventSettingCell *) oneObject;
				//					cell.backgroundColor = [UIColor whiteColor];
				//cell.delegate = self;
			}
		}
    }
	
	cell.text = nil;
	cell.image = nil;
	cell.accessoryView = nil;
	
	if (eventData != nil) {
		switch (indexPath.row) {
			case 0:
				cell.titleLabel.text = @"제목 : ";
				cell.valueLabel.text = [eventData valueForKey:@"eventname"];
				break;
			case 1:
				cell.titleLabel.text = @"내용 : ";
				cell.valueLabel.text = [eventData valueForKey:@"eventmemo"];
				break;
			case 2:
				cell.titleLabel.text = @"날짜 : ";
				cell.valueLabel.text = [self.dateFormatter stringFromDate:[eventData valueForKey:@"eventdate"]];
				cell.eventDate = [eventData valueForKey:@"eventdate"];
				break;
			case 3:
				cell.titleLabel.text = @"대상 : ";
				ChildData *childData = [eventData valueForKey:@"child"];
				cell.valueLabel.text = [childData valueForKey:@"childname"];
				break;
//			case 4:
//				cell.titleLabel.text = @"알림 : ";
//				cell.accessoryView = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
//				
//				if ([[eventData valueForKey:@"eventtype"] integerValue] == 0) {
//					[cell.accessoryView setOn:NO animated:YES];
//				} else {
//					[cell.accessoryView setOn:YES animated:YES];
//				}

				
//				break;
			default:
				break;
		}
		
	} else {
		switch (indexPath.row) {
			case 0:
				cell.titleLabel.text = @"제목 : ";
				break;
			case 1:
				cell.titleLabel.text = @"내용 : ";
				break;
			case 2:
				cell.titleLabel.text = @"날짜 : ";
				cell.valueLabel.text = [self.dateFormatter stringFromDate:[NSDate date]];
				cell.eventDate = [NSDate date];
				break;
			case 3:
				cell.titleLabel.text = @"대상 : ";
				cell.valueLabel.text = [AppMainViewController selectedChildName];
				break;
//			case 4:
//				cell.titleLabel.text = @"알림 : ";
//				cell.accessoryView = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
//				break;
			default:
				break;
		}
		
	}

		
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	[delegate moveEditView:indexPath.row withViewController:self andTableViewCell:[tableView cellForRowAtIndexPath:indexPath]];
}

#pragma mark -
#pragma markAddEventViewControllerDelegate

- (void)setChangedChild:(NSString *)childName {
	[delegate changeChild:childName];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[closeViewButton release];
	[eventSettingCell release];
	[dateFormatter release];
	[delegate release];
	[eventData release];
    [super dealloc];
}


@end

