import Foundation
import ActivityKit

let vz8 = "group.com.matchcenter.app-d353a8df8958"
func ql(_ s:String)->String { NSLocalizedString(s, comment: "") }
func qf(_ s:String,_ v:CVarArg...)->String { String(format: ql(s), locale: .current, arguments:v) }
struct Nv2: Codable,Identifiable,Hashable {
 var id:String; var name:String
 static let seed:[Nv2] = [ .init(id:"57",name:"Arsenal FC"),.init(id:"65",name:"Manchester City FC"),.init(id:"64",name:"Liverpool FC"),.init(id:"81",name:"FC Barcelona"),.init(id:"86",name:"Real Madrid CF"),.init(id:"5",name:"FC Bayern München"),.init(id:"524",name:"Paris Saint-Germain FC"),.init(id:"109",name:"Juventus FC"),.init(id:"local:flamengo",name:"Flamengo"),.init(id:"local:palmeiras",name:"Palmeiras"),.init(id:"local:corinthians",name:"Corinthians"),.init(id:"local:santos",name:"Santos") ]
}
extension Nv2 {
 static func resolved(_ id:Int,_ name:String,_ short:String?)->Nv2 {
  let n=(short ?? name).folding(options:[.diacriticInsensitive,.caseInsensitive],locale:Locale(identifier:"en_US_POSIX"));let parts=n.components(separatedBy:CharacterSet.alphanumerics.inverted).filter{!$0.isEmpty && !["fc","cf","cr","sc","se","ac","paulista"].contains($0)};let key=parts.joined(separator:" ")
  if let t=seed.first(where:{$0.id.hasPrefix("local:") && $0.name.lowercased()==key}){return t};return Nv2(id:String(id),name:short ?? name)
 }
}
struct Jh6: Codable,Identifiable,Hashable {
 var id = UUID().uuidString; var minute:Int; var kind:String; var home:Bool; var person:String
}
struct Zr7: Codable,Identifiable,Hashable {
 var id:String; var home:Nv2; var away:Nv2; var league:String; var kickoff:Date
 var state:String; var h:Int?; var a:Int?; var minute:Int?; var events:[Jh6] = []
 var observed:Date; var local:Bool
 var running:Bool { ["IN_PLAY","PAUSED","EXTRA_TIME","PENALTY_SHOOTOUT"].contains(state) }
 var upcoming:Bool { ["SCHEDULED","TIMED"].contains(state) }
 var score:String { if let h,let a { return "\(h) – \(a)" }; return "– : –" }
 func favourite(_ ids:[String])->Bool { ids.contains(home.id) || ids.contains(away.id) }
 var status:String { ql(["IN_PLAY":"In progress","PAUSED":"Half-time","FINISHED":"Finished","SCHEDULED":"Scheduled","TIMED":"Scheduled","POSTPONED":"Postponed","SUSPENDED":"Suspended","CANCELLED":"Cancelled","EXTRA_TIME":"Extra time","PENALTY_SHOOTOUT":"Penalties","AWARDED":"Awarded"][state] ?? "Scheduled") }
}
struct Tb9:Codable,Identifiable,Hashable {
 var id:String; var name:String; var played:Int; var won:Int; var drawn:Int; var lost:Int; var gf:Int; var ga:Int; var points:Int
}
struct Nw2:Codable,Identifiable,Hashable { var id:String;var title:String;var source:String;var date:String }
struct Rk4:Codable {
 var matches:[Zr7] = []; var teams:[Nv2] = Nv2.seed; var favourites:[String] = []
 var tables:[String:[Tb9]] = [:]; var tableDates:[String:Date] = [:]; var news:[Nw2] = []
 var stamp:Date?; var league = ""; var onlyStars = false
 static func read(_ defaults:UserDefaults = UserDefaults(suiteName:vz8) ?? .standard)->Rk4 {
  for key in ["ember.snapshot","ember.backup"] { if let d=defaults.data(forKey:key),let x=try? JSONDecoder().decode(Rk4.self,from:d) { return x } };return Rk4()
 }
 func save(_ defaults:UserDefaults = UserDefaults(suiteName:vz8) ?? .standard) {
  guard let d=try? JSONEncoder().encode(self) else {return}
  if let old=defaults.data(forKey:"ember.snapshot"), (try? JSONDecoder().decode(Rk4.self,from:old)) != nil { defaults.set(old,forKey:"ember.backup") }
  defaults.set(d,forKey:"ember.snapshot")
 }
 func list(_ day:Date,live:Bool = false)->[Zr7] {
  matches.filter { Calendar.current.isDate($0.kickoff,inSameDayAs:day) && (league.isEmpty || $0.league == league) && (!onlyStars || $0.favourite(favourites)) && (!live || $0.running) }.sorted { if $0.running != $1.running { return $0.running };return $0.kickoff < $1.kickoff }
 }
 mutating func merge(_ incoming:[Zr7]) {
  let keys=Set(incoming.map(\.id)); matches.removeAll{keys.contains($0.id) && !$0.local}; matches += incoming
  matches.sort{$0.kickoff > $1.kickoff}; matches = matches.filter{$0.local} + Array(matches.filter{!$0.local}.prefix(1600)); stamp=Date()
  for x in incoming { for t in [x.home,x.away] where !teams.contains(where:{$0.id == t.id}) { teams.append(t) } }
 }
 func digest(_ day:Date)->String {
  let rows=matches.filter{Calendar.current.isDate($0.kickoff,inSameDayAs:day) && $0.favourite(favourites)}.sorted{$0.kickoff<$1.kickoff}
  guard !rows.isEmpty else{return ql("No favourite fixtures saved for this day.")}
  let lines=rows.prefix(3).map{m in m.home.name+" · "+m.away.name+" "+(m.h == nil ? m.kickoff.formatted(date:.omitted,time:.shortened):m.score)}
  return lines.joined(separator:"; ")+". "+ql("Saved")+" "+(rows.map(\.observed).max() ?? day).formatted(date:.abbreviated,time:.shortened)
 }
 func localTable(_ league:String)->[Tb9] {
  var d:[String:Tb9] = [:]
  for m in matches where m.local && m.league == league && m.state == "FINISHED" {
   guard let h=m.h,let a=m.a else{continue}
   for (t,f,g) in [(m.home,h,a),(m.away,a,h)] {
    var r=d[t.id] ?? Tb9(id:t.id,name:t.name,played:0,won:0,drawn:0,lost:0,gf:0,ga:0,points:0)
    r.played+=1;r.gf+=f;r.ga+=g
    if f>g {r.won+=1;r.points+=3} else if f==g {r.drawn+=1;r.points+=1} else{r.lost+=1};d[t.id]=r
   }
  }
  return d.values.sorted { if $0.points != $1.points{return $0.points>$1.points}; if $0.gf-$0.ga != $1.gf-$1.ga{return $0.gf-$0.ga > $1.gf-$1.ga}; if $0.gf != $1.gf{return $0.gf>$1.gf};return $0.name<$1.name }
 }
}
struct Xa3:ActivityAttributes {
 struct ContentState:Codable,Hashable { var kickoff:Date }
 var matchID:String;var home:String;var away:String
}
enum Dp4 {
 static func matches(_ d:Data,now:Date = Date()) throws->[Zr7] {
  let root=try JSONSerialization.jsonObject(with:d) as? [String:Any]
  guard let rows=root?["matches"] as? [[String:Any]] else { throw NSError(domain:"Invalid response",code:1) }
  let iso=ISO8601DateFormatter()
  return rows.compactMap { r in
   guard let id=r["id"] as? Int,let utc=r["utcDate"] as? String,let dt=iso.date(from:utc),let h=r["homeTeam"] as? [String:Any],let a=r["awayTeam"] as? [String:Any],let hi=h["id"] as? Int,let ai=a["id"] as? Int,let hn=h["name"] as? String,let an=a["name"] as? String else { return nil }
   let co=r["competition"] as? [String:Any];let sc=r["score"] as? [String:Any];let full=sc?["fullTime"] as? [String:Any]
   var ev:[Jh6] = []
   for (key,kind) in [("goals","Goal"),("bookings","Card"),("substitutions","Substitution")] {
    for (i,e) in ((r[key] as? [[String:Any]]) ?? []).enumerated() {
     let team=e["team"] as? [String:Any]; let person=(e["scorer"] ?? e["player"] ?? e["playerIn"]) as? [String:Any]
     ev.append(Jh6(id:"\(id)-\(key)-\(i)",minute:e["minute"] as? Int ?? 0,kind:kind,home:(team?["id"] as? Int)==hi,person:person?["name"] as? String ?? ""))
    }
   }
   return Zr7(id:"fd:\(id)",home:Nv2.resolved(hi,hn,h["shortName"] as? String),away:Nv2.resolved(ai,an,a["shortName"] as? String),league:co?["code"] as? String ?? "Football",kickoff:dt,state:r["status"] as? String ?? "SCHEDULED",h:full?["home"] as? Int,a:full?["away"] as? Int,minute:r["minute"] as? Int,events:ev.sorted{$0.minute<$1.minute},observed:now,local:false)
  }
 }
 static func changes(_ old:[Zr7],_ fresh:[Zr7],_ fav:[String])->[(String,String)] {
  var out:[(String,String)]=[]
  for m in fresh where m.favourite(fav) {
   guard let p=old.first(where:{$0.id==m.id}) else{continue}
   if m.running && p.upcoming {out.append((m.id+"-start",ql("Match started")+": "+m.home.name+" · "+m.away.name))}
   if (m.h ?? 0)>(p.h ?? 0) || (m.a ?? 0)>(p.a ?? 0) { out.append((m.id+"-\(m.h ?? 0)-\(m.a ?? 0)",ql("Score updated")+": "+m.home.name+" "+m.score+" "+m.away.name)) }
  };return out
 }
 static func standings(_ d:Data)throws->[Tb9] {
  let root=try JSONSerialization.jsonObject(with:d) as? [String:Any]
  guard let arr=root?["standings"] as? [[String:Any]],let total=arr.first(where:{$0["type"] as? String == "TOTAL"}),let rows=total["table"] as? [[String:Any]] else{throw NSError(domain:"Invalid table",code:2)}
  return rows.compactMap { r in guard let t=r["team"] as? [String:Any],let id=t["id"] as? Int,let name=t["name"] as? String else{return nil};return Tb9(id:String(id),name:name,played:r["playedGames"] as? Int ?? 0,won:r["won"] as? Int ?? 0,drawn:r["draw"] as? Int ?? 0,lost:r["lost"] as? Int ?? 0,gf:r["goalsFor"] as? Int ?? 0,ga:r["goalsAgainst"] as? Int ?? 0,points:r["points"] as? Int ?? 0) }
 }
}
