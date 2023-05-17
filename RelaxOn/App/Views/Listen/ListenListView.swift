//
//  ListenListView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/09.
//

import SwiftUI

struct ListenListView: View {
    
    @ObservedObject private var viewModel = MixedSoundsViewModel()
    @State private var searchText = ""
    
    // MARK: - Body
    var body: some View {
        
        NavigationView {
            
            VStack {
                SearchBar(text: $searchText)
                    .padding()
                List {
                    ForEach(viewModel.mixedSounds, id: \.id) { mixedSound in
                        ListenListCell(title: mixedSound.name, ImageName: mixedSound.imageName)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            viewModel.removeMixedSound(at: index)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Listen")
                .navigationBarTitleDisplayMode(.large)
                .padding()
                .onAppear {
                    viewModel.loadMixedSound()
                }
                PlayerBar()
            }
        }
    }
}

struct PlayerBar: View {
    
    var body: some View {
        
        HStack {
            
            // TODO: 재생하는 사운드의 이미지 가져오기
            Image(systemName: "play.fill")
                .background(.foreground.opacity(0.08)).cornerRadius(10)
                .padding(30)
            
            // TODO: 선택한 사운드 제목 가져오기
            Text("Title")
                .font(.title)
            
            Spacer()
            
            Button {
                // TODO: 선택한 사운드를 재생
            } label: {
                Image(systemName: "play.fill")
                    .foregroundColor(Color.black)
                    .padding(30)
                
            }
        }
        .background(Color.systemGrey1)
        .ignoresSafeArea()
    }
}

// TODO: 검색기능 구현
struct SearchBar: View {
    
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("저장한 나만의 소리를 검색해보세요", text: $text)
                .foregroundColor(.primary)
            
            if !text.isEmpty {
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.primary)
                }
            }
        }
        .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10.0)
    }
}

struct ListenListCell: View {
    // MARK: - Properties
    var title: String
    var ImageName: String
    
    var PlayButtonImageName: String = "play.fill"
    var PauseButtonImageName: String = "pause.fill"
    @State var isPlayerBarShowing: Bool = false
    
    var body: some View {
        HStack {
            Button {
                isPlayerBarShowing = true
            } label: {
                Image(ImageName)
                    .frame(maxWidth: 60, maxHeight: 60)
                    .background(.foreground.opacity(0.08)).cornerRadius(10)
            }
            
            Text(title)
                .font(.body)
                .bold()
            Spacer()
            Button(action: {
                // TODO: Implement play/pause functionality
            }) {
                Image(systemName: PauseButtonImageName)
                    .foregroundColor(.black)
                    .padding()
            }
        }.sheet(isPresented: $isPlayerBarShowing) {
            SoundPlayerView()
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ListenListView_Previews: PreviewProvider {
    static var previews: some View {
        ListenListView()
    }
}
