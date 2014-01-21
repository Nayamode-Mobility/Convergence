//
//  FindLikeMindedViewController.m
//  ConvergenceUSA_2014
//
//  Created by Nikhil on 15/01/14.
//  Copyright (c) 2014 Nayamode. All rights reserved.
//

#import "FindLikeMindedViewController.h"
#import "AttendeeDB.h"
#import "Filters.h"
#import "CustomCollectionViewCell.h"
#import "NSString+Custom.h"
#import "AttendeeDetailViewController.h"

@interface FindLikeMindedViewController ()

@end

@implementation FindLikeMindedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    blnDropdownExpanded = NO;
    
    AttendeeDB *objAttendeeDB = [[AttendeeDB alloc]init];
    arrCategory1 = [objAttendeeDB GetAttendeesCategoryOfFilterType:@"JobRoles"];
    arrCategory2 = [objAttendeeDB GetAttendeesCategoryOfFilterType:@"MyBusiness"];
    arrCategory3 = [objAttendeeDB GetAttendeesCategoryOfFilterType:@"ImpProducts"];
    arrCategory4 = [objAttendeeDB GetAttendeesCategoryOfFilterType:@"SellProducts"];
    arrCategory5 = [objAttendeeDB GetAttendeesCategoryOfFilterType:@"EvalProducts"];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger intReturnValue;
    switch (tableView.tag) {
        case 1:
            intReturnValue = [arrCategory1 count];
            break;
        case 2:
            intReturnValue = [arrCategory2 count];
            break;
        case 3:
            intReturnValue = [arrCategory3 count];
            break;
        case 4:
            intReturnValue = [arrCategory4 count];
            break;
        default:
            intReturnValue = 0;
            break;
    }
    return intReturnValue;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *strTitle;
    
    
    NSLog(@"%ld",(long)tableView.tag);
    
    switch (tableView.tag)
    {
        case 1:
        {
            Filters  *objFilters = [arrCategory1 objectAtIndex:indexPath.row];
            strTitle = objFilters.strCategory;
        }
            break;
        case 2:
        {
            Filters  *objFilters = [arrCategory2 objectAtIndex:indexPath.row];
            strTitle = objFilters.strCategory;
        }
            break;
        case 3:
        {
            Filters  *objFilters = [arrCategory3 objectAtIndex:indexPath.row];
            strTitle = objFilters.strCategory;
        }
            break;
        case 4:
        {
            Filters  *objFilters = [arrCategory4 objectAtIndex:indexPath.row];
            strTitle = objFilters.strCategory;
        }
            break;
        default:
            strTitle = @"";
            break;
    }
    
    
    cell.textLabel.text = strTitle;
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:(104/255.0) green:(33/255.5) blue:0 alpha:1];
    cell.selectedBackgroundView = selectionColor;
    
    //[UIView addTouchEffect:cell.contentView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self ShrinkAllDropdownViews];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    blnDropdownExpanded = NO;
    switch (tableView.tag)
    {
        case 1:
        {
            Filters  *objFilters = [arrCategory1 objectAtIndex:indexPath.row];
            lblCategory1.text = objFilters.strCategory;
        }
            break;
        case 2:
        {
            Filters  *objFilters = [arrCategory2 objectAtIndex:indexPath.row];
            lblCategory2.text = objFilters.strCategory;
        }
            break;
        case 3:
        {
            Filters  *objFilters = [arrCategory3 objectAtIndex:indexPath.row];
            lblCategory3.text = objFilters.strCategory;
        }
            break;
        case 4:
        {
            Filters *objFilters = [arrCategory4 objectAtIndex:indexPath.row];
            lblCategory4.text = objFilters.strCategory;
        }
            break;
        default:
            break;
    }
    
    //[self setFloorPlanData:indexPath.row];
    [self viewDidLayoutSubviews];
}

-(IBAction)btnSearch_Click:(id)sender
{
    AttendeeDB *objAttendeeDB = [[AttendeeDB alloc]init];
    arrAttendees = [objAttendeeDB GetFilteredFindLikeMindedwithCategory1:lblCategory1.text Category2:lblCategory2.text Category3:lblCategory3.text Category4:lblCategory4.text];
    
    [collAttendees  reloadData];
    [scrlFindLikeMinded setContentSize:CGSizeMake(640, 483)];
    [scrlFindLikeMinded setContentOffset:CGPointMake(320, 0)];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"loadAttendeeDetail"])
    {
        AttendeeDetailViewController *controller = segue.destinationViewController;
        CustomCollectionViewCell *attendeeCell = (CustomCollectionViewCell *)sender;
        controller.attendeeData = (Attendee *)attendeeCell.cellData;
    }
}

