//
//  ContentView.swift
//  Tree
//
//  Created by Connor McClanahan on 12/12/2023.
import SwiftUI
import UIKit
import WebKit

extension Color {
    static let timelineBackground = Color(red: 1.0, green: 0.992, blue: 0.941) // Hex #FFFDF0
}
extension Font {
    static let timelineTitle = Font.custom("YourFontName", size: 28) // Replace with your actual font name and size
    static let contentText = Font.system(size: 36, weight: .black) // Black font with the same size and weight
}

struct FullScreenImageView: View {
    @Binding var isPresented: Bool

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Image("Finish")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        self.isPresented = false
                    }
                Button("Back") {
                    self.isPresented = false
                }
                .font(.title)
                .padding()
                .cornerRadius(10)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}



struct RippleEffectView: UIViewRepresentable {
    var referenceFrame: CGRect

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: referenceFrame)
        addRippleEffect(to: view)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) { }

    private func addRippleEffect(to referenceView: UIView) {
        let rippleShape = CAShapeLayer()
        rippleShape.bounds = referenceView.bounds
        rippleShape.position = CGPoint(x: referenceView.bounds.midX, y: referenceView.bounds.midY)
        rippleShape.path = UIBezierPath(ovalIn: referenceView.bounds).cgPath
        rippleShape.fillColor = UIColor.clear.cgColor
        rippleShape.strokeColor = UIColor.blue.cgColor
        rippleShape.lineWidth = 4
        rippleShape.opacity = 0

        let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        scaleAnim.toValue = NSValue(caTransform3D: CATransform3DMakeScale(2, 2, 1))

        let opacityAnim = CABasicAnimation(keyPath: "opacity")
        opacityAnim.fromValue = 1
        opacityAnim.toValue = 0

        let animation = CAAnimationGroup()
        animation.animations = [scaleAnim, opacityAnim]
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.duration = CFTimeInterval(0.7)
        animation.repeatCount = Float.infinity
        animation.isRemovedOnCompletion = false

        rippleShape.add(animation, forKey: "rippleEffect")
        referenceView.layer.addSublayer(rippleShape)
    }
}

struct InfoBoxView: View {
    @Binding var showInfoBox: Bool // Binding to control the visibility of the info box
    
    var body: some View {
        VStack(alignment: .center) { // Center the content vertically
            HStack {
                Spacer()
                Button(action: {
                    // Hide the info box when the close button is tapped
                    withAnimation {
                        showInfoBox = false
                    }
                }) {
                    Text("X") // Close button
                        .foregroundColor(.black)
                        .font(.title)
                        .padding(.trailing)
                }
            }
            
            Text("Extend the Olive Branch")
                .font(.title)
                .fontWeight(.bold)
                .padding([.leading, .trailing]) // Adjusted padding
                .cornerRadius(10)
                .padding(.bottom, 10) // Added padding to separate from the next text

            Text("Click the olive to start learning")
                .font(.body)
                .padding([.leading, .trailing])
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.timelineBackground.opacity(0.9)) // Slightly darker shade
        .cornerRadius(10)
        .padding(10)
        .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 3) // Customize the shadow
        .position(CGPoint(x: 195, y: 100))
        .onTapGesture {
            // Hide the info box when tapped
            withAnimation {
                showInfoBox = false
            }
        }
    }
}
struct OliveKeyView: View {
    @Binding var greenOliveCounter: Int
    @Binding var blackOliveCounter: Int
    @Binding var brownOliveCounter: Int
    @Binding var yellowOliveCounter: Int

    var body: some View {
        HStack(spacing: 20) {
            OliveCounterView(color: "Greenolive", counter: $greenOliveCounter)
            OliveCounterView(color: "Blackolive", counter: $blackOliveCounter)
            OliveCounterView(color: "Brownolive", counter: $brownOliveCounter)
            OliveCounterView(color: "Olive", counter: $yellowOliveCounter)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.timelineBackground)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}


struct OliveCounterView: View {
    let color: String
    @Binding var counter: Int

