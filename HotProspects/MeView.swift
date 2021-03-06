//
//  MeView.swift
//  HotProspects
//
//  Created by simge on 17.03.2022.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct MeView: View {
    
    @State private var name = "Anonymous"
    @State private var emailAddress = "you@yoursite.com"
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                    .textContentType(.name)
                    .font(.title)

                TextField("Email address", text: $emailAddress)
                    .textContentType(.emailAddress)
                    .font(.title)
                
                Image(uiImage: generateQRCode(from: "\(name)\n\(emailAddress)"))
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            .navigationTitle("Your code")
        }
    }
    
    func generateQRCode(from string: String) -> UIImage {
        //Filtre için girdimiz bir dizge olacaktır, ancak filtrenin girdisi Data'dır, bu yüzden onu dönüştürmemiz gerekiyor.
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
        //Dönüştürme herhangi bir nedenle başarısız olursa, "xmark.circle" görüntüsünü SF Symbols'den geri göndeririz.
        //Bu okunamıyorsa - ki bu teorik olarak mümkündür, çünkü SF Sembolleri dizgisel olarak yazılmıştır - o zaman boş bir UIImage göndeririz.
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
