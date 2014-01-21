//
//  FavouriteAttendeeViewController.m
//  ConvergenceUSA_2014
//
//  Created by Nayamode on 18/01/14.
//  Copyright (c) 2014 Nayamode. All rights reserved.
//

#import "FavouriteAttendeeViewController.h"
#import "AttendeeDB.h"
#import "CustomCollectionViewCell.h"
#import "NSString+Custom.h"
#import "AttendeeDetailViewController.h"

@interface FavouriteAttendeeViewController ()

@end

@implementation FavouriteAttendeeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    AttendeeDB *objAttnedee = [AttendeeDB GetInstance];
    arrFavAttendee = [objAttnedee GetFavouriteAttendee];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(IBAction)btnBack_Click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnSynchFavAttendee_click:(id)sender
{
    
}


#pragma mark - UICollectionViewDataSource methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
        return [arrFavAttendee count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    Attendee *objAttendee = [arrFavAttendee objectAtIndex:indexPath.row];
    
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"AttendeeDetail"])
    {
        AttendeeDetailViewController *controller = segue.destinationViewController;
        CustomCollectionViewCell *attendeeCell = (CustomCollectionViewCell *)sender;
        controller.attendeeData = (Attendee *)attendeeCell.cellData;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
