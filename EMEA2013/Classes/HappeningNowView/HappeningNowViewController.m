//
//  HappeningNowViewController.m
//  mgx2013
//
//  Created by Amit Karande on 05/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//
#define iPhone_Item_Width 300.0
#define iPhone_Item_Height 180.0
#define iPhone_NO_of_Rows 3.0
#define iPad_Item_Width 300.0
#define iPad_Item_Height 250.0
#define iPad_NO_of_Rows 3.0

#import "HappeningNowViewController.h"
#import "DeviceManager.h"
#import "HappeningNowCustomCollectionViewCell.h"
#import "SessionDetailViewController.h"
#import "CustomCollectionViewCell.h"
#import "SessionDB.h"
#import "MySessionDB.h"
#import "Session.h"
#import "Speaker.h"
#import "MasterDB.h"
#import "Tracks.h"
#import "SubTracks.h"
#import "Filters.h"
#import "VenueDB.h"
#import "Venue.h"
#import "User.h"
#import "Rooms.h"
#import "NSString+Custom.h"
#import "NSURLConnection+Tag.h"
#import "SessionNoteViewController.h"
#import "NotesViewController.h"

@interface HappeningNowViewController()
{
    @private
    id objSender;
    NSUInteger intDateRow;
}
@end

@implementation HappeningNowViewController
@synthesize intSelectedIndex;
@synthesize objConnection, objData;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.contentScrollView setContentSize:CGSizeMake(320, 2100)];
    
    if (self.arrSessions == nil)
    {
        self.arrSessions = [[NSArray alloc] init];
    }
    
    //SessionDB *objSessionDB = [SessionDB GetInstance];
    //if ([DeviceManager IsiPad])
    //{
    //    self.arrSessions = [objSessionDB WhatIsHappeningNow];
    //}
    //else
    //{
    //    self.arrSessions = [objSessionDB WhatIsHappeningAndGrouped:YES];
    //}
        
    if (self.arrTracks == nil)
    {
        self.arrTracks = [[NSArray alloc] init];
    }
    
    //if (self.arrSubTracks == nil)
    //{
    //    self.arrSubTracks = [[NSArray alloc] init];
    //}
    //self.arrSubTracks = [objMasterDB GetSubTracks];
    
    if (self.arrProducts == nil)
    {
        self.arrProducts = [[NSArray alloc] init];
    }
    
    if (self.arrSessionTypes == nil)
    {
        self.arrSessionTypes = [[NSArray alloc] init];
    }
    
    if (self.arrIndustries == nil)
    {
        self.arrIndustries = [[NSArray alloc] init];
    }
    
    if (self.arrSpeakers == nil)
    {
        self.arrSpeakers = [[NSArray alloc] init];
    }
    
    MasterDB *objMasterDB = [MasterDB GetInstance];
    self.arrTracks = [objMasterDB GetTracks];
    self.arrProducts = [objMasterDB GetProducts];
    self.arrSessionTypes = [objMasterDB GetSessionTypes];
    self.arrIndustries = [objMasterDB GetIndustries];
    self.arrSpeakers = [objMasterDB GetSpeakers];
    
    //if (self.arrVenues == nil)
    //{
    //    self.arrVenues = [[NSArray alloc] init];
    //}
    
    //VenueDB *objVenueDB = [VenueDB GetInstance];
    //self.arrVenues = [objVenueDB GetVenues];
    
    [self setBorders];
    
    [Analytics AddAnalyticsForScreen:strSCREEN_HAPPENING_NOW];
    
    //[UIView addTouchEffect:self.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //if ([DeviceManager IsiPad])
    //{
    //    NSIndexPath *selection = [NSIndexPath indexPathForItem:0 inSection:0];
    //    [self.agendaCollectionView selectItemAtIndexPath:selection animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    //}
    
    if (self.arrSessions == nil)
    {
        self.arrSessions = [[NSArray alloc] init];
    }
    
    SessionDB *objSessionDB = [SessionDB GetInstance];
    if ([DeviceManager IsiPad])
    {
        self.arrSessions = [objSessionDB WhatIsHappeningNow];
    }
    else
    {
        self.arrSessions = [objSessionDB WhatIsHappeningAndGrouped:YES];
    }
    
    if([[self arrSessions] count] > 0)
    {
        [[self agendaCollectionView] setHidden:NO];
        [[self lblNoItemsFound] setHidden:YES];
        
        [self.agendaCollectionView reloadData];
    }
    else
    {
        [[self agendaCollectionView] setHidden:YES];
        [[self lblNoItemsFound] setHidden:NO];
    }
    
    objSender = nil;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if([DeviceManager IsiPad] == YES)
    {
        //return UIInterfaceOrientationMaskAll;
        return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"loadSessionDetail2"] || [segue.identifier isEqualToString:@"loadSessionDetail6"])
    {
        NSInteger tagselected;
        
        //UIButton *btnDetail = (UIButton *)sender;
        
        SessionDetailViewController *controller = segue.destinationViewController;
        
        if ([sender isKindOfClass:[UIButton class]])
        {
            UIButton *btnDetail = (UIButton *)sender;
            tagselected = btnDetail.tag;
        }
        else
        {
            tagselected = ((CustomCollectionViewCell *)sender).tag;
        }
        
        controller.intTag = tagselected;
        
        if([DeviceManager IsiPad])
        {
            controller.sessionData = [self.arrSessions objectAtIndex:tagselected];
        }
        else
        {
            //controller.sessionData = [[self.arrSessions objectAtIndex:tagselected] objectAtIndex:1];
            controller.sessionData = [[[self.arrSessions objectAtIndex:intDateRow] objectAtIndex:1] objectAtIndex:tagselected];
        }
    }
    else if ([segue.identifier isEqualToString:@"gotoAddNote"])
    {
        UIButton *btnNote = (UIButton *)sender;
        SessionNoteViewController *controller = segue.destinationViewController;
        controller.sessionData = [[[self.arrSessions objectAtIndex:intDateRow] objectAtIndex:1] objectAtIndex:btnNote.tag];
        controller.strSessionInstanceID = ((Session*)[[[self.arrSessions objectAtIndex:intDateRow] objectAtIndex:1] objectAtIndex:btnNote.tag]).strSessionInstanceID;
        controller.blnNew = YES;
    }
    else if ([segue.identifier isEqualToString:@"gotoNotes"])
    {
        UIButton *btnNote = (UIButton *)sender;
        NotesViewController *controller = segue.destinationViewController;
        controller.sessionData = [[[self.arrSessions objectAtIndex:intDateRow] objectAtIndex:1] objectAtIndex:btnNote.tag];
        controller.strSessionInstanceID = ((Session*)[[[self.arrSessions objectAtIndex:intDateRow] objectAtIndex:1] objectAtIndex:btnNote.tag]).strSessionInstanceID;
    }
}

