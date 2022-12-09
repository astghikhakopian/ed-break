//
//  BottomsheetView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 22.11.22.
//

import SwiftUI

protocol BottomsheetCellModel {
    var id: Int { get }
    var title: String { get }
    var imageUrl: URL? { get }
}

struct BottomsheetView: View {
    
    let title: String
    var datasource: [BottomsheetCellModel]
    @Binding var selectedItems: [BottomsheetCellModel]?
    @Binding var isPresented: Bool
    var isMultiselect = false
    
    @State private var uiTabarController: UITabBarController?
    private func isSelected(item: BottomsheetCellModel) -> Bool {
        selectedItems?.contains(where: {$0.id == item.id}) ?? false
    }
    
    private let indicatorCornerRadius: CGFloat = 4
    private let cornerRadius: CGFloat = 12
    private let spacing: CGFloat = 22
    private let itemSpacing: CGFloat = 25
    private let imageHeight: CGFloat = 44
    private let selectionHeight: CGFloat = 20
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Spacer()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight:0, maxHeight: .infinity, alignment: Alignment.topLeading)
                VStack(spacing: spacing) {
                    RoundedRectangle(cornerRadius: indicatorCornerRadius)
                        .foregroundColor(.divader)
                        .frame(width: 36, height: 4)
                    Text(LocalizedStringKey(title))
                        .font(.appButton)
                        .foregroundColor(.primaryText)
                    VStack(spacing: itemSpacing) {
                        ForEach(datasource, id: \.id) {
                            cell(item: $0)
                        }
                    }
                    
                    
                }
                .padding(itemSpacing)
                .background(Color.appWhite)
                .cornerRadius(cornerRadius, corners: [.topLeft, .topRight])
                
            }.rotationEffect(Angle(degrees: 180))
        }
        .rotationEffect(Angle(degrees: 180))
        .ignoresSafeArea()
        .background(Color.appBlack.opacity(0.4))
        .introspectTabBarController { (UITabBarController) in
            UITabBarController.tabBar.isHidden = true
            uiTabarController = UITabBarController
        }.onDisappear{
            uiTabarController?.tabBar.isHidden = false
        }
    }
    
    func cell(item: BottomsheetCellModel)-> some View {
        HStack(spacing: spacing) {
            if let imageUrl = item.imageUrl {
                AsyncImageView(withURL: imageUrl.absoluteString, width: imageHeight, height: imageHeight)
                    .frame(width: imageHeight, height: imageHeight)
                    .cornerRadius(imageHeight/2)
            } else {
                Spacer()
            }
            Text(LocalizedStringKey(item.title))
                .font(.appButton)
                .foregroundColor(.primaryText)
            Spacer()
            if isMultiselect {
                RoundedRectangle(cornerRadius: selectionHeight/2)
                    .stroke(isSelected(item: item) ? Color.primaryPurple : Color.border, lineWidth: isSelected(item: item) ? 7 : 1)
                    .frame(width: selectionHeight - (isSelected(item: item) ? 7 : 1), height: selectionHeight - (isSelected(item: item) ? 7 : 1))
                    .padding(.leading, (isSelected(item: item) ? 3.5 : 0))
                    .padding(.trailing, (isSelected(item: item) ? 2.5 : 0))
            }
        }
    }
}

struct BottomsheetViewModifier {
    let title: String
    var datasource: [BottomsheetCellModel]
    @Binding var selectedItems: [BottomsheetCellModel]?
    @Binding var isPresented: Bool
    var isMultiselect = false
    
    private func isSelected(item: BottomsheetCellModel) -> Bool {
        localSelectedItems.contains(where: {$0.id == item.id})
    }
    @State private var isContentValid: Bool = false
    @State private var localSelectedItems: [BottomsheetCellModel] = []  {
        didSet {
            isContentValid = !localSelectedItems.isEmpty
        }
    }
    
    private let indicatorCornerRadius: CGFloat = 4
    private let cornerRadius: CGFloat = 12
    private let spacing: CGFloat = 22
    private let itemSpacing: CGFloat = 25
    private let imageHeight: CGFloat = 44
    private let selectionHeight: CGFloat = 20
    
}

