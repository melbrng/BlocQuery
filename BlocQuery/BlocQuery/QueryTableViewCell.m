//
//  QueryTableViewCell.m
//  BlocQuery
//
//  Created by Melissa Boring on 1/15/16.
//  Copyright © 2016 melbo. All rights reserved.
//

#import "QueryTableViewCell.h"

@interface QueryTableViewCell ()<UIGestureRecognizerDelegate>



@end

@implementation QueryTableViewCell

-(id)initWithCoder:(NSCoder *)aDecoder

{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {

        
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
