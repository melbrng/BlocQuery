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
#import "AnswerViewController.h"

@interface QuestionViewController : PFQueryTableViewController<AnswerViewControllerDelegate>

@property (strong,nonatomic) PFObject *question;
@property (strong,nonatomic) NSMutableArray *answers;

@end
