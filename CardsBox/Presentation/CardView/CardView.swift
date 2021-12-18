//
//  CardView.swift
//  CardsBox
//
//  Created by Eugene Shapovalov on 10.06.2021.
//

import SwiftUI
import CreditCardValidator

struct CardView: View {
    @Binding var cardType: String
    @Binding var cardNumber: String
    @Binding var cardHolderName: String
    @Binding var backgroundType: BackgroundCardType
    @State private var backgroundCard: [Color] = []
    @State private var textColor: Color = .white
    @State private var cardImage = "visa"
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack {
               Image(cardImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 15, alignment: .leading)
                Spacer()
            }
            Spacer()
            ZStack(alignment: .leading) {
                Text("1234 5678 9876 5432")
                    .foregroundColor(textColor)
                    .font(.system(size: 17))
                    .fontWeight(.bold)
                    .padding([.top, .bottom])
                    .frame(height: 50)
                    .opacity(cardNumber.isEmpty ? 0.2 : 0)
                
                Text(cardNumber.separate(every: 4, with: " "))
                    .foregroundColor(textColor)
                    .font(.system(size: 17))
                    .fontWeight(.bold)
                    .padding([.top, .bottom])
                    .frame(height: 50)
                    .opacity(cardNumber.isEmpty ? 0 : 1)
            }
            HStack {
                CardBottomInfo(title: "Card Holder Name",
                               detail: cardHolderName,
                               placeholder: "Ivanon Ivan",
                               textColor: $textColor)
                Spacer()
            }
            Spacer()
        }
        .onChange(of: backgroundType, perform: { newValue in
            switch newValue {
            case .ohhappiness:
                textColor = .white
                backgroundCard = Gradients().ohhappinessCardBackground
            case .flare:
                textColor = .white
                backgroundCard = Gradients().flareCardBackground
            case .black:
                textColor = .white
                backgroundCard = [Color.black]
            case .white:
                textColor = .black
                backgroundCard = [Color.white]
            case .default:
                textColor = .white
                backgroundCard = Gradients().defaultCardBackground
            }
        })
        .onChange(of: cardNumber, perform: { _ in
            checkType()
        })
        .onAppear(perform: {
            switch backgroundType {
            case .ohhappiness:
                textColor = .white
                backgroundCard = Gradients().ohhappinessCardBackground
            case .flare:
                textColor = .white
                backgroundCard = Gradients().flareCardBackground
            case .black:
                textColor = .white
                backgroundCard = [Color.black]
            case .white:
                textColor = .black
                backgroundCard = [Color.white]
            case .default:
                textColor = .white
                backgroundCard = Gradients().defaultCardBackground
            }
            checkType()
        })
        .padding([.top, .bottom], 5)
        .padding([.leading, .trailing], 25)
        .background(LinearGradient(gradient:
                                    Gradient(colors: backgroundCard),
                                   startPoint: .bottom,
                                   endPoint: .top))
        .overlay(
               RoundedRectangle(cornerRadius: 20)
                   .stroke(Color.headerLabel, lineWidth: 1)
           )
        .cornerRadius(20.0)
        .frame(height: 200)
    }
    
    private func checkType() {
        let type = CreditCardValidator(cardNumber)
        if type.type == .visa {
            cardImage = "visa"
        } else if type.type == .masterCard {
            cardImage = "mastercard"
        }
    }
}

struct CardViewCell_Previews: PreviewProvider {
    static var previews: some View {
        CardView(cardType: .constant("visa"),
                 cardNumber: .constant(""),
                 cardHolderName: .constant(""),
                 backgroundType: .constant(.ohhappiness))
            .previewLayout(.fixed(width: 390, height: 210))
    }
}

struct CardBottomInfo: View {
    var title: String
    var detail: String
    var placeholder: String
    @Binding var textColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 10))
                .fontWeight(.regular)
                .foregroundColor(textColor)
            ZStack(alignment: .leading) {
                Text(placeholder)
                    .font(.system(size: 15))
                    .fontWeight(.medium)
                    .foregroundColor(textColor)
                    .opacity(detail.isEmpty ? 0.2 : 0)
                Text(detail)
                    .font(.system(size: 15))
                    .fontWeight(.medium)
                    .foregroundColor(textColor)
                    .opacity(detail.isEmpty ? 0 : 1)
            }
        }
    }
}
