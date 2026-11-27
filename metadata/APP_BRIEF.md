<!-- gf-brief source=95d266e66d2a3a8cbddb9a4c889f4801ffc880f3ad471f3f0f175a03fe7454d5 written=2026-11-27T09:15:34+03:00 -->
# Match Center

## What it is

Match Center is a football companion for fans who want to browse published fixtures and delayed results, follow favourite teams, and keep a matchbook. It also lets people record their own scores and match events offline, calculate standings from finished matches, and explore six illustrated passing patterns.

## Launch and onboarding

1. A fresh launch opens the dark “Matchday” tab directly. There is no welcome screen, onboarding form, or permission prompt.
2. The header shows “YOUR FOOTBALL, IN FOCUS”, “Match Center”, and today’s weekday, month and day. The plus button is labelled “Add match” for accessibility.
3. “MATCHDAY DESK” shows “0” beside “matches saved today”, followed by “Delayed provider scores” and the “Refresh” icon. Below it is “Tactics notebook” with “Six passing patterns”.
4. “Matches” is selected in the “View” control, alongside “Tables” and “Headlines”. Below it are “All leagues”, “Favourites only”, “Today's fixtures”, and “In progress”. Both filters are off initially.
5. The first-run empty state reads “Build your matchday” and “Record scores and events offline, or refresh to get published fixtures.” Tap “Create a match” to open “Add match”, or tap “Refresh” to fetch published fixtures.
6. The bottom tabs are “Matchday”, “Calendar”, “Favourites”, and “Settings”. In US English, the third tab is “Favorites”.

## Screens

### “Matchday” → “Matches”

- “Add match” and “Create a match” open the local match form. “Refresh” and pull-to-refresh request published fixtures for today. The refresh icon gives way to a spinner while a request is running.
- “All leagues” opens a menu containing “All leagues” and the leagues represented in saved matches. Choosing a league filters the fixture list. “Favourites only” (“Favorites only” in US English) limits the list to matches involving a starred team. Both settings carry over to “Calendar”. The count beside “matches saved today” follows these two filters.
- “In progress” adds a filter for saved matches in progress, including half-time. The list and the count can differ because the count does not apply this toggle.
- “Provider cache updated” appears with a date and time after a successful fixture refresh. Each card shows the league, status, team names, score or “–” for each missing score, kickoff time, and “Local entry” or “Saved · delayed”. Matches in progress appear first, then matches are ordered by kickoff. Tap a card to open “Match details”.
- “Tactics notebook”, subtitled “Six passing patterns”, opens the illustrated play library. The “View” control switches among “Matches”, “Tables”, and “Headlines” within “Matchday”.

### “Matchday” → “Tables”

- “League” selects a published competition code or a league name from saved matches. The published options are “BL1”, “BSA”, “DED”, “ELC”, “FL1”, “PD”, “PL”, “PPL”, and “SA”. The view starts on “BSA”.
- “Refresh” retrieves published season results for the selected supported league and updates its “Provider standings”. A timestamp appears for saved provider standings. If the selected league has finished local matches, “Table from your finished local matches” takes precedence.
- Rows show rank and the columns “Team”, “P”, “GD”, and “Pts”. The legend reads “P: played · GD: goal difference · Pts: points”. Standings award three points for a win and one for a draw, then break ties by goal difference, goals scored, and team name.
- The empty state reads “No saved table. Refresh a supported league, or finish a local match to calculate standings.”

### “Matchday” → “Headlines”

- “Feed headlines appear in the publisher's original language.” appears above the list. Before any headlines have been saved, it also shows “Add your personal RSS feed in Settings.”
- “Refresh headlines” reloads the feed address saved in “Settings”. Each headline shows its publisher beneath it. Tapping a headline opens the publisher’s page outside the app.

### “Calendar”

- “Choose day” is a graphical date picker. Selecting a date shows its saved fixtures below the selected day and month. The toolbar’s “Refresh” icon and pull-to-refresh fetch published fixtures for that date. Choosing a date alone browses what is already saved.
- The league and favourite filters are shared with “Matchday”. “Add match” opens the same local match form. It defaults to approximately one hour from the current time, so set “Kickoff” explicitly when entering a match for a different date.
- Fixture cards open “Match details”. An empty date shows the same creation prompt used on “Matchday”.

### “Favourites” (“Favorites” in US English)

