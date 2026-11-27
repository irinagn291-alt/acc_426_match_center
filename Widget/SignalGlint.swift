import SwiftUI
import WidgetKit
import ActivityKit

struct Fv8:TimelineEntry {var date:Date;var x:Rk4}
struct Wn3:TimelineProvider {
 func placeholder(in context:Context)->Fv8{Fv8(date:Date(),x:Rk4())}
 func getSnapshot(in context:Context,completion:@escaping(Fv8)->Void){completion(Fv8(date:Date(),x:Rk4.read()))}
 func getTimeline(in context:Context,completion:@escaping(Timeline<Fv8>)->Void){let now=Date();let d=Rk4.read();let midnight=Calendar.current.date(byAdding:.day,value:1,to:Calendar.current.startOfDay(for:now))!;completion(Timeline(entries:[Fv8(date:now,x:d),Fv8(date:midnight,x:d)],policy:.after(now.addingTimeInterval(1800))))}
}
struct Vw3:View {
 @Environment(\.widgetFamily) var family;let entry:Fv8
 let orange=Color(red:1,green:0.42,blue:0)
 var fav:[Zr7]{entry.x.matches.filter{Calendar.current.isDate($0.kickoff,inSameDayAs:entry.date) && $0.favourite(entry.x.favourites)}.sorted{if $0.running != $1.running{return $0.running};return $0.kickoff<$1.kickoff}}
 var body:some View{
  Group{switch family {
   case .accessoryCircular:VStack{Image(systemName:"soccerball");Text(fav.first?.score ?? "–").font(.caption2.bold())}
   case .accessoryInline:Text(fav.first.map{$0.home.name+" "+$0.score+" "+$0.away.name} ?? ql("No favourite match saved"))
   case .accessoryRectangular:if let m=fav.first{VStack(alignment:.leading){Text(m.home.name+" · "+m.away.name).font(.caption2.bold()).lineLimit(1);Text(m.score).font(.headline.monospacedDigit());Text(ql("Saved")+" "+m.observed.formatted(date:.omitted,time:.shortened)).font(.caption2)}}else{Label(ql("No favourite match saved"),systemImage:"soccerball").font(.caption)}
   default:main
  }}.containerBackground(for:.widget){Color(white:0.067)}.widgetURL(URL(string:"embermatch://matchday"))
 }
 private var main:some View{
  VStack(alignment:.leading,spacing:10){HStack{Image(systemName:"soccerball").foregroundStyle(orange);Text("MATCH CENTER").font(.system(size:10,weight:.heavy)).tracking(1.1);Spacer()}
   if family == .systemSmall {
    Text(ql("Favourite today")).font(.caption).foregroundStyle(.secondary)
    if let m=fav.first{Text(m.home.name).font(.caption.bold()).lineLimit(1);HStack{Text(m.score).font(.title.bold().monospacedDigit());Spacer()};Text(m.away.name).font(.caption.bold()).lineLimit(1);Text(m.status).font(.caption2).foregroundStyle(orange)}else{empty}
   }else{
    let all = family == .systemMedium ? entry.x.matches.filter{$0.running && Calendar.current.isDate($0.kickoff,inSameDayAs:entry.date)}.sorted{$0.kickoff<$1.kickoff}:entry.x.list(entry.date)
    HStack{Text(ql(family == .systemMedium ? "In progress":"Today's fixtures")).font(.headline);Spacer();if family == .systemLarge{Text(entry.x.league.isEmpty ? ql("All leagues"):entry.x.league).font(.caption2).foregroundStyle(orange)}}
    if all.isEmpty{empty}else{ForEach(Array(all.prefix(family == .systemMedium ? 3:7))){m in HStack{Text(m.home.name+" · "+m.away.name).lineLimit(1).font(.caption.weight(.semibold));Spacer();Text(m.score).font(.caption.bold().monospacedDigit()).foregroundStyle(orange)};if family == .systemLarge{Text(m.league+" · "+m.status).font(.caption2).foregroundStyle(.secondary)}};if all.count>7 && family == .systemLarge{Text(qf("%d more in app",all.count-7)).font(.caption2).foregroundStyle(orange)}}
   };Spacer(minLength:0)
   Text(ql("Saved cache")+(entry.x.stamp.map{" · "+$0.formatted(date:.abbreviated,time:.shortened)} ?? "")).font(.system(size:9)).foregroundStyle(.secondary).lineLimit(1)
  }.foregroundStyle(.white)
 }
 private var empty:some View{Text(ql("Open the app to save matches and choose favourites.")).font(.caption).foregroundStyle(.secondary).fixedSize(horizontal:false,vertical:true)}
}
struct Kg9:Widget {
 var body:some WidgetConfiguration{StaticConfiguration(kind:"CinderScoreCache",provider:Wn3()){Vw3(entry:$0)}.configurationDisplayName(ql("Match Center")).description(ql("Saved fixtures and favourite scores. No network required.")).supportedFamilies([.systemSmall,.systemMedium,.systemLarge,.accessoryCircular,.accessoryRectangular,.accessoryInline])}
}
struct La6:Widget {
 var body:some WidgetConfiguration{ActivityConfiguration(for:Xa3.self){context in
  VStack(alignment:.leading,spacing:10){HStack{Label(ql("Scheduled kickoff"),systemImage:"soccerball");Spacer();if context.isStale{Text(ql("Kickoff time reached"))}else{Text(timerInterval:Date.distantPast...context.state.kickoff,countsDown:true).monospacedDigit().frame(maxWidth:120)}}.font(.caption.bold());HStack{Text(context.attributes.home).bold();Spacer();Text("·");Spacer();Text(context.attributes.away).bold()}.font(.headline);Text(context.state.kickoff,style:.time).font(.caption)}.padding(18).activityBackgroundTint(Color(white:0.08)).activitySystemActionForegroundColor(.orange).widgetURL(URL(string:"embermatch://matchday"))
 } dynamicIsland:{context in DynamicIsland {
  DynamicIslandExpandedRegion(.leading){Text(context.attributes.home).font(.caption.bold()).lineLimit(2)}
  DynamicIslandExpandedRegion(.trailing){Text(context.attributes.away).font(.caption.bold()).lineLimit(2)}
  DynamicIslandExpandedRegion(.bottom){HStack{Text(ql("Scheduled kickoff"));Spacer();Text(timerInterval:Date.distantPast...context.state.kickoff,countsDown:true).monospacedDigit().frame(width:110)}.font(.caption).foregroundStyle(.orange)}
 }compactLeading:{Image(systemName:"soccerball").foregroundStyle(.orange)}compactTrailing:{Text(timerInterval:Date.distantPast...context.state.kickoff,countsDown:true).monospacedDigit().frame(width:64)}minimal:{Image(systemName:"soccerball").foregroundStyle(.orange)}.widgetURL(URL(string:"embermatch://matchday"))}
 }
}
@main struct Pk3:WidgetBundle{var body:some Widget{Kg9();La6()}}
