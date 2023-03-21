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
    var isSimple: Bool = false
    var hideBackButton: Bool = false
    @ViewBuilder let  content: (() -> Content)
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private let contentCornerRadius = 12.0
    
    var body: some View {
        ZStack {
            if isSimple {
                Color.primaryPurple
                    .ignoresSafeArea()
            } else {
                VStack(spacing: 0) {
                    navigationBackground
                    Color.primaryBackground
                }.ignoresSafeArea()
            }
            VStack(spacing: 34) {
                HStack(alignment: .center) {
                    if withNavbar && !hideBackButton {
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
                    PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                        NotificationCenter.default.post(name: .Refresh.update, object: nil)
                    }
                    content().cornerRadius(contentCornerRadius)
                    if !isSimple {
                        Spacer()
                    }
                }.coordinateSpace(name: "pullToRefresh")
            }
            .padding(EdgeInsets(
                top: hideBackButton ? -74 : withNavbar ? 0 : 10,
                leading: 15,
                bottom: 0,
                trailing: 15))
        }.navigationBarTitleDisplayMode(.inline)//.navigationTitle(title ?? "")// .ignoresSafeArea()
            .navigationViewStyle(StackNavigationViewStyle())
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
        }.background(Color.primaryPurple)
    }
}
extension NSNotification.Name {
    struct Refresh {
        static let update = Notification.Name.init("Refresh.update")
    }
    struct Push {
        static let doExercises = Notification.Name.init("Push.doEx")
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
