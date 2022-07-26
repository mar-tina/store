//
//  PayView.swift
//  store
//
//  Created by martina khaemba on 26/07/2022.
//

import SwiftUI


struct PayView: View {
    var pay = Ipay(key:"demoCHANGED", baseURL: "https://payments.ipayafrica.com/v3/ke")
    @State private var phonenumber = ""
    @State private var email = ""
    @State private var amount = "900"
    
    var body: some View {
        NavigationView {
                Form {
                    TextField("Phone number",
                              text: $phonenumber)
                    TextField("Amount",
                              text: $amount)
                    TextField("Email", text: $email)
                    Button(action: {
                        print("form clicked")
                        pay.setParam(key: "live", value: "0")
                        pay.setParam(key: "ttl", value: amount)
                        pay.setParam(key: "eml", value: email)
                        pay.setParam(key: "tel", value: phonenumber)
                        pay.setParam(key: "oid", value: "112")
                        pay.setParam(key: "inv", value: "112020102292999")
                        pay.setParam(key: "vid", value: "demo")
                        pay.setParam(key: "curr", value: "KES")
                        pay.setParam(key: "p1", value: "airtel")
                        pay.setParam(key: "p2", value: "020102292999")
                        pay.setParam(key: "p3", value: "")
                        pay.setParam(key: "p4", value: "900")
                        pay.setParam(key: "cbk", value: "http://localhost:9888")
                        pay.setParam(key: "cst", value: "1")
                        pay.setParam(key: "crl", value: "2")
                        
                        print(pay.buildDatastr())
                        pay.complete()
                    }) {
                        Text("Proceed to Checkout")
                    }
                }
            }.navigationBarTitle(Text("Ipay Store"))
    }
}


struct PayView_Previews: PreviewProvider {
    static var previews: some View {
        PayView()
    }
}
