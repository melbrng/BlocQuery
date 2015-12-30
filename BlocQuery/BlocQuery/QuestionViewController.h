//
//  QuestionViewController.h
//  BlocQuery
//
//  Created by Melissa Boring on 12/16/15.
//  Copyright © 2015 melbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import "PFObject.h"

@interface QuestionViewController : UIViewController<UITableViewDataSource>

@property (strong,nonatomic) PFObject *question;
@property (weak, nonatomic) IBOutlet UITableView *answerTableView;

@end
