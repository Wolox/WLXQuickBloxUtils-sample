//
//  ConversationTableVIewCell.h
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/28/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrivateDialogViewModel.h"

@interface ConversationTableViewCell : UITableViewCell

- (void)populateWithViewModel:(PrivateDialogViewModel *)viewModel;

@end
