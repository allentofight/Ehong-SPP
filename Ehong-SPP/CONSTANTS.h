//
//  CONSTANTS.h
//  Vaccine
//
//  Created by Tonny on 7/30/13.
//  Copyright (c) 2013 DoouYa All rights reserved.
//

#ifndef Vaccine_CONSTANTS_h
#define Vaccine_CONSTANTS_h

//#import <CocoaLumberjack/DDLog.h>
#define NEED_OUTPUT_FILE_LOG             1

#ifdef DEBUG
    #define NEED_OUTPUT_LOG             1
    #define MR_ENABLE_ACTIVE_RECORD_LOGGING         0
#else
    #define NEED_OUTPUT_LOG             0
#endif

#define Activity_Threshold 100
#define PROJECTSWIFTHEADERFILE          "BabyHero-Swift.h"
#define kSinaAppKey         @"190409462"
#define isSimulatorTemps        1 //1

#define kRedirectURI        @"http://www.doouya.com/"



#define APP_STORE_LINK_http                 @"https://itunes.apple.com/us/app/cheng-zhang-ji-hua/id870429215?ls=1&mt=8"

#define UMENGKEY           @"54448264fd98c54231008034"

#define WeiXinAppId                         @"wx0274185b146617c3" //dev.mobile@doouya.com
#define WeiXinAppSecret                     @"ee851446fd2b63a7400eb819ab0ac5d9"

#define LEANCLOUD_APPID                     @"zee5vm6ljrj9ywxlz9y87h8pmwxlz2iy3f6ytmwfp0vlqt5k"
#define LEANCLOUD_CLIENTKEY                 @"2zw038e7p6hcbdw8kxljkggl3lvzj74is60trs3cvusnctnt"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


#define iOS_VERSION_6               SYSTEM_VERSION_LESS_THAN(@"7.0")
#define iOS_VERSION_7               SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")
#define iOS_VERSION_8               SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")
#define iOS_9_OR_LATER              SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")


//#define iOS_VERSION_BELOW_6         (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)

#define USER_DEFAULT                [NSUserDefaults standardUserDefaults]

#define kDeviceToken                @"Device_Token"
#define kNotifyToTakeTemperature    @"Loca_Notification_ToTakeTemperature"
#define Noti_New_HeightBit          @"Noti_New_HeightBit"

#define APP_SUPPORT                 [NSSearchPathForDirectoriesInDomains (NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define APP_SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width
#define APP_SCREEN_HEIGHT           [UIScreen mainScreen].bounds.size.height
#define IS_4_INCH                   (APP_SCREEN_HEIGHT > 480.0)

#define RGBCOLOR(r,g,b)             [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a)             [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

#define APP_CACHES_PATH             [NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define APP_DOCUMENT_PATH           [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define COLOR_BACKGROUND    RGBCOLOR(245, 244, 238)

#define FONT_B16        [UIFont boldSystemFontOfSize:16]
#define FONT_B14        [UIFont boldSystemFontOfSize:14]
#define FONT_14         [UIFont systemFontOfSize:14]
#define FONT_B12        [UIFont boldSystemFontOfSize:12]
#define FONT_12         [UIFont systemFontOfSize:12]
#define FONT(x)         [UIFont fontWithName:@"Heiti SC" size:(x)]
#define FONTB(x)        [UIFont boldSystemFontOfSize:x]

#define JPEG(imgName) [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(imgName) ofType:@"jpg"]]

#define DATA_ENV            [TBDataEnvironment sharedInstance]
#define kScreenWidth        [UIScreen mainScreen].bounds.size.width
#define kScreenHeight       [UIScreen mainScreen].bounds.size.height
#define NOTIFICATION_CENTER         [NSNotificationCenter defaultCenter]
#define ROOT_VIEWCONTROLLER         [[[UIApplication sharedApplication] keyWindow] rootViewController]

