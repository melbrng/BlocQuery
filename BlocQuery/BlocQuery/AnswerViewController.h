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

@class AnswerViewController;

//Delegate to let is know if our answer was saved successfully
@protocol AnswerViewControllerDelegate <NSObject>
- (void)answerViewControllerDidSave:(PFObject *)answer;
@end

@interface AnswerViewController : UIViewController <UITextViewDelegate>

@property (strong,nonatomic) PFObject *question;
@property (nonatomic, weak) id <AnswerViewControllerDelegate> delegate;

@end
