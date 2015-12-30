//
//  AnswerViewController.h
//  BlocQuery
//
//  Created by Melissa Boring on 12/28/15.
//  Copyright © 2015 melbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFObject.h"
#import "PFUser.h"
#import "PFRelation.h"

@interface AnswerViewController : UIViewController <UITextViewDelegate>

@property (strong,nonatomic) PFObject *question;

@end