#pragma mark - UICollectionViewDataSource methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [self.arrSessions count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([DeviceManager IsiPhone])
    {
        intDateRow = indexPath.row;
        
        HappeningNowCustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        
        NSString *strDate = [NSString stringWithFormat:@"%@",[[self.arrSessions objectAtIndex:indexPath.row] objectAtIndex:0]];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSDate *dbdate = [dateFormat dateFromString:strDate];
        
        //if ([DeviceManager IsiPad])
        //{
        //    [dateFormat setDateFormat:@"EEEE, LLLL d"];
        //    NSString *strFormattedDate = [dateFormat stringFromDate:dbdate];
        //    cell.articleTitle.text = strFormattedDate;
        //}
        //else
        //{
            //[dateFormat setDateFormat:@"EE, d LLLL"];
            [dateFormat setDateFormat:@"EE, d LLL"];
            NSString *strFormattedDate = [dateFormat stringFromDate:dbdate];
            cell.articleTitle.text = [strFormattedDate lowercaseString];
        //}
        
        [cell setTableViewDataSourceDelegate:cell arrSessionList:[[self.arrSessions objectAtIndex:indexPath.row] objectAtIndex:1]];
        
        //[UIView addTouchEffect:cell.contentView];

        return cell;
    }
    else
    {
        //if (cell.selected)
        //{
        //    [cell.articleImage setHidden:NO];
        //}
        
        //Session *objSession = [self.arrSessions objectAtIndex:indexPath.row];
        //cell.lblTitle.text = objSession.strSessionTitle;
        //cell.lblName.text = @"";
        //cell.lblDate.text = [self formatDate:objSession.strStartDate sourceFormat:@"yyyy-MM-dd" destinationFormat:@"EEEE, LLLL d"];
        //cell.lblLocation.text = @"";
        //cell.lblTiming.text = [NSString stringWithFormat:@"%@ - %@",[self formatDate:objSession.strStartDate sourceFormat:@"HH:mm:ss" destinationFormat:@"HH:mm a"],[self formatDate:objSession.strStartDate sourceFormat:@"HH:mm:ss" destinationFormat:@"HH:mm a"]];
        
        CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"TCell" forIndexPath:indexPath];
        
        Session *objSession = [self.arrSessions objectAtIndex:indexPath.row];
        
        cell.lblTitle.text = objSession.strSessionTitle;
        cell.tag = indexPath.row;
        cell.btnDetail.tag = indexPath.row;
        
        [cell.vwSessionButtons setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:122/255.0 alpha:1.0]];
        if([[objSession strIsAdded] boolValue])
        {
            [cell.vwSessionButtons setBackgroundColor:[UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0]];
        }
        
        cell.btnAddToMySchedule.hidden = [[objSession strIsAdded] boolValue];
        cell.btnAddToMySchedule.tag = indexPath.row;
        
        cell.btnRemoveFromMySchedule.hidden = ![[objSession strIsAdded] boolValue];
        cell.btnRemoveFromMySchedule.tag = indexPath.row;
        
        [cell.btnAddToMySchedule addTarget:self action:@selector(AddToMySchedule:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnRemoveFromMySchedule addTarget:self action:@selector(RemoveFromMySchedule:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *strSpeakers = @"";
        if([objSession.arrSpeakers count] > 0)
        {
            for (NSUInteger i = 0; i < [objSession.arrSpeakers count]; i++)
            {
                if(![NSString IsEmpty:strSpeakers shouldCleanWhiteSpace:YES])
                {
                    strSpeakers = [strSpeakers stringByAppendingString:@", "];
                }
                strSpeakers = [strSpeakers stringByAppendingString:[[[objSession.arrSpeakers objectAtIndex:i] objectAtIndex:0] strFirstName]];
                strSpeakers = [strSpeakers stringByAppendingString:@" "];
                strSpeakers = [strSpeakers stringByAppendingString:[[[objSession.arrSpeakers objectAtIndex:i] objectAtIndex:0] strLastName]];
            }
        }
        cell.lblName.text = strSpeakers;
        
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"yyyy-MM-dd"];
        NSDate *dtStartDate = [dateFormater dateFromString:objSession.strStartDate];
        [dateFormater setDateFormat:@"EEEE, dd MMM."];
        cell.lblDate.text = [NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtStartDate]];
        
        [dateFormater setDateFormat:@"HH:mm:ss"];
        NSDate *dtStartTime = [dateFormater dateFromString:objSession.strStartTime];
        NSDate *dtEndTime = [dateFormater dateFromString:objSession.strEndTime];
        
        [dateFormater setDateFormat:@"hh:mm a"];
        NSString *strTime = [NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtStartTime]];
        strTime = [strTime stringByAppendingString:@" - "];
        strTime = [strTime stringByAppendingString:[NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtEndTime]]];
        cell.lblTiming.text = strTime;
        
        if ([objSession.arrRooms count] > 0){
         Rooms *objRoom = [objSession.arrRooms objectAtIndex:0];
         cell.lblRoom.text = objRoom.strRoomName;
        }
        cell.lblSessionCode.text = [NSString stringWithFormat:@"Session Code: %@",objSession.strSessionCode];
        
        //[UIView addTouchEffect:cell.contentView];
        
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    
    if([DeviceManager IsiPad])
    {
        size = CGSizeMake(300.0f, 250.0f);
    }
    else
    {
        if([DeviceManager Is4Inch])
        {
           size = CGSizeMake(320.0f, 460.0f);
        }
        else
        {
           size = CGSizeMake(320.0f, 372.0f);
        }
    }
    
    return size;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//}

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
            intReturnValue = [self.arrTracks count];
            break;
        case 2:
            intReturnValue = [self.arrProducts count];
            break;
        case 3:
            intReturnValue = [self.arrSessionTypes count];
            break;
        case 4:
            intReturnValue = [self.arrIndustries count];
            break;
        case 5:
            intReturnValue = [self.arrSpeakers count];
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
    switch (tableView.tag) {
        case 1:
        {
            Tracks *objTrack = [self.arrTracks objectAtIndex:indexPath.row];
            strTitle = objTrack.strTrackName;
        }
            break;
        case 2:
        {
            Filters *objFilters = [self.arrProducts objectAtIndex:indexPath.row];
            strTitle = objFilters.strCategory;
        }
            break;
        case 3:
        {
            SessionTypes *objSessionType = [self.arrSessionTypes objectAtIndex:indexPath.row];
            strTitle = objSessionType.strSessionTypeName;
        }
            break;
        case 4:
        {
            Filters *objFilters = [self.arrIndustries objectAtIndex:indexPath.row];
            strTitle = objFilters.strCategory;
        }
            break;
        case 5:
        {
           
            Filters *objSpeaker = [self.arrSpeakers objectAtIndex:indexPath.row];
            NSString *firstname;
            firstname = objSpeaker.strCategory;
            if ([firstname isEqualToString:@"All"]) {
                strTitle = firstname;
            }else{
                
                NSString *lastname;
                lastname = objSpeaker.strCategoryName;
                NSLog(@"lastname %@",lastname);
                NSString *str = @" ";
                strTitle = [NSString stringWithFormat:@"%@%@%@", firstname, str, lastname];
            }

        }
            break;
//        case 6:
//        {
//            
//            Filters *objSpeaker = [self.arrt objectAtIndex:indexPath.row];
//            NSString *firstname;
//            firstname = objSpeaker.strCategory;
//            if ([firstname isEqualToString:@"All"]) {
//                strTitle = firstname;
//            }else{
//                
//                NSString *lastname;
//                lastname = objSpeaker.strCategoryName;
//                NSLog(@"lastname %@",lastname);
//                NSString *str = @" ";
//                strTitle = [NSString stringWithFormat:@"%@%@%@", firstname, str, lastname];
//            }
//            
//        }
//            break;
        default:
            strTitle = @"";
            break;
    }
    //VenueFloorPlan *objVenueFloorPlan = [self.arrFloorPlans objectAtIndex:indexPath.row];
    cell.textLabel.text = strTitle;// [NSString stringWithFormat:@"Track %d",indexPath.row];//objVenueFloorPlan.strBriefDescription;
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:(104/255.0) green:(33/255.5) blue:0 alpha:1];
    cell.selectedBackgroundView = selectionColor;
    
    //[UIView addTouchEffect:cell.contentView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self ShrinkAllDropdownViews];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.blnDropdownExpanded = NO;
    switch (tableView.tag)
    {
        case 1:
        {
            Tracks *objTrack = [self.arrTracks objectAtIndex:indexPath.row];
            self.lblTrack.text = objTrack.strTrackName;
            
            MasterDB *objMasterDB = [MasterDB GetInstance];
            self.lblTrackInstanceID.text = [objMasterDB GetTrackInstanceID:self.lblTrack.text];
            
            SessionDB *objSessionDB = [SessionDB GetInstance];
            self.arrSessions = [objSessionDB GetSessionsWithTrackIDAndProductIDAndSessionTypeIDAndIndustryID:self.lblTrackInstanceID.text ProductID:self.lblProductID.text SessionTypeID:self.lblSessionTypeID.text IndustryID:self.lblIndustryID.text SpeakerID:self.lblSpeakerID.text TimeSlotID:self.lblTimeslotID.text];
            
            if([[self arrSessions] count] > 0)
            {
                [[self agendaCollectionView] setHidden:NO];
                [[self lblNoItemsFound] setHidden:YES];
                
                [self.agendaCollectionView reloadData];
            }
            else
            {
                [[self agendaCollectionView] setHidden:YES];
                [[self lblNoItemsFound] setHidden:NO];
            }
        }
            break;
        case 2:
        {
            Filters *objFilters = [self.arrProducts objectAtIndex:indexPath.row];
            self.lblProduct.text = objFilters.strCategory;
            
            MasterDB *objMasterDB = [MasterDB GetInstance];
            self.lblProductID.text = [objMasterDB GetProductID:self.lblProduct.text];
            
            SessionDB *objSessionDB = [SessionDB GetInstance];
            self.arrSessions = [objSessionDB GetSessionsWithTrackIDAndProductIDAndSessionTypeIDAndIndustryID:self.lblTrackInstanceID.text ProductID:self.lblProductID.text SessionTypeID:self.lblSessionTypeID.text IndustryID:self.lblIndustryID.text SpeakerID:self.lblSpeakerID.text TimeSlotID:self.lblTimeslotID.text];
            
            if([[self arrSessions] count] > 0)
            {
                [[self agendaCollectionView] setHidden:NO];
                [[self lblNoItemsFound] setHidden:YES];
                
                [self.agendaCollectionView reloadData];
            }
            else
            {
                [[self agendaCollectionView] setHidden:YES];
                [[self lblNoItemsFound] setHidden:NO];
            }
        }
            break;
        case 3:
        {
            SessionTypes *objSessionType = [self.arrSessionTypes objectAtIndex:indexPath.row];
            self.lblSessionType.text = objSessionType.strSessionTypeName;
            
            MasterDB *objMasterDB = [MasterDB GetInstance];
            self.lblSessionTypeID.text = [objMasterDB GetSessionTypeID:self.lblSessionType.text];
            
            SessionDB *objSessionDB = [SessionDB GetInstance];
            self.arrSessions = [objSessionDB GetSessionsWithTrackIDAndProductIDAndSessionTypeIDAndIndustryID:self.lblTrackInstanceID.text ProductID:self.lblProductID.text SessionTypeID:self.lblSessionTypeID.text IndustryID:self.lblIndustryID.text SpeakerID:self.lblSpeakerID.text TimeSlotID:self.lblTimeslotID.text];
            
            if([[self arrSessions] count] > 0)
            {
                [[self agendaCollectionView] setHidden:NO];
                [[self lblNoItemsFound] setHidden:YES];
                
                [self.agendaCollectionView reloadData];
            }
            else
            {
                [[self agendaCollectionView] setHidden:YES];
                [[self lblNoItemsFound] setHidden:NO];
            }
        }
            break;
        case 4:
        {
            Filters *objFilters = [self.arrIndustries objectAtIndex:indexPath.row];
            self.lblIndustry.text = objFilters.strCategory;
            
            MasterDB *objMasterDB = [MasterDB GetInstance];
            self.lblIndustryID.text = [objMasterDB GetIndustryID:self.lblIndustry.text];
            
            SessionDB *objSessionDB = [SessionDB GetInstance];
            self.arrSessions = [objSessionDB GetSessionsWithTrackIDAndProductIDAndSessionTypeIDAndIndustryID:self.lblTrackInstanceID.text ProductID:self.lblProductID.text SessionTypeID:self.lblSessionTypeID.text IndustryID:self.lblIndustryID.text SpeakerID:self.lblSpeakerID.text TimeSlotID:self.lblTimeslotID.text];
            
            [self.agendaCollectionView reloadData];
        }
            break;
        default:
            break;
    }
    //[self setFloorPlanData:indexPath.row];
}