    var body: some View {
        Button(action: {
            // Decrement the counter when the olive is tapped
            if self.counter > 0 {
                self.counter -= 1
            }
        }) {
            Image(color)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .overlay(
                    Text("\(String(format: "%02d", counter))")
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding(4),
                    alignment: .bottomTrailing
                )
        }
        .buttonStyle(PlainButtonStyle()) // Removes button-like interaction styles
    }
}

struct OliveKeyItem: View {
    let color: String
    let label: String
    @Binding var counter: Int // Bind to the counter state
    
    var body: some View {
        VStack {
            Image(color) // Use the string as the image name
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .onTapGesture {
                    // Only decrement counter if it's greater than 0
                    if counter > 0 {
                        counter -= 1
                    }
                }
            
            Text(label)
                .font(.caption)
                .foregroundColor(.black)
            
            // Display the counter value
            Text("\(String(format: "%02d", counter))")
                .font(.caption)
                .foregroundColor(.black)
        }
    }
}
struct TitleWithLinesView: View {
    var body: some View {
        VStack {
            Text("The")
                .font(.system(size: 10, weight: .semibold))
            HStack {
                Line()
                Spacer(minLength: 0)
                Text("Timeline")
                    .font(.system(size: 36, weight: .black)) // SF Pro Black
                Line()
            }
        }
    }
    
    struct Line: View {
        var body: some View {
            Rectangle()
                .frame(height: 2)
                .foregroundColor(Color(hex: "4B7F52")) // Custom green color
                .frame(maxWidth: 110)
        }
    }
}
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}

extension View {
    func flexible() -> some View {
        self.frame(maxWidth: .infinity)
    }
}
struct TreeView: View {
    @State private var showInfoBox = true
      @State private var nodePosition: CGFloat = 0 // Single y-offset for the node
      @State private var showDetailView = false
    @State private var leafPosition: CGFloat = 0 // State for leaf's falling animation
    @State private var greenOliveCounter: Int = 0
       @State private var blackOliveCounter: Int = 0
       @State private var brownOliveCounter: Int = 0
       @State private var yellowOliveCounter: Int = 1
    @State private var ripplePosition: CGPoint = CGPoint(x: 62, y: 100) // Start with a fixed position for testing
        @State private var rippleActive = false
    @Binding var showFullScreenImage: Bool

      let growthStage: Int



    var body: some View {
        NavigationView {
            VStack {
                TitleWithLinesView()// Your custom title view with lines
                ZStack {
                    // Trunk
                    Rectangle()
                        .fill(Color.brown)
                        .frame(width: 10, height: 600)
                        .cornerRadius(5)
                        .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 150 / 2)
                    
                    if growthStage >= 0 {
                        // Branch
                        Path { path in
                            let branchStartY = UIScreen.main.bounds.height - 220 - 60
                            let branchEndY = branchStartY - 60
                            
                            path.move(to: CGPoint(x: UIScreen.main.bounds.width / 2, y: branchStartY))
                            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width / 2 + 60, y: branchEndY))
                        }
                        .stroke(Color.brown, lineWidth: 4)
                    }
                    
                    // Leaf with falling animation
                    Image("Leaf") // Replace "Leaf" with the name of your leaf image in assets
                        .resizable()
                        .frame(width: 55.5/2.3, height: 228.5/2.3)
                    
                        .position(x: UIScreen.main.bounds.width / 2 + 75, y: UIScreen.main.bounds.height - 330 + leafPosition)
                        .rotationEffect(.degrees(30)) // Rotates the image by 30 degrees
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 1)) {
                                leafPosition += 300 // Move the leaf down
                            }
                        }
                    // Olive with falling animation
                                Image("Olive")
                                    .resizable()
                                    .frame(width: 129/2.3, height: 176/2.3)
                                    .position(x: UIScreen.main.bounds.width / 2 + 60, y: UIScreen.main.bounds.height - 310 + nodePosition)
                                    .shadow(radius: 3, x: 5, y: 0)
                                    .onTapGesture {
                                        withAnimation(.easeIn(duration: 1)) {
                                            nodePosition += 300 // Move the node down
                                            ripplePosition = CGPoint(x: UIScreen.main.bounds.width / 2 + 60, y: UIScreen.main.bounds.height - 310 + nodePosition)
                                            rippleActive = true
                                        }
                                        // Trigger the navigation after the node falls
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            showDetailView = true
                                        }
                                    }
                    

                          // Navigation Link for DetailsView
                          if showDetailView {
                              NavigationLink("", destination: DetailsView(onDismiss: {
                                  showDetailView = false
                              }), isActive: $showDetailView)
                          }
                      }
                  }
            .background(Color.timelineBackground)
            .overlay(
                Group {
                    if showInfoBox {
                        InfoBoxView(showInfoBox: $showInfoBox)
                            .transition(.move(edge: .leading))
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    withAnimation {
                                        showInfoBox = false
                                    }
                                }
                            }
                    }
                }
            )
        }
    }
}
struct ContentView: View {
    @State private var treeGrowthStage = 0
    @State private var showFullScreenImage = false

