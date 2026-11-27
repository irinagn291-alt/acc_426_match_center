import SwiftUI
import UniformTypeIdentifiers

let oc7=Color(red:1,green:0.42,blue:0)
let bg7=Color(red:0.067,green:0.067,blue:0.067)
struct Uc8:View {
 @StateObject var z=Hx8.shared
 @State private var tab=0;@State private var day=Date();@State private var liveOnly=false;@State private var mode=0;@State private var add=false
 @Environment(\.scenePhase) var phase
 var body:some View {
  #if DEBUG
  if let screen = MatchGallery.index {
   gallery(screen)
  } else {
   tabs
  }
  #else
  tabs
  #endif
 }
 private var tabs:some View {
  TabView(selection:$tab){
   NavigationStack{feed}.tabItem{Label(ql("Matchday"),systemImage:"sportscourt.fill")}.tag(0)
   NavigationStack{calendar}.tabItem{Label(ql("Calendar"),systemImage:"calendar")}.tag(1)
   NavigationStack{stars}.tabItem{Label(ql("Favourites"),systemImage:"star.fill")}.tag(2)
   NavigationStack{Ct4().environmentObject(z)}.tabItem{Label(ql("Settings"),systemImage:"slider.horizontal.3")}.tag(3)
  }.tint(oc7).preferredColorScheme(.dark).environmentObject(z)
   .sheet(isPresented:$add){Ek5().environmentObject(z)}
   .task{await z.reconcile();await z.reminders()}
   .onChange(of:phase){_,p in if p == .active {Task{await z.reconcile();await z.reminders();if z.x.stamp != nil {_ = await z.refresh(day)}}}else if p == .background{Hx8.schedule()}}
   .onOpenURL{u in if u.scheme=="embermatch"{tab=0;if u.host=="calendar"{tab=1}}}
 }
 private var feed:some View {
  ScrollView{VStack(alignment:.leading,spacing:22){
   HStack(alignment:.top){VStack(alignment:.leading,spacing:5){Text(ql("YOUR FOOTBALL, IN FOCUS")).font(.caption2.weight(.bold)).tracking(2).foregroundStyle(oc7);Text(ql("Match Center")).font(.largeTitle.bold());Text(Date(),format:.dateTime.weekday(.wide).month(.wide).day()).font(.subheadline).foregroundStyle(.secondary)};Spacer();Button{add=true}label:{Image(systemName:"plus").font(.title3.bold()).frame(width:46,height:46).background(oc7,in:Circle()).foregroundStyle(.black)}.accessibilityLabel(ql("Add match")).accessibilityIdentifier("addMatch")}
   hero
   NavigationLink { FieldManual() } label: {
    HStack(spacing:14) {
     Image(systemName:"sportscourt.fill").font(.title2).foregroundStyle(.mint)
     VStack(alignment:.leading,spacing:4) { Text(ql("Tactics notebook")).font(.headline); Text(ql("Six passing patterns")).font(.caption).foregroundStyle(.secondary) }
     Spacer();Image(systemName:"arrow.up.right").foregroundStyle(.mint)
    }.padding(16).background(Color(red:0.04,green:0.19,blue:0.16),in:RoundedRectangle(cornerRadius:18))
   }.buttonStyle(.plain).accessibilityIdentifier("tactics")
   Picker(ql("View"),selection:$mode){Text(ql("Matches")).tag(0);Text(ql("Tables")).tag(1);Text(ql("Headlines")).tag(2)}.pickerStyle(.segmented)
   if mode==0 {filters;HStack{Text(ql("Today's fixtures")).font(.title2.bold());Spacer();Toggle(ql("In progress"),isOn:$liveOnly).toggleStyle(.button).font(.caption)};cards(z.x.list(Date(),live:liveOnly))}
   if mode==1 {Gt3().environmentObject(z)}
   if mode==2 {news}
  }.padding(20).frame(maxWidth:920).frame(maxWidth:.infinity)}.background(bg7).toolbar(.hidden,for:.navigationBar).refreshable{_ = await z.refresh()}
 }
 private var hero:some View {
  VStack(alignment:.leading,spacing:16){HStack{Label(ql("MATCHDAY DESK"),systemImage:"dot.radiowaves.left.and.right").font(.caption.weight(.bold)).tracking(1.6);Spacer();Image(systemName:"sportscourt").font(.system(size:44,weight:.thin)).rotationEffect(.degrees(-9))}
   HStack(alignment:.firstTextBaseline,spacing:8){Text("\(z.x.list(Date()).count)").font(.system(size:54,weight:.heavy,design:.rounded));Text(ql("matches saved today")).font(.headline);Spacer()}
   HStack{Label(ql("Delayed provider scores"),systemImage:"clock.arrow.circlepath").font(.caption.weight(.semibold));Spacer();if z.busy{ProgressView().tint(.black)}else{Button{Task{_ = await z.refresh()}}label:{Image(systemName:"arrow.clockwise").font(.headline)}.accessibilityLabel(ql("Refresh"))}}
  }.foregroundStyle(.black).padding(20).background(LinearGradient(colors:[oc7,Color(red:1,green:0.62,blue:0.22)],startPoint:.topLeading,endPoint:.bottomTrailing),in:RoundedRectangle(cornerRadius:26)).accessibilityElement(children:.contain)
 }
 private var filters:some View {
  VStack(alignment:.leading,spacing:10){HStack{Menu{Button(ql("All leagues")){z.x.league="";z.save()};ForEach(Array(Set(z.x.matches.map(\.league))).sorted(),id:\.self){l in Button(l){z.x.league=l;z.save()}}}label:{Label(z.x.league.isEmpty ? ql("All leagues"):z.x.league,systemImage:"line.3.horizontal.decrease").font(.subheadline.weight(.semibold))};Spacer();Toggle(ql("Favourites only"),isOn:Binding(get:{z.x.onlyStars},set:{z.x.onlyStars=$0;z.save()})).font(.caption).fixedSize()}
   if let d=z.x.stamp{Text(ql("Provider cache updated")+" "+d.formatted(date:.abbreviated,time:.shortened)).font(.caption2).foregroundStyle(.secondary)}
   if !z.notice.isEmpty{Text(z.notice).font(.caption).foregroundStyle(oc7).accessibilityIdentifier("notice")}
  }
 }
 private var calendar:some View {
  ScrollView{VStack(alignment:.leading,spacing:20){DatePicker(ql("Choose day"),selection:$day,displayedComponents:.date).datePickerStyle(.graphical).tint(oc7).padding(10).background(.white.opacity(0.04),in:RoundedRectangle(cornerRadius:20));filters;HStack{Text(day,format:.dateTime.day().month(.wide)).font(.title2.bold());Spacer();Button{add=true}label:{Label(ql("Add match"),systemImage:"plus")}};cards(z.x.list(day))}.padding(20).frame(maxWidth:920).frame(maxWidth:.infinity)}.background(bg7).navigationTitle(ql("Calendar")).toolbar{Button{Task{_ = await z.refresh(day)}}label:{Image(systemName:"arrow.clockwise")}.accessibilityLabel(ql("Refresh"))}.refreshable{_ = await z.refresh(day)}
 }
 @ViewBuilder private func cards(_ a:[Zr7])->some View {
  if a.isEmpty {VStack(spacing:14){Image(systemName:liveOnly ? "sportscourt":"calendar.badge.plus").font(.system(size:38)).foregroundStyle(oc7);Text(ql(liveOnly ? "No saved matches in progress":"Build your matchday")).font(.title3.bold());Text(ql("Record scores and events offline, or refresh to get published fixtures.")).font(.subheadline).foregroundStyle(.secondary).multilineTextAlignment(.center).frame(maxWidth:410);Button(ql("Create a match")){add=true}.buttonStyle(.borderedProminent).tint(oc7).foregroundStyle(.black).accessibilityIdentifier("emptyAdd")}.frame(maxWidth:.infinity).padding(.vertical,30).padding(.horizontal,15).background(.white.opacity(0.04),in:RoundedRectangle(cornerRadius:24))}
  else{LazyVGrid(columns:[GridItem(.adaptive(minimum:300),spacing:16)],spacing:16){ForEach(a){m in NavigationLink{Md8(id:m.id).environmentObject(z)}label:{Cr6(m:m)}.buttonStyle(.plain).accessibilityIdentifier("match-"+m.id)}}}
 }
 @State private var search=""
 private var stars:some View {
  List {
   Section{Text(ql("Choose teams for your personal feed, reminders and widgets.")).font(.subheadline).foregroundStyle(.secondary)}
   if !z.x.favourites.isEmpty {Section(ql("Your teams")){ForEach(z.x.teams.filter{z.x.favourites.contains($0.id)}){t in teamRow(t)}}}
   Section(ql("Team directory")){ForEach(z.x.teams.filter{search.isEmpty || $0.name.localizedCaseInsensitiveContains(search)}){t in teamRow(t)}}
  }.scrollContentBackground(.hidden).background(bg7).searchable(text:$search,prompt:ql("Search teams")).navigationTitle(ql("Favourites"))
 }
 private func teamRow(_ t:Nv2)->some View {HStack{TeamBadge(team:t).frame(width:38,height:42);Text(t.name).font(.headline);Spacer();Button{z.star(t)}label:{Image(systemName:z.x.favourites.contains(t.id) ? "star.fill":"star").foregroundStyle(oc7).frame(minWidth:44,minHeight:44)}.buttonStyle(.borderless).accessibilityLabel(ql(z.x.favourites.contains(t.id) ? "Remove favourite":"Add favourite")+" "+t.name).accessibilityIdentifier("star-"+t.id)}}
 private var news:some View {VStack(alignment:.leading,spacing:16){Text(ql("Feed headlines appear in the publisher's original language.")).font(.caption).foregroundStyle(.secondary);if z.x.news.isEmpty{Label(ql("Add your personal RSS feed in Settings."),systemImage:"newspaper").foregroundStyle(.secondary)};ForEach(z.x.news){n in if let u=URL(string:n.id),u.scheme=="https"{Link(destination:u){VStack(alignment:.leading,spacing:8){Text(n.title).font(.headline).foregroundStyle(.white);Text(n.source).font(.caption).foregroundStyle(oc7)}.frame(maxWidth:.infinity,alignment:.leading).padding(18).background(.white.opacity(0.05),in:RoundedRectangle(cornerRadius:18))}}};Button(ql("Refresh headlines")){Task{await z.rss()}}}.frame(maxWidth:.infinity,alignment:.leading)}
}
private struct TeamBadge: View {
 let team: Nv2
 private let palette = [Color.orange, .mint, .cyan, .pink, .yellow, .indigo]
 var body: some View {
  let colour = palette[team.id.utf8.reduce(0) { ($0 + Int($1)) % palette.count }]
  let initials = team.name.split(separator:" ").prefix(2).compactMap(\.first).map(String.init).joined()
  ZStack {
   Image(systemName:"shield.fill").resizable().scaledToFit().foregroundStyle(colour.opacity(0.25))
   Image(systemName:"shield").resizable().scaledToFit().foregroundStyle(colour)
   Text(initials).font(.system(size:12,weight:.black,design:.rounded)).foregroundStyle(colour)
  }.accessibilityHidden(true)
 }
}
struct Cr6:View {
 let m:Zr7
 var body:some View{VStack(alignment:.leading,spacing:17){HStack{Text(m.league).font(.caption.weight(.heavy)).tracking(1.1);Spacer();Text(m.status).font(.caption.weight(.semibold)).foregroundStyle(m.running ? oc7:.secondary)};HStack{VStack(alignment:.leading,spacing:12){Label(m.home.name,systemImage:"shield.fill");Label(m.away.name,systemImage:"shield.lefthalf.filled")}.font(.subheadline.weight(.semibold)).lineLimit(2);Spacer();VStack(spacing:8){Text(m.h.map(String.init) ?? "–");Text(m.a.map(String.init) ?? "–")}.font(.title2.bold().monospacedDigit())};Divider();HStack{Text(m.kickoff,style:.time);Spacer();Text(ql(m.local ? "Local entry":"Saved · delayed")).foregroundStyle(oc7)}.font(.caption)}.padding(18).background(Color(white:0.13),in:RoundedRectangle(cornerRadius:22)).overlay(RoundedRectangle(cornerRadius:22).stroke(.white.opacity(0.06))).accessibilityElement(children:.combine)}
}
struct Md8:View {
 @EnvironmentObject var z:Hx8;let id:String
 @State private var edit=false;@State private var event=false;@State private var deleting=false
 var m:Zr7? {z.x.matches.first{$0.id==id}}
 var body:some View {Group{if let m{ScrollView{VStack(alignment:.leading,spacing:22){
  VStack(spacing:16){Text(m.league).font(.caption.weight(.bold)).foregroundStyle(oc7);HStack(alignment:.center){side(m.home);Spacer();Text(m.score).font(.system(size:39,weight:.heavy,design:.rounded)).minimumScaleFactor(0.6).lineLimit(1);Spacer();side(m.away)};Text(m.status).font(.headline).foregroundStyle(oc7);Text(m.kickoff,format:.dateTime.day().month(.wide).hour().minute()).foregroundStyle(.secondary)}.padding(22).frame(maxWidth:.infinity).background(Color(white:0.14),in:RoundedRectangle(cornerRadius:26))
  VStack(alignment:.leading,spacing:6){Label(ql(m.local ? "Local entry":"OpenFootball"),systemImage:"internaldrive");Text(ql("Saved")+" "+m.observed.formatted(date:.abbreviated,time:.shortened));if !m.local{Text(ql("Scores may arrive later. Events appear when the source publishes them."))}}.font(.caption).foregroundStyle(.secondary)
  if m.upcoming {Button{Task{await z.live(m)}}label:{Label(ql("Start kickoff countdown"),systemImage:"timer")}.buttonStyle(.borderedProminent).tint(oc7).foregroundStyle(.black);Button(ql("Stop countdown")){Task{await z.stop(m.id)}}.font(.caption);Text(ql("Favourite the team first. Available within 8 hours of scheduled kickoff; no score updates through Live Activity.")).font(.caption).foregroundStyle(.secondary)}
  if !z.notice.isEmpty{Text(z.notice).font(.caption).foregroundStyle(oc7)}
  HStack{Text(ql("Match timeline")).font(.title2.bold());Spacer();if m.local{Button{event=true}label:{Image(systemName:"plus.circle.fill").font(.title2)}.accessibilityLabel(ql("Add event")).accessibilityIdentifier("addEvent")}}
  if m.events.isEmpty {Label(ql(m.local ? "Add goals, cards and key moments as they happen.":"No minute-by-minute events supplied for this match."),systemImage:"clock").font(.subheadline).foregroundStyle(.secondary).padding(.vertical,20)}
  ForEach(m.events){e in HStack(alignment:.top,spacing:15){Text("\(e.minute)′").font(.headline.monospacedDigit()).foregroundStyle(oc7).frame(width:46);VStack(alignment:.leading,spacing:5){Text(ql(e.kind)).font(.headline);Text((e.home ? m.home.name:m.away.name)+(e.person.isEmpty ? "":" · "+e.person)).font(.subheadline).foregroundStyle(.secondary)};Spacer();if m.local{Button(role:.destructive){z.removeEvent(id,e)}label:{Image(systemName:"trash")}.accessibilityLabel(ql("Delete event"))}}.padding(16).background(.white.opacity(0.04),in:RoundedRectangle(cornerRadius:16))}
  if m.local{Button(ql("Delete match"),role:.destructive){deleting=true}}else{Button(ql("Refresh match details")){Task{await z.detail(m)}}}
 }.padding(20).frame(maxWidth:850).frame(maxWidth:.infinity)}.background(bg7).toolbar{if m.local{Button(ql("Edit")){edit=true}.accessibilityIdentifier("editMatch")}}.sheet(isPresented:$edit){Ek5(existing:m).environmentObject(z)}.sheet(isPresented:$event){Ev4(match:m).environmentObject(z)}.confirmationDialog(ql("Delete this local match?"),isPresented:$deleting,titleVisibility:.visible){Button(ql("Delete match"),role:.destructive){z.remove(m)}}}else{ContentUnavailableView(ql("Match removed"),systemImage:"checkmark.circle")}}.navigationTitle(ql("Match details")).navigationBarTitleDisplayMode(.inline)}
 private func side(_ t:Nv2)->some View{VStack(spacing:8){TeamBadge(team:t).frame(width:46,height:52);Text(t.name).font(.subheadline.weight(.bold)).multilineTextAlignment(.center);Button{z.star(t)}label:{Image(systemName:z.x.favourites.contains(t.id) ? "star.fill":"star").frame(width:44,height:36)}.accessibilityLabel(ql("Toggle favourite")+" "+t.name)}.frame(maxWidth:170)}
}
struct Ek5:View {
 @EnvironmentObject var z:Hx8;@Environment(\.dismiss) var dismiss
 let existing:Zr7?
 @State var home="";@State var away="";@State var league="";@State var date=Date().addingTimeInterval(3600);@State var status="SCHEDULED";@State var h=0;@State var a=0
 init(existing:Zr7? = nil){self.existing=existing}
 var body:some View{NavigationStack{Form{Section(ql("Local match")){Text(ql("Your entries stay on this device and are labelled as local. No result is fetched automatically.")).font(.caption).foregroundStyle(.secondary);TextField(ql("Home team"),text:$home).accessibilityIdentifier("homeInput");TextField(ql("Away team"),text:$away).accessibilityIdentifier("awayInput");TextField(ql("League"),text:$league).accessibilityIdentifier("leagueInput");DatePicker(ql("Kickoff"),selection:$date)};Section(ql("Match state")){Picker(ql("Status"),selection:$status){ForEach(["SCHEDULED","IN_PLAY","PAUSED","FINISHED","POSTPONED","CANCELLED"],id:\.self){s in Text(ql(["SCHEDULED":"Scheduled","IN_PLAY":"In progress","PAUSED":"Half-time","FINISHED":"Finished","POSTPONED":"Postponed","CANCELLED":"Cancelled"][s]!)).tag(s)}}.accessibilityIdentifier("statusPicker");if !["SCHEDULED","POSTPONED","CANCELLED"].contains(status){Stepper(qf("Home goals: %d",h),value:$h,in:0...99);Stepper(qf("Away goals: %d",a),value:$a,in:0...99)}}}.navigationTitle(ql(existing==nil ? "Add match":"Edit match")).toolbar{ToolbarItem(placement:.cancellationAction){Button(ql("Cancel")){dismiss()}};ToolbarItem(placement:.confirmationAction){Button(ql("Save")){commit()}.disabled(!valid).accessibilityIdentifier("saveMatch")}}.onAppear{if let m=existing{home=m.home.name;away=m.away.name;league=m.league;date=m.kickoff;status=m.state;h=m.h ?? 0;a=m.a ?? 0}}}.tint(oc7)}
 var valid:Bool{!home.trimmingCharacters(in:.whitespaces).isEmpty && !away.trimmingCharacters(in:.whitespaces).isEmpty && home.trimmingCharacters(in:.whitespaces).lowercased() != away.trimmingCharacters(in:.whitespaces).lowercased() && !league.trimmingCharacters(in:.whitespaces).isEmpty}
 func commit(){func t(_ name:String)->Nv2{let s=name.trimmingCharacters(in:.whitespacesAndNewlines);return z.x.teams.first{$0.name.caseInsensitiveCompare(s) == .orderedSame} ?? Nv2(id:"local:"+UUID().uuidString,name:s)};let upcoming=["SCHEDULED","POSTPONED","CANCELLED"].contains(status);z.put(Zr7(id:existing?.id ?? "local:"+UUID().uuidString,home:t(home),away:t(away),league:league.trimmingCharacters(in:.whitespacesAndNewlines),kickoff:date,state:status,h:upcoming ? nil:h,a:upcoming ? nil:a,minute:existing?.minute,events:existing?.events ?? [],observed:Date(),local:true));dismiss()}
}
struct Ev4:View {
 @EnvironmentObject var z:Hx8;@Environment(\.dismiss) var dismiss;let match:Zr7
 @State private var minute=1;@State private var kind="Goal";@State private var home=true;@State private var person=""
 var body:some View{NavigationStack{Form{Stepper(qf("Minute: %d",minute),value:$minute,in:0...150);Picker(ql("Event"),selection:$kind){ForEach(["Goal","Card","Substitution","Key moment"],id:\.self){Text(ql($0)).tag($0)}};Picker(ql("Team"),selection:$home){Text(match.home.name).tag(true);Text(match.away.name).tag(false)};TextField(ql("Player or note (optional)"),text:$person);Text(ql("Adding or deleting a goal adjusts the local score.")).font(.caption).foregroundStyle(.secondary)}.navigationTitle(ql("Add event")).toolbar{ToolbarItem(placement:.cancellationAction){Button(ql("Cancel")){dismiss()}};ToolbarItem(placement:.confirmationAction){Button(ql("Save")){z.addEvent(match.id,Jh6(minute:minute,kind:kind,home:home,person:person));dismiss()}.accessibilityIdentifier("saveEvent")}}}.tint(oc7)}
}
struct Gt3:View {
 @EnvironmentObject var z:Hx8;@State private var code="BSA"
 let codes=["BSA","PL","BL1","FL1","PD","SA","PPL","DED","ELC"]
 init(code:String="BSA") { _code=State(initialValue:code) }
 var rows:[Tb9]{let local=z.x.localTable(code);return local.isEmpty ? z.x.tables[code] ?? []:local}
 var body:some View{VStack(alignment:.leading,spacing:16){Picker(ql("League"),selection:$code){ForEach(Array(Set(codes+z.x.matches.map(\.league))).sorted(),id:\.self){Text($0).tag($0)}}.pickerStyle(.menu);HStack{Text(ql(z.x.localTable(code).isEmpty ? "Provider standings":"Table from your finished local matches")).font(.caption).foregroundStyle(.secondary);Spacer();Button(ql("Refresh")){Task{await z.table(code)}}.disabled(!codes.contains(code)||z.busy)};if let d=z.x.tableDates[code],z.x.localTable(code).isEmpty{Text(d,format:.dateTime.day().month().hour().minute()).font(.caption2).foregroundStyle(.secondary)};if !z.notice.isEmpty{Text(z.notice).font(.caption).foregroundStyle(oc7)};HStack{Text(ql("Team"));Spacer();Text(ql("P"));Text(ql("GD")).frame(width:40);Text(ql("Pts")).frame(width:35)}.font(.caption).foregroundStyle(.secondary);if rows.isEmpty{Text(ql("No saved table. Refresh a supported league, or finish a local match to calculate standings.")).foregroundStyle(.secondary).font(.subheadline)};ForEach(Array(rows.enumerated()),id:\.element.id){i,r in HStack{Text("\(i+1)").foregroundStyle(oc7).frame(width:24);Text(r.name).font(.subheadline.weight(.semibold));Spacer();Text("\(r.played)");Text("\(r.gf-r.ga)").frame(width:40);Text("\(r.points)").bold().frame(width:35)}.font(.subheadline.monospacedDigit()).padding(.vertical,10);Divider()};Text(ql("P: played · GD: goal difference · Pts: points")).font(.caption2).foregroundStyle(.secondary)}}
}
struct Ct4:View {
 @EnvironmentObject var z:Hx8
 @State private var feed="";@State private var saved=false;@State private var importing=false;@State private var erase=false;@State private var export:URL?
 @State private var alerts=false;@State private var morning=false;@State private var evening=false
 var body:some View {Form{
  Section(ql("Data connection")){Link("OpenFootball · CC0",destination:URL(string:"https://github.com/openfootball/football.json")!)}
  Section(ql("Personal headlines")){TextField(ql("HTTPS RSS feed address"),text:$feed).keyboardType(.URL).textInputAutocapitalization(.never).autocorrectionDisabled();Text(ql("Add a feed you are permitted to read for personal use. Only headlines and links are cached; article text and images are not downloaded.")).font(.caption).foregroundStyle(.secondary);Button(ql("Save and refresh feed")){z.feed=feed;Task{await z.rss()}}}
  Section(ql("Notifications")){Text(ql("Start reminders follow saved kickoff times. Score and start changes are announced only after data refresh. iOS chooses background timing; instant alerts are not available.")).font(.caption).foregroundStyle(.secondary);Text(ql("Digests cover the next 7 days and renew when you open the app.")).font(.caption).foregroundStyle(.secondary);Button(ql("Enable notifications")){Task{await z.allow()}};if !z.permission.isEmpty{Text(z.permission).font(.caption).foregroundStyle(oc7)};Toggle(ql("Favourite match alerts"),isOn:$alerts).onChange(of:alerts){_,v in z.alerts=v};Toggle(ql("Morning digest · 08:00"),isOn:$morning).onChange(of:morning){_,v in z.morning=v};Toggle(ql("Evening digest · 20:00"),isOn:$evening).onChange(of:evening){_,v in z.evening=v};Link(ql("System notification settings"),destination:URL(string:UIApplication.openSettingsURLString)!)}
  Section(ql("Widgets")){Text(ql("Small: favourite team today. Medium: saved matches in progress. Large: today's saved fixtures, using your league and favourite filters. Lock Screen: favourite score. Widgets read local cache and never request the network.")).font(.caption).foregroundStyle(.secondary);Text(ql("Add Match Center from the Home Screen widget gallery. Change the league and favourite filters on Matchday to update the large widget.")).font(.caption).foregroundStyle(.secondary)}
  Section(ql("Your data")){Button(ql("Import matchbook")){importing=true};Button(ql("Prepare export")){export=z.exportURL()};if let export{ShareLink(ql("Share matchbook"),item:export)};Button(ql("Delete all local data"),role:.destructive){erase=true};Text(ql("Your favourites and matchbook stay on your device. Refreshing connects directly to the fixture source or your RSS publisher and shares your IP address with them. No account is required.")).font(.caption).foregroundStyle(.secondary)}
  if !z.notice.isEmpty{Section{Text(z.notice).foregroundStyle(oc7)}}
  Section{Text("Match Center · 1.3.1 (17)").font(.caption).foregroundStyle(.secondary);Text(ql("All times use your device's time zone.")).font(.caption).foregroundStyle(.secondary)}
 }.navigationTitle(ql("Settings")).scrollContentBackground(.hidden).background(bg7).onAppear{feed=z.feed;alerts=z.alerts;morning=z.morning;evening=z.evening}.fileImporter(isPresented:$importing,allowedContentTypes:[.json]){r in if case .success(let u)=r{z.importFile(u)}}.confirmationDialog(ql("Permanently delete saved matches, favourites and connection settings?"),isPresented:$erase,titleVisibility:.visible){Button(ql("Delete all local data"),role:.destructive){Task{await z.erase();feed="";alerts=false;morning=false;evening=false}}}}
}

