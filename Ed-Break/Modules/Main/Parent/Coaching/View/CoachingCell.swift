//
//  CoachingCell.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.11.22.
//

import SwiftUI

struct CoachingCell: View {
    
    let child: ChildModel
    
    private let imageHeight = 52.0
    private let cornerRadius = 12.0
    private let padding = 20.0
    private let spacing = 20.0
    private let progressHeight = 7.0
    private let progressCornerRadius = 4.0
    
    
    var body: some View {
        VStack(spacing: spacing) {
            childInfoView(child: child)
            VStack(spacing: spacing) {
                statistics(child: child)
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
            progress
        }
        .padding(padding)
        .background(Color.appWhite)
        .cornerRadius(cornerRadius)
    }
}

private extension CoachingCell {
    private func childInfoView(child: ChildModel) -> some View {
        HStack(spacing: spacing) {
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
            
            VStack(alignment: .leading) {
                Text(child.name)
                    .font(.appButton)
                Text(child.lastLogin)
                    .font(.appBody)
                    .foregroundColor(.primaryDescription)
            }
            Spacer()
        }
    }
    
    private func statistics(child: ChildModel) -> some View {
        HStack {
            statisticsItem(
                title: "\(child.todayCorrectAnswers) of \(child.todayAnswers)",
                description: "main.parent.home.questions")
            Spacer()
            statisticsItem(title: "\(Int(child.percentageToday))%", description: "main.parent.home.answers")
        }
    }
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
    
    private var progress: some View {
        VStack(spacing: spacing) {
            progress(name: "Math", blue: 54, green: 60)
            progress(name: "English", blue: 76, green: 80)
            progress(name: "Spanish", blue: 20, green: 50)
            progress(name: "Science", blue: 87, green: 90)
        }
    }
    
    private func progress(name: String, blue: CGFloat, green: CGFloat, grey: CGFloat = 100) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("\(name) - \(Int(blue))%")
                    .font(.appBody)
                    .foregroundColor(.black)
                Spacer()
                Text("+2,4%")
                    .font(.appBody)
                    .foregroundColor(.primaryPurple)
            }
            ZStack(alignment: .leading) {
                GeometryReader { geo in
                    Rectangle()
                        .foregroundColor(Color.divader)
                        .frame(width: geo.size.width * grey / 100)
                        .cornerRadius(progressCornerRadius)
                    Rectangle()
                        .foregroundColor(Color.primaryGreenLight)
                        .frame(width: geo.size.width * green / 100)
                        .cornerRadius(progressCornerRadius)
                    Rectangle()
                        .foregroundColor(Color.primaryBlueDark)
                        .frame(width: geo.size.width * blue / 100)
                        .cornerRadius(progressCornerRadius)
                }
            }
            .frame(height: progressHeight)
        }
    }
}


struct CoachingCell_Previews: PreviewProvider {
    static var previews: some View {
        CoachingCell(child: ChildModel(dto: ChildDto(id: 0, name: "Emma", grade: 3, restrictionTime: nil, photo: nil, todayAnswers: 20, todayCorrectAnswers: 19, percentageToday: 95, lastLogin: "Active 14 min ago")))
    }
}

