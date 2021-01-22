//
//  ContentView.swift
//  Nasa
//
//  Created by 王瑋 on 2021/1/17.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var apiManager = APIManager.shared
    
    @State private var queryString = ""
    @State private var enhanced = true
    @State private var selectDate = Date()
    @State private var typePick = 1
    @State private var randomPic = true
    @State private var minWidth = 0.0
    @State private var amount = 3
    @State private var showAlert = false
    @State private var showImageWall = false
    @State private var showSheet = false
    @State private var bgColor = Color.white
    let types=["fashion","science","animals", "food", "sports"]
    
    let today = Date()
    let startDate = Calendar.current.date(byAdding: .year,value: -30, to: Date())!
    var year: Int {
        Calendar.current.component(.year, from: selectDate)
    }
    var body: some View {
        VStack{
            IconView(showSheet: self.$showSheet)
            Form{
                TextField("照片關鍵字", text: self.$queryString)
//                    .onChange(of: queryString) { value in
//                        if(value.count>100){
//                            Text("請勿超過100字").foregroundColor(Color.red)
//                    }
                Toggle("不限種類", isOn: $randomPic)
                if(!randomPic)
                {
                    TypePicker(type: self.$typePick)
                }
                HStack{
                    Text("照片寬度:  \(Int(self.minWidth))")
                    Spacer()
                    Text("(不限寬度設0)").font(.footnote)
                }
                WidthSlider(width: self.$minWidth)
                AmountStepper(amount: self.$amount)
                DatePicker("日期", selection: self.$selectDate, in: self.startDate ... self.today, displayedComponents: .date)
            }
//            ColorPicker("背景顏色", selection: $bgColor)
            Button(action: {
                if(self.queryString == ""){
                    self.showAlert = true
                }
                else{
                    print(self.queryString)
                    self.showAlert = false
                    self.apiManager.updateImage(queryString: self.queryString, category: self.types[self.typePick], minWidth: Int(self.minWidth))
                    self.showImageWall = true
                }
            })
            {
                Text("找美照！")
                    .foregroundColor(.black)
                    .font(.headline)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(15)
                    .padding(5)
            }
            .alert(isPresented: $showAlert) { () -> Alert in
                return Alert(title: Text("沒有關鍵字"),message: Text("請輸入關鍵字"))
            }
            .sheet(isPresented: self.$showImageWall) {
                ImageWallView(amount: self.amount)
            }
        }
        .background(bgColor)
    }
    
}
struct TypePicker: View{
    @Binding var type: Int
    let types=["fashion","science","animals", "food", "sports"]
    var body: some View{
        Picker("照片類別",selection: self.$type){
            ForEach(0..<types.count){(index) in
                Text(self.types[index])
            }
        }.pickerStyle(SegmentedPickerStyle())
    }
}
struct WidthSlider: View {
    @Binding var width: Double
    
    var body: some View {
        
        Slider(value: $width, in: 0...1000,step: 1, minimumValueLabel: Text("0"), maximumValueLabel:Text("1000")){
            Text("照片寬度")
            
        }
    }
}
struct AmountStepper: View {
    @Binding var amount: Int
    
    var body: some View {
        Stepper("要幾張呢：" + String(format: "%d", amount), value: $amount, in: 0 ... 100)
    }
}

struct IconView: View{
    @Binding var showSheet: Bool
    var body: some View{
        Button(action: {
            self.showSheet = true
        }){
            Image("NasaIcon")
            .resizable()
            .scaledToFit()
                .frame(width: 200, height: 200)
        }
        .actionSheet(isPresented: $showSheet){
            ActionSheet(title: Text("Image is provided by:"), message: Text("https://pixabay.com/"), buttons:[.default(Text("OK"))])
        }.buttonStyle(PlainButtonStyle())

    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
