//
//  NotificationMacro.h
//  Weimai
//
//  Created by Richard Shen on 16/1/19.
//  Copyright © 2016年 Weibo. All rights reserved.
//

#ifndef NotificationMacro_h
#define NotificationMacro_h

//token失效
#define kNotificationInvalidToken                   @"kNotificationInvalidToken"

//首页Feed展开缩回描述
#define kNotificationHomeFeedContentChange          @"kNotificationHomeFeedContentChange"

//移除首页关注的推荐用户
#define kNotificationHomeRemoveFollowedCell         @"kNotificationHomeRemoveFollowedCell"

//评论页移除删除的评论
#define kNotificationCommentRemoveDeleteCell        @"kNotificationCommentRemoveDeleteCell"

//刷新商品列表
#define kNotificationProductListUpdate               @"kNotificationProductListUpdate"

//商品分类刷新
#define kNotificationProductCategoryUpdate           @"kNotificationProductCategoryUpdate"

//收到新消息更新消息记录页面未读数
#define kNotificationUnreadCountUpdate               @"kNotificationUnreadCountUpdate"

//收到新消息更新tabbar未读数
#define kNotificationUnreadCountBadgeUpdate          @"kNotificationUnreadCountBadgeUpdate"

//订单确认收货
#define kNotificationOrderSatausChange               @"kNotificationOrderSatausChange"

//付款后订单刷新
#define kNotificationOrderListUpdate                 @"kNotificationOrderListUpdate"

//订单详情刷新
#define kNotificationOrderDetailUpdate               @"kNotificationOrderDetailUpdate"

#endif /* NotificationMacro_h */
