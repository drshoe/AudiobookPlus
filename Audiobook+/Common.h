//
//  Common.h
//  Audiobook+
//
//  Created by Sheng Xu on 2013-04-15.
//
//

#ifndef Audiobook__Common_h
#define Audiobook__Common_h



#endif
#define kTimer10s 1
#define kTimer5s 5

#define kAudioBookDidChangeNotification @"AudiobookPlayerDidChangeChapterNotification"
#define kAudioBookWillFinishNotification @"AudiobookPlayerWillFinishChapterNotification"

typedef enum {
    SidePanelButtonTypeNowPlaying,
    SidePanelButtonTypeLibrary,
    SidePanelButtonTypeBookmarks,
    SidePanelButtonTypeStats,
    SidePanelButtonTypeSettings,
} SidePanelButtonType;

typedef NS_ENUM(NSInteger, SettingGroup) {
    SettingGroupHelp,
    SettingGroupFeedback,
    SettingGroupCount
};

typedef NS_ENUM(NSInteger, SettingGroupHelpCell) {
    SettingGroupHelpCellQuickStart,
    SettingGroupHelpCellFullGuide,
    SettingGroupHelpCellAppVersion,
    SettingGroupHelpCellCount
};

typedef NS_ENUM(NSInteger, SettingGroupFeedbackCell) {
    SettingGroupFeedbackCellTellFriends,
    SettingGroupFeedbackCellSendFeedback,
    SettingGroupFeedbackCellCount
};

typedef enum {
    ChapterAndBookmarkTableBookmarkSelected,
    ChapterAndBookmarkTableChapterSelected
} ChapterAndBookmarkTable;


