//
//  ArticleDetailView.swift
//  Atlas
//
//  Created by Michael Bautista on 1/23/25.
//

import SwiftUI

struct ArticleDetailView: View {
    @EnvironmentObject var navigationController: NavigationController
    @StateObject var viewModel: ArticleDetailViewModel
    
    var body: some View {
        if viewModel.isLoading {
            VStack(alignment: .center) {
                Spacer()
                ProgressView()
                    .frame(maxWidth: UIScreen.main.bounds.size.width)
                    .tint(Color.ColorSystem.primaryText)
                Spacer()
            }
            .background(Color.ColorSystem.systemBackground)
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $viewModel.didReturnError, content: {
                Alert(title: Text(viewModel.returnedErrorMessage))
            })
            .onAppear {
                Task {
                    await viewModel.checkSubscription()
                }
            }
        } else {
            List {
                VStack(spacing: 20) {
                    if viewModel.article.imageUrl != nil {
                        if viewModel.articleImage != nil {
                            Image(uiImage: viewModel.articleImage!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 160, height: 160)
                                .buttonStyle(.plain)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } else {
                            ProgressView()
                                .frame(width: 160, height: 160)
                                .tint(Color.ColorSystem.primaryText)
                                .background(Color.ColorSystem.systemBackground)
                                .buttonStyle(.plain)
                        }
                    }
                    
                    VStack(spacing: 0) {
                        // MARK: Title
                        Text(viewModel.article.title)
                            .font(Font.FontStyles.title1)
                            .foregroundStyle(Color.ColorSystem.primaryText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                        
                        // MARK: Creator
                        if let createdBy = viewModel.article.users {
                            Text(createdBy.fullName)
                                .font(Font.FontStyles.headline)
                                .foregroundStyle(Color.ColorSystem.systemGray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
                .listRowSeparator(.hidden)
                
                // MARK: Content
                if viewModel.article.free || viewModel.isCreator || viewModel.isSubscribed {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(0...viewModel.jsonContent.count - 1, id: \.self) { i in
                            if let contentAsDictionary = viewModel.jsonContent[i] as? NSDictionary {
                                translateNode(node: contentAsDictionary)
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                } else {
                    Button {
                        
                    } label: {
                        HStack {
                            Spacer()
                            Text("Subscribers only")
                                .font(Font.FontStyles.headline)
                                .foregroundStyle(Color.ColorSystem.systemGray)
                            Spacer()
                        }
                        .padding(10)
                        .background(Color.ColorSystem.systemGray6)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.ColorSystem.systemBackground)
        }
    }
    
    func getFormattedString(content: NSArray) -> String {
        var str = ""
        
        for substring in content {
            if let dictContent = substring as? NSDictionary {
                var firstHalfFormat = ""
                var secondHalfFormat = ""
                
                if let marks = dictContent["marks"] as? NSArray {
                    for mark in marks {
                        if let formattedMark = mark as? NSDictionary {
                            if let markType = formattedMark["type"] as? String {
                                if markType == "bold" {
                                    firstHalfFormat = "**\(firstHalfFormat)"
                                    secondHalfFormat = "\(secondHalfFormat)**"
                                } else {
                                    firstHalfFormat = "_\(firstHalfFormat)"
                                    secondHalfFormat = "\(secondHalfFormat)_"
                                }
                            }
                        }
                    }
                }
                
                if let text = dictContent["text"] as? String {
                    str += "\(firstHalfFormat)\(text)\(secondHalfFormat)"
                }
            }
        }
        
        return str
    }
    
    @ViewBuilder
    func parseBulletList(content: NSArray) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0...content.count - 1, id: \.self) { i in
                if let itemContent = content[i] as? NSDictionary {
                    translateListNode(node: itemContent, order: nil)
                }
            }
        }
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
    }
    
    @ViewBuilder
    func parseOrderedList(content: NSArray) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0...content.count - 1, id: \.self) { i in
                if let itemContent = content[i] as? NSDictionary {
                    translateListNode(node: itemContent, order: i + 1)
                }
            }
        }
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
    }
    
    @ViewBuilder
    func translateListNode(node: NSDictionary, order: Int?) -> some View {
        if let nodeType = node["type"] as? String {
            switch nodeType {
            case "bulletList":
                if let content = node["content"] as? NSArray {
                    parseBulletList(content: content)
                }
            case "listItem":
                if let content = node["content"] as? NSArray {
                    ForEach(0...content.count - 1, id: \.self) { i in
                        if let itemContent = content[i] as? NSDictionary {
                            translateListNode(node: itemContent, order: order != nil ? order : nil)
                        }
                    }
                }
            case "orderedList":
                if let content = node["content"] as? NSArray {
                    parseOrderedList(content: content)
                }
            case "paragraph":
                if let paragraphContent = node["content"] as? NSArray {
                    HStack {
                        if order != nil {
                            Text("\(order!).")
                                .foregroundStyle(Color.ColorSystem.primaryText)
                        } else {
                            Circle()
                                .frame(width: 5, height: 5)
                                .foregroundStyle(Color.ColorSystem.primaryText)
                        }
                        
                        Text(LocalizedStringKey(getFormattedString(content: paragraphContent)))
                    }
                } else {
                    Text("")
                }
            case "image":
                if let nodeAttrs = node["attrs"] as? NSDictionary {
                    if let imageSrc = nodeAttrs["src"] as? String {
                        AsyncImage(url: URL(string: imageSrc)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: UIScreen.main.bounds.size.width - 40)
                    }
                }
            case "horizontalRule":
                Rectangle()
                    .frame(maxWidth: UIScreen.main.bounds.size.width)
                    .frame(height: 1)
                    .foregroundStyle(Color.ColorSystem.systemGray5)
            default:
                Text("Couldn't get article node.")
            }
        }
    }
    
    // MARK: Translate node
    @ViewBuilder
    func translateNode(node: NSDictionary) -> some View {
        if let nodeType = node["type"] as? String {
            switch nodeType {
            case "bulletList":
                if let content = node["content"] as? NSArray {
                    parseBulletList(content: content)
                }
            case "listItem":
                if let content = node["content"] as? NSArray {
                    ForEach(0...content.count - 1, id: \.self) { i in
                        if let itemContent = content[i] as? NSDictionary {
                            translateNode(node: itemContent)
                        }
                    }
                }
            case "orderedList":
                if let content = node["content"] as? NSArray {
                    parseOrderedList(content: content)
                }
            case "paragraph":
                if let paragraphContent = node["content"] as? NSArray {
                    Text(LocalizedStringKey(getFormattedString(content: paragraphContent)))
                } else {
                    Text("")
                }
            case "heading":
                if let content = node["content"] as? NSArray, let attrs = node["attrs"] as? NSDictionary {
                    let str = LocalizedStringKey(getFormattedString(content: content))
                    
                    if let level = attrs["level"] as? Int {
                        Text(str)
                            .font(level == 1 ? Font.FontStyles.title1 : (level == 2 ? Font.FontStyles.title2 : Font.FontStyles.title3))
                    }
                }
            case "image":
                if let nodeAttrs = node["attrs"] as? NSDictionary {
                    if let imageSrc = nodeAttrs["src"] as? String {
                        AsyncImage(url: URL(string: imageSrc)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: UIScreen.main.bounds.size.width - 40)
                    }
                }
            case "horizontalRule":
                Rectangle()
                    .frame(maxWidth: UIScreen.main.bounds.size.width)
                    .frame(height: 1)
                    .foregroundStyle(Color.ColorSystem.systemGray5)
            default:
                Text("Couldn't get article node.")
            }
        }
    }
}

#Preview {
    ArticleDetailView(viewModel: ArticleDetailViewModel(article: Article(id: "", title: "", content: "", free: false)))
}