#if DEBUG
private enum MatchGallery {
    static let index: Int? = {
        let process = ProcessInfo.processInfo
        let args = process.arguments
        guard args.contains("-AppStoreScreenshots") || process.environment["APPSTORE_SCREENSHOTS"] == "1" else { return nil }
        if let position=args.firstIndex(of:"-AppStoreScreenshotScreen"), args.indices.contains(position+1) {
            return Int(args[position+1])
        }
        return Int(process.environment["APPSTORE_SCREENSHOT_SCREEN"] ?? "0")
    }()
    static let league = "Harbour Cup"
    static func matchbook() -> Rk4 {
        let names=["Northbank United","Port Athletic","Dockside Rovers","Orchard Town","West Vale","Mill Lane"]
        let teams=names.enumerated().map {Nv2(id:"gallery-team-\($0.offset)",name:$0.element)}
        let day=Calendar.current.startOfDay(for:Date())
        var book=Rk4()
        book.teams=teams + Nv2.seed; book.favourites=[teams[0].id,teams[1].id,teams[4].id]
        let calendar=Calendar.current
        let pairs=[(0,1),(2,3),(4,5),(1,3),(4,0),(2,5),(0,2),(1,4),(3,5),(2,4),(5,1),(3,0)]
        for (index, pair) in pairs.enumerated() {
            let days = index < 3 ? 0 : -(index / 3)
            let kickoff=calendar.date(byAdding:.hour,value:11+index%3*3,to:calendar.date(byAdding:.day,value:days,to:day)!)!
            let finished=index != 2
            let homeGoals=index == 0 ? 2 : (index+1)%4
            let awayGoals=index == 0 ? 1 : (index+2)%3
            var events:[Jh6]=[]
            if index==0 {
                events = [Jh6(minute:12,kind:"Goal",home:true,person:"A. Morgan"),
                          Jh6(minute:31,kind:"Card",home:false,person:"F. Evans"),
                          Jh6(minute:48,kind:"Goal",home:false,person:"L. Reid"),
                          Jh6(minute:71,kind:"Substitution",home:true,person:"E. Blake"),
                          Jh6(minute:84,kind:"Goal",home:true,person:"M. Ellis")]
            }
            book.matches.append(Zr7(id:"local:gallery-\(index)",home:teams[pair.0],away:teams[pair.1],league:league,
                kickoff:kickoff,state:finished ? "FINISHED":"SCHEDULED",h:finished ? homeGoals:nil,a:finished ? awayGoals:nil,
                minute:nil,events:events,observed:kickoff,local:true))
        }
        return book
    }
}
extension Uc8 {
    @ViewBuilder fileprivate func gallery(_ screen: Int) -> some View {
        NavigationStack {
            switch screen {
            case 1: Md8(id:"local:gallery-0")
            case 2: ScrollView {
                VStack(alignment:.leading,spacing:20) {
                    Text(ql("Tables")).font(.largeTitle.bold()); Gt3(code:MatchGallery.league)
                }.padding(20).frame(maxWidth:760).frame(maxWidth:.infinity)
            }.background(bg7)
            case 3: calendar.navigationBarTitleDisplayMode(.inline)
            case 4: stars.navigationBarTitleDisplayMode(.inline)
            case 5: FieldManual()
            default: feed
            }
        }
        .environmentObject(z).tint(oc7).preferredColorScheme(.dark)
        .onAppear { z.x=MatchGallery.matchbook() }
    }
}
#endif