- Introductory copy reads “Choose teams for your personal feed, reminders and widgets.”
- “Search teams” searches “Team directory” by team name. “Your teams” appears once at least one team is starred and remains separate from the search results.
- The star beside each team toggles its favourite status. Its accessibility label is “Add favourite” or “Remove favourite” followed by the team name. US English uses “Add favorite” and “Remove favorite”. A team can appear in both “Your teams” and “Team directory”. Tapping the name itself does not open a profile.

### “Match details”

- Shows the league, both teams and their badges, score or “– : –”, status, kickoff date and time, and “Saved” followed by a timestamp. The source label reads “Local entry” or “OpenFootball”. Published matches also show “Scores may arrive later. Events appear when the source publishes them.”
- Each team has a star with the accessibility label “Toggle favourite” followed by its name, or “Toggle favorite” in US English. It updates the same choices shown in “Favourites”.
- For a scheduled match, “Start kickoff countdown” starts a Live Activity if the match involves a favourite team and kicks off within the next eight hours. “Stop countdown” ends that match’s countdown. The guidance reads “Favourite the team first. Available within 8 hours of scheduled kickoff; no score updates through Live Activity.” US English starts it with “Favorite the team first.”
- “Match timeline” lists events in minute order, with event type, team and any player name or note. For a local match, the plus icon labelled “Add event” opens the event form. Each local event has a trash icon labelled “Delete event”, which removes it immediately. “Edit” opens “Edit match”.
- An empty local timeline says “Add goals, cards and key moments as they happen.” An empty published timeline says “No minute-by-minute events supplied for this match.” Published matches offer “Refresh match details”.
- On a local match, “Delete match” opens “Delete this local match?” and a second “Delete match” confirms removal. The detail screen then reads “Match removed”. Use the navigation back control to return to the list.

### “Add match” and “Edit match”

- Under “Local match”, the form says “Your entries stay on this device and are labelled as local. No result is fetched automatically.” US English uses “labeled”. “Home team”, “Away team”, and “League” accept text. “Kickoff” sets the date and time.
- Under “Match state”, “Status” offers “Scheduled”, “In progress”, “Half-time”, “Finished”, “Postponed”, and “Cancelled”. “Home goals: 0” and “Away goals: 0” show the current values and can be stepped from 0 to 99. They appear for “In progress”, “Half-time”, and “Finished”.
- “Add match” starts with blank team and league fields, “Scheduled”, and a kickoff about one hour ahead. “Edit match” fills in the saved values. “Save” writes the match and closes the form. “Cancel” closes it without saving.

### “Add event”

- “Minute: 1” starts at 1 and can be stepped from 0 to 150. “Event” defaults to “Goal” and also offers “Card”, “Substitution”, and “Key moment”. “Team” offers the two team names and defaults to the home team. “Player or note (optional)” accepts text.
- The form says “Adding or deleting a goal adjusts the local score.” “Save” adds the event and returns to “Match details”. “Cancel” discards the event and returns to the same screen.

### “Tactics notebook”

- Shows the selected formation, a numbered pitch diagram with a pass arrow, and explanatory text. “Pass 1”, “Pass 2”, and “Pass 3” change the arrow, highlighted players and explanation. The pitch’s accessibility label describes the current pass by player number.
- “Play library” offers “Switch the play” (“4–3–3”), “Third-player run” (“4–2–3–1”), “Overlap on the flank” (“4–4–2”), “Play through pressure” (“3–4–2–1”), “Counter from a regain” (“4–1–4–1”), and “Escape the touchline” (“3–5–2”). Tapping any pattern selects it and returns to “Pass 1”. The screen opens on “Switch the play”.

### “Settings”

