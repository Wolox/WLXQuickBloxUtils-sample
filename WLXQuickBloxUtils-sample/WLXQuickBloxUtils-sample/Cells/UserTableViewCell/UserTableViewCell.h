//
//  UserTableViewCell.h
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/27/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserViewModel.h"

@interface UserTableViewCell : UITableViewCell

- (void)populateWithViewModel:(UserViewModel *)viewModel;

@end
