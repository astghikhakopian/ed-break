//
//  PullToRefresh.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 30.01.23.
//

import SwiftUI

//struct PullToRefresh: View {
//
//    var coordinateSpaceName: String
//    var onRefresh: ()->Void
//
//    @State var needRefresh: Bool = false
//
//    var body: some View {
//        GeometryReader { geo in
//            if (geo.frame(in: .named(coordinateSpaceName)).midY > 50) {
//                Spacer()
//                    .onAppear {
//                        needRefresh = true
//                    }
//            } else if (geo.frame(in: .named(coordinateSpaceName)).maxY < 10) {
//                Spacer()
//                    .onAppear {
//                        if needRefresh {
//                            needRefresh = false
//                            onRefresh()
//                        }
//                    }
//            }
//            HStack {
//                Spacer()
//                if needRefresh {
//                    ProgressView()
//                }
//                Spacer()
//            }
//        }.padding(.top, -50)
//    }
//}

import SwiftUI

private struct PullToRefresh: UIViewRepresentable {
    
    @Binding var isShowing: Bool
    let onRefresh: () -> Void
    
    public init(
        isShowing: Binding<Bool>,
        onRefresh: @escaping () -> Void
    ) {
        _isShowing = isShowing
        self.onRefresh = onRefresh
    }
    
    public class Coordinator {
        let onRefresh: () -> Void
        var isShowing: Binding<Bool>
        
        init(
            onRefresh: @escaping () -> Void,
            isShowing: Binding<Bool>
        ) {
            self.onRefresh = onRefresh
            self.isShowing = isShowing
        }
        
        @objc
        func onValueChanged() {
            isShowing.wrappedValue = true
            onRefresh()
        }
    }
    
    public func makeUIView(context: UIViewRepresentableContext<PullToRefresh>) -> UIView {
        let view = UIView(frame: .zero)
        view.isHidden = true
        view.isUserInteractionEnabled = false
        return view
    }
    
    private func ScrollView(entry: UIView) -> UIScrollView? {
        
        // Search in ancestors
        if let ScrollView = Introspect.findAncestor(ofType: UIScrollView.self, from: entry) {
            return ScrollView
        }

        guard let viewHost = Introspect.findViewHost(from: entry) else {
            return nil
        }

        // Search in siblings
        return Introspect.previousSibling(containing: UIScrollView.self, from: viewHost)
    }

    public func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PullToRefresh>) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
            guard let ScrollView = self.ScrollView(entry: uiView) else {
                return
            }
            
            if let refreshControl = ScrollView.refreshControl {
                if self.isShowing {
                    refreshControl.beginRefreshing()
                } else {
                    refreshControl.endRefreshing()
                }
                return
            }
            
            let refreshControl = UIRefreshControl()
            refreshControl.tintColor = .white
            refreshControl.addTarget(context.coordinator, action: #selector(Coordinator.onValueChanged), for: .valueChanged)
            ScrollView.refreshControl = refreshControl
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(onRefresh: onRefresh, isShowing: $isShowing)
    }
}

extension View {
    public func pullToRefresh(isShowing: Binding<Bool>, onRefresh: @escaping () -> Void) -> some View {
        return overlay(
            PullToRefresh(isShowing: isShowing, onRefresh: onRefresh)
                .frame(width: 0, height: 0)
        )
    }
}
