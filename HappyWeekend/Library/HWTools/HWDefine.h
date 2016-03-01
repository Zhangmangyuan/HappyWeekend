//
//  HWDefine.h
//  HappyWeekend
//  以后把所有的接口都统一放到HWDefine里边定义
//  Created by 张茫原 on 16/1/6.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#ifndef HWDefine_h
#define HWDefine_h


typedef NS_ENUM(NSInteger, ClassifyListType) {
    ClassifyListTypeShowRepertoire = 1,     //演出剧目
    ClassifyListTypeTouristPlace,           //景点场馆
    ClassifyListTypeStudyPUZ,               //学习益智
    ClassifyListTypeFamilyTravel            //亲子旅游
};


//首页数据接口
#define kMainDataList @"http://e.kumi.cn/app/v1.3/index.php?_s_=02a411494fa910f5177d82a6b0a63788&_t_=1451307342&channelid=appstore&cityid=1&lat=34.62172291944134&limit=30&lng=112.4149512442411&page=1"

//活动详情接口
#define kActivityDetail @"http://e.kumi.cn/app/articleinfo.php?_s_=6055add057b829033bb586a3e00c5e9a&_t_=1452071715&channelid=appstore&cityid=1&lat=34.61356779156581&lng=112.4141403843618"

//活动专题接口
#define kActivityTheme @"http://e.kumi.cn/app/positioninfo.php?_s_=1b2f0563dade7abdfdb4b7caa5b36110&_t_=1452218405&channelid=appstore&cityid=1&lat=34.61349052974207&limit=30&lng=112.4139739846577&page=1"

//精选活动接口
#define kGoodActivity @"http://e.kumi.cn/app/articlelist.php?_s_=a9d09aa8b7692ebee5c8a123deacf775&_t_=1452236979&channelid=appstore&cityid=1&lat=34.61351314785497&limit=30&lng=112.4140755658942&type=1"

//热门专题接口
#define kHotActivity @"http://e.kumi.cn/app/positionlist.php?_s_=e2b71c66789428d5385b06c178a88db2&_t_=1452237051&channelid=appstore&cityid=1&lat=34.61351314785497&limit=30&lng=112.4140755658942&page=1"

//分类列表接口
#define kClassifyList @"http://e.kumi.cn/app/v1.3/catelist.php?_s_=dad924a9b9cd534b53fc2c521e9f8e84&_t_=1452495193&channelid=appstore&cityid=1&lat=34.61356398594803&limit=30&lng=112.4140434532402"

#define kDiscover @"http://e.kumi.cn/app/found.php?_s_=a82c7d49216aedb18c04a20fd9b0d5b2&_t_=1451310230&channelid=appstore&cityid=1&lat=34.62172291944134&lng=112.4149512442411"

//新浪微博分享
#define kAppKey    @"4249192859"
#define kAppSecret  @"2acf0b6e2a209c25f9addab737cc1cad"
#define kRedirectURL @"https://api.weibo.com/oauth2/default.html"

//微信分享
#define kWeixinAppID    @"wxce8ee23b76332ba3"
#define kWeixinAppSecret @"1cdbc4502d9ee17acf60788a80e750a1"

//bmob
#define kBmobAppkey @"83fc00b652e740183c2e101af6409d48"

#endif /* HWDefine_h */