#pragma mark - UICollectionViewDataSource methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [arrAttendees count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    Attendee *objAttendee;
        
    objAttendee = [arrAttendees objectAtIndex:indexPath.row];
    
        cell.lblName.text = [NSString stringWithFormat:@"%@ %@",objAttendee.strFirstName,objAttendee.strLastName];
        cell.lblTitle.text = objAttendee.strAttendeeName;
        cell.lblTitle.textColor = [UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0];
        cell.lblCompany.text = objAttendee.strCompany;
        cell.cellData = objAttendee;
        
        cell.imgLogo.image = nil;
        cell.imgLogo.image = [UIImage imageNamed:@"normal.png"];
        if(![NSString IsEmpty:objAttendee.strPhotoURL shouldCleanWhiteSpace:YES])
        {
            NSURL *imgURL = [NSURL URLWithString:objAttendee.strPhotoURL];
            NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
            [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
                                                                                                                       NSData *data,
                                                                                                                       NSError *error)
             {
                 if (!error)
                 {
                     //NSLog(@"%@ %@",response.URL.absoluteString,((Attendee*)cell.cellData).strPhotoURL);
                     if([response.URL.absoluteString isEqualToString:((Attendee*)cell.cellData).strPhotoURL])
                     {
                         cell.imgLogo.image = [UIImage imageWithData:data];
                     }
                 }
             }];
        }
    
    //[UIView addTouchEffect:cell.contentView];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //[self performSegueWithIdentifier:@"loadSponsorDetail" sender:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)btnCategory_Click:(id)sender
{
    if (blnDropdownExpanded)
    {
        [self ShrinkAllDropdownViews];
        blnDropdownExpanded = NO;
    }
    else
    {
        UIButton *clickedButton = (UIButton *)sender;
        [self expandView:clickedButton.tag];
        blnDropdownExpanded = YES;
    }

}

- (void)expandView:(NSInteger)tag
{
    NSInteger intExpandHeight = [UIScreen mainScreen].bounds.size.height - 130;
    
    switch (tag)
    {
        case 1:
        {
            intExpandHeight = intExpandHeight - viewTableCategory1.frame.origin.y;
            [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
                viewTableCategory1.frame = CGRectMake(viewTableCategory1.frame.origin.x, viewTableCategory1.frame.origin.y, (viewTableCategory1.frame.size.width), intExpandHeight);
                
            } completion:nil];
        }
            break;
        case 2:
        {
            intExpandHeight = intExpandHeight - viewTableCategory2.frame.origin.y;
            [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
                viewTableCategory2.frame = CGRectMake(viewTableCategory2.frame.origin.x, viewTableCategory2.frame.origin.y, (viewTableCategory2.frame.size.width), intExpandHeight);
                
            } completion:nil];
        }
            break;
        case 3:
        {
            intExpandHeight = intExpandHeight - viewTableCategory3.frame.origin.y;
            [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
                viewTableCategory3.frame = CGRectMake(viewTableCategory3.frame.origin.x, viewTableCategory3.frame.origin.y, (viewTableCategory3.frame.size.width), intExpandHeight);
                
            } completion:nil];
        }
            break;
        case 4:
        {
            intExpandHeight = intExpandHeight - viewTableCategory4.frame.origin.y;
            [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
                viewTableCategory4.frame = CGRectMake(viewTableCategory4.frame.origin.x, viewTableCategory4.frame.origin.y, (viewTableCategory4.frame.size.width), intExpandHeight);
                
            } completion:nil];
        }
            break;
        default:
            break;
    }
    //blnViewExpanded = YES;
}
- (void)ShrinkAllDropdownViews
{
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
        viewTableCategory1.frame = CGRectMake(viewTableCategory1.frame.origin.x, viewTableCategory1.frame.origin.y, (viewTableCategory1.frame.size.width), 0);
    } completion:nil];
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
        viewTableCategory2.frame = CGRectMake(viewTableCategory2.frame.origin.x, viewTableCategory2.frame.origin.y, (viewTableCategory2.frame.size.width), 0);
    } completion:nil];
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
        viewTableCategory3.frame = CGRectMake(viewTableCategory3.frame.origin.x, viewTableCategory3.frame.origin.y, (viewTableCategory3.frame.size.width), 0);
    } completion:nil];
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
        viewTableCategory4.frame = CGRectMake(viewTableCategory4.frame.origin.x, viewTableCategory4.frame.origin.y, (viewTableCategory4.frame.size.width), 0);
    } completion:nil];
}


@end
