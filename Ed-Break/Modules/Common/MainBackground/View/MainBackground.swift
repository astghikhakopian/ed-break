//
//  MainBackground.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 26.09.22.
//

import SwiftUI

struct MainBackground<Content> : View where Content : View {
    
    let title: String?
    let withNavbar: Bool
    @ViewBuilder let  content: (() -> Content)
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                navigationBackground
                Color.primaryBackground
            } .ignoresSafeArea()
            VStack(spacing: 34) {
                HStack(alignment: .center) {
                    if withNavbar {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image.Background.back
                        }
                    }
                    if let title = title {
                        Spacer()
                        Text(LocalizedStringKey(title))
                            .font(.appLargeTitle)
                            .foregroundColor(Color.appWhite)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                }
                ScrollView(showsIndicators: false) {
                    content()
                    Spacer()
                }
            }.padding(EdgeInsets(
                top: withNavbar ? -8 : 30,
                leading: 15,
                bottom: 0,
                trailing: 15))
        }
    }
}

// MARK: - Private Components

extension MainBackground {
    
    private var navigationBackground: some View {
        VStack {
            HStack {
                Spacer()
                Image.Background.backgroundEcliipse2
            }
            HStack {
                Image.Background.backgroundEcliipse1
                Spacer()
            }
            HStack {
                Spacer()
                Image.Background.backgroundEcliipse3
                Spacer().frame(width: 18)
            }
        }.background(Color.primary)
    }
}

// MARK: - Priview

struct MainBackground_Previews: PreviewProvider {
    static var previews: some View {
        MainBackground(title: "onboarding.role", withNavbar: false) {
            Spacer()
        }
    }
}
