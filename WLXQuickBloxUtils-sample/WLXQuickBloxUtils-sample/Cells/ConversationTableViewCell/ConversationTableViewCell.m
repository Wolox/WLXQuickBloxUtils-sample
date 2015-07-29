//
//  ConversationTableVIewCell.m
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/28/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import "ConversationTableViewCell.h"

@interface ConversationTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMessageDateLabel;

@end

@implementation ConversationTableViewCell

- (void)populateWithViewModel:(PrivateDialogViewModel *)viewModel {
    self.nameLabel.text = viewModel.title;
    self.lastMessageLabel.text = viewModel.lastMessage;
    self.lastMessageDateLabel.text = viewModel.lastMessageDate;
}

@end
