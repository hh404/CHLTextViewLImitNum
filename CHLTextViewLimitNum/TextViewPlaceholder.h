//
//  TextViewPlaceholder.h
//  YuWan
//
//  Created by huochaihy on 2016/11/10.
//  Copyright © 2016年 changhailuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextViewPlaceholder : UITextView

/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

@end
