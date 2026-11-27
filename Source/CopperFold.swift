import SwiftUI
import WidgetKit
import UserNotifications
import Security
import BackgroundTasks
import ActivityKit
import Foundation

@MainActor final class Hx8:ObservableObject {
 static let shared=Hx8()
 @Published var x=Rk4.read();@Published var busy=false;@Published var notice="";@Published var permission=""
 let prefs=UserDefaults(suiteName:vz8) ?? .standard
 var feed:String {get{prefs.string(forKey:"feed") ?? ""}set{prefs.set(newValue,forKey:"feed")}}
 var alerts:Bool { get{prefs.bool(forKey:"alerts")}set{prefs.set(newValue,forKey:"alerts");Task{await reminders()}} }
 var morning:Bool { get{prefs.bool(forKey:"morning")}set{prefs.set(newValue,forKey:"morning");Task{await reminders()}} }
 var evening:Bool { get{prefs.bool(forKey:"evening")}set{prefs.set(newValue,forKey:"evening");Task{await reminders()}} }
 func save(){ x.save(prefs);WidgetCenter.shared.reloadAllTimelines() }
 func star(_ t:Nv2) {
  if x.favourites.contains(t.id){x.favourites.removeAll{$0==t.id}}else{x.favourites.append(t.id)}
  if !x.teams.contains(t){x.teams.append(t)};save();Task{await reminders()}
 }
 func put(_ m:Zr7) {if let i=x.matches.firstIndex(where:{$0.id==m.id}) {x.matches[i]=m}else{x.matches.append(m)};for t in [m.home,m.away] where !x.teams.contains(where:{$0.id==t.id}) {x.teams.append(t)};save();Task{await reminders()}}
 func remove(_ m:Zr7){x.matches.removeAll{$0.id==m.id};save();Task{await stop(m.id);await reminders()}}
 func addEvent(_ id:String,_ e:Jh6){guard let i=x.matches.firstIndex(where:{$0.id==id && $0.local}) else{return};if x.matches[i].upcoming{x.matches[i].state="IN_PLAY";x.matches[i].h=0;x.matches[i].a=0};x.matches[i].events.append(e);x.matches[i].events.sort{$0.minute<$1.minute};x.matches[i].minute=e.minute;if e.kind=="Goal"{if e.home{x.matches[i].h=(x.matches[i].h ?? 0)+1}else{x.matches[i].a=(x.matches[i].a ?? 0)+1}};x.matches[i].observed=Date();save()}
 func removeEvent(_ id:String,_ e:Jh6){guard let i=x.matches.firstIndex(where:{$0.id==id})else{return};x.matches[i].events.removeAll{$0.id==e.id};if e.kind=="Goal"{if e.home{x.matches[i].h=max(0,(x.matches[i].h ?? 0)-1)}else{x.matches[i].a=max(0,(x.matches[i].a ?? 0)-1)}};save()}
 private func request(_ path:String) async throws->Data {
  let until=prefs.double(forKey:"nextCall");if Date().timeIntervalSince1970<until{throw Lp7.text("Please wait before refreshing again.")}
  return try await FixtureAlmanac.read(path)
 }
 func refresh(_ day:Date=Date()) async->Bool {
  guard !busy else{return false};busy=true;defer{busy=false};notice=""
  do {
   let f=DateFormatter();f.calendar=Calendar(identifier:.gregorian);f.locale=Locale(identifier:"en_US_POSIX");f.timeZone=TimeZone(secondsFromGMT:0);f.dateFormat="yyyy-MM-dd"
   let a=Calendar.current.startOfDay(for:day);let b=Calendar.current.date(byAdding:.day,value:1,to:a)!
   let d=try await request("matches?dateFrom=\(f.string(from:a))&dateTo=\(f.string(from:b))")
   let fresh=try Dp4.matches(d);let changes=Dp4.changes(x.matches,fresh,x.favourites);x.merge(fresh);save()
   if alerts {for (id,body) in changes {await notify(id,body)}}
   await reminders();await reconcile();return true
  }catch {notice=(error as? Lp7)?.errorDescription ?? ql("Unable to connect. Saved data remains available offline.");return false}
 }
 func table(_ code:String) async {guard !busy else{return};busy=true;defer{busy=false};do{let d=try await request("competitions/\(code)/standings");x.tables[code]=try Dp4.standings(d);x.tableDates[code]=Date();save()}catch{notice=(error as? Lp7)?.errorDescription ?? ql("Unable to connect. Saved data remains available offline.")}}
 func detail(_ m:Zr7) async {guard !m.local,!busy else{return};busy=true;defer{busy=false};do {let d=try await request("matches/"+m.id.replacingOccurrences(of:"fd:",with:""));let r=try JSONSerialization.jsonObject(with:d);let wrap=try JSONSerialization.data(withJSONObject:["matches":[r]]);let fresh=try Dp4.matches(wrap);x.merge(fresh);save()}catch{notice=(error as? Lp7)?.errorDescription ?? ql("Unable to connect. Saved data remains available offline.")}}
 func allow() async {do{let ok=try await UNUserNotificationCenter.current().requestAuthorization(options:[.alert,.sound,.badge]);permission=ql(ok ? "Notifications enabled":"Notifications are disabled. You can enable them in system Settings.");await reminders()}catch{permission=ql("Notifications are disabled. You can enable them in system Settings.")}}
 private func notify(_ id:String,_ body:String) async {
  let key="seen:"+id;guard !prefs.bool(forKey:key)else{return};let c=UNMutableNotificationContent();c.title="Match Center";c.body=body+". "+ql("After data refresh");c.sound = .default
  try? await UNUserNotificationCenter.current().add(UNNotificationRequest(identifier:id,content:c,trigger:nil));prefs.set(true,forKey:key)
 }
 func reminders() async {
  let center=UNUserNotificationCenter.current();let pending=await center.pendingNotificationRequests();center.removePendingNotificationRequests(withIdentifiers:pending.filter{$0.identifier.hasPrefix("kick:") || $0.identifier.hasPrefix("digest:")}.map(\.identifier))
  let s=await center.notificationSettings();guard [.authorized,.provisional,.ephemeral].contains(s.authorizationStatus) else{return}
  let next=x.matches.filter{$0.upcoming && $0.kickoff>Date() && $0.favourite(x.favourites)}.sorted{$0.kickoff<$1.kickoff}
  if alerts {for m in next.prefix(40) {let c=UNMutableNotificationContent();c.title=ql("Scheduled kickoff");c.body=m.home.name+" · "+m.away.name;c.sound = .default;let dt=Calendar.current.dateComponents([.year,.month,.day,.hour,.minute],from:m.kickoff);try? await center.add(UNNotificationRequest(identifier:"kick:"+m.id,content:c,trigger:UNCalendarNotificationTrigger(dateMatching:dt,repeats:false)))}}
  for (enabled,hour) in [(morning,8),(evening,20)] where enabled {
   for offset in 0..<7 {
    guard let day=Calendar.current.date(byAdding:.day,value:offset,to:Date()),let at=Calendar.current.date(bySettingHour:hour,minute:0,second:0,of:day),at>Date() else{continue}
    let c=UNMutableNotificationContent();c.title=ql(hour==8 ? "Morning football digest":"Evening football digest");c.body=x.digest(day);c.sound = .default
    let parts=Calendar.current.dateComponents([.year,.month,.day,.hour,.minute],from:at)
    try? await center.add(UNNotificationRequest(identifier:"digest:\(offset)-\(hour)",content:c,trigger:UNCalendarNotificationTrigger(dateMatching:parts,repeats:false)))
   }
  }
 }
 func live(_ m:Zr7) async {
  guard m.upcoming,m.favourite(x.favourites),m.kickoff>Date(),m.kickoff.timeIntervalSinceNow<=8*3600 else{notice=ql("Countdowns are available for favourite matches starting within 8 hours.");return}
  guard ActivityAuthorizationInfo().areActivitiesEnabled else{notice=ql("Live Activities are disabled in system Settings.");return}
  await stop(m.id)
  do{_ = try Activity<Xa3>.request(attributes:Xa3(matchID:m.id,home:m.home.name,away:m.away.name),content:ActivityContent(state:Xa3.ContentState(kickoff:m.kickoff),staleDate:m.kickoff),pushType:nil);notice=ql("Countdown started on your Lock Screen.")}catch{notice=ql("The countdown could not start. Try again on a supported device.")}
 }
 func stop(_ id:String) async {for a in Activity<Xa3>.activities where a.attributes.matchID==id{await a.end(nil,dismissalPolicy:.immediate)}}
 func reconcile() async {for a in Activity<Xa3>.activities {if let m=x.matches.first(where:{$0.id==a.attributes.matchID}), m.upcoming,m.kickoff>Date(){await a.update(ActivityContent(state:.init(kickoff:m.kickoff),staleDate:m.kickoff))}else{await a.end(nil,dismissalPolicy:.immediate)}}}
 func rss() async {
  guard let url=URL(string:feed),url.scheme=="https",url.host != nil else{notice=ql("Enter a valid HTTPS RSS address.");return};guard !busy else{return};busy=true;defer{busy=false}
  do{var r=URLRequest(url:url);r.timeoutInterval=15;let(d,s)=try await URLSession.shared.data(for:r);guard (s as? HTTPURLResponse)?.statusCode==200,d.count<2_000_000 else{throw Lp7.text("The feed is unavailable.")};let p=Fs9();let parser=XMLParser(data:d);parser.delegate=p;guard parser.parse(),!p.items.isEmpty else{throw Lp7.text("This feed has no readable items.")};x.news=p.items;save()}catch{notice=(error as? Lp7)?.errorDescription ?? ql("The feed is unavailable. Saved headlines remain available.")}
 }
 func exportURL()->URL?{let u=FileManager.default.temporaryDirectory.appendingPathComponent("MatchCenter.json");guard let d=try? JSONEncoder().encode(x), (try? d.write(to:u,options:.atomic)) != nil else{return nil};return u}
 func importFile(_ u:URL) {let ok=u.startAccessingSecurityScopedResource();defer{if ok{u.stopAccessingSecurityScopedResource()}};do{let d=try Data(contentsOf:u);guard d.count<10_000_000 else{throw Lp7.text("The file is too large.")};let a=try JSONDecoder().decode(Rk4.self,from:d);guard a.matches.count<5000,Set(a.matches.map(\.id)).count==a.matches.count,a.matches.allSatisfy({$0.home.id != $0.away.id && ($0.h ?? 0)>=0 && ($0.a ?? 0)>=0 && $0.events.allSatisfy{(0...150).contains($0.minute)}})else{throw Lp7.text("The file contains invalid match data.")};let ids=Set(x.matches.map(\.id));x.matches+=a.matches.filter{!ids.contains($0.id)};for t in a.teams where !x.teams.contains(where:{$0.id==t.id}) {x.teams.append(t)};save();notice=ql("Matches imported.")}catch{notice=ql("This file could not be imported. Existing matches were kept.")}}
 func erase() async {for a in Activity<Xa3>.activities{await a.end(nil,dismissalPolicy:.immediate)};UNUserNotificationCenter.current().removeAllPendingNotificationRequests();UNUserNotificationCenter.current().removeAllDeliveredNotifications();prefs.removePersistentDomain(forName:vz8);SecItemDelete(Vq6.query as CFDictionary);x=Rk4();save();notice=ql("Local data deleted.")}
 static func schedule(){let r=BGAppRefreshTaskRequest(identifier:"com.matchcenter.app-d353a8df8958.refresh");r.earliestBeginDate=Date(timeIntervalSinceNow:30*60);try? BGTaskScheduler.shared.submit(r)}
}
enum Lp7:LocalizedError {case text(String);var errorDescription:String? {switch self{case .text(let s):return ql(s)}}}
enum Vq6 {
 static let query:[String:Any] = [kSecClass as String:kSecClassGenericPassword,kSecAttrService as String:"com.matchcenter.app-d353a8df8958",kSecAttrAccount as String:"football-token"]
}
final class Fs9:NSObject,XMLParserDelegate {
 var items:[Nw2]=[];var inside=false;var element="";var title="";var link="";var date=""
 func parser(_ parser:XMLParser,didStartElement n:String,namespaceURI:String?,qualifiedName:String?,attributes:[String:String]){element=n;if n=="item"{inside=true;title="";link="";date=""}}
 func parser(_ parser:XMLParser,foundCharacters s:String){guard inside else{return};switch element{case "title":title+=s;case "link":link+=s;case "pubDate":date+=s;default:break}}
 func parser(_ parser:XMLParser,foundCDATA d:Data){if let s=String(data:d,encoding:.utf8){self.parser(parser,foundCharacters:s)}}
 func parser(_ parser:XMLParser,didEndElement n:String,namespaceURI:String?,qualifiedName:String?){if n=="item" {inside=false;let t=title.trimmingCharacters(in:.whitespacesAndNewlines);let l=link.trimmingCharacters(in:.whitespacesAndNewlines);if let u=URL(string:l),u.scheme=="https",!t.isEmpty,t.range(of:"(?i)\\b(bet\\w*|casino\\w*|jackpot\\w*|odds|aposta\\w*)\\b",options:.regularExpression)==nil,items.count<40 {items.append(Nw2(id:l,title:t,source:u.host ?? "RSS",date:date))}};element=""}
}

