//
//  QuestionsViewController.h
//  BlocQuery
//
//  Created by Melissa Boring on 12/9/15.
//  Copyright © 2015 melbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import "LoginViewController.h"

@interface QuestionsViewController : PFQueryTableViewController

@property (strong,nonatomic) NSString *username;

@end