    var body: some View {
        NavigationView {
            ZStack {
                TreeView(showFullScreenImage: $showFullScreenImage, growthStage: treeGrowthStage)
                
                // Navigation to FullScreenImageView
                if showFullScreenImage {
                    FullScreenImageView(isPresented: $showFullScreenImage)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .navigationBarHidden(true)
        }
        .background(Color.timelineBackground)
    }
}

struct OliveFallingView: View {
    @Binding var animationCompleted: Bool
    
    var body: some View {
        VStack {
            Text("Olives Falling")
                .font(.system(size: 36, weight: .black))
                .padding(.bottom, 5)
            // Add your olive falling animation here
            
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    self.animationCompleted = true
                }
            }
        }
    }
}
struct TitleView: View {
    var body: some View {
        HStack {
            Line()
            Text("The")
                .font(.system(size: 10, weight: .semibold))
            Text("Timeline")
                .font(Font.timelineTitle)
            Line()
        }
    }
}

struct Line: View {
    var body: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity) // This should be replaced with a method that makes the line flexible
    }
}
struct Olive {
    var imageName: String
    var position: CGPoint
}

struct LargerTreeView: View {
    
    @State private var trunkHeight: CGFloat = 0
    @State private var branchLengths: [CGFloat] = [0, 0, 0, 0, 0]
    @State private var nodePositions: [CGFloat] = [0, 0, 0] // Store y-offsets for each node
    @State private var showBranches = false
    @State private var showDetailView = false
    @State private var selectedNodeIndex: Int?
    @State private var leafPosition: CGFloat = 0 // State for leaf's falling animation
    @State private var navigateAfterFall: [Bool] = Array(repeating: false, count: 4)
    
    @State private var showDetailViewForOlive: [Bool] = [false, false, false] // Add this state to control navigation for each olive
    @State private var greenOliveCounter: Int = 1
    @State private var blackOliveCounter: Int = 1
    @State private var brownOliveCounter: Int = 1
    @State private var yellowOliveCounter: Int = 1
    
    // Define a struct to hold information about each olive
    struct OliveData {
         let imageName: String
         var position: CGPoint
         var counter: Int
         var isFallen: Bool = false
     }
    // State for each olive's data, including the image name and position
    @State private var olives: [OliveData] = [
        OliveData(imageName: "Olive", position: CGPoint(x: 270, y: 526),counter: 1),
        OliveData(imageName: "Brownolive", position: CGPoint(x: 300, y: 195),counter: 1),
        OliveData(imageName: "Blackolive", position: CGPoint(x: 150, y: 175),counter: 1),
        OliveData(imageName: "Greenolive", position: CGPoint(x: 250, y: 370),counter: 1),
        // Add more olives with different images and positions as needed
    ]


    // Vertical offsets for the falling animation
    @State private var oliveOffsets: [CGFloat] = [0, 0, 0, 0] // Add an entry for each olive

