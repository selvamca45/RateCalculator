//
//  DropDownView.m
//  TTDNow
//
//  Created by Shyamchandar on 24/03/16.
//  Copyright © 2016 HTC Global Services. All rights reserved.
//

#import "DropDownView.h"
#import <QuartzCore/QuartzCore.h>

#define TABLEROWHEIGHT 50;

@implementation DropDownView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (id)defaultDropDownControl
{
    static DropDownView *dropDownView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dropDownView = [[DropDownView alloc] init];
        dropDownView.tableViewDataArray = [[NSMutableArray alloc] init];
       
        dropDownView.dataTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        dropDownView.dataTableView.backgroundColor = [UIColor whiteColor];
        [dropDownView.dataTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//        [dropDownView.dataTableView setSeparatorInset:UIEdgeInsetsMake(-15, 0, 0, 0)];
        [dropDownView.dataTableView setContentInset:UIEdgeInsetsMake(5,0,0,0)];
        dropDownView.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        dropDownView.cancelButton.backgroundColor = [UIColor whiteColor];
        [dropDownView.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [dropDownView.cancelButton setTitleColor:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        dropDownView.cancelButton.titleLabel.font=[UIFont fontWithName:@"Roboto" size:17.0];
        dropDownView.cancelButton.layer.cornerRadius = 10.0;
        dropDownView.dataTableView.layer.cornerRadius = 10.0;
        [dropDownView addSubview:dropDownView.dataTableView];
        [dropDownView addSubview:dropDownView.cancelButton];
        [dropDownView.cancelButton addTarget:dropDownView action:@selector(cancelClicked:) forControlEvents:UIControlEventTouchUpInside];

        dropDownView.listSearchBar = [[UISearchBar alloc] init];
        dropDownView.allowSearching = YES;
        dropDownView.dataTableView.contentOffset = CGPointZero;
    });
    
    return dropDownView;
    
}

- (void)showDropDownForData:(NSMutableArray *)dataArray DropDownType:(DropDownType)dropDpwnTypeValue withFrame:(CGRect)displayFrame inView:(UIView *)parentView Delegate:(id<DropDownViewDelegate>)delegateObject withSelectedModelID:(NSMutableArray *)modelID
{

//    _dataTableView.scrollsToTop = true;
//    [_dataTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];

   
    switch (dropDpwnTypeValue) {
        case DropDownTypeSingleSelectionDefault:
        case DropDownTypeSingleSelectionWithImage:
            self.dropDownType = dropDpwnTypeValue;
            break;
        case DropDownTypeMultipleSelection:
            self.dropDownType = dropDpwnTypeValue;
            self.dataTableView.allowsMultipleSelection = YES;
            break;
        default:
            return;
            break;
    }
   
    
    displayFrame = [UIScreen mainScreen].bounds;
    self.frame = CGRectMake(0, displayFrame.size.height, displayFrame.size.width, displayFrame.size.height);
    self.delegate = delegateObject;
    self.dataTableView.delegate = self;
    self.dataTableView.dataSource = self;
    

    self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:.5];
    self.cancelButton.frame = CGRectMake(5.0, displayFrame.size.height - 55.0, displayFrame.size.width - 10.0, 50.0);
    [self addSubview:self.cancelButton];
    [self.tableViewDataArray removeAllObjects];
    [self.tableViewDataArray addObjectsFromArray:dataArray];
    float tableHeight = dataArray.count * 50.0;
    float availableHeight = displayFrame.size.height - 65.0;
    _listSearchBar.text=nil;
     if (tableHeight > availableHeight && self.dropDownType==DropDownTypeMultipleSelection) {
         if (self.allowSearching) {
             self.dataTableView.frame = CGRectMake(5.0, 55.0+10.0, displayFrame.size.width-10.0, availableHeight - 100.0);
             self.listSearchBar.frame = CGRectMake(5.0, 5.0+10.0, displayFrame.size.width-10.0, 50.0);
             _listSearchBar.searchBarStyle = UISearchBarStyleDefault;
             _listSearchBar.showsCancelButton = YES;
             _listSearchBar.placeholder=@"Search";
             
             [self addSubview:self.listSearchBar];
             _listSearchBar.delegate = self;
             self.cancelButton.frame = CGRectMake(5.0, displayFrame.size.height - 55.0, displayFrame.size.width - 10.0, 45.0);
             self.okButton.frame = CGRectMake(5.0,displayFrame.size.height - 105.0, displayFrame.size.width - 10.0, 45.0);
             [self addSubview:self.okButton];
         }
         else
         {
             self.dataTableView.frame = CGRectMake(5.0, 55.0+10.0, displayFrame.size.width-10.0, availableHeight - 50.0);
             self.okButton.frame = CGRectMake(5.0, displayFrame.size.height - 105.0, displayFrame.size.width - 10.0, 45.0);
             [self.listSearchBar removeFromSuperview];
         }

     }
    else if (tableHeight > availableHeight) {
        if (self.allowSearching) {
            self.dataTableView.frame = CGRectMake(5.0, 55.0+8.0, displayFrame.size.width-10.0, availableHeight - 50.0 - 10.0);
            self.listSearchBar.frame = CGRectMake(5.0, 5.0+10.0, displayFrame.size.width-10.0, 50.0);
            _listSearchBar.searchBarStyle = UISearchBarStyleDefault;
            _listSearchBar.showsCancelButton = YES;
            _listSearchBar.placeholder=@"Search";
            [self addSubview:self.listSearchBar];
            _listSearchBar.delegate = self;
            self.cancelButton.frame = CGRectMake(5.0, displayFrame.size.height - 55.0, displayFrame.size.width - 10.0, 45.0);
//            self.okButton.frame = CGRectMake(5.0,displayFrame.size.height - 105.0, displayFrame.size.width - 10.0, 45.0);
//            [self addSubview:self.okButton];
        }
        else
        {
            self.dataTableView.frame = CGRectMake(5.0, 55.0+8.0, displayFrame.size.width-10.0, availableHeight - 50.0 - 10.0);
//            self.okButton.frame = CGRectMake(5.0, displayFrame.size.height - 105.0, displayFrame.size.width - 10.0, 45.0);
//            [self.listSearchBar removeFromSuperview];
        }
        
    }
    else
    {
        self.dataTableView.frame = CGRectMake(5.0, displayFrame.size.height - (tableHeight + 65.0), displayFrame.size.width-10.0, tableHeight);
        if (self.listSearchBar) {
            [self.listSearchBar removeFromSuperview];
        }
    }
//    if (modelID.count) {
    
        self.selectedModelIDArray = [NSMutableArray arrayWithArray:[modelID copy]];
//    }
   
    [self.dataTableView reloadData];
    [UIView beginAnimations:@"dropDown" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:NO];
    self.frame = displayFrame;
    
//    [parentView.window.rootViewController.view addSubview:self];
    
    [parentView addSubview:self];
    [UIView commitAnimations];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)hideDropDown
{
    [self endEditing:YES];
    [UIView beginAnimations:@"dropDown" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:NO];
    self.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:.6];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [notificationCenter removeObserver:self name:UIKeyboardDidHideNotification object:nil];

    [_dataTableView setContentOffset:CGPointZero];
    _dataTableView.scrollsToTop = true;
    [_dataTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [_dataTableView reloadData];

    
    
}