private enum FixtureAlmanac {
 struct Season:Decodable {let name:String;let matches:[Fixture]}
 struct Fixture:Decodable {
  let status:String?;let round:String?;let date:String;let time:String?;let team1:String;let team2:String;let score:Totals?
  struct Totals:Decodable {
   let ft:[Int]?
   let ht:[Int]?
   private enum CodingKeys:String,CodingKey {case ft,ht}
   init(from decoder:Decoder) throws {
    func pair(_ values:[Int]?) -> [Int]? {
     guard let values, values.count == 2, values.allSatisfy({$0 >= 0}) else {return nil}
     return values
    }
    if let values = try? decoder.singleValueContainer().decode([Int].self) {
     ft = pair(values); ht = nil
    } else {
     let fields = try decoder.container(keyedBy:CodingKeys.self)
     ft = pair(try? fields.decode([Int].self,forKey:.ft))
     ht = pair(try? fields.decode([Int].self,forKey:.ht))
    }
   }
  }
 }
 static let catalog=["PL":("en.1","Europe/London"),"ELC":("en.2","Europe/London"),"BL1":("de.1","Europe/Berlin"),"SA":("it.1","Europe/Rome"),"FL1":("fr.1","Europe/Paris"),"PPL":("pt.1","Europe/Lisbon"),"DED":("nl.1","Europe/Amsterdam"),"PD":("es.1","Europe/Madrid"),"BSA":("br.1","America/Sao_Paulo")]
 static func number(_ text:String)->Int {
  var hash:UInt32=2166136261
  for b in text.utf8 {hash=(hash ^ UInt32(b)) &* 16777619}
  return 1_000_000+Int(hash)
 }
 static func clubID(_ name:String)->Int {
  
  return number(name)
 }
 static func load(_ league:String, at:Date,session:URLSession) async throws -> [[String:Any]] {
  guard let (file,zone)=catalog[league] else{throw URLError(.resourceUnavailable)}
  var cal=Calendar(identifier:.gregorian);cal.timeZone=TimeZone(identifier:zone)!
  let year=cal.component(.year,from:at),start=cal.component(.month,from:at)<7 ? year-1:year
  let folder=league=="BSA" ? String(year):String(format:"%d-%02d",start,(start+1)%100)
  let url=URL(string:"https://raw.githubusercontent.com/openfootball/football.json/master/\(folder)/\(file).json")!
  var req=URLRequest(url:url,timeoutInterval:18);req.setValue("application/json",forHTTPHeaderField:"Accept")
  let (data,res)=try await session.data(for:req)
  guard (res as? HTTPURLResponse)?.statusCode==200,data.count<4_000_000 else{throw URLError(.badServerResponse)}
  let season=try JSONDecoder().decode(Season.self,from:data)
  let parser=DateFormatter();parser.locale=Locale(identifier:"en_US_POSIX");parser.timeZone=cal.timeZone;parser.dateFormat="yyyy-MM-dd HH:mm"
  let iso=ISO8601DateFormatter()
  return season.matches.compactMap { m -> [String:Any]? in
   guard let time=m.time,let when=parser.date(from:m.date+" "+String(time.prefix(5))) else{return nil}
   if let state=m.status?.lowercased(), ["postponed","cancelled","canceled","abandoned","suspended"].contains(state) {return nil}
   let id=number(league+"|"+folder+"|"+(m.round ?? "")+"|"+m.team1+"|"+m.team2)
   let home:[String:Any]=["id":clubID(m.team1),"name":m.team1,"shortName":m.team1]
   let away:[String:Any]=["id":clubID(m.team2),"name":m.team2,"shortName":m.team2]
   var full=[String:Int](),half=[String:Int]()
   if let g=m.score?.ft,g.count==2 {full=["home":g[0],"away":g[1]]}
   if let g=m.score?.ht,g.count==2 {half=["home":g[0],"away":g[1]]}
   let day=Int((m.round ?? "").split(separator:" ").last ?? "") ?? 0
   return ["id":id,"utcDate":iso.string(from:when),"matchday":day,"season":["startDate":String(league=="BSA" ? year:start)+"-01-01"],"stage":"REGULAR_SEASON","competition":["code":league,"name":season.name],"homeTeam":home,"awayTeam":away,"score":["fullTime":full,"halfTime":half],"status":full.isEmpty ? "SCHEDULED":"FINISHED"]
  }
 }
 static func table(_ rows:[[String:Any]]) -> [[String:Any]] {
  struct Record { var team:[String:Any];var won=0,draw=0,lost=0,gf=0,ga=0;var points:Int{won*3+draw}}
  var records=[Int:Record]()
  for m in rows {
   guard let home=m["homeTeam"] as? [String:Any],let away=m["awayTeam"] as? [String:Any],
         let hid=home["id"] as? Int,let aid=away["id"] as? Int else{continue}
   for (id,t) in [(hid,home),(aid,away)] where records[id]==nil {records[id]=Record(team:t)}
   guard let full=(m["score"] as? [String:[String:Int]])?["fullTime"],let h=full["home"],let a=full["away"] else{continue}
   for (id,g,f) in [(hid,h,a),(aid,a,h)] {records[id]?.gf+=g;records[id]?.ga+=f
    if g==f {records[id]?.draw+=1} else if g>f {records[id]?.won+=1} else {records[id]?.lost+=1}
   }
  }
  let sorted=records.values.sorted{ a,b in
   if a.points != b.points {return a.points>b.points}
   if a.gf-a.ga != b.gf-b.ga{return a.gf-a.ga>b.gf-b.ga}
   if a.gf != b.gf{return a.gf>b.gf}
   return (a.team["name"] as? String ?? "")<(b.team["name"] as? String ?? "")
  }
  return sorted.enumerated().map {i,r in ["team":r.team,"position":i+1,"won":r.won,"draw":r.draw,"lost":r.lost,"playedGames":r.won+r.draw+r.lost,"points":r.points,"goalsFor":r.gf,"goalsAgainst":r.ga,"goalDifference":r.gf-r.ga]}
 }

