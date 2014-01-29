//
//  ACEModeNames.m
//  ACEView
//
//  Created by Michael Robinson on 2/12/12.
//  Copyright (c) 2012 Code of Interest. All rights reserved.
//

#import "ACEThemeNames.h"

NSString *const _ACEThemeNames[ACEThemeCount] = {
    [ACEThemeAmbiance]				 = @"ambiance",
    [ACEThemeChrome]				 = @"chrome",
    [ACEThemeClouds]				 = @"clouds",
    [ACEThemeCloudsMidnight]		 = @"clouds_midnight",
    [ACEThemeCobalt]				 = @"cobalt",
    [ACEThemeCrimsonEditor]			 = @"crimson_editor",
    [ACEThemeDawn]                   = @"dawn",
    [ACEThemeDreamweaver]			 = @"dreamweaver",
    [ACEThemeEclipse]				 = @"eclipse",
    [ACEThemeGithub]				 = @"github",
    [ACEThemeIdleFingers]			 = @"idle_fingers",
    [ACEThemeKr]                     = @"kr",
    [ACEThemeMerbivore]				 = @"merbivore",
    [ACEThemeMerbivoreSoft]			 = @"merbivore_soft",
    [ACEThemeMonoIndustrial]		 = @"mono_industrial",
    [ACEThemeMonokai]				 = @"monokai",
    [ACEThemePastelOnDark]			 = @"pastel_on_dark",
    [ACEThemeSolarizedDark]			 = @"solarized_dark",
    [ACEThemeSolarizedLight]		 = @"solarized_light",
    [ACEThemeTextmate]				 = @"textmate",
    [ACEThemeTomorrow]				 = @"tomorrow",
    [ACEThemeTomorrowNight]			 = @"tomorrow_night",
    [ACEThemeTomorrowNightBlue]		 = @"tomorrow_night_blue",
    [ACEThemeTomorrowNightBright]	 = @"tomorrow_night_bright",
    [ACEThemeTomorrowNightEighties]	 = @"tomorrow_night_eighties",
    [ACEThemeTwilight]				 = @"twilight",
    [ACEThemeVibrantInk]			 = @"vibrant_ink",
    [ACEThemeXcode]                  = @"xcode"
};

NSString *const _ACEThemeNamesHuman[ACEThemeCount] = {
    [ACEThemeAmbiance]				 = @"Ambiance",
    [ACEThemeChrome]				 = @"Chrome",
    [ACEThemeClouds]				 = @"Clouds",
    [ACEThemeCloudsMidnight]		 = @"Clouds Midnight",
    [ACEThemeCobalt]				 = @"Cobalt",
    [ACEThemeCrimsonEditor]			 = @"Crimson Editor",
    [ACEThemeDawn]                   = @"Dawn",
    [ACEThemeDreamweaver]			 = @"Dreamweaver",
    [ACEThemeEclipse]				 = @"Eclipse",
    [ACEThemeGithub]				 = @"Github",
    [ACEThemeIdleFingers]			 = @"Idle Fingers",
    [ACEThemeKr]                     = @"KR",
    [ACEThemeMerbivore]				 = @"Merbivore",
    [ACEThemeMerbivoreSoft]			 = @"Merbivore Soft",
    [ACEThemeMonoIndustrial]		 = @"Mono Industrial",
    [ACEThemeMonokai]				 = @"Monokai",
    [ACEThemePastelOnDark]			 = @"Pastel on Dark",
    [ACEThemeSolarizedDark]			 = @"Solarized Dark",
    [ACEThemeSolarizedLight]		 = @"Solarized Light",
    [ACEThemeTextmate]				 = @"Textmate",
    [ACEThemeTomorrow]				 = @"Tomorrow",
    [ACEThemeTomorrowNight]			 = @"Tomorrow Night",
    [ACEThemeTomorrowNightBlue]		 = @"Tomorrow Night Blue",
    [ACEThemeTomorrowNightBright]	 = @"Tomorrow Night Bright",
    [ACEThemeTomorrowNightEighties]	 = @"Tomorrow Night Eighties",
    [ACEThemeTwilight]				 = @"Twilight",
    [ACEThemeVibrantInk]			 = @"Vibrant Ink",
    [ACEThemeXcode]                  = @"Xcode"
};

@implementation ACEThemeNames

+ (NSArray *) themeNames {
    return [NSArray arrayWithObjects:_ACEThemeNames count:ACEThemeCount];
}
+ (NSArray *) humanThemeNames {
    return [NSArray arrayWithObjects:_ACEThemeNamesHuman count:ACEThemeCount];
}

+ (NSString *) nameForTheme:(ACETheme)theme  {
    return _ACEThemeNames[theme];
}
+ (NSString *) humanNameForTheme:(ACETheme)theme {
    return _ACEThemeNamesHuman[theme];
}

@end
