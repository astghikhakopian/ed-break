//
//  LessonCell.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.11.22.
//

import SwiftUI

struct LessonCell: View {
    
    let model: SubjectModel
    
    let progressHeight: CGFloat = 50
    let gap: CGFloat = 2
    
    var body: some View {
        HStack(spacing: 12) {
            Image("English")
            VStack(alignment: .leading, spacing: 1) {
                Text(model.title ?? "")
                    .font(.appSubTitle)
                Text(LocalizedStringKey(model.completed ? "main.child.home.completed" : "main.child.home.notcompleted"))
                    .font(.appBody)
                    .foregroundColor(Color.primaryGreen)
            }
            /*
            ZStack {
                Circle()
                    .stroke(
                        Color.divader,
                        style: //StrokeStyle(
                        StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .miter, dash: [CGFloat(model.questionsCount) * gap*2, CGFloat(model.questionsCount)*2]
                                   )
                    ).frame(height: progressHeight)
                    .rotationEffect(.degrees(-8))
                
                Circle()
                                .trim(from: 0, to: 3/5)
                    .stroke(
                        Color.primaryPurple,
                        style: //StrokeStyle(
                        StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .miter, dash: [CGFloat(model.questionsCount) * gap*2, CGFloat(model.questionsCount)*2]
                                   )
                    ).frame(height: progressHeight)
                    .rotationEffect(.degrees(-90))
//                .rotationEffect(.degrees(-90))
                // .animation(.easeOut, value: 8)
            }
             */
        }
    }
}

struct LessonCell_Previews: PreviewProvider {
    static var previews: some View {
        LessonCell(model: SubjectModel(dto: SubjectDto(id: 0, title: "Math", photo: "English", questionsCount: 5, completedCount: 5, correctAnswersCount: 3, completed: false)))
    }
}