    var body: some View {
        VStack {
            TitleWithLinesView()// Your custom title view with lines
            OliveKeyView(
                greenOliveCounter: $greenOliveCounter,
                blackOliveCounter: $blackOliveCounter,
                brownOliveCounter: $brownOliveCounter,
                yellowOliveCounter: $yellowOliveCounter
            )
            ZStack {
                // Animated Larger Trunk
                Rectangle()
                    .fill(Color.brown)
                    .frame(width: 20, height: trunkHeight)
                    .cornerRadius(5)
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 410 + (600 - trunkHeight) / 2)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.5)) {
                            trunkHeight = 600
                        }
                    }
                
                // Conditional rendering of branches
                if showBranches {
                    ForEach(0..<5, id: \.self) { index in
                        Group {
                            // Left side branch
                            Path { path in
                                let yOffset = CGFloat(800 - index * 160)
                                let length = branchLengths[index]
                                path.move(to: CGPoint(x: UIScreen.main.bounds.width / 2, y: yOffset))
                                path.addLine(to: CGPoint(x: UIScreen.main.bounds.width / 2 - length, y: yOffset - 30))
                            }
                            .stroke(Color.brown, lineWidth: 4)
                            
                            // Right side branch
                            Path { path in
                                let yOffset = CGFloat(840 - index * 160)
                                let length = branchLengths[index]
                                path.move(to: CGPoint(x: UIScreen.main.bounds.width / 2, y: yOffset))
                                path.addLine(to: CGPoint(x: UIScreen.main.bounds.width / 2 + length, y: yOffset - 30))
                            }
                            .stroke(Color.brown, lineWidth: 4)
                        }
                    }
                }
                
                // FINSIHED Leaf with falling animation
                Image("Leaf") // Replace "Leaf" with the name of your leaf image in assets
                    .resizable()
                    .frame(width: 55.5/2.3, height: 228.5/2.3)
                    .shadow(radius: 3, x: 5, y: 0)
                    .position(x: UIScreen.main.bounds.width - 350, y: UIScreen.main.bounds.height - 600 + leafPosition)
                    .rotationEffect(.degrees(30)) // Rotates the image by 30 degrees
                    .onTapGesture {
                        withAnimation(.easeIn(duration: 1)) {
                            leafPosition += 300 // Move the leaf down
                        }
                    }
                // FINISHED Leaf with falling animation
                Image("Leaf") // Replace "Leaf" with the name of your leaf image in assets
                    .resizable()
                    .frame(width: 55.5/2.3, height: 228.5/2.3)
                    .shadow(radius: 3, x: 5, y: 0)
                    .position(x: UIScreen.main.bounds.width - 250, y: UIScreen.main.bounds.height - 470 + leafPosition)
                    .rotationEffect(.degrees(30)) // Rotates the image by 30 degrees
                    .onTapGesture {
                        withAnimation(.easeIn(duration: 1)) {
                            leafPosition += 300 // Move the leaf down
                        }
                    }
                // FINISHED Leaf with falling animation
                Image("Leaf") // Replace "Leaf" with the name of your leaf image in assets
                    .resizable()
                    .frame(width: 55.5/2.3, height: 228.5/2.3)
                    .shadow(radius: 3, x: 5, y: 0)
                    .position(x: UIScreen.main.bounds.width - 120, y: UIScreen.main.bounds.height - 420 + leafPosition)
                    .rotationEffect(.degrees(-30)) // Rotates the image by 30 degrees
                    .onTapGesture {
                        withAnimation(.easeIn(duration: 1)) {
                            leafPosition += 300 // Move the leaf down
                        }
                    }
                ForEach(0..<olives.count, id: \.self) { index in
                    Image(olives[index].imageName)
                        .resizable()
                        .frame(width: 129/2.3, height: 176/2.3)
                        .offset(x: 0, y: oliveOffsets[index])
                        .position(olives[index].position)
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 1)) {
                                oliveOffsets[index] += 500 // Olive falls
                                decrementCounter(for: olives[index].imageName)
                                if allCountersZero() {
                                    self.showDetailView = true
                                }
                            }
                        }
                }
            }
            
            // Place this outside of your ForEach, but still within the ZStack.
            if showDetailView {
                NavigationLink(
                    destination: DetailsView2(onDismiss: { self.showDetailView = false }),
                    isActive: $showDetailView
                ) { EmptyView() }
                    .hidden()
            }
        }
        .background(Color.timelineBackground.opacity(0.7))
        .navigationBarBackButtonHidden(true)
        .onAppear {
            animateBranches()
        }
        
    }
        // Add this function outside of your ForEach but inside the LargerTreeView struct
        private func allCountersZero() -> Bool {
            return greenOliveCounter == 0 && blackOliveCounter == 0 && brownOliveCounter == 0 && yellowOliveCounter == 0
        }
    private func decrementCounter(for oliveName: String) {
        switch oliveName {
        case "Greenolive":
            greenOliveCounter -= 1
        case "Blackolive":
            blackOliveCounter -= 1
        case "Brownolive":
            brownOliveCounter -= 1
        case "Olive":
            yellowOliveCounter -= 1
        default:
            break
        }
    }
    private func checkCountersAndNavigate() {
        // Check if all the olives have been clicked
        let allCountersZero = olives.allSatisfy { $0.counter == 0 }

        // If so, navigate after the falling animation completes
        if allCountersZero {
            // Since all counters are zero, set all navigation flags to true
            for index in navigateAfterFall.indices {
                navigateAfterFall[index] = true
            }
        }
    }



    struct OliveKeyView: View {
        @Binding var greenOliveCounter: Int
        @Binding var blackOliveCounter: Int
        @Binding var brownOliveCounter: Int
        @Binding var yellowOliveCounter: Int

        var body: some View {
            HStack(spacing: 20) {
                OliveKeyItem(color: "Greenolive", label: "Culture", counter: $greenOliveCounter)
                OliveKeyItem(color: "Blackolive", label: "History", counter: $blackOliveCounter)
                OliveKeyItem(color: "Brownolive", label: "Stories", counter: $brownOliveCounter)
                OliveKeyItem(color: "Olive", label: "Facts", counter: $yellowOliveCounter)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.timelineBackground)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.horizontal)
        }
    }

    struct OliveKeyItem: View {
        let color: String
        let label: String
        @Binding var counter: Int

        var body: some View {
            VStack {
                Image(color)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                Text(label)
                    .font(.caption)
                    .foregroundColor(.black)
                Text(String(format: "%02d", counter))
                    .font(.caption)
                    .foregroundColor(counter == 0 ? .gray : .black)
            }
            .onTapGesture {
                if counter > 0 {
                    counter -= 1
                }
            }
        }
    }


    private func animateBranches() {
        withAnimation(.easeInOut(duration: 2).delay(0.5)) {
            showBranches = true
            for index in branchLengths.indices {
                branchLengths[index] = 60 + CGFloat(index) * 20
            }
        }
        // Delay for nodes animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            animateNodes()
        }
    }

    private func animateNodes() {
        withAnimation(.easeInOut(duration: 1)) {
            for index in nodePositions.indices {
                nodePositions[index] = 0 // Reset node positions for animation
            }
        }
    }
}


