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
typedef enum {
    SidePanelButtonTypeNowPlaying,
    SidePanelButtonTypeLibrary,
    SidePanelButtonTypeBookmarks,
    SidePanelButtonTypeStats,
    SidePanelButtonTypeSettings,
} SidePanelButtonType;

typedef enum {
    SettingsSectionManageSettings, 
    SettingsSectionHelp
} SettingsSection;

typedef enum {
    ChapterAndBookmarkTableBookmarkSelected,
    ChapterAndBookmarkTableChapterSelected
} ChapterAndBookmarkTable;


