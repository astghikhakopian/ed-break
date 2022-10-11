//
//  ChildProfileView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 10.10.22.
//

import SwiftUI

enum TimePeriod: String, CaseIterable, PickerItem {
    case day = "DAY"
    case week = "WEEK"
    case month  = "MONTH"
    
    var name: String {
        switch self {
        case .day:    return "Today"
        case .week:   return "This week"
        case .month:    return "This month"
        }
    }
    
    var key: String {
        switch self {
        case .day:    return "DAY"
        case .week:   return "WEEK"
        case .month:  return "MONTH"
        }
    }
}

struct ChildProfileView: View {
    
    let child: ChildModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var selectedEducationPeriod: TimePeriod = .day
    @State var selectedActivityPeriod: TimePeriod = .day
    var datasource: [TimePeriod] = TimePeriod.allCases
    
    private let imageHeight = 90.0
    private let cornerRadius = 12.0
    private let padding = 20.0
    private let spacing = 8.0
    private let contentSpacing = 16.0
    private let progressHeight = 7.0
    private let progressCornerRadius = 4.0
    
    var body: some View {
        ScrollView {
            VStack(spacing: padding) {
                header
                educationView
                activityView
            }
        }.background(Color.primaryBackground)
        
    }
}

// MARK: - header
private extension ChildProfileView {
    var header: some View {
        VStack(spacing: spacing) {
            navigationItems
            if let imageUrl = child.photoUrl {
                AsyncImageView(withURL: imageUrl.absoluteString, width: imageHeight, height: imageHeight)
                    .frame(width: imageHeight, height: imageHeight)
                    .cornerRadius(imageHeight/2)
            } else {
                Image.ChildDetails.uploadPlaceholder
                    .resizable()
                    .frame(width: imageHeight, height: imageHeight)
                    .cornerRadius(imageHeight/2)
            }
            
            VStack() {
                Text(child.name)
                    .font(.appLargeTitle)
                Text(child.lastLogin)
                    .font(.appHeadline)
                    .foregroundColor(.primaryDescription)
            }
        }.padding(padding)
            .background(Color.appWhite)
            .cornerRadius(cornerRadius)
    }
    var navigationItems: some View {
        HStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image.Common.back
            }
            Spacer()
            Button {
                // TODO: -
            } label: {
                Image.Common.more
            }
        }
    }
}


// MARK: - Education

private extension ChildProfileView {
    var educationView: some View {
        VStack(spacing: contentSpacing) {
            educationHeader
            educationStatistics(child: child)
        }
        .padding(padding)
        .background(Color.appWhite)
        .cornerRadius(cornerRadius)
    }
    
    var educationHeader: some View {
        HStack() {
            Text("main.parent.childProfile.education")
                .font(.appLargeTitle)
            Spacer()
            Menu {
                Picker(selection: $selectedEducationPeriod) {
                    ForEach(datasource, id: \.self) {
                        Text($0.name).font(.appHeadline)
                    }.font(.appHeadline)
                } label: { }
            } label: {
                Text(selectedEducationPeriod.name).font(.appHeadline)
                Image.Common.dropdownArrow.renderingMode(.template)
            }.foregroundColor(.primaryPurple)
        }
    }
    
    private func educationStatistics(child: ChildModel) -> some View {
        VStack(spacing: contentSpacing) {
            HStack {
                statisticsItem(
                    title: "\(child.todayCorrectAnswers) of \(child.todayAnswers)",
                    description: "main.parent.childProfile.questions")
                Spacer()
                statisticsItem(title: "\(Int(child.percentageToday))%", description: "main.parent.childProfile.correctAnswers")
            }
            HStack {
                statisticsItem(
                    title: "\(7)%",
                    description: "main.parent.childProfile.beter",
                    image: .Common.upArrow
                )
                Spacer()
            }
        }.padding(24)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.border, lineWidth: 1)
            )
    }
}


// MARK: - Activity

private extension ChildProfileView {
    var activityView: some View {
        VStack(spacing: contentSpacing) {
            activityHeader
            activityStatistics(child: child)
        }
        .padding(padding)
        .background(Color.appWhite)
        .cornerRadius(cornerRadius)
    }
    
    var activityHeader: some View {
        HStack() {
            Text("main.parent.childProfile.activity")
                .font(.appLargeTitle)
            Spacer()
            Menu {
                Picker(selection: $selectedActivityPeriod) {
                    ForEach(datasource, id: \.self) {
                        Text($0.name).font(.appHeadline)
                    }.font(.appHeadline)
                } label: { }
            } label: {
                Text(selectedActivityPeriod.name).font(.appHeadline)
                Image.Common.dropdownArrow.renderingMode(.template)
            }.foregroundColor(.primaryPurple)
        }
    }
    
    private func activityStatistics(child: ChildModel) -> some View {
        VStack(spacing: contentSpacing) {
            HStack {
                statisticsItem(
                    title: "\(4.5)",
                    description: "main.parent.childProfile.questions",
                    subtitle: "main.parent.childProfile.hours")
                Spacer()
                Divider().foregroundColor(.border)
                Spacer()
                statisticsItem(title: "\(0.4)", description: "main.parent.childProfile.avgSession",
                               subtitle: "main.parent.childProfile.hours")
            }
        }.padding(24)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.border, lineWidth: 1)
            )
    }
}


// MARK: - Common

private extension ChildProfileView {
    
    private func statisticsItem(title: String, description: String, subtitle: String? = nil, image: Image? = nil) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(LocalizedStringKey(title))
                    .font(.appLargeTitle)
                    .foregroundColor(.link)
                if let image = image {
                    image
                }
                if let subtitle = subtitle {
                    Text(LocalizedStringKey(subtitle))
                        .font(.appHeadline)
                        .foregroundColor(.primaryDescription)
                }
            }
            Text(LocalizedStringKey(description))
                .font(.appHeadline)
                .foregroundColor(.primaryDescription)
        }
    }
}


// MARK: - Preview

struct ChildProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ChildProfileView(child: ChildModel(dto: ChildDto(id: -1, name: "Emma", grade: 1, restrictionTime: nil, photo: nil, todayAnswers: 140, todayCorrectAnswers: 130, percentageToday: 98, lastLogin: "Active 3 days ago")))
    }
}