- (void)cancelClicked:(id)sender
{
    _listSearchBar.text=nil;
    _isSearching=NO;
    
    [_dataTableView reloadData];
    _dataTableView.scrollsToTop = true;


    [self hideDropDown];
}

#pragma mark - keyboard show hide actions
- (void)keyboardWillShow:(NSNotification *)notification{
//    [_dataTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];

    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    CGRect displayFrame = [UIScreen mainScreen].bounds;
    displayFrame = CGRectMake(0, 0, displayFrame.size.width, displayFrame.size.height - keyboardBounds.size.height);
    self.cancelButton.frame = CGRectMake(5.0, displayFrame.size.height - 55.0, displayFrame.size.width - 10.0, 45.0);
    self.okButton.frame = CGRectMake(5.0, displayFrame.size.height - 105.0, displayFrame.size.width - 10.0, 45.0);
    float tableHeight = _tableViewDataArray.count * 50.0;
    float availableHeight = displayFrame.size.height - 65.0;
    if (tableHeight > availableHeight && self.dropDownType==DropDownTypeMultipleSelection) {
        
        self.dataTableView.frame = CGRectMake(5.0, 55.0, displayFrame.size.width-10.0, availableHeight - 100.0);
    }
    else if (tableHeight>availableHeight){
        self.dataTableView.frame = CGRectMake(5.0, 55.0, displayFrame.size.width-10.0, availableHeight - 50.0);
    }
    else
    {
        self.dataTableView.frame = CGRectMake(5.0, availableHeight - tableHeight, displayFrame.size.width-10.0, tableHeight);
    }
   
}

