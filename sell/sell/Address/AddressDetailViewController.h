//
//  AddressDetailViewController.h
//  eAinng
//
//  Created by tmachc on 15/3/4.
//  Copyright (c) 2015年 CCWOnline. All rights reserved.
//

typedef NS_ENUM(NSInteger, StateOfAddress) {
    StateNewAddress = 1,
    StateChangeAddress
};

@interface AddressDetailViewController : ParentViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, assign) StateOfAddress stateOfAddress;
@property (nonatomic, strong) NSMutableDictionary *dicData;

@end
