//
//  AccountView.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 21/02/2023.
//

import SwiftUI
import MapKit
import HealthKit

struct AccountButtons: View {
    @EnvironmentObject var vm: ViewModel

    var body: some View {

        HStack{
            HStack(spacing: 0){
                NavigationLink(destination: AccountButtons()) {
             Image(systemName: "person.circle")
                 .foregroundColor(.white)
                 .frame(width: SIZE, height: SIZE)
                 .scaleEffect(vm.scale)
                }
             Divider().frame(height: SIZE)

            }
            .font(.system(size: SIZE/2))
            .materialBackground()
            
        }
        .padding(.trailing, 350)
        .offset(x: 0, y: -700)

    }




    
}

struct AccountButtons_Previews: PreviewProvider {
    static var previews: some View {
        AccountButtons()
            .environmentObject(ViewModel())
    }
}