- (IBAction)showDropdownMenu:(id)sender
{
    if (self.blnDropdownExpanded)
    {
        [self ShrinkAllDropdownViews];
        self.blnDropdownExpanded = NO;
    }
    else
    {
        UIButton *clickedButton = (UIButton *)sender;
        [self expandView:clickedButton.tag];
        self.blnDropdownExpanded = YES;
    }
}

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)expandView:(NSInteger)tag
{
    //NSLog(@"%0.2f",[UIScreen mainScreen].bounds.size.height);
    
    //NSInteger intExpandHeight = 350;
    NSInteger intExpandHeight = [UIScreen mainScreen].bounds.size.height - 130;
    if ([DeviceManager IsiPad])
    {
        intExpandHeight = 550;
    }
    
    switch (tag)
    {
        case 1:
        {
            intExpandHeight = intExpandHeight - self.vwTracksDropdown.frame.origin.y;            
            [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
                self.vwTracksDropdown.frame = CGRectMake(self.vwTracksDropdown.frame.origin.x, self.vwTracksDropdown.frame.origin.y, (self.vwTracksDropdown.frame.size.width), intExpandHeight);
                
            } completion:nil];
        }
            break;
        case 2:
        {
            intExpandHeight = intExpandHeight - self.vwProductDropdown.frame.origin.y;
            [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
                self.vwProductDropdown.frame = CGRectMake(self.vwProductDropdown.frame.origin.x, self.vwProductDropdown.frame.origin.y, (self.vwProductDropdown.frame.size.width), intExpandHeight);
                
            } completion:nil];
        }
            break;
        case 3:
        {
            intExpandHeight = intExpandHeight - self.vwSessionTypeDropdown.frame.origin.y;
            [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
                self.vwSessionTypeDropdown.frame = CGRectMake(self.vwSessionTypeDropdown.frame.origin.x, self.vwSessionTypeDropdown.frame.origin.y, (self.vwSessionTypeDropdown.frame.size.width), intExpandHeight);
                
            } completion:nil];
        }
            break;
        case 4:
        {
            intExpandHeight = intExpandHeight - self.vwIndustryDropdown.frame.origin.y;
            [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
                self.vwIndustryDropdown.frame = CGRectMake(self.vwIndustryDropdown.frame.origin.x, self.vwIndustryDropdown.frame.origin.y, (self.vwIndustryDropdown.frame.size.width), intExpandHeight);
                
            } completion:nil];
        }
            break;
        default:
            break;
    }
    //blnViewExpanded = YES;
}

