local L = LibStub("AceLocale-3.0"):NewLocale("Skada", "zhTW", false)
if not L then return end

L["A damage meter."] = "一個傷害統計。"
L["Memory usage is high. You may want to reset Skada, and enable one of the automatic reset options."] = "記憶體使用過高，你或許想要重置Skada，並且啟用一個自動重設的選項。"
-- L["Skada is out of date. You can download the newest version from |cffffbb00%s|r"] = ""
L["Skada: Modes"] = "Skada:模組"
L["Skada: Fights"] = "Skada:戰鬥"
-- L["Error: No options selected"] = ""
L["Data Collection"] = "數據收集"
L["Profiles"] = "設定檔"
L["Enable"] = "啟用"
L["ENABLED"] = "啟用"
L["Disable"] = "停用"
L["DISABLED"] = "停用"
-- common lines
L["More Details"] = "更多細節"
L["Active Time"] = "活躍時間"
L["Segment Time"] = "分段時間"
L["Click for"] = "點擊後為"
L["Shift-Click for"] = "Shift+點擊後為"
L["Control-Click for"] = "Ctrl+點擊後為"
L["Minimum"] = "最小"
L["Maximum"] = "最大"
L["Average"] = "平均"
L["Count"] = "計數"
L["Refresh"] = "刷新"
L["Percent"] = "百分比"
L["General Options"] = "一般選項"
L["HoT"] = " (治療/跳)"
L["DoT"] = " (傷害/跳)"
L["Hits"] = "命中"
L["Normal Hits"] = "一般命中"
L["Critical"] = "致命"
L["Critical Hits"] = "致命一擊"
L["Crushing"] = "碾壓"
L["Glancing"] = "偏斜"
L["ABSORB"] = "吸收"
L["BLOCK"] = "格檔"
L["DEFLECT"] = "避開"
L["DODGE"] = "閃躲"
L["EVADE"] = "閃避"
L["IMMUNE"] = "免疫"
L["MISS"] = "未擊中"
L["PARRY"] = "招架"
L["REFLECT"] = "反射"
L["RESIST"] = "抵制"
-- windows section:
L["Window"] = "視窗"
L["Windows"] = "視窗"
L["Create Window"] = "建立視窗"
L["Enter the name for the new window."] = "為新視窗輸入名稱。"
L["Delete Window"] = "刪除視窗"
L["Choose the window to be deleted."] = "選擇的視窗已刪除。"
-- L["Are you sure you want to delete this window?"] = ""
L["Rename Window"] = "重新命名視窗"
L["Enter the name for the window."] = "輸入視窗名稱。"
-- L["Child Window"] = ""
-- L["A child window will replicate the parent window actions."] = ""
-- L["Child Window Mode"] = ""
L["Lock Window"] = "鎖定視窗"
L["Locks the bar window in place."] = "鎖定計量條視窗位置。"
L["Hide Window"] = "隱藏視窗"
-- L["Hides the window."] = ""
-- L["Sticky Window"] = ""
-- L["Allows the window to stick to other Skada windows."] = ""
L["Snap to best fit"] = "適合比例"
L["Snaps the window size to best fit when resizing."] = "視窗比例自動調整到適合比例。"
L["Display System"] = "顯示方式"
L["Choose the system to be used for displaying data in this window."] = "在視窗中選擇顯示資料的使用方式。"
-- L["Copy Settings"] = ""
-- L["Choose the window from which you want to copy the settings."] = ""
-- bars
L["Bars"] = "計量條"
L["Bar font"] = "計量條的字型"
L["The font used by all bars."] = "所有計量條使用這個字型。"
L["Bar font size"] = "計量條的字型大小"
L["The font size of all bars."] = "所有計量條的字型大小。"
-- L["Values font"] = ""
-- L["The font used by bar values."] = ""
-- L["Values font size"] = ""
-- L["The font size of bar values."] = ""
L["Font flags"] = "字型標籤"
L["Sets the font flags."] = "設定字型的標籤。"
L["Outline"] = "輪廓"
L["Thick outline"] = "粗體"
L["Monochrome"] = "單色"
L["Outlined monochrome"] = "單色字體"
L["Bar texture"] = "計量條的材質"
L["The texture used by all bars."] = "所有計量條使用這個材質。"
L["Bar spacing"] = "計量條的間距"
L["Distance between bars."] = "計量條之間的距離。"
L["Bar height"] = "計量條的高度"
L["The height of the bars."] = "計量條的高度。"
L["Bar width"] = "計量條的寬度"
L["The width of the bars."] = "計量條的寬度。"
L["Bar orientation"] = "計量條的方向"
L["The direction the bars are drawn in."] = "計量條的增長方向。"
L["Left to right"] = "由左到右"
L["Right to left"] = "由右到左"
L["Reverse bar growth"] = "計量條反向增長"
L["Bars will grow up instead of down."] = "計量條將向上增長。"
-- L["Disable bar highlight"] = ""
-- L["Hovering a bar won't make it brighter."] = ""
L["Bar color"] = "計量條的顏色"
L["Choose the default color of the bars."] = "變更計量條預設的顏色。"
L["Background color"] = "背景的顏色"
L["Choose the background color of the bars."] = "選擇計量條的背景顏色。"
L["Spell school colors"] = "法術派別顏色"
L["Use spell school colors where applicable."] = "適合的法術使用派別顏色。"
L["Class color bars"] = "計量條的職業顏色"
L["When possible, bars will be colored according to player class."] = "依照玩家職業來調整計量條的顏色。"
L["Class color text"] = "文字的職業顏色"
L["When possible, bar text will be colored according to player class."] = "依照玩家職業來調整計量條文字的顏色。"
L["Class icons"] = "職業圖示"
L["Use class icons where applicable."] = "使用職業圖示(如果適用)."
-- L["Spec icons"] = ""
-- L["Use specialization icons where applicable."] = ""
L["Role icons"] = "角色類型圖標"
L["Use role icons where applicable."] = "使用適用的角色類型圖標。"
L["Show spark effect"] = "顯示觸發效果"
L["Clickthrough"] = "穿越點擊"
L["Disables mouse clicks on bars."] = "在計量條上停用滑鼠點擊。"
L["Smooth bars"] = "平滑計量條"
L["Animate bar changes smoothly rather than immediately."] = "計量條動態平滑變化而非立即的。"
-- title bar
L["Title Bar"] = "標題條"
L["Enables the title bar."] = "啟用標題條。"
L["Include set"] = "包含設定"
L["Include set name in title bar"] = "在標題欄包含設定名稱"
L["Encounter timer"] = "首領戰鬥計時器"
L["When enabled, a stopwatch is shown on the left side of the text."] = "如果開啟，在文字的左側將出現一個計時器"
L["Title height"] = "標題高度"
L["The height of the title frame."] = "標題框架的高度"
-- L["Title font size"] = ""
-- L["The font size of the title bar."] = ""
L["Title color"] = "標題顏色"
L["The text color of the title."] = "標題的文字顏色。"
L["The texture used as the background of the title."] = "使用於標題的背景材質。"
L["The background color of the title."] = "標題的背景顏色。"
L["Border texture"] = "邊框的材質"
L["The texture used for the borders."] = "使用於邊框的材質。"
L["The texture used for the border of the title."] = "使用於標題的邊框材質。"
L["Border color"] = "外框顏色"
L["The color used for the border."] = "使用在外框的顏色。"
L["Buttons"] = "按鈕"
-- L["Show on MouseOver"] = ""
-- general window
L["Background"] = "背景"
L["Background texture"] = "背景的材質"
L["The texture used as the background."] = "使用於背景的材質。"
L["Tile"] = "標題"
L["Tile the background texture."] = "標題的背景材質。"
L["Tile size"] = "標題大小"
L["The size of the texture pattern."] = "材質圖案的大小"
L["The color of the background."] = "背景的顏色。"
L["Border"] = "外框"
L["Border thickness"] = "邊框的厚度"
L["The thickness of the borders."] = "邊框的厚度。"
L["General"] = "一般"
L["Scale"] = "比例"
L["Sets the scale of the window."] = "設定視窗比例。"
L["Strata"] = "層級"
L["This determines what other frames will be in front of the frame."] = "這決定了那些其他的框架會在此框架之前。"
L["Clamped To Screen"] = "固定到屏幕"
L["Width"] = "寬度"
L["Height"] = "高度"
L["Position Settings"] = "位置設定"
L["X Offset"] = "水平位置"
L["Y Offset"] = "垂直位置"
-- switching
L["Mode Switching"] = "轉換模組"
L["Combat mode"] = "戰鬥模組"
L["Automatically switch to set 'Current' and this mode when entering combat."] = "當進入戰鬥時，自動切換'目前的'以及選擇的模組。"
L["Return after combat"] = "戰鬥後返回"
L["Return to the previous set and mode after combat ends."] = "戰鬥結束後返回原先的設定和模組。"
L["Wipe mode"] = "清除模組"
L["Automatically switch to set 'Current' and this mode after a wipe."] = "清除後，自動切換至'目前的'模組。"
L["Inline bar display"] = "內置條顯示"
L["Inline display is a horizontal window style."] = "內置顯示是一個水平視窗樣式。"
-- L["Text"] = ""
-- L["Font Color"] = ""
-- L["Font Color. \nClick \"Use class colors\" to begin."] = ""
-- L["Width of bars. This only applies if the \"Fixed bar width\" option is used."] = ""
L["Fixed bar width"] = "固定條列寬度"
L["If checked, bar width is fixed. Otherwise, bar width depends on the text width."] = "勾選後，條列寬度將會固定。否則條列寬度取決於文字寬度。"
-- L["Use class colors"] = ""
-- L["Class colors:\n|cFFF58CBAKader|r - 5.71M (21.7K)\n\nWithout:\nKader - 5.71M (21.7K)"] = ""
-- L["Put values on new line."] = ""
-- L["New line:\nKader\n5.71M (21.7K)\n\nDivider:\nKader - 5.71M (21.7K)"] = ""
-- L["Use ElvUI skin if avaliable."] = ""
-- L["Check this to use ElvUI skin instead. \nDefault: checked"] = ""
-- L["Use solid background."] = ""
-- L["Un-check this for an opaque background."] = ""
L["Data text"] = "數據文字"
L["Text color"] = "文字顏色"
L["Choose the default color."] = "選擇預設顏色。"
L["Hint: Left-Click to set active mode."] = "提示：左鍵點擊來設定啟動模式。"
L["Right-Click to set active set."] = "右鍵點擊設定啟動設置。"
L["Shift+Left-Click to open menu."] = "Shift+左鍵點擊開啟選單。"
-- data resets
L["Data Resets"] = "資料重置"
L["Reset on entering instance"] = "進入副本時重置"
L["Controls if data is reset when you enter an instance."] = "當你進入副本時資料是否要重置。"
L["Reset on joining a group"] = "加入團體時重置"
L["Controls if data is reset when you join a group."] = "當你加入團體時資料是否要重置。"
L["Reset on leaving a group"] = "離開團體時重置"
L["Controls if data is reset when you leave a group."] = "當你離開團體時控制資料是否要重置。"
L["Ask"] = "詢問"
L["Do you want to reset Skada?"] = "你要重置Skada嗎？"
L["All data has been reset."] = "所有資料已重置。"
-- L["Skip reset dialog"] = ""
-- L["Enable this if you want Skada to reset without the confirmation dialog."] = ""
-- general options
L["Show minimap button"] = "顯示小地圖按鈕"
L["Toggles showing the minimap button."] = "切換顯示小地圖按鈕。"
-- L["Shorten menus"] = ""
-- L["Removes mode and segment menus from Skada menu to reduce its height. Menus are still accessible using window buttons."] = ""
-- L["Translit"] = ""
-- L["Make those russian letters that no one understands to be presented as western letters."] = ""
L["Merge pets"] = "合併寵物"
L["Merges pets with their owners. Changing this only affects new data."] = "合併寵物與主人的資料，此只影響改變後的資料。"
L["Show totals"] = "顯示總計"
L["Shows a extra row with a summary in certain modes."] = "在某些模式顯示額外一行的總計。"
L["Only keep boss fighs"] = "只保留首領戰"
L["Boss fights will be kept with this on, and non-boss fights are discarded."] = "保留與首領之間的戰鬥紀錄，與非首領的戰鬥紀錄將會被消除。"
-- L["Always keep boss fights"] = ""
-- L["Boss fights will be kept with this on and will not be affected by Skada reset."] = ""
L["Hide when solo"] = "單練時隱藏"
L["Hides Skada's window when not in a party or raid."] = "當不在隊伍或團隊時隱藏Skada的視窗。"
L["Hide in PvP"] = "在PvP中隱藏"
L["Hides Skada's window when in Battlegrounds/Arenas."] = "當處於戰場/競技場時隱藏Skada的視窗。"
L["Hide in combat"] = "戰鬥中隱藏"
L["Hides Skada's window when in combat."] = "當處於戰鬥狀態時隱藏Skada的視窗。"
-- L["Show in combat"] = ""
-- L["Shows Skada's window when in combat."] = ""
L["Disable while hidden"] = "停用時隱藏"
L["Skada will not collect any data when automatically hidden."] = "當自動隱藏時，Skada將不會紀錄任何資料。"
L["Sort modes by usage"] = "根據使用率對模組排序"
L["The mode list will be sorted to reflect usage instead of alphabetically."] = "模組列表將依照使用率排序而非字母順序"
L["Show rank numbers"] = "顯示排名"
L["Shows numbers for relative ranks for modes where it is applicable."] = "在模組適當位置顯示相對排名。"
L["Aggressive combat detection"] = "雜兵戰鬥檢測"
L["Skada usually uses a very conservative (simple) combat detection scheme that works best in raids. With this option Skada attempts to emulate other damage meters. Useful for running dungeons. Meaningless on boss encounters."] = "Skada在團隊副本中經常性的使用一種非常傳統(簡易)的戰鬥檢測機制。勾選此選項Skada將嘗試模仿其他的傷害統計插件，使其有效運用在雜兵戰。但與首領戰則是無效的。"
-- L["Tentative Timer"] = ""
-- L["The number of seconds Skada should wait after combat start to create a new segment.\n\nOnly works if \"Agressive combat detection\" is enabled."] = ""
L["Autostop"] = "自動停止"
L["Automatically stops the current segment after half of all raid members have died."] = "當有一半以上的團員已死時自動停止當前區段。"
L["Always show self"] = "總是顯示自己"
L["Keeps the player shown last even if there is not enough space."] = "保持玩家顯示在最後即使沒有足夠的空間。"
L["Number format"] = "數字位數"
L["Controls the way large numbers are displayed."] = "控制數字的顯示位數。"
L["Condensed"] = "簡易的"
L["Detailed"] = "詳細的"
L["Combined"] = "組合的"
L["Comma"] = "逗號"
L["Data feed"] = "資料來源"
L["Choose which data feed to show in the DataBroker view. This requires an LDB display addon, such as Titan Panel."] = "選擇需要顯示在DataBroker上的資料來源。需要一個LDB的顯示插件，例如Titan Panel。"
L["Time measure"] = "時間測量方式"
L["Activity time"] = "活躍時間"
L["Effective time"] = "介面效果微調"
L.timemesure_desc = [=[|cFFFFFF00活躍時間|r: 每一位團隊成員停止活動時，便會暫停各自的計時，並在恢復後再次開始計時。這是用來測量 DPS 和 HPS 最常用的方法。

|cFFFFFF00有效時間|r: 用於排名，此方法會使用整場戰鬥時間來測量所有團隊成員的 DPS 和 HPS。]=]
L["Number set duplicates"] = "重複數字設置"
L["Append a count to set names with duplicate mob names."] = "追加一個統計以設置重複的怪物名稱。"
L["Set format"] = "設定格式"
L["Controls the way set names are displayed."] = "控制設定名稱顯示的方式。"
-- L["Links in reports"] = ""
-- L["When possible, use links in the report messages."] = ""
-- L["Memory Check"] = ""
-- L["Checks memory usage and warns you if it is greater than or equal to %dmb."] = ""
L["Data segments to keep"] = "保留分段資料"
L["The number of fight segments to keep. Persistent segments are not included in this."] = "保留多少戰鬥資料分段的數量，不包含連續的片段。"
L["Update frequency"] = "更新頻率"
L["How often windows are updated. Shorter for faster updates. Increases CPU usage."] = "視窗更新有多頻繁。較短時間更新快速，但增加CPU的負擔。"
-- columns
L["Columns"] = "計量條上"
-- tooltips
L["Tooltips"] = "提示訊息"
L["Show tooltips"] = "顯示提示訊息"
L["Shows tooltips with extra information in some modes."] = "在一些模組中顯示提示訊息以及額外的訊息。"
L["Informative tooltips"] = "提示訊息的資訊"
L["Shows subview summaries in the tooltips."] = "在提示訊息中顯示即時資訊。"
L["Subview rows"] = "資訊行數"
L["The number of rows from each subview to show when using informative tooltips."] = "當使用提示訊息的資訊時需要多少行數來顯示資訊。"
L["Tooltip position"] = "提示訊息的位置"
L["Position of the tooltips."] = "提示訊息的位置。"
L["Default"] = "預設值"
L["Top right"] = "右上"
L["Top left"] = "左上"
L["Bottom right"] = "右下"
L["Bottom left"] = "左下"
L["Smart"] = "智能"
-- L["Follow Cursor"] = ""
-- disabled modules
-- L["Modules"] = ""
L["Disabled Modules"] = "停用模組"
L["Tick the modules you want to disable."] = "勾選您想要停用的模組。"
L["This change requires a UI reload. Are you sure?"] = "這些改變需要重載UI，你確認嗎？"
L["Adds a set of standard themes to Skada. Custom themes can also be used."] = "新增一個Skada的基本主題設定。自訂主題也能使用。"
-- themes module
L["Theme"] = "主題"
L["Themes"] = "主題"
L["Apply Theme"] = "套用主題"
-- L["Theme applied!"] = ""
L["Name of your new theme."] = "你新主題的名稱。"
L["Save theme"] = "儲存主題"
L["Delete theme"] = "刪除主題"
-- scroll module
-- L["Scroll"] = ""
-- L["Mouse"] = ""
-- L["Scrolling speed"] = ""
-- L["Scroll icon"] = ""
-- L["Scroll mouse button"] = ""
-- L["Keybinding"] = ""
-- L["Key scrolling speed"] = ""
-- minimap button
L["Skada Summary"] = "Skada一覽"
-- L["|cffeda55fLeft-Click|r to toggle windows."] = ""
L["|cffeda55fShift+Left-Click|r to reset."] = "Shift+左鍵點|r擊進行重置。"
L["|cffeda55fRight-Click|r to open menu."] = "右鍵點擊開啟選單。"
-- skada menu
L["Skada Menu"] = "Skada 選單"
L["Delete Segment"] = "刪除分段資料"
L["Select Segment"] = "选择细分"
L["Keep Segment"] = "保留分段資料"
L["Toggle Windows"] = "切換視窗"
L["Start New Segment"] = "開始新的分段"
-- window buttons
L["Configure"] = "設定"
L["Opens the configuration window."] = "讓你配置此啟用的Skada視窗。"
L["Resets all fight data except those marked as kept."] = "除標記為保留外重置全部戰鬥數據。"
L["Segment"] = "分段"
L["Jump to a specific segment."] = "跳至特定區段。"
L["Mode"] = "模組"
L["Jump to a specific mode."] = "跳至特定模組。"
L["Report"] = "報告"
L["Opens a dialog that lets you report your data to others in various ways."] = "打開一個對話框，讓你以各種方式報告數據給他人。"
L["Stop"] = "停止"
L["Stops or resumes the current segment. Useful for discounting data after a wipe. Can also be set to automatically stop in the settings."] = "停止或恢復當前區段。用於滅團後停止收集數據。也可在設置中設為自動停止。"
L["Quick Access"] = "快速訪問"
-- default segments
L["Total"] = "總體的"
L["Current"] = "目前的"
-- report module and window
L["Skada: %s for %s:"] = "Skada:%s來自%s:"
L["Channel"] = "頻道"
L["Self"] = "自己"
L["Whisper"] = "悄悄話"
L["Whisper Target"] = "悄悄話目標"
L["Line"] = "排"
L["Lines"] = "行數"
L["There is nothing to report."] = "沒有資料可以報告。"
L["No mode or segment selected for report."] = "沒有選擇可報告的模組或分段資料。"
-- Bar Display Module --
L["Bar display"] = "顯示計量條"
L["Bar display is the normal bar window used by most damage meters. It can be extensively styled."] = "條列顯示是大多數傷害統計使用的一般條列視窗。它可以是廣泛的樣式。"
-- Threat Module --
L["Threat"] = "威脅值"
L["Threat warning"] = "威脅值的警告"
L["Flash screen"] = "螢幕閃爍"
L["This will cause the screen to flash as a threat warning."] = "威脅值警告時讓螢幕閃爍。"
L["Shake screen"] = "螢幕震動"
L["This will cause the screen to shake as a threat warning."] = "威脅值警告時讓螢幕震動。"
L["Warning Message"] = "警报消息"
L["Print a message to screen when you accumulate too much threat."] = "當你仇恨過高時在螢幕上顯示警報消息。"
L["Play sound"] = "播放音效"
L["This will play a sound as a threat warning."] = "威脅值警告時會撥放音效。"
L["Threat sound"] = "威脅值的音效"
L["The sound that will be played when your threat percentage reaches a certain point."] = "當你的威脅值達到一定的百分比時播放音效。"
L["Warning Frequency"] = "警告頻率"
L["Threat threshold"] = "威脅值的條件"
L["When your threat reaches this level, relative to tank, warnings are shown."] = "當你的威脅值與坦克相同時顯示警告。"
L["Show raw threat"] = "顯示原始威脅值"
L["Shows raw threat percentage relative to tank instead of modified for range."] = "顯示與坦克之間的原始威脅值百分比。"
L["Use focus target"] = "使用專注目標"
L["Shows threat on focus target, or focus target's target, when available."] = "當有設定時可顯示專注目標或專注目標的目標的威脅值。"
L["Disable while tanking"] = "當為坦克時關閉警報"
L["Test warnings"] = "測試警報"
L["TPS"] = "每秒威脅值"
L["Threat: Personal Threat"] = "威脅值:個人的威脅值"
-- Absorbs & Healing Module --
L["Healing"] = "治療"
L["Healing Done"] = "造成治療"
L["Healing Taken"] = "承受治療"
L["Healed player list"] = "被治療的玩家"
L["Healing spell list"] = "治療法術列表"
-- L["%s's healing"] = ""
-- L["%s's healing spells"] = ""
-- L["%s's healed players"] = ""
L["HPS"] = "每秒治療"
-- L["Healing: Personal HPS"] = ""
-- L["RHPS"] = ""
-- L["Healing: Raid HPS"] = ""
L["Total Healing"] = "總體治療"
L["Overhealing"] = "過量治療"
-- L["Overhealed player list"] = ""
-- L["Overheal spell list"] = ""
-- L["%s's overheal spells"] = ""
-- L["%s's overhealed players"] = ""
-- L["Healing and Overhealing"] = ""
-- L["Heal and overheal spells"] = ""
-- L["Healed and overhealed players"] = ""
-- L["%s's heal and overheal spells"] = ""
-- L["%s's healed and overhealed players"] = ""
L["Absorbs"] = "吸收量"
-- L["Absorbed player list"] = ""
-- L["Absorb spell list"] = ""
-- L["%s's absorbed players"] = ""
-- L["%s's absorb spells"] = ""
L["Absorbs and Healing"] = "吸收和治療"
-- L["Absorbs and healing spells"] = ""
-- L["Absorbed and healed players"] = ""
-- L["%s's absorb and healing spells"] = ""
-- L["%s's absorbed and healed players"] = ""
-- L["Healing player list"] = ""
-- L["%s's received healing"] = ""
-- L["Healing Done By Spell"] = ""
-- L["Healing spell sources"] = ""
-- Auras Module --
-- L["Uptime"] = ""
-- L["Buffs and Debuffs"] = ""
L["Buffs"] = "增益"
L["Buff spell list"] = "增益法術列表"
-- L["%s's buffs"] = ""
L["Debuffs"] = "減益"
L["Debuff spell list"] = "減益法術的列表"
-- L["Debuff target list"] = ""
-- L["%s's debuffs"] = ""
-- L["%s's <%s> targets"] = ""
-- L["Sunder Counter"] = ""
-- L["Sunder target list"] = ""
-- CC Tracker Module --
-- L["CC Tracker"] = ""
-- CC Done:
-- L["CC Done"] = ""
-- L["CC Done spells"] = ""
-- L["CC Done targets"] = ""
-- L["%s's CC Done spells"] = ""
-- L["%s's CC Done targets"] = ""
-- CC Taken
-- L["CC Taken"] = ""
-- L["CC Taken spells"] = ""
-- L["CC Taken sources"] = ""
-- L["%s's CC Taken spells"] = ""
-- L["%s's CC Taken sources"] = ""
L["CC Breaks"] = "控場被破除"
L["CC Breakers"] = "控場破除者"
-- L["CC Break spells"] = ""
-- L["CC Break targets"] = ""
-- L["%s's CC Break spells"] = ""
-- L["%s's CC Break targets"] = ""
-- options
L["CC"] = "控場"
L["Announce CC breaking to party"] = "控場被破除時通知到隊伍頻道中"
L["Ignore Main Tanks"] = "忽略主坦克"
L["%s on %s removed by %s"] = "%s在%s被%s移除了"
L["%s on %s removed by %s's %s"] = "%s在%s被%s的%s移除了"
-- Damage Module --
-- damage done module
L["Damage"] = "傷害"
-- L["Damage target list"] = ""
L["Damage spell list"] = "傷害法術列表"
L["Damage spell details"] = "傷害法術細節"
-- L["Damage spell targets"] = ""
L["Damage Done"] = "總傷害"
-- L["%s's damage"] = ""
-- L["%s's <%s> damage"] = ""
-- L["%s's <%s> damage on %s"] = ""
-- L["Useful Damage"] = ""
-- L["Useful damage on %s"] = ""
-- L["Damage Done By Spell"] = ""
-- L["%s's sources"] = ""
L["DPS"] = "每秒傷害"
L["Damage: Personal DPS"] = "傷害:個人的DPS"
L["RDPS"] = "團隊DPS"
L["Damage: Raid DPS"] = "傷害:團隊的DPS"
-- damage taken module
L["Damage Taken"] = "承受傷害"
-- L["Damage taken by %s"] = ""
-- L["%s's damage on %s"] = ""
-- L["Damage source list"] = ""
-- L["Damage spell sources"] = ""
L["Damage Taken By Spell"] = "承受法術傷害"
-- L["%s's targets"] = ""
L["DTPS"] = "每秒承受的傷害"
-- enemy damage done module
L["Enemies"] = "敵方"
L["Enemy Damage Done"] = "敵方的傷害"
L["Damage done per player"] = "每位玩家的總傷害"
-- L["Damage from %s"] = ""
-- enemy damage taken module
L["Enemy Damage Taken"] = "敵方的承受傷害"
L["Damage taken per player"] = "每位玩家的承受傷害"
-- L["Damage on %s"] = ""
-- L["%s's damage sources"] = ""
-- enemy healing done module
L["Enemy Healing Done"] = "敵方造成治療"
-- avoidance and mitigation module
-- L["Avoidance & Mitigation"] = ""
-- L["Damage Breakdown"] = ""
-- L["%s's damage breakdown"] = ""
-- friendly fire module
L["Friendly Fire"] = "隊友誤傷"
-- useful damage targets
-- L["Useful targets"] = ""
-- L["Oozes"] = ""
-- L["Princes overkilling"] = ""
-- L["Adds"] = ""
-- L["Halion and Inferno"] = ""
-- L["Valkyrs overkilling"] = ""
-- missing bosses entries
-- L["Cult Adherent"] = ""
-- L["Cult Fanatic"] = ""
-- L["Darnavan"] = ""
-- L["Deformed Fanatic"] = ""
-- L["Empowered Adherent"] = ""
-- L["Gas Cloud"] = ""
-- L["Living Inferno"] = ""
-- L["Reanimated Adherent"] = ""
-- L["Reanimated Fanatic"] = ""
-- L["Volatile Ooze"] = ""
-- L["Wicked Spirit"] = ""
-- Deaths Module --
L["Deaths"] = "死亡紀錄"
-- L["%s's death"] = ""
-- L["%s's deaths"] = ""
L["Death log"] = "死亡紀錄表"
-- L["%s's death log"] = ""
-- L["Player's deaths"] = ""
L["%s dies"] = "%s已死亡"
L["Spell details"] = "法術細節"
-- L["Spell"] = ""
-- L["Amount"] = ""
-- L["Source"] = ""
L["Health"] = "生命力"
L["Change"] = "變更"
L["Survivability"] = "生存能力"
L["Events Amount"] = "事件數量"
L["Set the amount of events the death log should record."] = "設置死亡日誌應記錄的事件數量。"
L["Minimum Healing"] = "最小癒合"
L["Ignore heal events that are below this threshold."] = "忽略低於此閾值的修復事件。"
-- activity module
L["Activity"] = "活躍度"
-- L["Activity per target"] = ""
-- dispels module lines --
L["Dispels"] = "驅散"
-- L["Dispel spell list"] = ""
-- L["Dispelled spell list"] = ""
-- L["Dispelled target list"] = ""
-- L["%s's dispel spells"] = ""
-- L["%s's dispelled spells"] = ""
-- L["%s's dispelled targets"] = ""
-- failbot module lines --
L["Fails"] = "失誤"
-- L["%s's fails"] = ""
-- L["Player's failed events"] = ""
-- L["Event's failed players"] = ""
-- interrupts module lines --
L["Interrupts"] = "中斷"
-- L["Interrupt spells"] = ""
-- L["Interrupted spells"] = ""
-- L["Interrupted targets"] = ""
-- L["%s's interrupt spells"] = ""
-- L["%s's interrupted spells"] = ""
-- L["%s's interrupted targets"] = ""
-- L["Announce Interrupts"] = ""
L["%s interrupted!"] = "%s 打斷!"
-- Power gained module --
L["Power"] = "能量"
L["Resources"] = "能量"
-- L["%s's gained %s"] = ""
L["Power gained: Mana"] = "獲得法力"
L["Mana gained spell list"] = "獲得法力的法術列表"
L["Power gained: Rage"] = "獲得怒氣"
L["Rage gained spell list"] = "怒氣獲得來源"
L["Power gained: Energy"] = "獲得能量"
L["Energy gained spell list"] = "能量獲得來源"
L["Power gained: Runic Power"] = "獲得符能"
L["Runic Power gained spell list"] = "符能獲得來源"
-- Parry module lines --
-- L["Parry-Haste"] = ""
-- L["Parry target list"] = ""
-- L["%s's parry targets"] = ""
-- Potions module lines --
-- L["Potions"] = ""
-- L["Potions list"] = ""
-- L["Players list"] = ""
-- L["%s's used potions"] = ""
-- L["Pre-potion"] = "Pre-potion"
-- L["pre-potion: %s"] = "pre-potion: %s"
-- L["Prints pre-potion after the end of the combat."] = ""
-- resurrect module lines --
-- L["Resurrects"] = ""
-- L["Resurrect spell list"] = ""
-- L["Resurrect target list"] = ""
-- L["%s's resurrect spells"] = ""
-- L["%s's resurrect targets"] = ""
-- nickname module lines --
L["Nickname"] = "暱稱"
L["Set a nickname for you.\nNicknames are sent to group members and Skada can use them instead of your character name."] = "給你自己設定一個暱稱。\n在傳遞Skada數據之時，你的人物名將會被暱稱所代替。"
-- L["Nickname isn't a valid string."] = ""
-- L["Your nickname is too long, max of 12 characters is allowed."] = ""
-- L["Only letters and two spaces are allowed."] = ""
-- L["You can't use the same letter three times consecutively, two spaces consecutively or more then two spaces."] = ""
L["Ignore Nicknames"] = "忽略所有昵称"
L["When enabled, nicknames set by Skada users are ignored."] = "如果启用，则Skada用户设置的所有昵称将被忽略。"
-- L["Name display"] = ""
-- L["Choose how names are shown on your bars."] = ""
L["Clear Cache"] = "Clear Cache"
L["Are you sure you want clear cached nicknames?"] = "您确定要清除缓存的昵称吗？"
-- player score module lines --
-- L["Player Score"] = ""
-- L["Raid Score"] = ""
-- L["Score"] = ""
-- L["%s's Score"] = ""
-- damage mitigated lines --
-- L["Damage Mitigated"] = ""
-- L["%s's mitigated damage"] = ""
-- L["%s's <%s> mitigated damage"] = ""
-- overkill module lines --
L["Overkill"] = "過度損壞"
L["Overkill spell list"] = "過度傷害法術"
L["Overkill target list"] = "過度損壞的目標"
L["%s's overkill spells"] = "%s過度傷害法術"
L["%s's overkill targets"] = "%s過度損壞的目標"
-- tweaks module lines --
-- L["Improvement"] = ""
L["Tweaks"] = "調整"
-- L["First hit"] = ""
-- L["|cffffff00First Hit|r: %s from %s"] = ""
-- L["|cffffbb00First Hit|r: *?*"] = ""
-- L["|cffffbb00Boss First Target|r: %s (%s)"] = ""
-- L["Prints a message of the first hit before combat.\nOnly works for boss encounters."] = ""
-- L["Filter DPS meters Spam"] = ""
-- L["Suppresses chat messages from damage meters and provides single chat-link damage statistics in a popup."] = ""
L["Reported by: %s"] = "已回報由%s"
-- L["Smart Stop"] = ""
-- L["Automatically stops the current segment after the boss has died.\nUseful to avoid collecting data in case of a combat bug."] = ""
-- L["Duration"] = ""
-- L["For how long Skada should wait before stopping the segment."] = ""
-- L["Module Icons"] = ""
-- L["Enable this if you want to show module icons on windows and menus."] = ""
L["Fix Combat Log"] = "修理戰鬥記錄"
L["Keeps the combat log from breaking without munging it completely."] = "從斷裂而沒有完全破壞它可以防止戰鬥記錄。"
L["Enable this if you want to ignore |cffffbb00%s|r."] = "如果您想忽略|cffffbb00%s|r，請啟用此功能。"