- “Data connection” contains “OpenFootball · CC0”, which opens the source’s public project page.
- “Personal headlines” contains “HTTPS RSS feed address” and “Save and refresh feed”. The button saves the entered address and attempts to load it. The guidance reads “Add a feed you are permitted to read for personal use. Only headlines and links are cached; article text and images are not downloaded.”
- “Notifications” contains “Enable notifications”, “Favourite match alerts” (“Favorite match alerts” in US English), “Morning digest · 08:00”, “Evening digest · 20:00”, and “System notification settings”. The button requests permission, the three switches control their respective notifications, and the link opens this app’s system settings. The guidance reads “Start reminders follow saved kickoff times. Score and start changes are announced only after data refresh. iOS chooses background timing; instant alerts are not available.” and “Digests cover the next 7 days and renew when you open the app.”
- “Widgets” provides setup instructions. Add “Match Center” through the Home Screen or Lock Screen widget gallery. The small widget shows “Favourite today” (“Favorite today” in US English), the medium widget shows “In progress”, and the large widget shows “Today's fixtures” with the saved league and favourite filters. Lock Screen widgets show a favourite score. Tapping a widget opens “Matchday”.
- “Your data” contains “Import matchbook”, which opens the system document picker, and “Prepare export”, which makes “Share matchbook” appear. “Share matchbook” opens the system share sheet. “Delete all local data” opens “Permanently delete saved matches, favourites and connection settings?” (“favorites” in US English). Tap “Delete all local data” again to confirm.
- The footer shows “Match Center · 1.3.1 (17)” and “All times use your device's time zone.”

## Features

- “MATCHDAY DESK” with published fixtures and delayed scores. Fixture refresh covers the English Premier League, German Bundesliga, and Spanish La Liga.
- “Calendar” with date-based fixture browsing and shared league and favourite filters.
- “Local match” with offline scorekeeping and “Match timeline” entries for “Goal”, “Card”, “Substitution”, and “Key moment”.
- “Tables” with published standings for nine supported competition codes and standings calculated from finished local matches.
- “Favourites” with team search, a personal team list, fixture filtering, saved kickoff reminders, and morning and evening digests.
- “Start kickoff countdown” for eligible favourite matches. The Live Activity shows team names and a timer under “Scheduled kickoff” on the Lock Screen and, where supported, in the Dynamic Island. The Lock Screen can show “Kickoff time reached”. Tapping the activity opens “Matchday”.
- “Personal headlines” from a user-supplied HTTPS RSS feed. Up to 40 qualifying headlines are saved per refresh. Items with non-HTTPS links or gambling-related terms in the title are skipped.
- “Widgets” for favourite scores, saved matches in progress, and today’s fixtures. They use saved data and work offline.
- “Tactics notebook” with six formations and three illustrated passes per pattern.
- “Import matchbook”, “Prepare export”, “Share matchbook”, and “Delete all local data”.

## Behaviours that can look like bugs

- **Empty fixture lists.** “Build your matchday” appears before the first match is saved and on dates with no matching fixtures. With “In progress” selected, the empty heading becomes “No saved matches in progress”. The shared empty view can carry that heading into an empty “Calendar” date as well. Turn off “In progress” or “Favourites only”, choose “All leagues”, change the date, use “Refresh”, or tap “Create a match”.
- **Delayed results and empty published timelines.** “Delayed provider scores” and “Saved · delayed” describe published data. The current fixture source supplies scheduled fixtures and finished scores, so “In progress” can remain empty after a refresh and “No minute-by-minute events supplied for this match.” can persist after “Refresh match details”. To record a match as it happens, create a “Local entry” and use “Add event”. If a request fails, “Unable to connect. Saved data remains available offline.” means previously saved material is still available.
- **A disabled “Save”.** In “Add match” and “Edit match”, enter both team names and a league. The two team names must differ even when case and surrounding spaces are ignored. To enter goals, choose “In progress”, “Half-time”, or “Finished”. Saving as “Scheduled”, “Postponed”, or “Cancelled” clears the displayed score. Saving the form returns to the screen it opened from.
- **An event changes the match.** Adding the first event to a “Scheduled” local match moves it to “In progress”. A “Goal” adds one to the selected team’s score. “Delete event” subtracts one for a deleted goal, down to zero.
- **A disabled “Refresh” in “Tables”.** It is disabled while a request is running and for a league outside the supported provider codes. To populate a table for a local league, save a scored match in that league as “Finished”. If finished local matches share a provider league code, “Table from your finished local matches” stays visible even after refreshing the provider standings.
- **A countdown button that stays visible.** “Start kickoff countdown” can show “Countdowns are available for favourite matches starting within 8 hours.” Star either team and wait until its future kickoff is within eight hours. “Live Activities are disabled in system Settings.” means they must be enabled there. Success shows “Countdown started on your Lock Screen.” A failed start can show “The countdown could not start. Try again on a supported device.” Starting again replaces the existing countdown for that match. “Stop countdown” is shown even when one has not been started.
- **No notifications after switching on an option.** Use “Enable notifications” first. The status reads “Notifications enabled” or “Notifications are disabled. You can enable them in system Settings.” Use “System notification settings” if permission was declined. Saved future kickoffs for favourite teams can produce “Scheduled kickoff” reminders. “Match started” and “Score updated” require a change detected during refresh and carry “After data refresh”. Digests are titled “Morning football digest” and “Evening football digest”. A digest can say “No favourite fixtures saved for this day.”
- **Headlines need a compatible feed.** Start in “Settings” with “HTTPS RSS feed address” and “Save and refresh feed”. “Enter a valid HTTPS RSS address.” means the address is missing or unsuitable. “This feed has no readable items.” means there were no qualifying entries. A failed request can show “The feed is unavailable.” or “The feed is unavailable. Saved headlines remain available.” A successful refresh replaces the previous set of headlines.
- **Export is a two-step flow and import is additive.** Tap “Prepare export” to reveal “Share matchbook”. “Import matchbook” adds matches and teams that are missing and keeps existing matches in place. It does not restore favourite selections or settings. Success reads “Matches imported.” A rejected import reads “This file could not be imported. Existing matches were kept.” Use a compatible Match Center export.
- **The directory and saved lists change over time.** “Team directory” grows as teams are added through local matches, fixture refreshes, or imports. “Your teams” disappears when its last star is removed. Older published fixtures can drop out as newer fixtures are saved. “Delete all local data” clears saved matches, favourite selections, headlines, connection settings, reminder preferences and countdowns, then restores the starter directory. Confirmation reads “Local data deleted.”
- **Widgets can be empty at first.** “Open the app to save matches and choose favourites.” or “No favourite match saved” means the selected widget has no matching saved data. Add or refresh a match, star a team where required, and check the date and filters. The circular Lock Screen widget can show “–” in this state.