- (void)ShrinkView
{
    [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
        self.vwTracksDropdown.frame = CGRectMake(self.vwTracksDropdown.frame.origin.x, self.vwTracksDropdown.frame.origin.y, (self.vwTracksDropdown.frame.size.width), 0);
    } completion:nil];
    //blnViewExpanded = NO;
}

-(void)ShrinkAllDropdownViews
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
        self.vwTracksDropdown.frame = CGRectMake(self.vwTracksDropdown.frame.origin.x, self.vwTracksDropdown.frame.origin.y, (self.vwTracksDropdown.frame.size.width), 0);
    } completion:nil];

    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
        self.vwProductDropdown.frame = CGRectMake(self.vwProductDropdown.frame.origin.x, self.vwProductDropdown.frame.origin.y, (self.vwProductDropdown.frame.size.width), 0);
    } completion:nil];
    
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
        self.vwSessionTypeDropdown.frame = CGRectMake(self.vwSessionTypeDropdown.frame.origin.x, self.vwSessionTypeDropdown.frame.origin.y, (self.vwSessionTypeDropdown.frame.size.width), 0);
    } completion:nil];
    
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
        self.vwIndustryDropdown.frame = CGRectMake(self.vwIndustryDropdown.frame.origin.x, self.vwIndustryDropdown.frame.origin.y, (self.vwIndustryDropdown.frame.size.width), 0);
    } completion:nil];
    
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
        self.vwIndustryDropdown.frame = CGRectMake(self.vwSpeakerDropdown.frame.origin.x, self.vwSpeakerDropdown.frame.origin.y, (self.vwSpeakerDropdown.frame.size.width), 0);
    } completion:nil];
    
}

