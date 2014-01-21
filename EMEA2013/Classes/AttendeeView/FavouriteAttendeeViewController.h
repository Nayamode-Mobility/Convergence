//
//  FavouriteAttendeeViewController.h
//  ConvergenceUSA_2014
//
//  Created by Nayamode on 18/01/14.
//  Copyright (c) 2014 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavouriteAttendeeViewController : UIViewController
{
    NSArray *arrFavAttendee;
}

-(IBAction)btnBack_Click:(id)sender;
-(IBAction)btnSynchFavAttendee_click:(id)sender;
@end
