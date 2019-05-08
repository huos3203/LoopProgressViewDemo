//
//  ProjectCtlTableViewCell.m
//  
//
//  Created by CUG on 16/2/15.
//  Copyright © 2016年 CUG All rights reserved.
//

#import "ProjectCtlTableViewCell.h"
#import "LoopProgressView.h"

@interface ProjectCtlTableViewCell()
@property (nonatomic,strong)IBOutlet LoopProgressView *loopView;

@end

@implementation ProjectCtlTableViewCell

- (void)awakeFromNib {
}

-(void)refreshProjectUI:(CGFloat)loopProgressNumber
{
    self.loopView.progress = loopProgressNumber/100;
}

@end
