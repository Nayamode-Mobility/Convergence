//
//  InternetAccessViewController.h
//  mgx2013
//
//  Created by Amit Karande on 16/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InternetAccessViewController : UIViewController
{
}

@property (strong, nonatomic) IBOutlet UIScrollView *svwInternetAccess;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)MakePhoneCall:(id)sender;
@end