// The view that is presented when the node is clicked
struct DetailsView: View {
    var onDismiss: () -> Void
    @State private var currentPage = 0

    var body: some View {
        VStack {
            InformationView(currentPage: $currentPage)
        }
    }
}


struct DetailsView2: View {
    @State private var navigateToImage = false
    @State private var currentPage = 0
    
    var onDismiss: () -> Void

    var body: some View {
        VStack {
            InformationView2(currentPage: $currentPage, navigateToImage: $navigateToImage)

            Spacer()
            if navigateToImage {
                NavigationLink(destination: FullScreenImageView(isPresented: $navigateToImage), isActive: $navigateToImage) { EmptyView() }
            }
        }
        .background(Color.timelineBackground)
        .navigationBarBackButtonHidden(true)
    }
}


struct InformationView: View {
    @Binding var currentPage: Int
    var onDismiss: (() -> Void)? // Closure to dismiss this view
    @State private var navigateToLargerTree = false // State to control navigation

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("\nWelcome to Olive Tree Academy")
                        .font(.custom("Georgia", size: 20))
                        .foregroundColor(Color(UIColor(red: 0.294, green: 0.498, blue: 0.322, alpha: 1.0)))
                        .bold()

                    Text("Embark on a captivating journey through the intertwined histories and cultural legacies of Palestine and Israel with Olive Tree Academy. Dive into a rich tapestry of narratives, exploring the shared past that has shaped these lands and the people who call them home.")
                    