 static func read(_ path:String,session:URLSession = .shared) async throws -> Data {
  let parts=URLComponents(string:path)
  let route=parts?.path.split(separator:"/").map(String.init) ?? []
  let query=Dictionary((parts?.queryItems ?? []).compactMap { item in item.value.map{(item.name,$0)} },uniquingKeysWith:{$1})
  let formatter=ISO8601DateFormatter()
  let at=query["dateFrom"].flatMap{formatter.date(from:$0+"T12:00:00Z")} ?? Date()
  let first=route.first,requested=first=="competitions" && route.count>1 ? [route[1]] : ["PL", "BL1", "PD"]
  let end=query["dateTo"].flatMap{formatter.date(from:$0+"T12:00:00Z")} ?? at
  guard end>=at,end.timeIntervalSince(at)<=370*86400 else{throw URLError(.badURL)}
  var rows=[[String:Any]]()
  for code in requested {
   let leading=try await load(code,at:at,session:session)
   rows.append(contentsOf:leading)
   guard let zone=catalog[code]?.1,let tz=TimeZone(identifier:zone) else{throw URLError(.badURL)}
   var calendar=Calendar(identifier:.gregorian);calendar.timeZone=tz
   func seasonYear(_ instant:Date)->Int {
    calendar.component(.year,from:instant) - (code != "BSA" && calendar.component(.month,from:instant)<7 ? 1:0)
   }
   if seasonYear(end) != seasonYear(at) {
    rows.append(contentsOf:try await load(code,at:end,session:session))
   }
  }
  if route.last=="standings" {return try JSONSerialization.data(withJSONObject:["standings":[["type":"TOTAL","table":table(rows)]]])}
  if first=="matches",route.count==2,let id=Int(route[1]) {guard let m=rows.first(where:{$0["id"] as? Int==id}) else{throw URLError(.resourceUnavailable)};return try JSONSerialization.data(withJSONObject:m)}
  if first=="teams",route.count>=2,let team=Int(route[1]) {rows=rows.filter { ($0["homeTeam"] as? [String:Any])?["id"] as? Int==team || ($0["awayTeam"] as? [String:Any])?["id"] as? Int==team }}
  if let lower=query["dateFrom"] {rows=rows.filter{String(($0["utcDate"] as? String ?? "").prefix(10))>=lower}}
  if let upper=query["dateTo"] {rows=rows.filter{String(($0["utcDate"] as? String ?? "").prefix(10))<=upper}}
  return try JSONSerialization.data(withJSONObject:["matches":rows])
 }
}
