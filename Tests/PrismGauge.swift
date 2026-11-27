import XCTest
#if UI_PROBE
final class Gn9:XCTestCase {
 private func navigationTab(_ label: String, in app: XCUIApplication) -> XCUIElement {
  let compactTab = app.tabBars.buttons[label].firstMatch
  if compactTab.exists { return compactTab }
  // iPad exposes floating tabs as buttons without a TabBar accessibility ancestor.
  return app.buttons.matching(NSPredicate(format: "label == %@", label)).firstMatch
 }
 func testOfflineJourney() throws {
  let app=XCUIApplication();app.launchArguments=["-AppleLanguages","(en)","-AppleLocale","en_US"];app.launch()
  XCTAssertTrue(app.buttons["addMatch"].waitForExistence(timeout:15));snap("01-first-launch")
  app.buttons["addMatch"].tap()
  let home=app.textFields["homeInput"];XCTAssertTrue(home.waitForExistence(timeout:5));home.tap();home.typeText("Northside")
  let away=app.textFields["awayInput"];away.tap();away.typeText("Riverside")
  let league=app.textFields["leagueInput"];league.tap();league.typeText("Community Cup")
  app.buttons["saveMatch"].tap()
  let card=app.buttons.matching(NSPredicate(format:"identifier BEGINSWITH 'match-local:'")).firstMatch
  XCTAssertTrue(card.waitForExistence(timeout:6));snap("02-local-fixture");card.tap();snap("03-detail")
  app.buttons.matching(NSPredicate(format:"label CONTAINS 'Toggle favourite Northside'")).firstMatch.tap()
  app.buttons["Start kickoff countdown"].tap();snap("03-countdown-request");
  app.buttons["addEvent"].tap();XCTAssertTrue(app.buttons["saveEvent"].waitForExistence(timeout:4));app.buttons["saveEvent"].tap()
  XCTAssertTrue(app.staticTexts["Goal"].waitForExistence(timeout:5));snap("04-event")
  app.terminate();app.launch();XCTAssertTrue(app.buttons.matching(NSPredicate(format:"identifier BEGINSWITH 'match-local:'")).firstMatch.waitForExistence(timeout:10));snap("05-restored")
  navigationTab("Calendar", in: app).tap();snap("06-calendar")
  navigationTab("Favourites", in: app).tap();XCTAssertTrue(app.staticTexts["Northside"].firstMatch.waitForExistence(timeout:5));snap("07-favourites")
  navigationTab("Settings", in: app).tap();snap("08-settings")
 }
 func testOfflineTacticalTransitions() {
  let app=XCUIApplication()
  app.launchArguments=["-AppleLanguages","(en)","-AppleLocale","en_GB"]
  app.launch()
  app.buttons["tactics"].firstMatch.tap()
  XCTAssertTrue(app.buttons["Pass 1"].waitForExistence(timeout:5))
  app.buttons["Pass 2"].tap()
  XCTAssertTrue(app.staticTexts.matching(NSPredicate(format:"label BEGINSWITH %@", "The pivot receives")).firstMatch.exists)
  for _ in 0..<4 where !app.buttons["play-4"].isHittable { app.swipeUp() }
  app.buttons["play-4"].tap()
  for _ in 0..<4 where !app.buttons["Pass 1"].isHittable { app.swipeDown() }
  XCTAssertTrue(app.staticTexts.matching(NSPredicate(format:"label BEGINSWITH %@", "The holding midfielder secures")).firstMatch.exists)
 }
 func testLocalizedLaunches() {
  for (language,locale,calendar) in [("pt-BR","pt_BR","Calendário"),("de","de_DE","Kalender"),("fr","fr_FR","Calendrier"),("es","es_ES","Calendario"),("it","it_IT","Calendario"),("ar","ar_SA","التقويم"),("zh-Hant","zh_TW","行事曆")] {
   let a=XCUIApplication();a.launchArguments=["-AppleLanguages","(\(language))","-AppleLocale",locale];a.launch();XCTAssertTrue(navigationTab(calendar, in: a).waitForExistence(timeout:10));snap("locale-"+language);a.terminate()
  }
 }
 func testNotificationDenialAndLargeText() {
  let a=XCUIApplication();a.launchArguments=["-AppleLanguages","(en)","-AppleLocale","en_US"];a.launch();navigationTab("Settings", in: a).tap()
  for _ in 0..<5 {if a.buttons["Enable notifications"].isHittable{break};a.swipeUp()}
  a.buttons["Enable notifications"].tap()
  let os=XCUIApplication(bundleIdentifier:"com.apple.springboard")
  let b=os.alerts.buttons.matching(NSPredicate(format:"label CONTAINS[c] 'allow' AND label CONTAINS[c] 'don'")).firstMatch
  if b.waitForExistence(timeout:3){b.tap()}else{let c=a.alerts.buttons.matching(NSPredicate(format:"label CONTAINS[c] 'allow' AND label CONTAINS[c] 'don'")).firstMatch;if c.exists{c.tap()}}
  let denied=a.staticTexts.matching(NSPredicate(format:"label CONTAINS 'Notifications are disabled'")).firstMatch
  if !denied.waitForExistence(timeout:5){a.swipeUp()}
  XCTAssertTrue(denied.waitForExistence(timeout:5));snap("notifications-denied");a.terminate()
  a.launchArguments=["-AppleLanguages","(en)","-UIPreferredContentSizeCategoryName","UICTContentSizeCategoryAccessibilityXXXL"];a.launch();XCTAssertTrue(a.buttons["addMatch"].waitForExistence(timeout:10));snap("accessibility-large-text")
 }
 func snap(_ name:String){let a=XCTAttachment(screenshot:XCUIScreen.main.screenshot());a.name=name;a.lifetime = .keepAlways;add(a)}
}
#else
@testable import CinderDesk
final class Gn9:XCTestCase {
 func fixture(_ id:String="local:test",state:String="FINISHED",h:Int=2,a:Int=1)->Zr7{Zr7(id:id,home:Nv2(id:"h",name:"Home"),away:Nv2(id:"a",name:"Away"),league:"L",kickoff:Date(),state:state,h:h,a:a,minute:nil,observed:Date(),local:id.hasPrefix("local:"))}
 func testBrazilDirectoryAndProviderShareFavouriteIdentity(){XCTAssertEqual(Nv2.resolved(999,"CR Flamengo","Flamengo").id,"local:flamengo");XCTAssertEqual(Nv2.resolved(998,"SC Corinthians Paulista",nil).id,"local:corinthians")}
 func testDigestOnlySummarizesTheFavouriteMatchday(){var x=Rk4();x.matches=[fixture()];x.favourites=["h"];XCTAssertTrue(x.digest(Date()).contains("Home"));x.favourites=[];XCTAssertFalse(x.digest(Date()).contains("Home"))}
 func testTableThreePointsAndGoalDifference(){var x=Rk4();x.matches=[fixture(),fixture("local:draw",h:1,a:1)];let t=x.localTable("L");XCTAssertEqual(t.first?.points,4);XCTAssertEqual(t.first?.played,2);XCTAssertEqual(t.first?.gf,3);XCTAssertEqual(t.last?.points,1)}
 func testMergeRetainsLocalAndReplacesProvider(){var x=Rk4();x.matches=[fixture(),fixture("fd:1")];x.merge([fixture("fd:1",h:5)]);XCTAssertEqual(x.matches.count,2);XCTAssertEqual(x.matches.first{$0.id=="fd:1"}?.h,5);XCTAssertTrue(x.matches.contains{$0.local})}
 func testNotificationDiffOnlyForFavouritesAndNeverFirstSnapshot(){let old=fixture("fd:1",state:"SCHEDULED",h:0,a:0);let now=fixture("fd:1",state:"IN_PLAY",h:1,a:0);XCTAssertEqual(Dp4.changes([], [now],["h"]).count,0);XCTAssertEqual(Dp4.changes([old],[now],[]).count,0);XCTAssertEqual(Dp4.changes([old],[now],["h"]).count,2);XCTAssertTrue(Dp4.changes([now],[old],["h"]).isEmpty)}
 func testDayLeagueAndFavouriteFilters(){var x=Rk4();var m=fixture();m.kickoff=Calendar.current.date(byAdding:.day,value:1,to:Date())!;x.matches=[fixture(),m];x.onlyStars=true;XCTAssertTrue(x.list(Date()).isEmpty);x.favourites=["h"];XCTAssertEqual(x.list(Date()).count,1);x.league="other";XCTAssertTrue(x.list(Date()).isEmpty)}
 func testCorruptedSnapshotFallsBackToValidatedBackup(){let name="qa."+UUID().uuidString;let d=UserDefaults(suiteName:name)!;defer{d.removePersistentDomain(forName:name)};var x=Rk4();x.matches=[fixture()];x.save(d);x.favourites=["h"];x.save(d);d.set(Data("broken".utf8),forKey:"ember.snapshot");XCTAssertEqual(Rk4.read(d).matches.count,1)}
 func testProviderParserHandlesNullScoresAndMissingDeepData()throws{let d=Data(#"{"matches":[{"id":7,"utcDate":"2026-11-15T15:00:00Z","homeTeam":{"id":57,"name":"Home"},"awayTeam":{"id":65,"name":"Away"},"competition":{"code":"PL"},"status":"TIMED","score":{"fullTime":{"home":null,"away":null}}}]}"#.utf8);let m=try XCTUnwrap(Dp4.matches(d).first);XCTAssertNil(m.h);XCTAssertTrue(m.events.isEmpty);XCTAssertTrue(m.upcoming);XCTAssertFalse(m.local)}
 @MainActor func testRSSReaderCachesOnlySecureHeadlineLinks(){let r=Fs9();let p=XMLParser(data:Data("<rss><channel><item><title>Football update</title><link>https://example.org/story</link></item><item><title>Unsafe</title><link>http://example.org/story</link></item></channel></rss>".utf8));p.delegate=r;XCTAssertTrue(p.parse());XCTAssertEqual(r.items.count,1);XCTAssertEqual(r.items.first?.title,"Football update")}
}
#endif
