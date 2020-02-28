//
//  DropDownView.h
//  TTDNow
//
//  Created by Shyamchandar on 24/03/16.
//  Copyright © 2016 HTC Global Services. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownModel.h"

typedef NS_ENUM(NSInteger, DropDownType) {
    DropDownTypeSingleSelectionDefault,
    DropDownTypeSingleSelectionWithImage,
    DropDownTypeMultipleSelection  
};

@protocol DropDownViewDelegate <NSObject>

- (void)selectedData:(DropDownModel *)dataObject;
- (void)selectedDataArray:(NSMutableArray *)dataArray;
- (void)selectedData1:(NSString*)selectedDataStr;

@end


@interface DropDownView : UIView<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic, strong) UITableView *dataTableView;
@property (nonatomic, strong)UIButton *cancelButton;
@property (nonatomic,strong) UIButton *okButton;
@property (nonatomic, weak) id<DropDownViewDelegate> delegate;
@property (nonatomic, strong) UISearchBar *listSearchBar;
@property (nonatomic, strong) NSMutableArray *tableViewDataArray;
@property (nonatomic, strong) NSMutableArray *tableViewSearchDataArray;
@property (nonatomic, strong) NSMutableArray *selectedModelIDArray;
@property (nonatomic) DropDownType dropDownType;
@property (nonatomic) BOOL isSearching;
@property (nonatomic) BOOL allowSearching;

- (void)showDropDownForData:(NSMutableArray *)dataArray DropDownType:(DropDownType)dropDpwnTypeValue withFrame:(CGRect)displayFrame inView:(UIView *)parentView Delegate:(id<DropDownViewDelegate>)delegateObject withSelectedModelID:(NSMutableArray *)modelID;

- (void)cancelClicked:(id)sender;

- (void)hideDropDown;
+ (id)defaultDropDownControl;


@end
