//
//  DetailStoryModel.h
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/24.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailStoryModel : NSObject

/** body  HTML 格式的新闻 */
@property (strong, nonatomic) NSString *body;
/** image-source  图片的内容提供方 */
@property (strong, nonatomic) NSString *image_source;
/** title  新闻标题 */
@property (strong, nonatomic) NSString *title;
/** image  图片 */
@property (nonatomic, copy) NSString *image;
/** share_url  分享至 SNS 用的 URL */
@property (strong, nonatomic) NSString *share_url;
/** recommenders  这篇文章的推荐者 */
@property (strong, nonatomic) NSArray *recommenders;
/** section 栏目的信息 */
@property (strong, nonatomic) NSDictionary *section;
/** type  新闻的类型 */
@property (strong, nonatomic) NSNumber *type;
/** id  新闻的 id */
@property (strong, nonatomic) NSNumber *ID;
/** css  供手机端的 WebView(UIWebView) 使用 */
@property (strong, nonatomic) NSArray *css;
/** html  供手机端的 WebView(UIWebView) 使用 */
@property (strong, nonatomic) NSString *htmlUrl;

@end