extension BottomsheetViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                GeometryReader { geometry in
                    BottomSheetView(
                        isOpen: $isPresented,
                        maxHeight: CGFloat(240 + (44 + 25) * datasource.count)
                    ) {
                        
                        VStack(spacing: spacing) {
                            RoundedRectangle(cornerRadius: indicatorCornerRadius)
                                .foregroundColor(.divader)
                                .frame(width: 36, height: 4)
                            Text(LocalizedStringKey(title))
                                .font(.appButton)
                                .foregroundColor(.primaryText)
                            VStack(spacing: itemSpacing) {
                                ForEach(datasource, id: \.id) { item in
                                    Button {
                                        if isMultiselect {
                                            if localSelectedItems.contains(where: {item.id == $0.id}) {
                                                localSelectedItems.removeAll(where: {item.id == $0.id})
                                            } else {
                                                localSelectedItems.append(item)
                                            }
                                        } else {
                                            localSelectedItems = [item]
                                            selectedItems = localSelectedItems
                                            isPresented = false
                                        }
                                    } label: {
                                        cell(item: item)
                                    }
                                }
                            }
                            if isMultiselect {
                                ConfirmButton(action: {
                                    DispatchQueue.main.async {
                                        selectedItems = localSelectedItems
                                        isPresented = false
                                    }
                                }, title: "common.confirm", isContentValid: $isContentValid, isLoading: .constant(false))
                            }
                            Spacer().frame(height: 20)
                        }.padding(itemSpacing)
                            .background(Color.appWhite)
                    }.background(Color.appBlack.opacity(0.4))
                }.edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    func cell(item: BottomsheetCellModel)-> some View {
        HStack(spacing: spacing) {
            if let imageUrl = item.imageUrl {
                AsyncImageView(withURL: imageUrl.absoluteString, width: imageHeight, height: imageHeight)
                    .frame(width: imageHeight, height: imageHeight)
                    .cornerRadius(imageHeight/2)
            } else if isMultiselect {
                Spacer().frame(width: imageHeight, height: imageHeight)
            } else {
                Spacer()
            }
            Text(LocalizedStringKey(item.title))
                .font(.appButton)
                .foregroundColor(isMultiselect ? .primaryText : .primaryPurple)
            Spacer()
            if isMultiselect {
                RoundedRectangle(cornerRadius: selectionHeight/2)
                    .stroke(isSelected(item: item) ? Color.primaryPurple : Color.border, lineWidth: isSelected(item: item) ? 7 : 1)
                    .frame(width: selectionHeight - (isSelected(item: item) ? 7 : 1), height: selectionHeight - (isSelected(item: item) ? 7 : 1))
                    .padding(.leading, (isSelected(item: item) ? 3.5 : 0))
                    .padding(.trailing, (isSelected(item: item) ? 2.5 : 0))
            }
        }
    }
}

extension View {
    
    func bottomsheet(title: String, datasource: [BottomsheetCellModel], selectedItems: Binding<[BottomsheetCellModel]?>, isPresented: Binding<Bool>, isMultiselect: Bool = false) -> some View {
        return modifier(BottomsheetViewModifier(title: title, datasource: datasource, selectedItems: selectedItems, isPresented: isPresented, isMultiselect: isMultiselect))
    }
}

struct BottomsheetView_Previews: PreviewProvider {
    static var previews: some View {
        BottomsheetView(title: "childDetails.subjects", datasource: [], selectedItems: .constant(nil), isPresented: .constant(true))
    }
}


import SwiftUI

fileprivate enum Constants {
    static let radius: CGFloat = 16
    static let indicatorHeight: CGFloat = 6
    static let indicatorWidth: CGFloat = 60
    static let snapRatio: CGFloat = 0.25
    static let minHeightRatio: CGFloat = 0.3
}

struct BottomSheetView<Content: View>: View {
    @Binding var isOpen: Bool
    
    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content
    
    
    private let indicatorCornerRadius: CGFloat = 4
    private let cornerRadius: CGFloat = 12
    private let spacing: CGFloat = 22
    private let itemSpacing: CGFloat = 25
    private let imageHeight: CGFloat = 44
    private let selectionHeight: CGFloat = 20
    
    @GestureState private var translation: CGFloat = 0
    
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }
    
    private var indicator: some View {
        RoundedRectangle(cornerRadius: Constants.radius)
            .fill(Color.secondary)
            .frame(
                width: Constants.indicatorWidth,
                height: Constants.indicatorHeight
            ).onTapGesture {
                self.isOpen.toggle()
            }
    }
    
    init(isOpen: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self.minHeight = maxHeight * Constants.minHeightRatio
        self.maxHeight = maxHeight
        self.content = content()
        self._isOpen = isOpen
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer().frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: Alignment.topLeading)
            content
                .background(Color.appWhite)
                .cornerRadius(cornerRadius, corners: [.topLeft, .topRight])
        }
        .cornerRadius(Constants.radius, corners: [.topRight, .topLeft])
        .offset(y: max(self.offset + self.translation, 0))
        .gesture(
            DragGesture().updating(self.$translation) { value, state, _ in
                state = value.translation.height
            }.onEnded { value in
                let snapDistance = self.maxHeight * Constants.snapRatio
                guard abs(value.translation.height) > snapDistance else {
                    return
                }
                self.isOpen = value.translation.height < 0
            }
        )
    }
}

struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetView(isOpen: .constant(false), maxHeight: 600) {
            Rectangle().fill(Color.red)
        }.edgesIgnoringSafeArea(.all)
    }
}