-(void)setBorders
{
    [self setBorderToView:self.vwTracksDropdown];
    [self setBorderToView:self.vwProductDropdown];
    [self setBorderToView:self.vwSessionTypeDropdown];
    [self setBorderToView:self.vwIndustryDropdown];
    [self setBorderToView:self.vwSpeakerDropdown];
}

-(void)setBorderToView:(UIView *)view
{
    [[view layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[view layer] setBorderWidth:1.5];
    //[[self.vwTracksDropdown layer] setCornerRadius:10];
    [view setClipsToBounds: YES];
}

-(NSString *)formatDate:(NSString *)strDate sourceFormat:(NSString *)sourceFormat destinationFormat:(NSString *)destinationFormat
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:sourceFormat];
    NSDate *dbdate = [dateFormat dateFromString:strDate];
    [dateFormat setDateFormat:destinationFormat];
    NSString *strFormattedDate = [dateFormat stringFromDate:dbdate];
    return strFormattedDate;
}

- (IBAction)AddToMySchedule:(id)sender
{
    BOOL blnResult = NO;
    
    objSender = sender;
    UIButton *btnAdd = (UIButton*)sender;
    
    Session *objSession = [self.arrSessions objectAtIndex:btnAdd.tag];
    
    NSLog(@"%@",[objSession strSessionInstanceID]);
    NSLog(@"%@",[objSession strSessionTitle]);
    
    MySessionDB *objMySessionDB = [MySessionDB GetInstance];
    blnResult = [objMySessionDB AddSession:[objSession strSessionInstanceID]];
    
    User *objUser = [User GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_SESSION_ADD_MY_SESSION_LIST];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    
    [objRequest addValue:[objSession strSessionInstanceID] forHTTPHeaderField:@"SessionInstanceId"];
    [objRequest addValue:@"false" forHTTPHeaderField:@"IsScheduleRemoved"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_ADD_MY_SESSION_LIST];
}

