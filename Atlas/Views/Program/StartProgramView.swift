//
//  StartProgramView.swift
//  Atlas
//
//  Created by Michael Bautista on 9/30/24.
//

import SwiftUI

struct StartProgramView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel = StartProgramViewModel()
    
    @Binding var isStarted: Bool
    
    @State var currentPage = 1
    @State var isEnd = false
    
    var programId: String
    var weeks: Int
    var pages: Int
    var remainder: Int
    
    var days = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
    
    @State var selectedDay = (1, "sunday")
    
    func calculateStartWeek() -> Int {
        return 1 + (4 * (currentPage - 1))
    }
    
    func calculateEndWeek() -> Int {
        return 4 + (4 * (currentPage - 1))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                VStack(spacing: 5) {
                    Text("Start Program")
                        .font(Font.FontStyles.title1)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                    
                    Text("Select which day you’d like to start the program from.")
                        .font(Font.FontStyles.headline)
                        .foregroundStyle(Color.ColorSystem.systemGray)
                        .multilineTextAlignment(.center)
                }
                
                // MARK: Calendar
                VStack(spacing: 10) {
                    // MARK: Week selector
                    HStack(alignment: .center) {
                        Button {
                            currentPage -= 1
                            
                            if currentPage < pages {
                                isEnd = false
                            }
                            
                            selectedDay = (calculateStartWeek(), "sunday")
                        } label: {
                            HStack {
                                Spacer()
                                
                                Image(systemName: "chevron.left")
                                    .foregroundStyle(isEnd ? Color.ColorSystem.systemGray3 : Color.ColorSystem.primaryText)
                                
                                Spacer()
                            }
                            .frame(width: 40, height: 30)
                        }
                        .buttonStyle(.plain)
                        .disabled(currentPage == 1)
                        
                        Spacer()
                        
                        Text("Weeks \(calculateStartWeek()) - \(calculateEndWeek())")
                            .font(Font.FontStyles.headline)
                            .foregroundStyle(Color.ColorSystem.primaryText)
                        
                        Spacer()
                        
                        Button {
                            currentPage += 1
                            
                            if currentPage == pages {
                                isEnd = true
                            }
                            
                            selectedDay = (calculateStartWeek(), "sunday")
                        } label: {
                            HStack {
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(isEnd ? Color.ColorSystem.systemGray3 : Color.ColorSystem.primaryText)
                                
                                Spacer()
                            }
                            .frame(width: 40, height: 30)
                        }
                        .buttonStyle(.plain)
                        .disabled(isEnd)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    
                    // MARK: Calendar
                    ForEach(calculateStartWeek()...calculateEndWeek(), id: \.self) { week in
                        HStack(alignment: .center) {
                            Text(String(week))
                                .frame(width: 24)
                                .font(Font.FontStyles.caption1)
                                .foregroundStyle(Color.ColorSystem.systemGray5)
                            
                            ForEach(days, id: \.self) { day in
                                if (isEnd && week > weeks) {
                                    Text(day.prefix(1).capitalized)
                                        .frame(maxWidth: .infinity, minHeight: 40)
                                        .font(Font.FontStyles.headline)
                                        .foregroundStyle(Color.ColorSystem.systemGray5)
                                        .background(Color.ColorSystem.systemBackground)
                                } else {
                                    Text(day.prefix(1).capitalized)
                                        .frame(maxWidth: .infinity, minHeight: 40)
                                        .font(Font.FontStyles.headline)
                                        .foregroundStyle(Color.ColorSystem.primaryText)
                                        .background(selectedDay == (week, day) ? Color.ColorSystem.systemGray3 : Color.ColorSystem.systemBackground)
                                        .clipShape(Circle())
                                        .onTapGesture {
                                            selectedDay = (week, day)
                                        }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    }
                }
                
                Button {
                    viewModel.startProgram(programId: programId, startDate: selectedDay)
                    self.isStarted.toggle()
                    dismiss()
                } label: {
                    HStack {
                        Spacer()
                        
                        Text("Start Program")
                            .font(Font.FontStyles.headline)
                            .foregroundStyle(Color.ColorSystem.primaryText)
                        
                        Spacer()
                    }
                    .padding(10)
                }
                .background(Color.ColorSystem.systemBlue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(20)
                
                Spacer()
            }
            .background(Color.ColorSystem.systemBackground)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .font(Font.FontStyles.body)
                            .foregroundStyle(Color.ColorSystem.primaryText)
                    }
                }
            }
        }
    }
}

#Preview {
    StartProgramView(isStarted: .constant(false), programId: "", weeks: 10, pages: 10 / 4 + 1, remainder: 10 % 4)
}
