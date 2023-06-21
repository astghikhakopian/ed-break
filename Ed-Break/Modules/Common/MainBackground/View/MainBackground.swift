//
//  MainBackground.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 26.09.22.
//

import SwiftUI

struct MainBackgroundCore<Content: View, Q: View, BarButtonItem: View> : View {
    
    let title: String?
    let withNavbar: Bool
    var isSimple: Bool
    var hideBackButton: Bool
    let stickyView: () -> Q?
    let leftBarButtonItem: () -> BarButtonItem?
    let content: (() -> Content)
    
    init(
        title: String?,
        withNavbar: Bool,
        isSimple: Bool = false,
        hideBackButton: Bool = false,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder stickyView: @escaping () -> Q? = { nil },
        @ViewBuilder leftBarButtonItem: @escaping () -> BarButtonItem? = { nil }
    ) {
        self.title = title
        self.withNavbar = withNavbar
        self.isSimple = isSimple
        self.hideBackButton = hideBackButton
        self.content = content
        self.stickyView = stickyView
        self.leftBarButtonItem = leftBarButtonItem
    }
    
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
                            ZStack {
                                Image.Background.back
                            }.frame(width: 50)
                        }
                    }
                    if let title = title {
                        Spacer()
                        Text(LocalizedStringKey(title))
                            .font(.appLargeTitle)
                            .foregroundColor(Color.appWhite)
                            .padding(.leading, withNavbar && !hideBackButton ? -50 : 0)
                            .padding(.trailing, withNavbar && leftBarButtonItem() != nil ? -30 : 0)
                        Spacer()
                    }
                    leftBarButtonItem()
                }
                ScrollView(showsIndicators: false) {
                    PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                        NotificationCenter.default.post(name: .Refresh.update, object: nil)
                    }
                    content()
                        .cornerRadius(contentCornerRadius)
                    if !isSimple {
                        Spacer()
                    }
                }
                .coordinateSpace(name: "pullToRefresh")
                    stickyView()
                        .padding(.bottom, 15)
            }
            .padding(EdgeInsets(
                top: hideBackButton ? -74 : withNavbar ? 0 : 10,
                leading: 15,
                bottom: 0,
                trailing: 15))
        }
        .navigationBarTitleDisplayMode(.inline)
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

typealias MainBackground<Content: View> = MainBackgroundCore<Content, AnyView, AnyView>

// MARK: - Priview

struct MainBackground_Previews: PreviewProvider {
    static var previews: some View {
        MainBackground(title: "onboarding.role", withNavbar: true, content: {
            EmptyView()
        }, leftBarButtonItem: {
            return AnyView(Image.ChildHome.volume)
        })
    }
}
