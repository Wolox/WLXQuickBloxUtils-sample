//
//  UITableViewController+RegisterNib.m
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/27/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import "UITableViewController+RegisterNib.h"

@implementation UITableViewController (RegisterNib)

- (void)registerNibWithIdentifier:(NSString *)identifier {
    UINib *nib = [UINib nibWithNibName:identifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:identifier];
}

@end