                    Text("\nDiscover Intriguing Histories")
                        .font(.custom("Georgia", size: 20))
                        .foregroundColor(Color(UIColor(red: 0.294, green: 0.498, blue: 0.322, alpha: 1.0)))
                        .bold()

                    Text("Uncover the layers of historical events and pivotal moments that have defined the region. From ancient civilizations to modern conflicts, delve into stories of resilience, diversity, and coexistence. Gain a deeper understanding of the complexities inherent in the land's history, fostering a more nuanced perspective.")
                    
                    Text("\nGrow Knowledge, Cultivate Unity")
                        .font(.custom("Georgia", size: 20))
                        .foregroundColor(Color(UIColor(red: 0.294, green: 0.498, blue: 0.322, alpha: 1.0)))
                        .bold()

                    Text("As you engage with our content, witness the growth of an olive tree—a symbol of your expanding knowledge. Your journey is a quest for understanding and empathy. Only when you feel rooted in your comprehension will the tree mature, signifying your readiness to form informed opinions.\n\nLet the exploration begin!")
                }
                .padding()
                .multilineTextAlignment(.leading)
                .tag(0)
                .tabItem {
                    Label("Page 1", systemImage: "1.circle")
                }
            
                VStack(alignment: .leading, spacing: 8) {
                    Text("Why the olive tree?")
                        .font(.custom("Georgia", size: 25))
                        .foregroundColor(Color(UIColor(red: 0.294, green: 0.498, blue: 0.322, alpha: 1.0)))
                        .bold()
                    Text("Symbol of Endurance and Cultural Identity:")
                        .font(.custom("Georgia", size: 20))
                        .foregroundColor(Color(UIColor(red: 0.294, green: 0.498, blue: 0.322, alpha: 1.0)))
                        .bold()

                    Text("The olive tree stands as an emblematic symbol deeply intertwined with the land of Palestine and Israel. Its roots penetrate the rich soil, echoing centuries of agricultural tradition and cultural heritage. Enduring through generations, these trees not only produce the cherished olive fruit and oil but also embody the resilience and steadfastness of the people connected to this sacred land.")
                    
                    Text("\nCultural Heritage and Agricultural Legacy:")
                        .font(.custom("Georgia", size: 20))
                        .foregroundColor(Color(UIColor(red: 0.294, green: 0.498, blue: 0.322, alpha: 1.0)))
                        .bold()

                    Text("The cultivation of olive trees holds profound significance, reflecting the agricultural legacy that spans millennia. These trees signify a bond between the inhabitants and their ancestral lands, shaping local economies and traditions. Their branches, laden with olives, have been part of cultural ceremonies, culinary delights, and artistic expressions, symbolizing unity and shared experiences among communities.")
                    
                    Text("\nUnity and Peaceful Coexistence:")
                        .font(.custom("Georgia", size: 20))
                        .foregroundColor(Color(UIColor(red: 0.294, green: 0.498, blue: 0.322, alpha: 1.0)))
                        .bold()

                    Text("The olive tree, known as a symbol of peace, serves as a silent witness to the enduring quest for harmony between diverse communities. Its presence in the landscape underscores the shared desire for reconciliation, fostering a vision of unity amidst historical complexities. ")
                    
                    // Add the NavigationLink
                                NavigationLink(destination: LargerTreeView(), isActive: $navigateToLargerTree) { EmptyView() }
                                
                                // Modify the "Next" button action
                                Button(action: {
                                    navigateToLargerTree = true // Activate navigation
                                }) {
                                    Text("Next")
                                                .padding()
                                                .foregroundColor(.white)
                                                .background(Color(UIColor(red: 0.294, green: 0.498, blue: 0.322, alpha: 1.0))) // Use the color #4B7F52
                                                .cornerRadius(8)
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                    }
                                    .padding()
                                    .multilineTextAlignment(.leading)
                                    .tag(1) // Adjust the tag accordingly
                                    .tabItem {
                                        Label("Page 3", systemImage: "3.circle")
                                    }
                                }
                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                                .background(Color(UIColor(red: 1.0, green: 0.992, blue: 0.941, alpha: 1.0))) // Background color for the TabView itself
                                
                                PageControl(numberOfPages: 2, currentPage: $currentPage)
                                    .padding(.top, 8)
                            }
                            .background(Color(UIColor(red: 1.0, green: 0.992, blue: 0.941, alpha: 1.0))) // Background color for the entire VStack
                            .navigationBarTitle("Information")
                        }
                    }

