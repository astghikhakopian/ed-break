//
//  MainBackground.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 26.09.22.
//

import SwiftUI
import SwiftUIPullToRefresh

struct MainBackgroundCore<Content: View, Q: View, BarButtonItem: View> : View {
    
    let title: String?
    let withNavbar: Bool
    let isRefreshable: Bool
    var isSimple: Bool
    var hideBackButton: Bool
    let stickyView: () -> Q?
    let leftBarButtonItem: () -> BarButtonItem?
    let onRefresh: OnRefresh
    let content: (() -> Content)
    @Binding var contentSize: CGSize
    
    init(
        title: String?,
        withNavbar: Bool,
        isRefreshable: Bool = false,
        isSimple: Bool = false,
        hideBackButton: Bool = false,
        onRefresh: @escaping OnRefresh = { done in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { done() }
        },
        contentSize: Binding<CGSize> = .constant(.zero),
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder stickyView: @escaping () -> Q? = { nil },
        @ViewBuilder leftBarButtonItem: @escaping () -> BarButtonItem? = { nil }
    ) {
        self.title = title
        self.withNavbar = withNavbar
        self.isRefreshable = isRefreshable
        self.isSimple = isSimple
        self.hideBackButton = hideBackButton
        self.onRefresh = onRefresh
        self.content = content
        self.stickyView = stickyView
        self.leftBarButtonItem = leftBarButtonItem
        self._contentSize = contentSize
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
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    leftBarButtonItem()
                }
                Group {
                    if isRefreshable {
                        RefreshableScrollView(showsIndicators: false, loadingViewBackgroundColor: .clear, onRefresh: onRefresh, progress: { state in
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .primaryCellBackground))
                        }) {
                            content()
                                .cornerRadius(contentCornerRadius)
                            if !isSimple {
                                Spacer()
                            }
                        }
                    } else {
                        ScrollView(showsIndicators: false) {
                            content()
                                .cornerRadius(contentCornerRadius)
                            if !isSimple {
                                Spacer()
                            }
                        }
                    }
                }
                .overlay(
                    GeometryReader { geo in
                        Color.clear.onAppear {
                            let height = geo.size.height + (!hideBackButton ? -104 : withNavbar ? 0 : 10)
                            let size = CGSize(width: geo.size.width, height: height)
                            contentSize = size
                        }
                    }
                )
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
        MainBackground(
            title: "onboarding.role",
            withNavbar: true,
            onRefresh: { _ in
            },
            content: {
                EmptyView()
            }, leftBarButtonItem: {
                return AnyView(Image.ChildHome.volume)
            }
        )
    }
}