- (IBAction)RemoveFromMySchedule:(id)sender
{
    objSender = sender;
    
    UIAlertView *confirm = [[UIAlertView alloc]
                            initWithTitle:nil
                            message:@"Do you really want to remove this session from you r schedule?"
                            delegate:self
                            cancelButtonTitle:@"Yes"
                            otherButtonTitles:@"No", nil];
    
    confirm.tag = 1;
    [confirm show];
}

- (void)RemoveFromMySchedule
{
    BOOL blnResult = NO;
    
    //objSender = sender;
    //UIButton *btnRemove = (UIButton*)sender;
    UIButton *btnRemove = (UIButton*)objSender;
    
    Session *objSession = [self.arrSessions objectAtIndex:btnRemove.tag];
    
    NSLog(@"%@",[objSession strSessionInstanceID]);
    NSLog(@"%@",[objSession strSessionTitle]);
    
    MySessionDB *objMySessionDB = [MySessionDB GetInstance];
    blnResult = [objMySessionDB DeleteSession:[objSession strSessionInstanceID]];
    
    User *objUser = [User GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_SESSION_ADD_MY_SESSION_LIST];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    
    [objRequest addValue:[objSession strSessionInstanceID] forHTTPHeaderField:@"SessionInstanceId"];
    [objRequest addValue:@"true" forHTTPHeaderField:@"IsScheduleRemoved"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_REMOVE_MY_SESSION_LIST];
}

