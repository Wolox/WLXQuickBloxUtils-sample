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

@property (weak, nonatomic) id<UserTableViewCellDelegate> delegate;

@end

@implementation UserTableViewCell

- (void)populateWithViewModel:(UserViewModel *)viewModel delegate:(id<UserTableViewCellDelegate>)delegate indexPath:(NSIndexPath *)indexPath {
    self.delegate = delegate;
    
    self.nameLabel.text = viewModel.email;
    [self.talkButton setTitle:viewModel.talkButtonTitle forState:UIControlStateNormal];
    self.talkButton.tag = indexPath.row;
    [self.talkButton addTarget:self.delegate action:@selector(didPressTalk:) forControlEvents:UIControlEventTouchUpInside];
}

@end