- (void) keyboardWillHide:(NSNotification *)notification{
//    [_dataTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];

    CGRect displayFrame = [UIScreen mainScreen].bounds;
    self.cancelButton.frame = CGRectMake(5.0, displayFrame.size.height - 55.0, displayFrame.size.width - 10.0, 45.0);
    self.okButton.frame = CGRectMake(5.0, displayFrame.size.height - 105.0, displayFrame.size.width - 10.0, 45.0);
    float tableHeight = _tableViewDataArray.count * 50.0;
    float availableHeight = displayFrame.size.height - 65.0;
    if (tableHeight > availableHeight && self.dropDownType==DropDownTypeMultipleSelection) {
        
        self.dataTableView.frame = CGRectMake(5.0, 55.0, displayFrame.size.width-10.0, availableHeight - 100.0);
    }
    else if (tableHeight > availableHeight) {
        self.dataTableView.frame = CGRectMake(5.0, 55.0, displayFrame.size.width-10.0, availableHeight - 50.0);
    }
    else
    {
        self.dataTableView.frame = CGRectMake(5.0, availableHeight - tableHeight, displayFrame.size.width-10.0, tableHeight);
    }
    
}

#pragma mark - search bar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length) {
        _isSearching = YES;
        if (self.tableViewSearchDataArray == nil) {
            self.tableViewSearchDataArray = [NSMutableArray array];
        }
        [self.tableViewSearchDataArray removeAllObjects];
        NSPredicate *searchprdicate = [NSPredicate predicateWithFormat:@"modelDataString BEGINSWITH[c] %@",searchText];
        [self.tableViewSearchDataArray addObjectsFromArray:[self.tableViewDataArray filteredArrayUsingPredicate:searchprdicate]];
        [self.dataTableView reloadData];
        
    }
    else
    {
        _listSearchBar.text=nil;
        _isSearching = NO;
        [self.dataTableView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    _listSearchBar.text=nil;
    _isSearching=NO;

       [_dataTableView reloadData];
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark - uitableview data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isSearching) {
        return self.tableViewSearchDataArray.count;
    }
    return self.tableViewDataArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *dropDownCellIdentifier = @"dropdown";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dropDownCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dropDownCellIdentifier];
        UIImageView *SepImg =[[UIImageView alloc]initWithFrame:CGRectMake(0, cell.frame.size.height-1, tableView.frame.size.width, 0.5)];
//        [SepImg setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]];
        [SepImg setBackgroundColor:[UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:1.0]];
        [cell.contentView addSubview:SepImg];
    }
    
    
    DropDownModel *dropDownObject;
    if (_isSearching) {
        dropDownObject = (DropDownModel *)[self.tableViewSearchDataArray objectAtIndex:indexPath.row];
    }
    else
    {
        dropDownObject = (DropDownModel *)[self.tableViewDataArray objectAtIndex:indexPath.row];
    }
    cell.imageView.image = nil;
   // NSLog(@"********%@", dropDownObject.modelDataString);

    if(dropDownObject.modelDataString){
       // NSLog(@"++++++++%@", dropDownObject.modelDataString);

        cell.textLabel.text = dropDownObject.modelDataString;
    }
    else{
        NSString *s = (DropDownModel *) [self.tableViewDataArray objectAtIndex:0];
        // NSLog(@"%@", dropDownObject.modelIdString);
         NSLog(@"%@", dropDownObject.modelDataString);
          NSLog(@"%@", dropDownObject.modelIdStringNew);
        
        NSLog(@"%@", [self.tableViewDataArray objectAtIndex:0]);
        NSLog(@"%@", [self.tableViewDataArray objectAtIndex:1]);
        cell.textLabel.text=[self.tableViewDataArray objectAtIndex:indexPath.row];
    }
    cell.textLabel.font=[UIFont fontWithName:@"Roboto" size:17.0];
    [cell.textLabel setTextAlignment:NSTextAlignmentLeft]; //NSTextAlignmentCenter  ******************************
    //[cell.textLabel setTextAlignment:NSTextAlignmentNatural];
