//
//  ContentView.swift
//  Glassify2
//
//  Created by Figo Alessandro Lehman on 18/05/23.
//

import SwiftUI
import RealityKit
import ARKit

var arView = ARView(frame: .zero)

struct ContentView : View {
    @State var glassesList: [GlassesModel] = []
    let placeholderImage = Image(systemName: "photo")
    //    @ObservedObject var thumbnailGenerator: ThumbnailGenerator
    //
    //    init(thumbnailGenerator: ThumbnailGenerator = ThumbnailGenerator()) {
    //        self.thumbnailGenerator = thumbnailGenerator
    //        self.thumbnailGenerator.generateThumbnail(for: "glasses1", size: CGSize(width: 50, height: 50))
    //    }
    
    @State var index: Int = 0
    @State var isLoading = false
    @State var phase = 1
    
    var body: some View {
        NavigationStack{
            if isLoading {
                SplashView()
            }
            else {
                ZStack{
                    //            Color.black.ignoresSafeArea()
                    ARViewContainer(index: $index).edgesIgnoringSafeArea(.all)
                    VStack{
                        Spacer()
                        if(phase == 1){
                            Text("Please face straight to the camera")
                                .font(.system(size: 21))
                                .frame(width: 196)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .offset(y:30)
                        }
                        else if(phase == 2){
                            Text("Swipe left or right to change glasses")
                                .font(.system(size: 21))
                                .frame(width: 196)
                                .foregroundColor(.white)
                                .opacity(0.7)
                                .multilineTextAlignment(.center)
                                .offset(y:30)
                        }
                        ZStack {
                            SnapCarousel(trailingSpace: 150,index: $index, items: glassesList){
                                glasses in
                                GeometryReader { proxy in
                                    
                                    let size = proxy.size
                                    
                                    VStack {
                                        Spacer()
                                        Image(glasses.image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .scaleEffect(0.8)
                                        
                                        Spacer()
                                    }
                                    
                                }
                            }.frame(height: 200)
                            
                            Button{
                                arView.snapshot(saveToHDR: false) { (image) in
                                    // Compress the image
                                    let compressedImage = UIImage(data: (image?.pngData())!)
                                    // Save in the photo album
                                    UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
                                    
                                }
                            } label: {
                                Circle()
                                    .strokeBorder(.white, lineWidth: 10)
                                    .frame(width: 120, height: 120)
                                    .onAppear{
                                        for index in 1..<4 {
                                            glassesList.append(GlassesModel(image: "glasses\(index)"))
                                        }
                                    }
                            }
                        }
                        
                        
                    }
                    
                }
            }
        }
        .onAppear{
            loadingCall()
        }
    }
    
    func loadingCall(){
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            isLoading = false
            phase = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 5){
                phase = 2
                DispatchQueue.main.asyncAfter(deadline: .now() + 5){
                    phase = 0
                }
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    @Binding var index: Int
    
    func makeUIView(context: Context) -> ARView {
        
        let configuration = ARFaceTrackingConfiguration()
        if #available(iOS 13.0, *) {
            configuration.maximumNumberOfTrackedFaces = ARFaceTrackingConfiguration.supportedNumberOfTrackedFaces
        }
        configuration.isLightEstimationEnabled = true
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        switch index{
        case 0:
            arView.scene.anchors.append(try! Experience.loadGlasses1())
        case 1:
            arView.scene.anchors.append(try! Experience.loadGlasses2())
        case 2:
            arView.scene.anchors.append(try! Experience.loadGlasses3())
        default:
            print("error")
        }
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        arView.scene.anchors.removeAll()
        switch index{
        case 0:
            arView.scene.anchors.append(try! Experience.loadGlasses1())
        case 1:
            arView.scene.anchors.append(try! Experience.loadGlasses2())
        case 2:
            arView.scene.anchors.append(try! Experience.loadGlasses3())
        default:
            print("error")
        }
    }
    
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
