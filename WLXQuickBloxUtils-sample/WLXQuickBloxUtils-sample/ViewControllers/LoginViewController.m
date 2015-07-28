//
//  ViewController.m
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/10/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewModel.h"
#import "UIView+MakeToast.h"
#import "Application.h"
#import "UserListTableViewController.h"
#import "TabBarController.h"

NSString *const TabBarSegueId = @"TabBarSegue";

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) LoginViewModel *viewModel;

@end

@implementation LoginViewController

#pragma mark - View methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeViewModel];
    [self setUI];
    [self setRecognizers];
}

#pragma mark - IBActions

- (IBAction)loginButtonPressed:(id)sender {
    [self updateViewModelData];
    [self validateFieldsWithValidBlock:^{
        [self hideButtons:YES];
        [self performLogin];
    }];
}

- (IBAction)signupButtonPressed:(id)sender {
    [self updateViewModelData];
    [self validateFieldsWithValidBlock:^{
        [self hideButtons:YES];
        [self performSignUp];
    }];
}

- (void)validateFieldsWithValidBlock:(void(^)())validBlock {
    [self.viewModel validate:^(BOOL valid, NSString *errorMessage) {
                        if(valid) {
                            if(validBlock) {
                                validBlock();
                            }
                        } else {
                            [self.view makeToastWithText:errorMessage];
                        }
                    }];
}

#pragma mark - Recognizer methods

- (void)dismissKeyboard:(UITapGestureRecognizer *)recognizer {
    if([self.emailTextField isFirstResponder]) {
        [self.emailTextField resignFirstResponder];
    } else if([self.passwordTextField isFirstResponder]) {
        [self.passwordTextField resignFirstResponder];
    }
}

#pragma mark - Private methods

- (void)initializeViewModel {
    self.viewModel = [[LoginViewModel alloc] initWithQuickbloxUtils:[Application sharedInstance].quickbloxUtils];
}

- (void)setUI {
    self.emailTextField.placeholder = self.viewModel.emailPlaceholder;
    self.passwordTextField.placeholder = self.viewModel.passwordPlaceholder;
    [self.loginButton setTitle:self.viewModel.loginButtonTitle forState:UIControlStateNormal];
    [self.signUpButton setTitle:self.viewModel.signUpButtonTitle forState:UIControlStateNormal];
    self.passwordTextField.secureTextEntry = YES;
    [self hideButtons:NO];
}

- (void)hideButtons:(BOOL)hide {
    self.loginButton.hidden = hide;
    self.signUpButton.hidden = hide;
    hide ? [self.activityIndicator startAnimating] : [self.activityIndicator stopAnimating];
}

- (void)performLogin {
    [self.viewModel login:^(UserViewModel *userViewModel){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self segueToUserList:userViewModel];
            [self hideButtons:NO];
        });
    } failure:^(NSString *errorMSG) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideButtons:NO];
            [self.view makeToastWithText:errorMSG];
        });
    }];
}

- (void)performSignUp {
    [self.viewModel signup:^(UserViewModel *userViewModel) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self segueToUserList:userViewModel];
            [self hideButtons:NO];
        });
    } failure:^(NSString *errorMSG) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideButtons:NO];
            [self.view makeToastWithText:errorMSG];
        });

    }];
}

- (void)setRecognizers {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:recognizer];
}

- (void)segueToUserList:(UserViewModel *)userViewModel {
    [self performSegueWithIdentifier:TabBarSegueId sender:self];
}

- (void)updateViewModelData {
    self.viewModel.password = self.passwordTextField.text;
    self.viewModel.email = self.emailTextField.text;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueIdentifier = [segue identifier];
    if([segueIdentifier isEqualToString:TabBarSegueId]) {
        TabBarController *tabBarController = [segue destinationViewController];
        tabBarController.viewModel = self.viewModel.tabBarViewModel;
    }
}

@end
