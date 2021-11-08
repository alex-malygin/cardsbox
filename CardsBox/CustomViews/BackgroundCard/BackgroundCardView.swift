//
//  BackgroundCardView.swift
//  CardsBox
//
//  Created by Alexander Malygin on 10/22/21.
//

import SwiftUI
import Combine

enum BackgroundCardType: String {
    case ohhappiness, flare, black, white, `default`
}

struct BackgroundCardView: View {
    @ObservedObject var viewModel: BackgroundCardViewModel

    var body: some View {
        VStack {
            ZStack {
                
            }
            .frame(width: 80, height: 80, alignment: .center)
        }
        .background(LinearGradient(gradient:
                                    Gradient(colors: viewModel.backgroundCard),
                                   startPoint: .bottom,
                                   endPoint: .top))
        .overlay(RoundedRectangle(cornerRadius: 10.0)
                            .stroke($viewModel.isSelected.wrappedValue ? .blue : .gray,
                                    lineWidth: $viewModel.isSelected.wrappedValue ? 8 : 4))
        .cornerRadius(10.0)

    }
}

struct BackgroundCardView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundCardView(viewModel: BackgroundCardViewModel())
            .previewLayout(.fixed(width: 120, height: 120))
    }
}

class BackgroundCardViewModel: ObservableObject {
    @Published private var backgroundType: BackgroundCardType
    @Published var isSelected: Bool
    @Published var backgroundCard: [Color] = []
    
    init(backgroundType: BackgroundCardType = .default, isSelected: Bool = false) {
        switch backgroundType {
        case .ohhappiness:
            backgroundCard = Gradients().ohhappinessCardBackground
        case .flare:
            backgroundCard = Gradients().flareCardBackground
        case .black:
            backgroundCard = [Color.black]
        case .white:
            backgroundCard = [Color.white]
        case .default:
            backgroundCard = Gradients().defaultCardBackground
        }
        self.backgroundType = backgroundType
        self.isSelected = isSelected
    }
}
