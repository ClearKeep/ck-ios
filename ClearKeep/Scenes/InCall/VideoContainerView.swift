//
//  VideoContainerView.swift
//  ClearKeep
//
//  Created by Luong Minh Hiep on 19/05/2021.
//

import SwiftUI
import CommonUI
import CallManager

struct VideoContainerView: View {
    @ObservedObject var viewModel: CallViewModel
    
    var body: some View {
        Group {
            if viewModel.callGroup {
                GroupVideoContainerView(viewModel: viewModel)
            } else {
                P2PVideoContainerView(viewModel: viewModel)
            }
        }
    }
}

struct GroupVideoContainerView: View {
    @ObservedObject var viewModel: CallViewModel
    
    var body: some View {
        GeometryReader { reader in
            ZStack(alignment: .top) {
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack {
                        let columns = viewModel.remotesVideoView.count < 3 ? 1 : 2
                        GridView(columns: columns, list: viewModel.remotesVideoView) { videoView in
                            let config = viewModel.videoViewConfig(for: videoView)
                            let view = CustomVideoView(videoViewConfig: config, rtcVideoView: videoView)
                            let sizeView = view.getFrame(lstVideo: viewModel.remotesVideoView, containerHeight: reader.size.height)
                            view
                                .frame(width: sizeView.width, height: sizeView.height)
                                .clipShape(Rectangle())
                        }
                    }
                })
            }
        }
    }
}
struct P2PVideoContainerView: View {
    @ObservedObject var viewModel: CallViewModel
    
    var body: some View {
        GeometryReader { reader in
            ZStack(alignment: .top) {
                // remote videos
				ScrollView(.vertical, showsIndicators: false, content: {
					VStack {
						if let videoView = viewModel.localVideoView,
						   viewModel.callStatus != .answered {
							let width = reader.frame(in: .global).width
							let height = reader.frame(in: .global).height
							VideoView(rtcVideoView: videoView)
								.frame(width: width,
									   height: height,
									   alignment: .center)
								.clipShape(Rectangle())
						} else if let videoView = viewModel.remoteVideoView {
							// show full screen
							let width = reader.frame(in: .global).width
							let height = reader.frame(in: .global).height
							VideoView(rtcVideoView: videoView)
								.frame(width: width,
									   height: height,
									   alignment: .center)
								.clipShape(Rectangle())
						}
					}
				})
                
                // local video
                if let videoView = viewModel.localVideoView,
				   viewModel.callStatus == .answered {
                        let widthOfContainerView: CGFloat = 120
                        let heightOfContainerView: CGFloat = 180
                        VStack {
                            Spacer()
                            HStack(alignment: .top) {
                                Spacer()
                                VideoView(rtcVideoView: videoView)
                                    .frame(width: widthOfContainerView,
                                           height: heightOfContainerView,
                                           alignment: .center)
                                    .clipShape(Rectangle())
                                    .cornerRadius(10)
                                    .padding(.trailing, 16)
                                    .padding(.bottom, 68)
                            }
                            .padding(.trailing, 16)
                        }
                }
            }
        }
    }
}

struct VideoContainerView_Previews: PreviewProvider {
    static var previews: some View {
        VideoContainerView(viewModel: CallViewModel())
    }
}