- (void)showAlert:(NSString*)titleMsg withMessage:(NSString*)alertMsg withButton:(NSString*)btnMsg withIcon:(NSString*)imagePath
{
	UIAlertView *currentAlert	= [[UIAlertView alloc]
                                   initWithTitle:titleMsg
                                   message:alertMsg
                                   delegate:nil
                                   cancelButtonTitle:btnMsg
                                   otherButtonTitles:nil];
    
	[currentAlert show];
}

#pragma mark Connections Events
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    objSender = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    objData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [objData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSInteger intTag = (int)[connection getTag];
    //NSLog(@"Connection Tag: %d",intTag);
    
    NSString *strData = [[NSString alloc]initWithData:objData encoding:NSUTF8StringEncoding];
    //NSLog(@"Response: %@",strData);
    
    switch (intTag)
    {
        case OPER_ADD_MY_SESSION_LIST:
        {
            if ([strData isEqualToString:@"true"])
            {
                UIButton *btnAdd = (UIButton*)objSender;
                [[self.arrSessions objectAtIndex:btnAdd.tag] setStrIsAdded:@"1"];
                
                [self.agendaCollectionView reloadData];
                objSender = nil;
                
                 [self showAlert:nil withMessage:@"Session added to your schedule." withButton:@"OK" withIcon:nil];                                       
            }
        }
            break;
        case OPER_REMOVE_MY_SESSION_LIST:
        {
            if ([strData isEqualToString:@"true"])
            {
                UIButton *btnRemove = (UIButton*)objSender;
                [[self.arrSessions objectAtIndex:btnRemove.tag] setStrIsAdded: @"0"];
                
                [self.agendaCollectionView reloadData];
                objSender = nil;
                
                [self showAlert:nil withMessage:@"Session has been removed from your schedule." withButton:@"OK" withIcon:nil];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark -

-(void)viewDidLayoutSubviews
{
    if([DeviceManager IsiPad])
    {
        self.agendaCollectionView.frame = [self collectionViewContentSize];
        [self.svwWhatsNow setContentSize:CGSizeMake([self collectionViewContentSize].size.width, self.svwWhatsNow.frame.size.height)];
    }
    [self.svwWhatsNow setContentSize:CGSizeMake(640.0, self.svwWhatsNow.frame.size.height)];
}

- (CGRect)collectionViewContentSize
{
    if([DeviceManager IsiPad])
    {
        double itemCount = [self.agendaCollectionView numberOfItemsInSection:0] ;
        double totalWidth = ceil((itemCount*320)/2.0);

        return CGRectMake(self.agendaCollectionView.frame.origin.x, self.agendaCollectionView.frame.origin.y, totalWidth, self.agendaCollectionView.frame.size.height);
    }
    else
    {
        return CGRectMake(self.agendaCollectionView.frame.origin.x, self.agendaCollectionView.frame.origin.y, self.agendaCollectionView.frame.size.width, self.agendaCollectionView.frame.size.height);
    }
}

#pragma mark Alert Events
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag != 1)
    {
        return;
    }
    
    switch (buttonIndex)
    {
        case 0:
        {
            [self RemoveFromMySchedule];
        }
            break;
        case 1:
        {
            //Do Nothing
        }
            break;
        default:
            break;
    }
}
#pragma mark  -
@end
