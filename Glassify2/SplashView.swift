//
//  SplashView.swift
//  Glassify2
//
//  Created by Figo Alessandro Lehman on 22/05/23.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack{
            Spacer()
            Image("glassify")
                .resizable()
                .scaledToFit()
                .padding(.bottom)
            Spacer()
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