struct PageControl: View {
    let numberOfPages: Int
    @Binding var currentPage: Int
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<numberOfPages, id: \.self) { page in
                Circle()
                    .fill(page == currentPage ? Color(UIColor(red: 0.294, green: 0.498, blue: 0.322, alpha: 1.0)) : Color.gray)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(6)
        .background(Color(UIColor(red: 1.0, green: 0.992, blue: 0.941, alpha: 1.0)))
        .clipShape(Capsule()) // Use Capsule shape for rounded corners
    }
}
struct YouTubeVideoView: UIViewRepresentable {
    let videoURL = URL(string: "https://www.youtube.com/embed/Tz7JJcO-rWw")!

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: videoURL))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}



struct InformationView2: View {
    @Binding var currentPage: Int
    @State private var isNextPageActive = false
    @Binding var navigateToImage: Bool  // Add this line
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("The Balfour Declaration")
                        .font(.title)
                        .font(.custom("Georgia", size: 28)) // Using Georgia Serif font with size 28
                        .padding()
                        .bold()
                        .foregroundColor(Color(UIColor(red: 0.294, green: 0.498, blue: 0.322, alpha: 1.0)))
                    
                    Text("\nWhat is the Balfour Declaration?")
                        .font(.custom("Georgia", size: 20))
                        .foregroundColor(Color(UIColor(red: 0.294, green: 0.498, blue: 0.322, alpha: 1.0)))
                        .bold()
                    
                    Text("The Balfour Declaration (“Balfour’s promise” in Arabic) was a public pledge by Britain in 1917 declaring its aim to establish “a national home for the Jewish people” in Palestine.\n\nThe statement came in the form of a letter from Britain’s then-foreign secretary, Arthur Balfour, addressed to Lionel Walter Rothschild, a figurehead of the British Jewish community.\n\nIt was made during World War I (1914-1918) and was included in the terms of the British Mandate for Palestine after the dissolution of the Ottoman Empire.\n\nThe so-called mandate system, set up by the Allied powers, was a thinly veiled form of colonialism and occupation.\n\nThe system transferred rule from the territories that were previously controlled by the powers defeated in the war – Germany, Austria-Hungary, the Ottoman Empire, and Bulgaria – to the victors.\n\n")
                }
                .padding()
                .multilineTextAlignment(.leading)
                .tag(0)
                .tabItem {
                    Label("Page 1", systemImage: "1.circle")
                }
                
                // Second tab content
                YouTubeVideoView()
                    .tag(1)
                    .tabItem {
                        Label("Page 2", systemImage: "2.circle")
                    }
                
                // Third tab content
                VStack(alignment: .leading, spacing: 8) {
                    Image("declaration")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 350, height: 550)
                        .clipped()
                        .padding()

                    Button(action: {
                        navigateToImage = true // Set to true when Next is tapped
                    }) {
                        Text("Next")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color(UIColor(red: 0.294, green: 0.498, blue: 0.322, alpha: 1.0))) // The color #4B7F52
                            .cornerRadius(8)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                }
                .multilineTextAlignment(.center)
                .tag(2)
                .tabItem {
                    Label("Page 3", systemImage: "3.circle")
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .background(Color(UIColor(red: 1.0, green: 0.992, blue: 0.941, alpha: 1.0))) // Background color for the TabView itself
            
            PageControl(numberOfPages: 3, currentPage: $currentPage)
                .padding(.top, 8)
        }
        .background(Color(UIColor(red: 1.0, green: 0.992, blue: 0.941, alpha: 1.0))) // Background color for the entire VStack
        .navigationBarTitle("Information")
        .navigationBarBackButtonHidden(true)
        // NavigationLink for transitioning to FullScreenImageView
        .background(NavigationLink("", destination: FullScreenImageView(isPresented: $navigateToImage), isActive: $navigateToImage).hidden())
    }
}

struct Tree: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
