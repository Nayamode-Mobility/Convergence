//
//  FindLikeMindedViewController.h
//  ConvergenceUSA_2014
//
//  Created by Nikhil on 15/01/14.
//  Copyright (c) 2014 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindLikeMindedViewController : UIViewController
{
    NSArray *arrCategory1;
    NSArray *arrCategory2;
    NSArray *arrCategory3;
    NSArray *arrCategory4;
    NSArray *arrCategory5;
    
    IBOutlet UILabel *lblCategory1;
    IBOutlet UILabel *lblCategory2;
    IBOutlet UILabel *lblCategory3;
    IBOutlet UILabel *lblCategory4;
    IBOutlet UILabel *lblCategory5;
    
    IBOutlet UIView *viewTableCategory1;
    IBOutlet UIView *viewTableCategory2;
    IBOutlet UIView *viewTableCategory3;
    IBOutlet UIView *viewTableCategory4;
    IBOutlet UIView *viewTableCategory5;
    
    BOOL blnDropdownExpanded;
    
    IBOutlet UIButton *btnSearch;
    
    NSArray *arrAttendees;
    
    IBOutlet UICollectionView *collAttendees;
    IBOutlet UIScrollView *scrlFindLikeMinded;
}

-(IBAction)btnCategory_Click:(id)sender;
-(IBAction)btnSearch_Click:(id)sender;
@end