## Starter content and resume

- “Team directory” starts with “Arsenal FC”, “Manchester City FC”, “Liverpool FC”, “FC Barcelona”, “Real Madrid CF”, “FC Bayern München”, “Paris Saint-Germain FC”, “Juventus FC”, “Flamengo”, “Palmeiras”, “Corinthians”, and “Santos”. “Tactics notebook” includes all six passing patterns from the first launch.
- A fresh install starts without saved matches, match events, favourite selections, tables, or headlines. Saved matches can be reopened and edited later. Unsaved match and event forms have no draft recovery. A fresh launch returns to “Matchday” with “Matches” selected. Saved league and favourite filters are retained.

## Permissions

- **Notifications.** The first tap on “Enable notifications” in “Settings” can show the iOS prompt for alerts, sounds, and badges. iOS supplies the prompt text. The app has no custom usage-description string.
- **Live Activities.** Tapping “Start kickoff countdown” on an eligible match starts the activity when the system allows it. iOS supplies any system confirmation. The app has no custom usage-description string. Selecting a matchbook in the system document picker requires access only to the document the user chooses.

## Absent

Login or accounts, in-app purchase, ads, analytics, a public user-generated content feed or submission flow, account deletion, and an App Tracking Transparency prompt are absent. Users can create private match entries and event notes, and can choose to export and share their matchbook.

## Data and support

Matchbook entries, favourites, saved fixtures, tables, and headlines are kept on this device. “Refresh” connects directly to the published fixture source, and headline refresh connects to the RSS publisher the user supplies. Those connections expose the device’s IP address to the service contacted. “Share matchbook” lets the user send an export through the system share sheet. “Delete all local data” clears the app’s saved data.

There is no on-screen “Contact” or “Support” control. “OpenFootball · CC0” is the fixture-source link.

## Scanning and health

None.

## Platform

- iPhone and iPad, with a minimum of iOS 17.4. iPhone supports portrait and both landscape orientations. iPad also supports upside-down portrait.
- There is no in-app region selector or region gate. The same competition choices are available across regions. Dates and times follow the device’s locale and time zone, and headline text stays in the publisher’s language.
- The interface is available in English, US English, UK English, Arabic, Traditional Chinese, Brazilian Portuguese, German, French, Spanish, and Italian. The app name is “Match Center” in every supported language. The quoted labels in this brief use the base English wording, with US English alternatives noted where relevant. System controls such as the document picker, share sheet, and permission prompt use the device language.

## Category

Sports
