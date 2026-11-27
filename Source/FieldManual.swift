import SwiftUI

struct Pattern: Identifiable {
    var id: String { title }
    let title: String
    let shape: String
    let rows: [Int]
    let route: [Int]
    let notes: [String]
    static let library = [
        Pattern(title: "Switch the play", shape: "4–3–3", rows: [4,3,3], route: [1,6,4,10],
                notes: ["The full-back draws pressure towards the near touchline. The holding midfielder opens a passing lane behind the first presser.", "The pivot receives side-on and moves the ball across the midfield before the block can slide.", "The far-side full-back finds the winger wide. Drive forward while the opposing full-back is still recovering."]),
        Pattern(title: "Third-player run", shape: "4–2–3–1", rows: [4,2,3,1], route: [5,8,7,10],
                notes: ["A deeper midfielder plays into the attacking midfielder between the lines.", "The receiver sets the ball back first time. A teammate arriving from the blind side can now face forward.", "The runner releases the striker into the channel before the centre-backs can step across."]),
        Pattern(title: "Overlap on the flank", shape: "4–4–2", rows: [4,4,2], route: [4,8,4,10],
                notes: ["The full-back passes ahead to the wide midfielder and continues up the touchline.", "The wide midfielder waits for the defender to turn inward, then releases the overlapping full-back into space.", "Look back towards the penalty spot for a cutback. The second striker holds a different finishing lane."]),
        Pattern(title: "Play through pressure", shape: "3–4–2–1", rows: [3,4,2,1], route: [0,2,6,9],
                notes: ["The goalkeeper attracts the first forward before finding the free centre-back.", "The outside midfielder stays wide. Pass beyond the pressing forward while the inside passing lane remains protected.", "The attacking midfielder checks into the space behind the press, ready to receive on the turn."]),
        Pattern(title: "Counter from a regain", shape: "4–1–4–1", rows: [4,1,4,1], route: [5,7,9,10],
                notes: ["The holding midfielder secures the loose ball and looks forward before taking a second touch.", "The central runner feeds the wide player early, stretching the retreating defence.", "A diagonal pass across the last defender finds the striker. Support underneath if the forward pass closes."]),
        Pattern(title: "Escape the touchline", shape: "3–5–2", rows: [3,5,2], route: [4,2,6,8],
                notes: ["When the wing-back meets a double team, recycle the ball to the outside centre-back.", "The central midfielder offers a diagonal angle outside the opponent's cover shadow.", "Use the opposite wing-back as an outlet. Keep the ball travelling faster than the defending block."])
    ]
}

struct PatternPitch: View {
    let pattern: Pattern
    let step: Int

