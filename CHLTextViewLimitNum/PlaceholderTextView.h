//
//  TextViewPlaceholder.h
//  YuWan
//
//  Created by huochaihy on 2016/11/10.
//  Copyright © 2016年 changhailuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholderTextView : UITextView

/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

@property (nonatomic, assign) NSUInteger maxLength;

/**
 *  @brief 外部UITextView的delegate必须调用,以达到限制最大长度
 *
 *  @param textView <#textView description#>
 *  @param range    <#range description#>
 *  @param text     <#text description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text;

@end