//    [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
    cell.textLabel.textColor=[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    cell.accessoryView = nil;
    //Comments JSK
   // UIImageView *accessoryImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15.0, 15.0)];
    switch (self.dropDownType) {
        case DropDownTypeSingleSelectionDefault:
       /* case DropDownTypeMultipleSelection:
            if (self.selectedModelIDArray.count) {
                if ([self.selectedModelIDArray containsObject:dropDownObject.modelIdString]) {
//                    accessoryImgView.image = [UIImage imageNamed:@"check_selected.png"];
                    accessoryImgView.image = [UIImage imageNamed:@"radio_Button_selecte.png"];
                    
                }
                else
                {
//                    accessoryImgView.image = [UIImage imageNamed:@"check_default.png"];
                    accessoryImgView.image = [UIImage imageNamed:@"radio_Button_non_selecte.png"];
                }
            }
            else
            {
//                accessoryImgView.image = [UIImage imageNamed:@"check_default.png"];
                accessoryImgView.image = [UIImage imageNamed:@"radio_Button_non_selecte.png"];
        
            }
            cell.accessoryView = accessoryImgView;
            break;*/
        case DropDownTypeSingleSelectionWithImage:
            cell.imageView.image = [UIImage imageWithContentsOfFile:dropDownObject.imagePath];
            if (!cell.imageView.image) {
                cell.imageView.image = [UIImage imageNamed:dropDownObject.imagePath];
                [cell.textLabel setTextAlignment:NSTextAlignmentCenter]; //NSTextAlignmentCenter

            }
            break;
        default:
            break;
    }


   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    _dataTableView.scrollsToTop = true;

    
    DropDownModel *dropDownObject;
    if (_isSearching) {
        dropDownObject = (DropDownModel *)[self.tableViewSearchDataArray objectAtIndex:indexPath.row];
    }
    else
    {
        dropDownObject = (DropDownModel *)[self.tableViewDataArray objectAtIndex:indexPath.row];
    }
    if (self.selectedModelIDArray == nil) {
        self.selectedModelIDArray = [NSMutableArray array];
    }
    switch (self.dropDownType) {
        case DropDownTypeSingleSelectionWithImage:
        case DropDownTypeSingleSelectionDefault:
            [self.selectedModelIDArray removeAllObjects];
//            [self.selectedModelIDArray addObject:[NSString stringWithString:dropDownObject.modelIdString]];
            
            if (_isSearching) {
                _listSearchBar.text=nil;
                [self.delegate selectedData:(DropDownModel *)[self.tableViewSearchDataArray objectAtIndex:indexPath.row]];
                _isSearching=NO;
            }
            else
            {
                [self.delegate selectedData:(DropDownModel *)[self.tableViewDataArray objectAtIndex:indexPath.row]];
            }
//            [self.delegate selectedData1:[self.tableViewDataArray objectAtIndex:indexPath.row]];
            break;
        /*case DropDownTypeMultipleSelection:
            if ([self.selectedModelIDArray containsObject:dropDownObject.modelIdString]) {
                [self.selectedModelIDArray removeObject:dropDownObject.modelIdString];
            }
            else
            {
                [self.selectedModelIDArray addObject:dropDownObject.modelIdString];
            }

            [self.delegate selectedDataArray:self.selectedModelIDArray];
            break;*/
        default:
            break;
    }
    
    [tableView reloadData];

//    [_dataTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];

    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did deselect");
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

@end