#define APP_SCREEN_CONTENT_HEIGHT   ([UIScreen mainScreen].bounds.size.height-20.0)
#define COLOR_BACKSHADOW            [UIColor colorWithWhite:0 alpha:0.6]

#define NOTI_LOGIN_SUCCESS              @"noti_login_success"
#define NOTI_ADD_NEW_PROFILE            @"noti_add_profile"
#define NOTI_DONE_CHECK_TEM             @"noti_done_check_tem"
#define NOTI_DONE_ADD_TEM_FOR_PROFILE   @"noti_done_add_tem_for_profile"
#define NOTI_UPDATE_SECTION             @"noti_update_section"
#define NOTI_UPDATE_POINT               @"noti_update_point"
#define NOTI_DATE_SELECTED              @"noti_date_selected"
#define NOTI_RESTART_GAME               @"noti_restart_game"
#define NOTI_BACKTO_MAIN_MENU           @"noti_backto_main_menu"
#define NOTI_NEWUSERCREATED             @"noti_NewUserCreated"
#define NOTI_BLE_DATA_RECEIVED          @"Noti_BLE_Data_Received"
#define NOTI_USER_BINDING_SUCCESS       @"Noti_UserBinding_Success"

#define NOTI_UPDATE_PROFILE             @"noti_update_profile"
#define NOTI_ENERGYSCALE_CHANGED        @"noti_energyScaleChanged"

#define NOTI_UPDATE_CENTRALMANAGER_STATE @"noti_update_central_manager_state"

#define NOTI_RESPONSE_SINA_WEIBO        @"noto_response_sina_weibo"
#define NOTI_AudioRouteChanged          @"noti_audio_route_changed"

#define NOTI_SHARE_IMAGE                @"noti_share_image"



#define MyLocalizedString(string)     NSLocalizedString(string, nil)

#define MaxCacheAge                     24 * 3600

//Record Audio
#define kBufferDurationSeconds          .5
#define IS_UMENG_TURN_ON                0

#if NEED_OUTPUT_LOG
#define SLog(xx, ...)   NSLog(xx, ##__VA_ARGS__)
#define SLLog(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#define SLLogRect(rect) \
SLLog(@"%s x=%f, y=%f, w=%f, h=%f", #rect, rect.origin.x, rect.origin.y, \
rect.size.width, rect.size.height)

#define SLLogPoint(pt) \
SLLog(@"%s x=%f, y=%f", #pt, pt.x, pt.y)

#define SLLogSize(size) \
SLLog(@"%s w=%f, h=%f", #size, size.width, size.height)

#define SLLogColor(_COLOR) \
SLLog(@"%s h=%f, s=%f, v=%f", #_COLOR, _COLOR.hue, _COLOR.saturation, _COLOR.value)

#define SLLogSuperViews(_VIEW) \
{ for (UIView* view = _VIEW; view; view = view.superview) { SLLog(@"%@", view); } }

#define SLLogSubViews(_VIEW) \
{ for (UIView* view in [_VIEW subviews]) { SLLog(@"%@", view); } }

#else
#define SLog(xx, ...)  ((void)0)
#define SLLog(xx, ...)  ((void)0)
#define SLLogSize(size) ((void)0)
#endif

//Nordi Noti
#define WF_NOTIFICATION_DISCOVERED_SENSOR      @"WFNotificationDiscoveredSensor"
#define WF_NOTIFICATION_HW_CONNECTED           @"WFNotificationHWConnected"
#define WF_NOTIFICATION_HW_DISCONNECTED        @"WFNotificationHWDisconnected"
#define WF_NOTIFICATION_SENSOR_CONNECTED       @"WFNotificationSensorConnected"
#define WF_NOTIFICATION_SENSOR_DISCONNECTED    @"WFNotificationSensorDisconnected"
#define WF_NOTIFICATION_SENSOR_HAS_DATA        @"WFNotificationSensorHasData"
#endif
