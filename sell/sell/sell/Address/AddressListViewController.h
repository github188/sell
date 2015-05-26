//
//  AddressListViewController.h
//  eAinng
//
//  Created by tmachc on 15/3/4.
//  Copyright (c) 2015年 CCWOnline. All rights reserved.
//

typedef NS_ENUM(NSInteger, StateOfAddressEdit) {
    StateOfSelect,
    StateOfJustEdit
};

@interface AddressListViewController : ParentViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) StateOfAddressEdit stateOfAddress;

- (void)getDataFromNet;

@end
