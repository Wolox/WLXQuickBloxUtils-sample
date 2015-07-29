//
//  ConversationViewController.m
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/28/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import "ConversationViewController.h"

#import "JSQMessages.h"

#import "UIView+MakeToast.h"

NSUInteger const MessagesBetweenDates = 3;

@interface ConversationViewController ()

@property (strong, nonatomic) UITapGestureRecognizer *recognizer;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

@end

@implementation ConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initJsqUIAttributes];
    [self registerForNotifications];
    [self performRequest];
}

#pragma mark - Initializers

- (void)initJsqUIAttributes {
    self.title = self.viewModel.title;
    self.senderId = [@(self.viewModel.senderId) stringValue];
    self.senderDisplayName = self.viewModel.title;
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleBlueColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.messageBubbleFont = [UIFont fontWithName:@"HelveticaNeue" size:14];
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    self.inputToolbar.contentView.textView.placeHolder = nil;
    self.showLoadEarlierMessagesHeader = YES;
    self.collectionView.loadEarlierMessagesHeaderTextColor = [UIColor blueColor];
}

- (void)initRecognizers {
    self.recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.collectionView addGestureRecognizer:self.recognizer];
}

#pragma mark - Notification methods

- (void)registerForNotifications {
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:PrivateMessageReceivedNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *notification) {
                                                      __strong typeof(self) strongSelf = weakSelf;
                                                      [strongSelf.viewModel addMessage:notification.userInfo[@"message"]];
                                                      [strongSelf.collectionView reloadData];
                                                      [strongSelf scrollToBottomAnimated:YES];
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:PrivateMessageNotSentNoticifation
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *notification) {
                                                      __strong typeof(self) strongSelf = weakSelf;
                                                      [strongSelf.view makeToastWithText:notification.userInfo[@"error"]];
                                                  }];
}

#pragma mark - <JSQMessageViewController>


- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date {
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    [self.viewModel createMessage:text sentAt:[NSDate date]];
    [self finishSendingMessageAnimated:YES];
    [self scrollToBottomAnimated:YES];
}

#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    MessageViewModel *messageViewModel = [self.viewModel objectAtIndex:indexPath.item];
    return [self.viewModel isOutgoing:messageViewModel] ? self.outgoingBubbleImageData : self.incomingBubbleImageData;
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    MessageViewModel *viewModel = [self.viewModel objectAtIndex:indexPath.item];
    return [viewModel jsqMessage];
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item % MessagesBetweenDates == 0) {
        MessageViewModel *viewModel = [self.viewModel objectAtIndex:indexPath.item];
        return [viewModel dateAttributedString];
    }
    
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel count];
}

#pragma mark JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item % MessagesBetweenDates == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender {
    [self performRequest];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath {
    [self dismissKeyboard];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissKeyboard];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation {
    [self dismissKeyboard];
}

#pragma mark - Request methods

- (void)performRequest {
    [self.viewModel fetchMessages:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            [self scrollToBottomAnimated:NO];
        });
    } failure:^(NSString *errorMSG) {
        [self.view makeToastWithText:errorMSG];
    }];
}

#pragma mark - Recognizer actions

- (void)dismissKeyboard {
    if([self.inputToolbar.contentView.textView isFirstResponder]) {
        [self.inputToolbar.contentView.textView resignFirstResponder];
    }
}

@end