    var body: some View {
        Canvas { context, size in
            let field = CGRect(origin: .zero, size: size).insetBy(dx: 12, dy: 12)
            let stripe = field.width / 10
            for n in 0..<10 where n.isMultiple(of: 2) {
                context.fill(Path(CGRect(x: field.minX + CGFloat(n)*stripe, y: field.minY, width: stripe, height: field.height)), with: .color(.white.opacity(0.035)))
            }
            func point(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
                CGPoint(x: field.minX + field.width*x, y: field.minY + field.height*y)
            }
            var paint = Path()
            paint.addRect(field)
            paint.move(to: point(0.5,0)); paint.addLine(to: point(0.5,1))
            let radius = min(field.height, field.width)*0.155
            paint.addEllipse(in: CGRect(x: field.midX-radius, y: field.midY-radius, width: radius*2, height: radius*2))
            for x in [CGFloat(0), 0.85] {
                paint.addRect(CGRect(origin: point(x,0.24), size: CGSize(width: field.width*0.15, height: field.height*0.52)))
            }
            context.stroke(paint, with: .color(.white.opacity(0.38)), lineWidth: 1)
            var positions = [point(0.065, 0.5)]
            for (line, count) in pattern.rows.enumerated() {
                let x = CGFloat(0.24) + 0.64*CGFloat(line)/CGFloat(pattern.rows.count-1)
                for player in 0..<count {
                    positions.append(point(x, CGFloat(player+1)/CGFloat(count+1)))
                }
            }
            let from = pattern.route[step], to = pattern.route[step+1]
            let a = positions[from], b = positions[to]
            var pass = Path(); pass.move(to: a); pass.addLine(to: b)
            context.stroke(pass, with: .color(.yellow), style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [6,5]))
            let angle = atan2(b.y-a.y, b.x-a.x)
            let tip = CGPoint(x:b.x-14*cos(angle),y:b.y-14*sin(angle))
            var head = Path(); head.move(to:CGPoint(x:tip.x-7*cos(angle-0.55),y:tip.y-7*sin(angle-0.55))); head.addLine(to:tip); head.addLine(to:CGPoint(x:tip.x-7*cos(angle+0.55),y:tip.y-7*sin(angle+0.55)))
            context.stroke(head,with:.color(.yellow),lineWidth:3)
            for (i, pos) in positions.enumerated() {
                let active = i == from || i == to
                let radius: CGFloat = active ? 10 : 8
                let rect = CGRect(x:pos.x-radius, y:pos.y-radius, width:radius*2,height:radius*2)
                context.fill(Path(ellipseIn:rect),with:.color(active ? .yellow : .white.opacity(0.93)))
                context.draw(Text(String(i+1)).font(.system(size: active ? 10:9, weight:.black,design:.rounded)).foregroundStyle(.black),at:pos)
            }
        }
        .aspectRatio(1.64, contentMode: .fit)
        .background(Color(red:0.04,green:0.31,blue:0.24),in:RoundedRectangle(cornerRadius:16))
        .accessibilityLabel(ql("Pass") + " " + String(pattern.route[step]+1) + " → " + String(pattern.route[step+1]+1))
    }
}

struct FieldManual: View {
    @State var selection = 0
    @State private var step = 0
    private var pattern: Pattern { Pattern.library[selection] }
    var body: some View {
        ScrollView {
            VStack(alignment:.leading,spacing:20) {
                HStack {
                    Label(ql("Tactics notebook"),systemImage:"sportscourt")
                        .font(.caption.bold()).textCase(.uppercase).tracking(1)
                    Spacer(); Text(pattern.shape).font(.headline.monospacedDigit())
                }.foregroundStyle(.mint)
                Text(ql(pattern.title)).font(.system(.largeTitle,design:.rounded,weight:.heavy))
                PatternPitch(pattern:pattern,step:step)
                Picker(ql("Pass"),selection:$step) {
                    ForEach(0..<3) { n in Text(ql("Pass") + " " + String(n+1)).tag(n) }
                }.pickerStyle(.segmented).accessibilityIdentifier("phaseControl")
                Text(ql(pattern.notes[step])).font(.body).lineSpacing(4)
                    .frame(maxWidth:.infinity,alignment:.leading)
                    .padding().background(Color.white.opacity(0.065),in:RoundedRectangle(cornerRadius:16))
                Text(ql("Play library")).font(.title3.bold()).padding(.top,4)
                LazyVGrid(columns:[GridItem(.adaptive(minimum:160),spacing:12)],spacing:12) {
                    ForEach(Array(Pattern.library.enumerated()),id:\.element.id) { n, item in
                        Button {
                            selection=n; step=0
                        } label: {
                            VStack(alignment:.leading,spacing:6) {
                                HStack { Text(item.shape).font(.caption.monospacedDigit()); Spacer()
                                    if n==selection {Image(systemName:"checkmark.circle.fill")} }
                                    .foregroundStyle(.mint)
                                Text(ql(item.title)).font(.subheadline.bold()).multilineTextAlignment(.leading)
                            }.padding(13).frame(maxWidth:.infinity,alignment:.leading)
                                .background(Color.white.opacity(n==selection ? 0.15:0.07),in:RoundedRectangle(cornerRadius:14))
                        }.buttonStyle(.plain).accessibilityIdentifier("play-" + String(n))
                    }
                }
            }.padding(20).frame(maxWidth:760).frame(maxWidth:.infinity)
        }.background(bg7).navigationTitle(ql("Tactics notebook")).navigationBarTitleDisplayMode(.inline)
    }
}
