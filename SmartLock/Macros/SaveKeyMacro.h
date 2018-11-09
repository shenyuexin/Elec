//
//  SaveKeyMacro.h
//  Weimai
//
//  Created by Richard Shen on 16/4/26.
//  Copyright © 2016年 Weibo. All rights reserved.
//

#ifndef SaveKeyMacro_h
#define SaveKeyMacro_h

#define kLastLoginPhone                 @"kLastLoginPhone"

#define kSaveDeviceToken                @"kSaveDeviceToken"
#define kSaveHotFixScript               @"kSaveHotFixScript"

//用户是否已评分
#define USER_GRADE                      @"user_has_given_a_mark"

#define kSaveToken                      @"kSaveToken"
#define kSaveUser                       @"kSaveUser"

#define kReadedMsgList                  @"kReadedMsgList"

#define kVersionUpdate                  @"version421"

#define kSearchHistory                  @"kSearchHistory"

#define kSearchHistory                  @"kSearchHistory"
#define kSearchMineOrderHistory         @"kSearchMineOrderHistory"

#define kNotificationSound              @"kNotificationSound"
#define kNotificationVibrate            @"kNotificationVibrate"

#define USER_IDENTIFY_SELF_PASSWORD_TIME @"when_user_identified_password_itself" //用户上次验证登录密码的时间 userdefault key
#define USER_IDENTIFY_SELF_MOBILE_TIME @"when_user_identified_mobile_itself" //用户上次验证手机号的时间 userdefault key

#define KEY_DATE_LAST_CHECK_PUSH    @"lastCheckPush"
#define KEY_DATE_LAST_CHECK_ACTION  @"lastCheckAction"
#define KEY_TAG_ACTIVITY            @"keyTagActivity"
#define KEY_GROUP_LIST              @"keyGroupList"
#define KEY_SEARCH_HISTORY          @"keySearchHistory"

#define PATH_OF_DOCUMENTS    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0]

#define PATH_OF_HRTDATA      [PATH_OF_DOCUMENTS stringByAppendingPathComponent:@"HRTDATA"]

#define PATH_OF_IM           [PATH_OF_HRTDATA stringByAppendingPathComponent:@"IM"]

#endif /* SaveKeyMacro_h */
