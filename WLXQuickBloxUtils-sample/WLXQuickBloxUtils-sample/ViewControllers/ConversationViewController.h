//
//  ConversationViewController.h
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/28/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import "JSQMessagesViewController.h"
#import "PrivateDialogViewModel.h"

@interface ConversationViewController : JSQMessagesViewController

@property (strong, nonatomic) PrivateDialogViewModel *viewModel;

@end
