//
//  QuestionViewController.h
//  BlocQuery
//
//  Created by Melissa Boring on 12/16/15.
//  Copyright © 2015 melbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFObject.h"

@interface QuestionViewController : UIViewController

@property (strong,nonatomic) PFObject *question;

@end
