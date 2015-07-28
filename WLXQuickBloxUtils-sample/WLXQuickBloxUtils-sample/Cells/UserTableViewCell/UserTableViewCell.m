//
//  UserTableViewCell.m
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/27/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import "UserTableViewCell.h"

@interface UserTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *talkButton;

@end

@implementation UserTableViewCell

- (void)populateWithViewModel:(UserViewModel *)viewModel {
    self.nameLabel.text = viewModel.email;
    [self.talkButton setTitle:viewModel.talkButtonTitle forState:UIControlStateNormal];
}

@end
